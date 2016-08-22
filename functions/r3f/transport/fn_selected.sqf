/**
 * Modified by Sean Crowe, original script by Team ~R3F~
 * please see orginal work @ https://forums.bistudio.com/topic/170033-r3f-logistics/
 *
 * To get a full list of changes please contant me on the biforums under the username S.Crowe
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_lock) then
{
	hintC STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_lock = true;

	R3F_LOG_object_selectionne = _this select 0;

	R3F_LOG_action_load_valid_selection = true;

	systemChat format [STR_R3F_LOG_action_selectionner_object_fait, getText (configFile >> "CfgVehicles" >> (typeOf R3F_LOG_object_selectionne) >> "displayName")];

	// D?selectionner l'objet si le joueur n'en fait rien
	[] spawn
	{
		while {!isNull R3F_LOG_object_selectionne} do
		{
			if (!alive player) then
			{
				R3F_LOG_object_selectionne = objNull;
			}
			else
			{
				if (vehicle player != player || (player distance R3F_LOG_object_selectionne > 10) || !isNull R3F_LOG_player_moves_object) then
				{

					R3F_LOG_object_selectionne = objNull;
				};
			};

			sleep 0.2;
		};

		R3F_LOG_action_load_valid_selection = false;
	};

	R3F_LOG_mutex_local_lock = false;
};