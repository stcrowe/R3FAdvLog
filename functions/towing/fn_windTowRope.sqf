_this spawn
{
	params ["_parma", "_length"];

	 _parma params ["_vehicle"];

	_ropes = _vehicle getVariable ["SA_Tow_Ropes",[]];
	_ropeLength = _vehicle getVariable ["SA_RopeLength", 10];

	{

		ropeUnwind [_x, 1.2, _length];

	} forEach (_ropes);

	//_vehicle setVariable ["SA_RopeLength", 3, true];

	while {_ropeLength != _length} do
	{
		if (_length > _ropeLength) then
		{

			_ropeLength = _ropeLength + 0.5;
		}
		else
		{
			_ropeLength = _ropeLength - 0.5;
		};

		_vehicle setVariable ["SA_RopeLength", _ropeLength, true];
		sleep 0.30;
	};

	/*
	if (count _ropes > 0) then
	{
		{
			if (ropeLength _x > 5) then
			{
				ropeUnwind [_x, 0.5, 4.5];
			};
		} forEach (_ropes);

		while {ropeLength (_ropes select 0) > 5} do
		{
			_vehicle setVariable ["SA_RopeLenght", ]
		};
	};*/



};