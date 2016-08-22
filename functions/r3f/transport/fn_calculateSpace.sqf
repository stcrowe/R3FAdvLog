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

private ["_objects_charges", "_chargement_actuel", "_chargement_maxi"];

params [["_transporteur", objNull]];

_objects_charges = _transporteur getVariable ["R3F_LOG_objects_charges", []];

// Get amount of cargo in vehicle
_chargement_actuel = 0;
{
	_chargement_actuel = _chargement_actuel + (([_x] call AdvLog_fnc_canBeTransported) param [1, 0]);

} forEach _objects_charges;

// Get maximum amount of cargo held

_chargement_maxi = ([_transporteur] call AdvLog_fnc_canTransport) param [1, 0];

[_chargement_actuel, _chargement_maxi]