/**
 * V?rifie si une unit? marche sur un objet ou est coll?e contre celui-ci
 *
 * @param 0 l'unit?
 * @param 1 l'objet pour lequel v?rifier si l'unit? marche dessus
 *
 * @return vrai si une unit? marche sur un objet ou est coll?e contre celui-ci
 *
 * @note les bounding box, trop approximatives, ne sont pas utilis?es
 * @note le calcul se fait ? l'aide de quelques dizaines de "lineIntersectsWith"
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

private ["_unite", "_object", "_contact", "_rayon", "_angle", "_pos_debut_segment", "_pos_fin_segment"];

_unite = _this select 0;
_object = _this select 1;

_contact = false;

// On scanne autour de l'unit? avec des segments r?partis sur 3 cercles
for "_rayon" from 0.3 to 0.9 step 0.3 do
{
	for "_angle" from 0 to 359 step 360 / (40 * _rayon) do
	{
		_pos_debut_segment = _unite modelToWorld [_rayon*sin _angle, _rayon*cos _angle, 1];
		_pos_fin_segment = [_pos_debut_segment select 0, _pos_debut_segment select 1, -1];

		if (_object in lineIntersectsWith [ATLtoASL _pos_debut_segment, ATLtoASL _pos_fin_segment, _unite, objNull, false]) then
		{
			_contact = true;
		};
	};
};

_contact