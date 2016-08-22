params [["_object", objNull]];

if (isNull _object) exitWith {false};

_class = typeOf _object;

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

_class_heritage


