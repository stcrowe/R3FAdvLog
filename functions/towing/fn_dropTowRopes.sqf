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

params ["_vehicle","_player"];
if(local _vehicle) then {
	private ["_helper"];
	_helper = (_player getVariable ["SA_Tow_Ropes_Pick_Up_Helper", objNull]);
	if(!isNull _helper) then {
		{
			//_helper ropeDetach _x;

			//_ropehelper = "Land_CanOpener_F" createVehicle position player;


			//_x ropeAttachedTo _ropehelper;

/*
			_myaction = ["AdvTow_takeRopes", "Take Tow Ropes","",{_this call SA_Take_Tow_Ropes_Action;},{_this call SA_Can_Take_Tow_Ropes},{}] call ace_interact_menu_fnc_createAction;

			[_ropehelper, 0, ["ACE_MainActions"], _myaction] call ace_interact_menu_fnc_addActionToObject;*/

		} forEach (_vehicle getVariable ["SA_Tow_Ropes",[]]);
		detach _helper;
		_helper hideObjectGlobal false;

		_helper setVariable ["AdvLog_Tow_Ropes_Vehicle", _vehicle];

		if !(_helper getVariable ["AdvLog_ACE_pickup_added", false]) then
		{
			_myaction = ["AdvTow_pickup", "Pickup Tow Rope","",{[(_this select 0) getVariable ["AdvLog_Tow_Ropes_Vehicle",objNull], player] call AdvLog_fnc_pickupTowRopes;},{_this call AdvLog_fnc_canPickupTowRopes},{}] call ace_interact_menu_fnc_createAction;

			[_helper, 0, ["ACE_MainActions"], _myaction] call AdvLog_fnc_globalAddAction;

			_helper setVariable ["AdvLog_ACE_pickup_added", true];
		};

	};
	_player setVariable ["SA_Tow_Ropes_Vehicle", nil,true];
	_player setVariable ["SA_Tow_Ropes_Pick_Up_Helper", nil,true];

	[_player,1,["ACE_SelfActions", "ACE_Equipment", 'AdvTow_Drop']] call ace_interact_menu_fnc_removeActionFromObject;
}
else
{
	_this remoteExecCall  ["AdvLog_fnc_dropTowRopes",_vehicle];
};