/**
 * Modified by Sean Crowe, original script by Team ~R3F~
 * please see orginal work @ https://forums.bistudio.com/topic/170033-r3f-logistics/
 *
 * To get a full list of changes please contant me on the biforums under the username S.Crowe
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

	#include "dlg_constantes.h"
	private ["_transporteur", "_objects_charges", "_type_object_a_decharger", "_object_a_decharger", "_action_confirmee", "_est_deplacable"];

	_transporteur = uiNamespace getVariable "R3F_LOG_dlg_CV_transporteur";
	_objects_charges = _transporteur getVariable ["R3F_LOG_objects_charges", []];

	if (lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu == -1) exitWith {R3F_LOG_mutex_local_lock = false;};

	_type_object_a_decharger = lbData [R3F_LOG_IDC_dlg_CV_liste_contenu, lbCurSel R3F_LOG_IDC_dlg_CV_liste_contenu];

	_object_a_decharger = objNull;
	{
		if (typeOf _x == _type_object_a_decharger) exitWith
		{
			_object_a_decharger = _x;
		};
	} forEach _objects_charges;

	_est_deplacable = [_object_a_decharger] call AdvLog_fnc_canMove;


	if (!(_type_object_a_decharger isKindOf "AllVehicles") && !_est_deplacable) then
	{
		_action_confirmee = [STR_R3F_LOG_action_decharger_deplacable_exceptionnel, "Warning", true, true] call BIS_fnc_GUImessage;
	}
	else
	{
		_action_confirmee = true;
	};

	if (_action_confirmee) then
	{
		closeDialog 0;


		if !(isNull _object_a_decharger) then
		{

			// On m?morise sur le r?seau le nouveau contenu du transporteur (c?d avec cet objet en moins)
			_objects_charges = _transporteur getVariable ["R3F_LOG_objects_charges", []];
			_objects_charges = _objects_charges - [_object_a_decharger];
			_transporteur setVariable ["R3F_LOG_objects_charges", _objects_charges, true];

			_object_a_decharger setVariable ["R3F_LOG_is_transported_by", objNull, true];

			if (!(_object_a_decharger isKindOf "AllVehicles") || _est_deplacable) then
			{
				R3F_LOG_mutex_local_lock = false;
				[_object_a_decharger, player, 0, true] spawn AdvLog_fnc_moveObj;
			}
			else
			{
				private ["_bbox_dim", "_pos_degagee", "_rayon"];

				systemChat STR_R3F_LOG_action_decharger_en_cours;

				_bbox_dim = (vectorMagnitude (boundingBoxReal _object_a_decharger select 0)) max (vectorMagnitude (boundingBoxReal _object_a_decharger select 1));

				sleep 1;

				// Recherche d'une position d?gag?e (on augmente progressivement le rayon jusqu'? trouver une position)
				for [{_rayon = 5 max (2*_bbox_dim); _pos_degagee = [];}, {count _pos_degagee == 0 && _rayon <= 30 + (8*_bbox_dim)}, {_rayon = _rayon + 10 + (2*_bbox_dim)}] do
				{
					_pos_degagee = [
						_bbox_dim,
						_transporteur modelToWorld [0, if (_transporteur isKindOf "AllVehicles") then {(boundingBoxReal _transporteur select 0 select 1) - 2 - 0.3*_rayon} else {0}, 0],
						_rayon,
						100 min (5 + _rayon^1.2)
					] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
				};

				if (count _pos_degagee > 0) then
				{
					detach _object_a_decharger;
					_object_a_decharger setPos _pos_degagee;
					_object_a_decharger setVectorDirAndUp [[-cos getDir _transporteur, sin getDir _transporteur, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
					_object_a_decharger setVelocity [0, 0, 0];

					sleep 0.4; // Car la nouvelle position n'est pas prise en compte instantann?ment

					// Si l'objet a ?t? cr?? assez loin, on indique sa position relative
					if (_object_a_decharger distance _transporteur > 40) then
					{
						systemChat format [STR_R3F_LOG_action_decharger_fait + " (%2)",
							getText (configFile >> "CfgVehicles" >> (typeOf _object_a_decharger) >> "displayName"),
							format ["%1m %2deg", round (_object_a_decharger distance _transporteur), round ([_transporteur, _object_a_decharger] call BIS_fnc_dirTo)]
						];
					}
					else
					{
						systemChat format [STR_R3F_LOG_action_decharger_fait, getText (configFile >> "CfgVehicles" >> (typeOf _object_a_decharger) >> "displayName")];
					};
					R3F_LOG_mutex_local_lock = false;
				}
				// Si ?chec recherche position d?gag?e, on d?charge l'objet comme un d?pla?able
				else
				{
					systemChat "WARNING : no free position found.";

					R3F_LOG_mutex_local_lock = false;
					[_object_a_decharger, player, 0, true] spawn AdvLog_fnc_moveObj;
				};
			};
		}
		else
		{
			hintC STR_R3F_LOG_action_decharger_deja_fait;
			R3F_LOG_mutex_local_lock = false;
		};
	}
	else
	{
		R3F_LOG_mutex_local_lock = false;
	};
};