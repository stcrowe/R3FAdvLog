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

	private ["_object", "_transporteur"];

	_object = R3F_LOG_object_selectionne;
	_transporteur = param [0, objNull];


	if (!(isNull _object)) then
	{

		if (isNull (_object getVariable "R3F_LOG_is_transported_by") && (isNull (_object getVariable "R3F_LOG_is_moved_by") || (!alive (_object getVariable "R3F_LOG_is_moved_by")) || (!isPlayer (_object getVariable "R3F_LOG_is_moved_by")))) then
		{


			if (isNull (_object getVariable ["R3F_LOG_remorque", objNull])) then
			{
				if (count crew _object == 0 || getNumber (configFile >> "CfgVehicles" >> (typeOf _object) >> "isUav") == 1) then
				{
					private ["_objects_charges", "_chargement", "_cout_chargement_object"];

					_chargement = [_transporteur] call AdvLog_fnc_calculateSpace;

					_cout_chargement_object = ([_object] call AdvLog_fnc_canBeTransported) param [1, 1];


					// Si l'objet loge dans le v?hicule
					if ((_chargement select 0) + _cout_chargement_object <= (_chargement select 1)) then
					{
						if (_object distance _transporteur <= 15) then
						{

							// On m?morise sur le r?seau le nouveau contenu du v?hicule
							_objects_charges = _transporteur getVariable ["R3F_LOG_objects_charges", []];
							_objects_charges = _objects_charges + [_object];
							_transporteur setVariable ["R3F_LOG_objects_charges", _objects_charges, true];

							_object setVariable ["R3F_LOG_is_transported_by", _transporteur, true];

							systemChat STR_R3F_LOG_action_load_in_course;

							//Added by crowe to give a little animation
								[] spawn
								{
									player playMove format ["AinvPknlMstpSlay%1Dnon_medic", switch (currentWeapon player) do
										{
											case "": {"Wnon"};
											case primaryWeapon player: {"Wrfl"};
											case secondaryWeapon player: {"Wlnr"};
											case handgunWeapon player: {"Wpst"};
											default {"Wrfl"};
										}];
								};

							sleep 2;

							// Gestion conflit d'acc?s
							if (_object getVariable ["R3F_LOG_is_transported_by", objNull] == _transporteur && _object in (_transporteur getVariable "R3F_LOG_objects_charges")) then
							{
								_object attachTo [R3F_LOG_PUBVAR_point_attache, [] call R3F_LOG_FNCT_3D_tirer_position_degagee_ciel];

								systemChat format [STR_R3F_LOG_action_charger_fait,
									getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName"),
									getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName")];


							}
							else
							{
								_object setVariable ["R3F_LOG_is_transported_by", objNull, true];
								hintC format ["ERROR : " + STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
							};
						}
						else
						{
							hintC format [STR_R3F_LOG_trop_loin, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
						};
					}
					else
					{
						hintC STR_R3F_LOG_action_charger_pas_assez_de_place;
					};
				}
				else
				{
					hintC format [STR_R3F_LOG_player_dans_object, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
				};
			}
			else
			{
				hintC format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
		};
	};

	R3F_LOG_object_selectionne = objNull;

	R3F_LOG_mutex_local_lock = false;
};