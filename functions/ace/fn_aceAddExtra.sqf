_this spawn
{

	params [["_object", objNull]];

	_aceExtraAdded = _object getVariable ["AdvLog_aceExtraAdded", false];

	if (_aceExtraAdded) exitWith {};

	if (!(missionNamespace getVariable ["AdvLog_Endabled", true])) exitWith {};

	waitUntil {!isNil "R3F_LOG_active"};

	_car = _object isKindOf "Car";
	_tank = _object isKindOf "Tank";


	if (_car OR _tank) then
	{

		_cargoSpace = ([_object] call AdvLog_fnc_canTransport) param [1, 0];


		_tireSpace = (["ACE_Wheel"] call AdvLog_fnc_canBeTransportedClass) param [1, -1];
		_trackSpace = (["ACE_Track"] call AdvLog_fnc_canBeTransportedClass) param [1, -1];

		if (_car AND _tireSpace > -1) then
		{


			if (_cargoSpace > _tireSpace) then
			{
				[_object, ["ACE_Wheel"]] call AdvLog_fnc_autoload;
			};

			//Extra Tire?
			if (_object isKindOf "Truck_F" OR _object isKindOf "Wheeled_APC_F") then
			{
				if (_cargoSpace > (_tireSpace * 2)) then
				{
					[_object, ["ACE_Wheel"]] call AdvLog_fnc_autoload;
				};
			};


		};

		if (_tank AND _trackSpace > -1) then
		{

			if (_cargoSpace > _trackSpace) then
			{
				[_object, ["ACE_Track"]] call AdvLog_fnc_autoload;
			};

			if (_cargoSpace > (_trackSpace * 2)) then
			{
				[_object, ["ACE_Track"]] call AdvLog_fnc_autoload;
			};

		};

	};

	_object setVariable ["AdvLog_aceExtraAdded", true, true];
};
