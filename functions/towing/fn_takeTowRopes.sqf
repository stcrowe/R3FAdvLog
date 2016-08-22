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

private ["_vehicle","_canTakeTowRopes"];
	params ["_params", "_ropeLength"];
	_params params ["_vehicle", "_player"];

	if([_vehicle, _player] call AdvLog_fnc_canTakeTowRopes) then {

		if (!local _vehicle) then
		{
			[_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];
		};

		_vehicle setVariable ["SA_RopeLength", 20, true];
		[_player,1,["ACE_SelfActions", "ACE_Equipment", 'AdvTow_Drop']] call ace_interact_menu_fnc_removeActionFromObject;

		private ["_existingTowRopes","_hitchPoint","_rope"];
		_existingTowRopes = _vehicle getVariable ["SA_Tow_Ropes",[]];
		if (count _existingTowRopes == 0) then {
			_hitchPoint = [_vehicle] call AdvLog_fnc_getHitchPoints select 1;
			_rope = ropeCreate [_vehicle, _hitchPoint, 20];
			_vehicle setVariable ["SA_Tow_Ropes",[_rope],true];
			_params call AdvLog_fnc_pickupTowRopes;
		};

	};