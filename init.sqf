

execVM "r3fAdvLog\R3F_LOG\init.sqf";

// Turn off ACE cargo


R3F_isACECargo = isClass (configFile >> "CfgPatches" >> "ace_cargo");

if (R3F_isACECargo) then
{
	[] spawn {

		waitUntil {!(isNil "ace_cargo_enable")};

		if (isServer) then
		{
			["ace_cargo_enable", false, true, true] call ace_common_fnc_setSetting;
		};

		ace_cargo_enable = false;

	};
};
