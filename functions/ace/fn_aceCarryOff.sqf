params ["_object"];

_object = _object param [0, objNull];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {};

waitUntil {sleep 0.1; !(isNil "R3F_LOG_active")};

_object setVariable ['ace_dragging_canCarry', false];
_object setVariable ['ace_dragging_canDrag', false];
_object setVariable ['ace_cargo_space', 0];
_object setVariable ['ace_cargo_canLoad', 0];

