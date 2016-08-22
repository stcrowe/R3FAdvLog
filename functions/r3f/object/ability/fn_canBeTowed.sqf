params [["_object", objNull]];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {false};

if (isNull _object) exitWith {false};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;

_can_be_towed = false;
{
		if (_x in R3F_LOG_CFG_can_be_towed) exitWith {_can_be_towed = true;};
} forEach _class_heritage;

_can_be_towed