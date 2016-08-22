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

_this spawn

{
	params
	[
		["_transporteur", objNull],
		["_liste_a_charger", []]
	];

	if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {};
	waitUntil {sleep 0.1; !(isNil "R3F_LOG_active")};

	private ["_transporteur", "_liste_a_charger", "_chargement", "_chargement_actuel", "_chargement_maxi", "_objects_charges", "_cout_chargement_object"];
	private ["_object_ou_classe", "_quantite", "_object", "_classe", "_bbox", "_bbox_dim", "_pos_degagee", "_fonctionnalites", "_i"];

	_chargement = [_transporteur] call AdvLog_fnc_calculateSpace;
	_chargement_actuel = _chargement select 0;
	_chargement_maxi = _chargement select 1;
	_objects_charges = _transporteur getVariable ["R3F_LOG_objects_charges", []];



	// Pour chaque ?l?ment de la liste ? charger
	{
		if (typeName _x == "ARRAY" && {count _x > 0}) then
		{
			_object_ou_classe = _x select 0;

			if (typeName _object_ou_classe == "STRING" && count _x > 1) then
			{
				_quantite = _x select 1;
			}
			else
			{
				_quantite = 1;
			};
		}
		else
		{
			_object_ou_classe = _x;
			_quantite = 1;
		};

		if (typeName _object_ou_classe == "STRING") then
		{
			_classe = _object_ou_classe;
			_bbox = [_classe] call R3F_LOG_FNCT_3D_get_bounding_box_depuis_classname;
			_bbox_dim = (vectorMagnitude (_bbox select 0)) max (vectorMagnitude (_bbox select 1));

			// Recherche d'une position d?gag?e. Les v?hicules doivent ?tre cr?? au niveau du sol sinon ils ne peuvent ?tre utilis?s.
			if (_classe isKindOf "AllVehicles") then
			{
				_pos_degagee = [_bbox_dim, getPos _transporteur, 200, 50] call R3F_LOG_FNCT_3D_tirer_position_degagee_sol;
			}
			else
			{
				_pos_degagee = [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel;
			};

			if (count _pos_degagee == 0) then {_pos_degagee = getPosATL _transporteur;};
		}
		else
		{
			_classe = typeOf _object_ou_classe;
		};

		_fonctionnalites = [_classe] call AdvLog_fnc_canBeTransportedClass;
		_cout_chargement_object = _fonctionnalites param [1, 0];

		// S'assurer que le type d'objet ? charger est transportable
		if !(_fonctionnalites param[0, false]) then
		{
			diag_log format ["[Auto-load ""%1"" in ""%2""] : %3",
				getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
				getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
				"The object is not a transporable class."];

			systemChat format ["[Auto-load ""%1"" in ""%2""] : %3",
				getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
				getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
				"The object is not a transporable class."];
		}
		else
		{
			for [{_i = 0}, {_i < _quantite}, {_i = _i+1}] do
			{
				// Si l'objet ? charger est donn? en tant que nom de classe, on le cr?e
				if (typeName _object_ou_classe == "STRING") then
				{
					// Recherche d'une position d?gag?e. Les v?hicules doivent ?tre cr?? au niveau du sol sinon ils ne peuvent ?tre utilis?s.
					if (_classe isKindOf "AllVehicles") then
					{
						_object = _classe createVehicle _pos_degagee;
						_object setVectorDirAndUp [[-cos getDir _transporteur, sin getDir _transporteur, 0] vectorCrossProduct surfaceNormal _pos_degagee, surfaceNormal _pos_degagee];
						_object setVelocity [0, 0, 0];
					}
					else
					{
						_object = _classe createVehicle _pos_degagee;
					};
				}
				else
				{
					_object = _object_ou_classe;
				};

				if (!isNull _object) then
				{
					// V?rifier qu'il n'est pas d?j? transport?
					if (isNull (_object getVariable ["R3F_LOG_is_transported_by", objNull]) &&
						(isNull (_object getVariable ["R3F_LOG_is_moved_by", objNull]) || (!alive (_object getVariable ["R3F_LOG_is_moved_by", objNull])) || (!isPlayer (_object getVariable ["R3F_LOG_is_moved_by", objNull])))
					) then
					{
						if (isNull (_object getVariable ["R3F_LOG_remorque", objNull])) then
						{
							// Si l'objet loge dans le v?hicule
							if (_chargement_actuel + _cout_chargement_object <= _chargement_maxi) then
							{
								_chargement_actuel = _chargement_actuel + _cout_chargement_object;
								_objects_charges pushBack _object;

								_object setVariable ["R3F_LOG_is_transported_by", _transporteur, true];
								_object attachTo [R3F_LOG_PUBVAR_point_attache, [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel];
							}
							else
							{
								diag_log format ["[Auto-load ""%1"" in ""%2""] : %3",
									getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
									getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
									STR_R3F_LOG_action_charger_pas_assez_de_place];

								systemChat format ["[Auto-load ""%1"" in ""%2""] : %3",
									getText (configFile >> "CfgVehicles" >> _classe >> "displayName"),
									getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName"),
									STR_R3F_LOG_action_charger_pas_assez_de_place];

								if (typeName _object_ou_classe == "STRING") then
								{
									deleteVehicle _object;
								};
							};
						}
						else
						{
							diag_log format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
							systemChat format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
						};
					}
					else
					{
						diag_log format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
						systemChat format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> _classe >> "displayName")];
					};
				};
			};
		};
	} forEach _liste_a_charger;

	// On m?morise sur le r?seau le nouveau contenu du v?hicule
	_transporteur setVariable ["R3F_LOG_objects_charges", _objects_charges, true];
};