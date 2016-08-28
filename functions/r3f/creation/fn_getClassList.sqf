params [["_factory", objNull], ["_category", nil]];

if (isNull _factory || isNil "_category") exitWith {[]};

_factoryData = _factory getVariable ["R3F_CF_local_factory", R3F_CF_global_factory];

_categories = _factoryData param [0, []];

_index = -1;

if ((typeName _category) == "STRING") then
{
	_index = _categories find _category;
}
else
{
	_index = _category;
};

if (_index == -1) exitWith {[]};

_classesPerCat = _factoryData param [1, []];

_classesForCat = _classesPerCat param [_index, []];

_classList = [];

{
	_classList append [_x param [0, "Land_ToiletBox_F"]];
} forEach _classesForCat;

_classList