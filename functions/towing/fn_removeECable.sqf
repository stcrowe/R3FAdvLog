params ["_vehicle","_player"];

if (!local _vehicle) then
{
	[_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];

};


private ["_existingTowRopes","_hitchPoint","_rope"];
	_existingTowRopes = _vehicle getVariable ["SA_Tow_Ropes",[]];
	if(count _existingTowRopes > 0) then {
		_this call AdvLog_fnc_pickupTowRopes;

		private ["_helper"];
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

		{
			ropeDestroy _x;
		} forEach _existingTowRopes;
		_vehicle setVariable ["SA_Tow_Ropes",nil,true];
	};

_vehicle setVariable ["AdvLog_attachedECable", false, true];
[_player, "AdvLog_TowCable"] call ace_common_fnc_addToInventory;