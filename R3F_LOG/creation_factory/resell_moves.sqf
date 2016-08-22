/**
 * Revendre l'objet d?plac? par le joueur ? une usine
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

	private ["_object", "_factory"];

	_object = R3F_LOG_player_moves_object;
	_factory = [_object, 5] call R3F_LOG_FNCT_3D_cursorTarget_virtuel;

	if (!isNull _factory && {
		!(_factory getVariable ["R3F_LOG_CF_disabled", true]) && alive _factory && (vectorMagnitude velocity _factory < 6) &&
		(abs ((getPosASL _factory select 2) - (getPosASL player select 2)) < 2.5)
	}) then
	{
		if (isNull (_object getVariable ["R3F_LOG_remorque", objNull])) then
		{
			if (count (_object getVariable ["R3F_LOG_objects_charges", []]) == 0) then
			{
				_object setVariable ["R3F_LOG_is_transported_by", _factory, true];

				// Faire relacher l'objet au joueur
				R3F_LOG_player_moves_object = objNull;
				waitUntil {_object getVariable "R3F_LOG_is_moved_by" != player};

				// Suppression de l'?quipage IA dans le cas d'un drone
				if (getNumber (configFile >> "CfgVehicles" >> (typeOf _object) >> "isUav") == 1) then
				{
					{if (!isPlayer _x) then {_object deleteVehicleCrew _x;};} forEach crew _object;
				};

				deleteVehicle _object;

				// Si l'usine n'a pas de cr?dits illimit? et que le taux d'occasion n'est pas nul
				if (_factory getVariable "R3F_LOG_CF_credits" != -1 && R3F_LOG_CFG_CF_sell_back_bargain_rate > 0) then
				{
					private ["_cout_neuf", "_valeur_occasion"];

					_cout_neuf = [typeOf _object] call R3F_LOG_FNCT_determine_cost_creation;
					_valeur_occasion = ceil (R3F_LOG_CFG_CF_sell_back_bargain_rate * (1 - damage _object) * _cout_neuf);

					// Ajout de la valeur d'occasion de l'objet dans les cr?dits de l'usine
					_factory setVariable ["R3F_LOG_CF_credits", (_factory getVariable "R3F_LOG_CF_credits") + _valeur_occasion, true];

					systemChat format [STR_R3F_LOG_action_revendre_fait + " (+%2 credits)",
						getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName"), [_valeur_occasion] call R3F_LOG_FNCT_format_number_of_integer_thousands];
				}
				else
				{
					systemChat format [STR_R3F_LOG_action_revendre_fait,
						getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
				};
			}
			else
			{
				hintC STR_R3F_LOG_action_revendre_decharger_avant;
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
		};
	};

	R3F_LOG_mutex_local_lock = false;
};