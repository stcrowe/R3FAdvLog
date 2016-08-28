params [["_factory", objNull]];

if (isNull _factory) exitWith {[]};

_factoryData = _factory getVariable ["R3F_CF_local_factory", R3F_CF_global_factory];

(_factoryData param [0, []])