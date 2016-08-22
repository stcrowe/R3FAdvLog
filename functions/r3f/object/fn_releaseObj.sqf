if (R3F_LOG_mutex_local_lock) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{

	// Added by Crowe - make creating most costly objects take longer to place

					_object = R3F_LOG_player_moves_object;

					_costs = [_object] call AdvLog_fnc_buildCosts;

					if (_costs >= 1) then
					{
								_handler = [{player playActionNow "MedicOther";}, 7, []] call CBA_fnc_addPerFrameHandler;

								[_costs, [_handler],

									{

										R3F_LOG_player_moves_object = objNull;
										(_this select 0) call CBA_fnc_removePerFrameHandler;
										player switchMove "";

									}, {(_this select 0) call CBA_fnc_removePerFrameHandler; player switchMove ""; hint "Cancelled";}, format ["Building %1", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")]] call ace_common_fnc_progressBar;
					}
					else
					{
						R3F_LOG_player_moves_object = objNull;
					};

					//Done player playActionNow "MedicOther";




};