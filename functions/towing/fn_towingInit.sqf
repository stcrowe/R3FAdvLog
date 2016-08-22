params [["_vehicle", objNull]];

if (isNull _vehicle) exitWith {};


_myaction = ["AdvTow_takeRopes", "Deploy Tow Ropes","",{[_this, 10] call AdvLog_fnc_takeTowRopes;},{_this call AdvLog_fnc_canTakeTowRopes},{}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;


// Depoly RopLenths
_myaction = ["AdvTow_TwFiv_Take", "25 Meters","",{[_this, 25] call AdvLog_fnc_takeTowRopes;},{_this call AdvLog_fnc_canTakeTowRopes}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_takeRopes"], _myaction] call ace_interact_menu_fnc_addActionToObject;

_myaction = ["AdvTow_Tw_Take", "20 Meters","",{[_this, 20] call AdvLog_fnc_takeTowRopes;},{_this call AdvLog_fnc_canTakeTowRopes}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_takeRopes"], _myaction] call ace_interact_menu_fnc_addActionToObject;


_myaction = ["AdvTow_Ten_Take", "10 Meters","",{[_this, 10] call AdvLog_fnc_takeTowRopes;},{_this call AdvLog_fnc_canTakeTowRopes}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_takeRopes"], _myaction] call ace_interact_menu_fnc_addActionToObject;

_myaction = ["AdvTow_Fi_Take", "5 Meters","",{[_this, 5] call AdvLog_fnc_takeTowRopes;},{_this call AdvLog_fnc_canTakeTowRopes}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_takeRopes"], _myaction] call ace_interact_menu_fnc_addActionToObject;

// Put away ropes
_myaction = ["AdvTow_putAwayRopes", "Put Away Tow Ropes","",{_this call AdvLog_fnc_putAwayTowRopes;},{_existingTowRopes = (_this select 0) getVariable ["SA_Tow_Ropes",[]]; (count _existingTowRopes) > 0},{}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;

// Shorten tow length
_myaction = ["AdvTow_RopeLength", "Rope Length","",{},{_existingTowRopes = (_this select 0) getVariable ["SA_Tow_Ropes",[]]; (count _existingTowRopes > 0 && (vectorMagnitude velocity _vehicle) < 2)},{}] call ace_interact_menu_fnc_createAction;


[_vehicle, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;

_myaction = ["AdvTow_Ten", "10 Meters","",{[_this, 10] call AdvLog_fnc_windTowRope;},{_existingTowRopes = (_this select 0) getVariable ["SA_Tow_Ropes",[]]; _ropeLength = (_this select 0) getVariable ["SA_RopeLength", 0];(count _existingTowRopes > 0 AND (_ropeLength >= 11 OR _ropeLength <= 7))},{}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_RopeLength"], _myaction] call ace_interact_menu_fnc_addActionToObject;


_myaction = ["AdvTow_Five", "5 Meters","",{[_this, 5] call AdvLog_fnc_windTowRope;},{_existingTowRopes = (_this select 0) getVariable ["SA_Tow_Ropes",[]]; _ropeLength = (_this select 0) getVariable ["SA_RopeLength", 0];(count _existingTowRopes > 0 AND (_ropeLength >= 6 OR _ropeLength <= 4))},{}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_RopeLength"], _myaction] call ace_interact_menu_fnc_addActionToObject;


_myaction = ["AdvTow_Three", "3 Meters","",{[_this, 3] call AdvLog_fnc_windTowRope;},{_existingTowRopes = (_this select 0) getVariable ["SA_Tow_Ropes",[]]; _ropeLength = (_this select 0) getVariable ["SA_RopeLength", 0];(count _existingTowRopes > 0 AND _ropeLength >= 4)},{}] call ace_interact_menu_fnc_createAction;

[_vehicle, 0, ["ACE_MainActions", "AdvTow_RopeLength"], _myaction] call ace_interact_menu_fnc_addActionToObject;


// _ropeLength = (_this select 0) getVariable ["SA_RopeLength", 0];(count _existingTowRopes > 0 AND _ropeLength >= 8)