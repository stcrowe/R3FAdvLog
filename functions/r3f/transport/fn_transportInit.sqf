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

params [["_object", objNull]];

if (isNull _object) exitWith {};



// D?finition locale de la variable si elle n'est pas d?finie sur le r?seau
if (isNil {_object getVariable "R3F_LOG_objects_charges"}) then
{
	_object setVariable ["R3F_LOG_objects_charges", [], false];
};


_myactionCargo = ["R3F_cargo","Cargo","",{_this spawn AdvLog_fnc_seeCargo;},{!R3F_LOG_mutex_local_lock && missionNamespace getVariable ["AdvLog_Endabled", true]},{}] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _myactionCargo] call ace_interact_menu_fnc_addActionToObject;


/*_myactionCargo = ["R3F_cargoLoad", "Load in vehicle","",{_this spawn AdvLog_fnc_loadSelection;},{!R3F_LOG_mutex_local_lock && R3F_LOG_action_load_valid_selection},{}] call ace_interact_menu_fnc_createAction;

[_object, 0, ["ACE_MainActions"], _myactionCargo] call ace_interact_menu_fnc_addActionToObject;*/

_object addAction [("<t color=""#dddd00"">" + format [STR_R3F_LOG_action_load_selection, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_loadSelection;}, nil, 10, true, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_action_load_valid_selection && (_this distance _target < 6)"];


if (_object isKindOf "VTOL_01_base_F") then
{

	_object addAction [("<t color=""#dddd00"">" + STR_R3F_LOG_action_content_vehicle + "</t>"), {_this spawn AdvLog_fnc_seeCargo;}, nil, 4, false, true, "", "!R3F_LOG_mutex_local_lock && missionNamespace getVariable ['AdvLog_Endabled', true]"];

};