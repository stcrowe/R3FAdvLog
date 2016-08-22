/*
Modified by Sean Crowe
please see orginal work @ forums.bistudio.com/topic/188980-advanced-towing

To get a full list of changes please contant me on the biforums under the username S.Crowe

The MIT License (MIT)

Copyright (c) 2016 Seth Duda

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

params ["_cargo"];

private ["_canTow", "_vehicle", "_rules"];

_rules = [
	["Tank","CAN_TOW","Tank"],
	["Tank","CAN_TOW","Car"],
	["Tank","CAN_TOW","Ship"],
	["Tank","CAN_TOW","Air"],
	["Car","CAN_TOW","Tank"],
	["Car","CAN_TOW","Car"],
	["Car","CAN_TOW","Ship"],
	["Car","CAN_TOW","Air"],
	["Ship","CAN_TOW","Ship"]
];


_vehicle = player getVariable ["SA_Tow_Ropes_Vehicle", objNull];
_ropeLength = _vehicle getVariable ["SA_RopeLength", 20];
_canTow = false;
if(not isNull _vehicle && not isNull _cargo) then {
	{
		if(_vehicle isKindOf (_x select 0)) then {
			if(_cargo isKindOf (_x select 2)) then {
				if( (toUpper (_x select 1)) == "CAN_TOW" ) then {
					_canTow = true;
				} else {
					_canTow = false;
				};
			};
		};
	} forEach (missionNamespace getVariable ["SA_TOW_RULES_OVERRIDE",_rules]);
};

if(!isNull _vehicle && !isNull _cargo) then
{
	(_canTow && vehicle player == player && _vehicle != _cargo)
}
else
{
	false
};