private ["_class_heritage, _can_transport_cargo, _can_transport_cargo_cout"];

params [["_object", objNull]];

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {[false, 0]};

if (isNull _object) exitWith {[false, 0]};

_class_heritage = [_object] call AdvLog_fnc_getObjectHeritage;

_can_be_transported_cargo = false;
_can_be_transported_cargo_cout = 0;
{
		_idx = R3F_LOG_classes_transportable_objects find _x;
		if (_idx != -1) exitWith
		{
			_can_be_transported_cargo = true;
			_can_be_transported_cargo_cout = R3F_LOG_CFG_can_be_transported_cargo select _idx select 1;
		};
} forEach _class_heritage;

[_can_be_transported_cargo, _can_be_transported_cargo_cout]