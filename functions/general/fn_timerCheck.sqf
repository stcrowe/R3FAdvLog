params [["_date", []], ["_minutes", 5]];

if (count _date < 5) exitWith {true};

_currentDate = date;


// Are we in the same month?
if ((_date param [1]) == (_currentDate param [1])) then
{

	_totalMinutes = ((_date param [2]) * 60 * 24) + ((_date param [3]) * 60) + (_date param [4]);

	_totalMinutesNow = ((_currentDate param [2]) * 60 * 24) + ((_currentDate param [3]) * 60) + (_currentDate param [4]);

	if (_totalMinutes <  _totalMinutesNow) then
	{
		_leftOverMinutes = _totalMinutesNow - _totalMinutes;

		if (_leftOverMinutes >= _minutes) then
		{
			true
		}
		else
		{
			false
		};

	}
	else
	{
		true
	};
}
else
{
	true
};

