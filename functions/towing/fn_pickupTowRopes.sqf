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

if (!local _vehicle) then
{
	[_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];

};


private ["_attachedObj","_helper"];
{
	_attachedObj = _x;
	{
		_attachedObj ropeDetach _x;
	} forEach (_vehicle getVariable ["SA_Tow_Ropes",[]]);
	deleteVehicle _attachedObj;
} forEach ropeAttachedObjects _vehicle;

_helper = "Land_CanOpener_F" createVehicle position _player;
{
	[_helper, [0, 0, 0], [0,0,-1]] ropeAttachTo _x;
	_helper attachTo [_player, [-0.1, 0.1, 0.15], "Pelvis"];
} forEach (_vehicle getVariable ["SA_Tow_Ropes",[]]);

//hideObject _helper;
hideObjectGlobal _helper;

_player setVariable ["SA_Tow_Ropes_Vehicle", _vehicle,true];
_player setVariable ["SA_Tow_Ropes_Pick_Up_Helper", _helper,true];

_orderAction = ['AdvTow_Drop','Drop Tow Ropes','',{[player getVariable ["SA_Tow_Ropes_Vehicle", objNull], player] call AdvLog_fnc_dropTowRopes;},{!isNull (player getVariable ["SA_Tow_Ropes_Vehicle", objNull])}] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "ACE_Equipment"], _orderAction] call AdvLog_fnc_globalAddAction;