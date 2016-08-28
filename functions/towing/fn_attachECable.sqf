params ["_vehicle", "_player"];

_player removeItem "AdvLog_TowCable";
_vehicle setVariable ["AdvLog_attachedECable", true, true];


params ["_vehicle", "_player"];
if([_vehicle, _player] call AdvLog_fnc_canTakeTowRopes) then {

	if (!local _vehicle) then
	{

		[_vehicle, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];

	};

	_vehicle setVariable ["SA_RopeLength", 5, true];
	[_player,1,["ACE_SelfActions", "ACE_Equipment", 'AdvTow_Drop']] call ace_interact_menu_fnc_removeActionFromObject;

	private ["_existingTowRopes","_hitchPoint","_rope"];
	_existingTowRopes = _vehicle getVariable ["SA_Tow_Ropes",[]];
	if (count _existingTowRopes == 0) then {
		_hitchPoint = [_vehicle] call AdvLog_fnc_getHitchPoints select 1;
		_rope = ropeCreate [_vehicle, _hitchPoint, 5];
		_vehicle setVariable ["SA_Tow_Ropes",[_rope],true];
		_this call AdvLog_fnc_pickupTowRopes;
	};

};
