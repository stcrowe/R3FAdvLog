params [["_class", nil]];

if (isNil "_class") exitWith {false};

if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {false};

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

// Can object be moved by player?
_can_be_moved_by_player = false;
{
	if (_x in R3F_LOG_CFG_can_be_moved_by_player) exitWith {_can_be_moved_by_player = true;};
} forEach _class_heritage;


_can_be_moved_by_player