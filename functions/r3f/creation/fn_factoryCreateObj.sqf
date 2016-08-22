/**
 * Cr?er un objet - appel? deuis l'interface de l'usine de cr?ation
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_lock) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_lock = true;

	disableSerialization; // A cause des displayCtrl

	#include "dlg_constantes.h"
	private ["_factory", "_classe", "_cout", "_object", "_pos_degagee", "_action_confirmee", "_est_deplacable", "_topIndex", "_bottomInde", "_factoryClasses", "_factoryCosts"];

	_factory = uiNamespace getVariable "R3F_LOG_dlg_LO_factory";

	if (lbCurSel R3F_LOG_IDC_dlg_LO_liste_objects == -1) exitWith {R3F_LOG_mutex_local_lock = false;};
	_classe = lbData [R3F_LOG_IDC_dlg_LO_liste_objects, lbCurSel R3F_LOG_IDC_dlg_LO_liste_objects];

	if (_classe != "") then
	{

		_topIndex = nil;
		_bottomIndex = nil;

		_factoryClasses = _factory getVariable ["R3F_LOG_CF_cfgVehicles_par_categories", []];
		_factoryCosts = _factory getVariable ["R3F_LOG_CF_cfgVehicles_costs", []];

		{
			_category = _x;

			_index = _foreachIndex;

			if (count _category > 0) then
			{
				{

					if (_x == _classe AND isNil "_bottomIndex") then
					{
						_bottomIndex = _foreachIndex;
					};
				} forEach _category;

				if (!(isNil "_bottomIndex") AND isNil "_topIndex") then
				{
					_topIndex = _index;
				};
			};

		} forEach _factoryClasses;

		_cout = 0;

		if (!(isNil "_topIndex")) then
		{

			_cout = (_factoryCosts select _topIndex) select _bottomIndex;
		};

		_est_deplacable = [_classe] call AdvLog_fnc_canMoveClass;

		// L'usine a-t-elle assez de cr?dits ?
		if (_factory getVariable "R3F_LOG_CF_credits" == -1 || _factory getVariable "R3F_LOG_CF_credits" >= _cout) then
		{
			// Recherche d'une position d?gag?e. Les v?hicules doivent ?tre cr?? au niveau du sol sinon ils ne peuvent ?tre utilis?s.
			if (_classe isKindOf "AllVehicles") then
			{
				private ["_rayon", "_bbox", "_bbox_dim"];

				systemChat STR_R3F_LOG_action_creer_en_cours;
				sleep 0.5;

				_bbox = [_classe] call R3F_LOG_FNCT_3D_get_bounding_box_depuis_classname;
				_bbox_dim = (vectorMagnitude (_bbox select 0)) max (vectorMagnitude (_bbox select 1));

				// Recherche d'une position d?gag?e (on augmente progressivement le rayon jusqu'? trouver une position)
				for [{_rayon = 5 max (2*_bbox_dim); _pos_degagee = [];}, {count _pos_degagee == 0 && _rayon <= 30 + (8*_bbox_dim)}, {_rayon = _rayon + 10 + (2*_bbox_dim)}] do
				{
					_pos_degagee = [
						_bbox_dim,
						_factory modelToWorld [0, if (_factory isKindOf "AllVehicles") then {(boundingBoxReal _factory select 0 select 1) - 2 - 0.3*_rayon} else {0}, 0],
						_rayon,
						100 min (5 + _rayon^1.2)
					] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
				};
			}
			else
			{
				_pos_degagee = [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel;
			};

			if (count _pos_degagee > 0) then
			{
				// Si l'objet n'est ni un v?hicule, ni d?pla?able manuellement, on demande confirmation de cr?ation
				if (!(_classe isKindOf "AllVehicles") && !_est_deplacable) then
				{
					_action_confirmee = [STR_R3F_LOG_action_decharger_deplacable_exceptionnel, "Warning", true, true] call BIS_fnc_GUImessage;
				}
				else
				{
					_action_confirmee = true;
				};

				if (_action_confirmee) then
				{
					// D?duction des cr?dits (si limit?)
					if (_factory getVariable "R3F_LOG_CF_credits" != -1) then
					{
						_factory setVariable ["R3F_LOG_CF_credits", 0 max ((_factory getVariable "R3F_LOG_CF_credits") - _cout), true];
					};

					_object = _classe createVehicle _pos_degagee;
					_object setPos _pos_degagee;
					_object setVectorDirAndUp [[-cos getDir _factory, sin getDir _factory, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
					_object setVelocity [0, 0, 0];

					if !(isNull _object) then
					{
						// D?sactivation du bouton fermer car la cr?ation est engag?e
						(findDisplay R3F_LOG_IDD_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_btn_fermer) ctrlEnable false;

						// M?moriser que cet objet a ?t? cr?? depuis une usine
						_object setVariable ["R3F_LOG_CF_depuis_factory", true, true];

						sleep 0.5;

						// Informer tout le monde qu'il y a un nouvel objet
						R3F_LOG_PUBVAR_nouvel_object_a_initialiser = true;
						publicVariable "R3F_LOG_PUBVAR_nouvel_object_a_initialiser";

						// Si l'objet cr?? est un drone, on y place des IA en ?quipage
						if (getNumber (configFile >> "CfgVehicles" >> (typeOf _object) >> "isUav") == 1) then
						{
							createVehicleCrew _object;
							sleep 0.5;
						};

						if (!(_object isKindOf "AllVehicles") || _est_deplacable) then
						{
							R3F_LOG_mutex_local_lock = false;
							[_object, player, 0, true] spawn AdvLog_fnc_moveObj;
						}
						else
						{
							sleep 0.4; // Car la prise en compte n'est pas instantann?e

							// Si l'objet a ?t? cr?? assez loin, on indique sa position relative
							if (_object distance _factory > 40) then
							{
								systemChat format [STR_R3F_LOG_action_creer_fait + " (%2)",
									getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName"),
									format ["%1m %2deg", round (_object distance _factory), round ([_factory, _object] call BIS_fnc_dirTo)]
								];
							}
							else
							{
								systemChat format [STR_R3F_LOG_action_creer_fait, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
							};
							R3F_LOG_mutex_local_lock = false;
						};

						closeDialog 0;
					}
					else
					{
						hintC format ["ERROR : ""%1"" is not an instanciable objet.", _classe];
						R3F_LOG_mutex_local_lock = false;
					};
				}
				else
				{
					R3F_LOG_mutex_local_lock = false;
				};
			}
			else
			{
				hintC format ["ERROR : no empty position found around. Creation canceled. Move out objects around the factory and try again."];
				R3F_LOG_mutex_local_lock = false;
			};
		}
		else
		{
			hintC STR_R3F_LOG_action_creer_pas_assez_credits;
			R3F_LOG_mutex_local_lock = false;
		};
	}
	else {R3F_LOG_mutex_local_lock = false;};
};