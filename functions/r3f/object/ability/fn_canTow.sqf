params [["_object", objNull]];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {false};

if (isNull _object) exitWith {false};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;

// Can the object tow things?
_can_tow = false;
{
	if (_x in R3F_LOG_CFG_can_tow) exitWith {_can_tow = true;};
} forEach _class_heritage;

_can_tow