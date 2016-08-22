params ["_vehicle"];

_existingTowRopes = _vehicle getVariable ["SA_Tow_Ropes",[]];
_existingVehicle = player getVariable ["SA_Tow_Ropes_Vehicle", objNull];
(vehicle player == player && player distance _vehicle < 10 && (count _existingTowRopes) == 0 && isNull _existingVehicle && missionNamespace getVariable ["AdvLog_Endabled", true] && (vectorMagnitude velocity _vehicle) < 2)
