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

params ["_cargo","_player"];
	_vehicle = _player getVariable ["SA_Tow_Ropes_Vehicle", objNull];

	if(!isNull _vehicle) then {
		if(!local _vehicle) then {

			[_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];
		};

		private ["_towRopes","_vehicleHitch","_cargoHitch","_objDistance","_ropeLength"];
		_towRopes = _vehicle getVariable ["SA_Tow_Ropes",[]];
		if(count _towRopes == 1) then {

			_cargoHitch = ([_cargo] call AdvLog_fnc_getHitchPoints) select 0;

			_vehicleHitch = ([_vehicle] call AdvLog_fnc_getHitchPoints) select 1;
			_ropeLength = _vehicle getVariable ["SA_RopeLength", 20];
			//_ropeLength = (ropeLength (_towRopes select 0));
			_objDistance = ((_vehicle modelToWorld _vehicleHitch) distance (_cargo modelToWorld _cargoHitch));
			if( _objDistance > _ropeLength ) then {
				"The tow ropes are too short. Move vehicle closer." remoteExecCall ["systemChat", _player];
			}
			else {

				_helper = (_player getVariable ["SA_Tow_Ropes_Pick_Up_Helper", objNull]);
				if(!isNull _helper) then {
					{
						_helper ropeDetach _x;
					} forEach (_vehicle getVariable ["SA_Tow_Ropes",[]]);
					detach _helper;
					deleteVehicle _helper;
				};
				_player setVariable ["SA_Tow_Ropes_Vehicle", nil,true];
				_player setVariable ["SA_Tow_Ropes_Pick_Up_Helper", nil,true];

				_helper = "Land_CanOpener_F" createVehicle position _cargo;
				_helper attachTo [_cargo, _cargoHitch];
				_helper setVariable ["SA_Cargo",_cargo,true];
				_helper hideObjectGlobal true;
				[_helper, [0,0,0], [0,0,-1]] ropeAttachTo (_towRopes select 0);
				//_vehicle setVariable ["SA_RopeLength", _ropeLength, true];
				[_player,1,["ACE_SelfActions", "ACE_Equipment", 'AdvTow_Drop']] call ace_interact_menu_fnc_removeActionFromObject;
				[_vehicle,_vehicleHitch,_cargo,_cargoHitch] spawn AdvLog_fnc_simulateTowing;
			};
		};
	};