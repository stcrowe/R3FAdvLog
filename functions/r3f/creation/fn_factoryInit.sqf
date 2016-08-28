/*
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


private ["_factory", "_credits_factory", "_num_side", "_param3", "_blackwhitelist_categories_toLower"];

_factory = param [0, objNull];
_credits_factory = param [0, -1];

// R?cup?ration du param?tre optionnel de cr?dits
if (count _this > 1 && {!isNil {_this select 1}}) then
{
	if (typeName (_this select 1) != "SCALAR") then
	{
		systemChat "ERROR : credits parameter passed to ""init creation factory"" is not a number.";
		diag_log text "ERROR : credits parameter passed to ""init creation factory"" is not a number.";
		_this set [1, -1];
	};

	_credits_factory = _this select 1;
}
else {_credits_factory = -1};

/** Cr?dits de cr?ation, -1 pour un cr?dit infinie */
if (isNil {_factory getVariable "R3F_LOG_CF_credits"}) then
{
	_factory setVariable ["R3F_LOG_CF_credits", _credits_factory, false];
};

if (isNil {_factory getVariable "R3F_LOG_CF_disabled"}) then
{
	_factory setVariable ["R3F_LOG_CF_disabled", false, false];
};

_factory setVariable ["R3F_LOG_CF_mem_idx_categorie", 0];
_factory setVariable ["R3F_LOG_CF_mem_idx_object", 0];

/** Tableau contenant toutes les usines cr??es */
R3F_LOG_CF_liste_factorys pushBack _factory;

//_factory addAction [("<t color=""#ff9600"">" + STR_R3F_LOG_action_ouvrir_factory + "</t>"), {_this call R3F_LOG_FNCT_factory_open_factory}, nil, 5, false, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_object_addAction == _target && R3F_LOG_action_valid_open_factory "];

	_myaction = ["R3F_openCF", "Open Factory","",{_this spawn R3F_LOG_FNCT_factory_open_factory;},{!R3F_LOG_mutex_local_lock},{}] call ace_interact_menu_fnc_createAction;

	[_factory, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;

// Add resell
	//_factory addAction [("<t color=""#dddd00"">" + format ["Return %1", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_factoryResell;}, nil, 10, true, true, "", "!R3F_LOG_mutex_local_lock && R3F_LOG_resell_load_valid_selection && (_this distance _target < 6)"];
