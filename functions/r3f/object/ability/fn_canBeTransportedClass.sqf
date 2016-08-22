params [["_class", nil]];

if (isNil "_class") exitWith {[false, 0]};

// Get the heritage of the object
_class_heritage = [];
for [
	{_config = configFile >> "CfgVehicles" >> _class},
	{isClass _config},
	{_config = inheritsFrom _config}
] do
{
	_class_heritage pushBack (toLower configName _config);
};

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