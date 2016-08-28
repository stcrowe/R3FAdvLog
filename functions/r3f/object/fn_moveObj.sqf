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

	R3F_LOG_object_selectionne = objNull;

	private ["_object", "_decharger", "_player", "_dir_player", "_arme_courante", "_muzzle_courant", "_mode_muzzle_courant", "_restaurer_arme", "_time"];
	private ["_vec_dir_rel", "_vec_dir_up", "_dernier_vec_dir_up", "_avant_dernier_vec_dir_up", "_normale_surface"];
	private ["_pos_rel_object_initial", "_pos_rel_object", "_dernier_pos_rel_object", "_avant_dernier_pos_rel_object"];
	private ["_elev_cam_initial", "_elev_cam", "_offset_hauteur_cam", "_offset_bounding_center", "_offset_hauteur_terrain"];
	private ["_offset_hauteur", "_dernier_offset_hauteur", "_avant_dernier_offset_hauteur"];
	private ["_hauteur_terrain_min_max_object", "_offset_hauteur_terrain_min", "_offset_hauteur_terrain_max"];
	private ["_action_relacher", "_action_aligner_pente", "_action_aligner_sol", "_action_aligner_horizon", "_action_tourner", "_action_rapprocher", "_action_cancel"];
	private ["_idx_eh_fired", "_idx_eh_keyDown", "_idx_eh_keyUp", "_time_derniere_rotation", "_time_derniere_translation"];

	_object = _this param [0, objNull];
	_decharger = _this param [3, false];
	_player = player;
	_dir_player = getDir _player;

	if (isNull _object) exitWith {};

	if (isNull (_object getVariable ["R3F_LOG_is_transported_by", objNull]) && (isNull (_object getVariable ["R3F_LOG_is_moved_by", objNull]) || (!alive (_object getVariable ["R3F_LOG_is_moved_by", objNull])) || (!isPlayer (_object getVariable ["R3F_LOG_is_moved_by", objNull])))) then
	{
		if (isNull (_object getVariable ["R3F_LOG_remorque", objNull])) then
		{
			if (count crew _object == 0 || getNumber (configFile >> "CfgVehicles" >> (typeOf _object) >> "isUav") == 1) then
			{
				_object setVariable ["R3F_LOG_is_moved_by", _player, true];

				_player forceWalk true;

				R3F_LOG_player_moves_object = _object;


				if (_decharger) then
				{
					// Orienter l'objet en fonction de son profil
					if (((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) != 0 && // Div par 0
						{
							((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) > 3.2 &&
							((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) /
							((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) > 1.25
						}
					) then
					{R3F_LOG_deplace_dir_rel_object = 90;} else {R3F_LOG_deplace_dir_rel_object = 0;};

					// Calcul de la position relative, de sorte ? ?loigner l'objet suffisamment pour garder un bon champ de vision
					_pos_rel_object_initial = [
						(boundingCenter _object select 0) * cos R3F_LOG_deplace_dir_rel_object - (boundingCenter _object select 1) * sin R3F_LOG_deplace_dir_rel_object,
						((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
						((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
						2 + 0.3 * (
							((boundingBoxReal _object select 1 select 1)-(boundingBoxReal _object select 0 select 1)) * abs sin R3F_LOG_deplace_dir_rel_object +
							((boundingBoxReal _object select 1 select 0)-(boundingBoxReal _object select 0 select 0)) * abs cos R3F_LOG_deplace_dir_rel_object
						),
						-(boundingBoxReal _object select 0 select 2)
					];

					_elev_cam_initial = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));

					_pos_rel_object_initial set [2, 0.1 + (_player selectionPosition "head" select 2) + (_pos_rel_object_initial select 1) * tan (89 min (-89 max (90-_elev_cam_initial)))];
				}
				else
				{

					R3F_LOG_deplace_dir_rel_object = (getDir _object) - _dir_player;

					_pos_rel_object_initial = _player worldToModel (_object modelToWorld [0,0,0]);

					// Calcul de la position relative de l'objet, bas?e sur la position initiale, et s?curis?e pour ne pas que l'objet rentre dans le joueur lors de la rotation
					// L'ajout de ce calcul a ?galement rendu inutile le test avec la fonction R3F_LOG_FNCT_unite_marche_dessus lors de la prise de l'objet
					_pos_rel_object_initial = [
						_pos_rel_object_initial select 0,
						(_pos_rel_object_initial select 1) max
						(
							((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
							((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
							1.2
						),
						_pos_rel_object_initial select 2
					];

					_elev_cam_initial = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
				};
				R3F_LOG_deplace_distance_rel_object = _pos_rel_object_initial select 1;

				// D?termination du mode d'alignement initial en fonction du type d'objet, de ses dimensions, ...
				R3F_LOG_deplace_mode_alignement = switch (true) do
				{
					case !(_object isKindOf "Static"): {"sol"};
					// Objet statique allong?
					case (
							((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) != 0 && // Div par 0
							{
								((boundingBoxReal _object select 1 select 0) - (boundingBoxReal _object select 0 select 0)) /
								((boundingBoxReal _object select 1 select 1) - (boundingBoxReal _object select 0 select 1)) > 1.75
							}
						): {"pente"};
					// Objet statique carr? ou peu allong?
					default {"horizon"};
				};


				// We request? That the object is local to the player for R?reduce the latencies (setDir, attachTo periodic)
				if (!local _object) then
				{
					private ["_time_demande_setOwner"];
					_time_demande_setOwner = time;

					[_object, clientOwner] remoteExec ["AdvLog_fnc_setOwner", 2];

					waitUntil {local _object || time > _time_demande_setOwner + 1.5};
				};

				/*// On pr?vient tout le monde qu'un nouveau objet va ?tre d?place pour ingorer les ?ventuelles blessures
				R3F_LOG_PV_nouvel_object_en_deplacement = _object;
				publicVariable "R3F_LOG_PV_nouvel_object_en_deplacement";
				["R3F_LOG_PV_nouvel_object_en_deplacement", R3F_LOG_PV_nouvel_object_en_deplacement] call R3F_LOG_FNCT_PVEH_nouvel_object_en_deplacement;*/

				_object allowDamage false;

				// M?morisation de l'arme courante et de son mode de tir
				_arme_courante = currentWeapon _player;
				_muzzle_courant = currentMuzzle _player;
				_mode_muzzle_courant = currentWeaponMode _player;

				// Sous l'eau on n'a pas le choix de l'arme
				if (!surfaceIsWater getPos _player) then
				{
					/*// Prise du PA si le joueur en a un
					if (handgunWeapon _player != "") then
					{
						_restaurer_arme = false;
						for [{_idx_muzzle = 0}, {currentWeapon _player != handgunWeapon _player}, {_idx_muzzle = _idx_muzzle+1}] do
						{
							_player action ["SWITCHWEAPON", _player, _player, _idx_muzzle];
						};
					}
					// Sinon pas d'arme dans les mains
					else
					{
						_restaurer_arme = true;
						_player action ["SWITCHWEAPON", _player, _player, 99999];
					};*/

					_restaurer_arme = true;
					_player action ["SWITCHWEAPON", _player, _player, 99999];
				} else {_restaurer_arme = false;};

				sleep 0.5;


				// V?rification qu'on ai bien obtenu la main (conflit d'acc?s simultan?s)
				if (_object getVariable "R3F_LOG_is_moved_by" == _player && isNull (_object getVariable ["R3F_LOG_is_transported_by", objNull])) then
				{
					R3F_LOG_deplace_force_setVector = false; // Mettre ? true pour forcer la r?-otientation de l'objet, en for?ant les filtres anti-flood
					R3F_LOG_deplace_force_attachTo = false; // Mettre ? true pour forcer le repositionnement de l'objet, en for?ant les filtres anti-flood

					// Ajout des actions de gestion de l'orientation
					_action_relacher = _player addAction [("<t color=""#ee0000"">" + format [STR_R3F_LOG_action_release_object, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")] + "</t>"), {_this call AdvLog_fnc_releaseObj;}, nil, 10, true, true];
					_action_aligner_pente = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_align_slope + "</t>"), {R3F_LOG_deplace_mode_alignement = "pente"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""pente"""];
					_action_aligner_sol = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_sol + "</t>"), {R3F_LOG_deplace_mode_alignement = "sol"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""sol"""];
					_action_aligner_horizon = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_aligner_horizon + "</t>"), {R3F_LOG_deplace_mode_alignement = "horizon"; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, true, "", "R3F_LOG_deplace_mode_alignement != ""horizon"""];
					_action_tourner = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_tourner + "</t>"), {R3F_LOG_deplace_dir_rel_object = R3F_LOG_deplace_dir_rel_object + 12; R3F_LOG_deplace_force_setVector = true;}, nil, 6, false, false];
					_action_rapprocher = _player addAction [("<t color=""#00eeff"">" + STR_R3F_LOG_action_rapprocher + "</t>"), {R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object - 0.4; R3F_LOG_deplace_force_attachTo = true;}, nil, 6, false, false];

					if (_object getVariable ["R3F_LOG_CF_depuis_factory", false]) then
					{
						_action_cancel = _player addAction [format ["<t color=""#bd1526"">Return %1</t>", getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")], {R3F_LOG_player_moves_object setVariable["R3F_DeleteMe", true]; R3F_LOG_player_moves_object = objNull;}, nil, 6, false, false];

					};

					// Rel?cher l'objet d?s que le joueur tire. Le detach sert ? rendre l'objet solide pour ne pas tirer au travers.
					_idx_eh_fired = _player addEventHandler ["Fired", {if (!surfaceIsWater getPos player) then {detach R3F_LOG_player_moves_object; R3F_LOG_player_moves_object = objNull;};}];

					// Gestion des ?v?nements KeyDown et KeyUp pour faire tourner l'objet avec les touches X/C
					R3F_LOG_player_deplace_key_rotation = "";
					R3F_LOG_player_deplace_key_translation = "";
					_time_derniere_rotation = 0;
					_time_derniere_translation = 0;
					_idx_eh_keyDown = (findDisplay 46) displayAddEventHandler ["KeyDown",
					{
						switch (_this select 1) do
						{
							case 45: {R3F_LOG_player_deplace_key_rotation = "X"; true};
							case 46: {R3F_LOG_player_deplace_key_rotation = "C"; true};
							case 33: {R3F_LOG_player_deplace_key_translation = "F"; true};
							case 19: {R3F_LOG_player_deplace_key_translation = "R"; true};
							default {false};
						}
					}];
					_idx_eh_keyUp = (findDisplay 46) displayAddEventHandler ["KeyUp",
					{
						switch (_this select 1) do
						{
							case 45: {R3F_LOG_player_deplace_key_rotation = ""; true};
							case 46: {R3F_LOG_player_deplace_key_rotation = ""; true};
							case 33: {R3F_LOG_player_deplace_key_translation = ""; true};
							case 19: {R3F_LOG_player_deplace_key_translation = ""; true};
							default {false};
						}
					}];

					// Initialisation de l'historique anti-flood
					_offset_hauteur = _pos_rel_object_initial select 2;
					_dernier_offset_hauteur = _offset_hauteur + 100;
					_avant_dernier_offset_hauteur = _dernier_offset_hauteur + 100;
					_dernier_pos_rel_object = _pos_rel_object_initial;
					_avant_dernier_pos_rel_object = _dernier_pos_rel_object;
					_vec_dir_rel = [sin R3F_LOG_deplace_dir_rel_object, cos R3F_LOG_deplace_dir_rel_object, 0];
					_vec_dir_up = [_vec_dir_rel, [0, 0, 1]];
					_dernier_vec_dir_up = [[0,0,0] vectorDiff (_vec_dir_up select 0), _vec_dir_up select 1];
					_avant_dernier_vec_dir_up = [_dernier_vec_dir_up select 0, [0,0,0] vectorDiff (_dernier_vec_dir_up select 1)];

					_object attachTo [_player, _pos_rel_object_initial];

					// Si ?chec transfert local, mode d?grad? : on conserve la direction de l'objet par rapport au joueur
					if (!local _object) then
					{
						[_object,R3F_LOG_deplace_dir_rel_object] remoteExec ["AdvLog_fnc_setDir"];
					};

					R3F_LOG_mutex_local_lock = false;

					// Boucle de gestion des ?v?nements et du positionnement pendant le d?placement
					while {!isNull R3F_LOG_player_moves_object && _object getVariable "R3F_LOG_is_moved_by" == _player && alive _player} do
					{
						// Gestion de l'orientation de l'objet en fonction du terrain
						if (local _object) then
						{
							// En fonction de la touche appuy?e (X/C), on fait pivoter l'objet
							if (R3F_LOG_player_deplace_key_rotation == "X" || R3F_LOG_player_deplace_key_rotation == "C") then
							{
								// Un cycle sur deux maxi (flood) on modifie de l'angle
								if (time - _time_derniere_rotation > 0.045) then
								{
									if (R3F_LOG_player_deplace_key_rotation == "X") then {R3F_LOG_deplace_dir_rel_object = R3F_LOG_deplace_dir_rel_object + 4;};
									if (R3F_LOG_player_deplace_key_rotation == "C") then {R3F_LOG_deplace_dir_rel_object = R3F_LOG_deplace_dir_rel_object - 4;};

									R3F_LOG_deplace_force_setVector = true;
									_time_derniere_rotation = time;
								};
							} else {_time_derniere_rotation = 0;};

							_vec_dir_rel = [sin R3F_LOG_deplace_dir_rel_object, cos R3F_LOG_deplace_dir_rel_object, 0];

							// Conversion de la normale du sol dans le rep?re du joueur car l'objet est attachTo
							_normale_surface = surfaceNormal getPos _object;
							_normale_surface = (player worldToModel ASLtoATL (_normale_surface vectorAdd getPosASL player)) vectorDiff (player worldToModel ASLtoATL (getPosASL player));

							// Red?finir l'orientation en fonction du terrain et du mode d'alignement
							_vec_dir_up = switch (R3F_LOG_deplace_mode_alignement) do
							{
								case "sol": {[[-cos R3F_LOG_deplace_dir_rel_object, sin R3F_LOG_deplace_dir_rel_object, 0] vectorCrossProduct _normale_surface, _normale_surface]};
								case "pente": {[_vec_dir_rel, _normale_surface]};
								default {[_vec_dir_rel, [0, 0, 1]]};
							};

							// On r?-oriente l'objet, lorsque n?cessaire (pas de flood)
							if (R3F_LOG_deplace_force_setVector ||
								(
									// Vecteur dir suffisamment diff?rent du dernier
									(_vec_dir_up select 0) vectorCos (_dernier_vec_dir_up select 0) < 0.999 &&
									// et diff?rent de l'avant dernier (pas d'oscillations sans fin)
									vectorMagnitude ((_vec_dir_up select 0) vectorDiff (_avant_dernier_vec_dir_up select 0)) > 1E-9
								) ||
								(
									// Vecteur up suffisamment diff?rent du dernier
									(_vec_dir_up select 1) vectorCos (_dernier_vec_dir_up select 1) < 0.999 &&
									// et diff?rent de l'avant dernier (pas d'oscillations sans fin)
									vectorMagnitude ((_vec_dir_up select 1) vectorDiff (_avant_dernier_vec_dir_up select 1)) > 1E-9
								)
							) then
							{
								_object setVectorDirAndUp _vec_dir_up;

								_avant_dernier_vec_dir_up = _dernier_vec_dir_up;
								_dernier_vec_dir_up = _vec_dir_up;

								R3F_LOG_deplace_force_setVector = false;
							};
						};

						sleep 0.015;

						// En fonction de la touche appuy?e (F/R), on fait avancer ou reculer l'objet
						if (R3F_LOG_player_deplace_key_translation == "F" || R3F_LOG_player_deplace_key_translation == "R") then
						{
							// Un cycle sur deux maxi (flood) on modifie de l'angle
							if (time - _time_derniere_translation > 0.045) then
							{
								if (R3F_LOG_player_deplace_key_translation == "F") then
								{
									R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object - 0.075;
								}
								else
								{
									R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object + 0.075;
								};

								// Borne min-max de la distance
								R3F_LOG_deplace_distance_rel_object = R3F_LOG_deplace_distance_rel_object min (
										(
											vectorMagnitude [
												(-(boundingBoxReal _object select 0 select 0)) max (boundingBoxReal _object select 1 select 0),
												(-(boundingBoxReal _object select 0 select 1)) max (boundingBoxReal _object select 1 select 1),
												0
											] + 2
										) max (_pos_rel_object_initial select 1)
								) max (
									(
										((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
										((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
										1.2
									)
								);

								R3F_LOG_deplace_force_attachTo = true;
								_time_derniere_translation = time;
							};
						} else {_time_derniere_translation = 0;};

						// Calcul de la position relative de l'objet, bas?e sur la position initiale, et s?curis?e pour ne pas que l'objet rentre dans le joueur lors de la rotation
						// L'ajout de ce calcul a ?galement rendu inutile le test avec la fonction R3F_LOG_FNCT_unite_marche_dessus lors de la prise de l'objet
						_pos_rel_object = [
							_pos_rel_object_initial select 0,
							R3F_LOG_deplace_distance_rel_object max
							(
								((-(boundingBoxReal _object select 0 select 0) * sin R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 0) * sin R3F_LOG_deplace_dir_rel_object)) +
								((-(boundingBoxReal _object select 0 select 1) * cos R3F_LOG_deplace_dir_rel_object) max (-(boundingBoxReal _object select 1 select 1) * cos R3F_LOG_deplace_dir_rel_object)) +
								1.2
							),
							_pos_rel_object_initial select 2
						];

						_elev_cam = acos ((ATLtoASL positionCameraToWorld [0, 0, 1] select 2) - (ATLtoASL positionCameraToWorld [0, 0, 0] select 2));
						_offset_hauteur_cam = (vectorMagnitude [_pos_rel_object select 0, _pos_rel_object select 1, 0]) * tan (89 min (-89 max (_elev_cam_initial - _elev_cam)));
						_offset_bounding_center = ((_object modelToWorld boundingCenter _object) select 2) - ((_object modelToWorld [0,0,0]) select 2);

						// Calcul de la hauteur de l'objet en fonction de l'?l?vation de la cam?ra et du terrain
						if (_object isKindOf "Static") then
						{
							// En mode horizontal, la plage d'offset terrain est calcul?e de sorte ? conserver au moins un des quatre coins inf?rieurs en contact avec le sol
							if (R3F_LOG_deplace_mode_alignement == "horizon") then
							{
								_hauteur_terrain_min_max_object = [_object] call R3F_LOG_FNCT_3D_get_hauteur_terrain_min_max_object;
								_offset_hauteur_terrain_min = (_hauteur_terrain_min_max_object select 0) - (getPosASL _player select 2) + _offset_bounding_center;
								_offset_hauteur_terrain_max = (_hauteur_terrain_min_max_object select 1) - (getPosASL _player select 2) + _offset_bounding_center;

								// On autorise un l?ger enterrement jusqu'? 40% de la hauteur de l'objet
								_offset_hauteur_terrain_min = _offset_hauteur_terrain_min min (_offset_hauteur_terrain_max - 0.4 * ((boundingBoxReal _object select 1 select 2) - (boundingBoxReal _object select 0 select 2)) / (_dernier_vec_dir_up select 1 select 2));
							}
							// Dans les autres modes d'alignement, on autorise un l?ger enterrement jusqu'? 40% de la hauteur de l'objet
							else
							{
								_offset_hauteur_terrain_max = getTerrainHeightASL (getPos _object) - (getPosASL _player select 2) + _offset_bounding_center;
								_offset_hauteur_terrain_min = _offset_hauteur_terrain_max - 0.4 * ((boundingBoxReal _object select 1 select 2) - (boundingBoxReal _object select 0 select 2)) / (_dernier_vec_dir_up select 1 select 2);
							};

							if (R3F_LOG_CFG_no_gravity_objects_can_be_set_in_height_over_ground) then
							{
								_offset_hauteur = _offset_hauteur_terrain_min max ((-1.4 + _offset_bounding_center) max ((2.75 + _offset_bounding_center) min ((_pos_rel_object select 2) + _offset_hauteur_cam)));
							}
							else
							{
								_offset_hauteur = _offset_hauteur_terrain_min max (_offset_hauteur_terrain_max min ((_pos_rel_object select 2) + _offset_hauteur_cam)) + (getPosATL _player select 2);
							};
						}
						else
						{
							_offset_hauteur_terrain = getTerrainHeightASL (getPos _object) - (getPosASL _player select 2) + _offset_bounding_center;
							_offset_hauteur = _offset_hauteur_terrain max ((-1.4 + _offset_bounding_center) max ((2.75 + _offset_bounding_center) min ((_pos_rel_object select 2) + _offset_hauteur_cam)));
						};

						// On repositionne l'objet par rapport au joueur, lorsque n?cessaire (pas de flood)
						if (R3F_LOG_deplace_force_attachTo ||
							(
								// Positionnement en hauteur suffisamment diff?rent
								abs (_offset_hauteur - _dernier_offset_hauteur) > 0.025 &&
								// et diff?rent de l'avant dernier (pas d'oscillations sans fin)
								abs (_offset_hauteur - _avant_dernier_offset_hauteur) > 1E-9
							) ||
							(
								// Position relative suffisamment diff?rente
								vectorMagnitude (_pos_rel_object vectorDiff _dernier_pos_rel_object) > 0.025 &&
								// et diff?rente de l'avant dernier (pas d'oscillations sans fin)
								vectorMagnitude (_pos_rel_object vectorDiff _avant_dernier_pos_rel_object) > 1E-9
							)
						) then
						{
							_object attachTo [_player, [
								_pos_rel_object select 0,
								_pos_rel_object select 1,
								_offset_hauteur
							]];

							_avant_dernier_offset_hauteur = _dernier_offset_hauteur;
							_dernier_offset_hauteur = _offset_hauteur;

							_avant_dernier_pos_rel_object = _dernier_pos_rel_object;
							_dernier_pos_rel_object = _pos_rel_object;

							R3F_LOG_deplace_force_attachTo = false;
						};

						// On interdit de monter dans un v?hicule tant que l'objet est port?
						if (vehicle _player != _player) then
						{
							systemChat STR_R3F_LOG_ne_pas_monter_dans_vehicule;
							_player action ["GetOut", vehicle _player];
							_player action ["Eject", vehicle _player];
							sleep 1;
						};

						// Le joueur change d'arme, on stoppe le d?placement et on ne reprendra pas l'arme initiale
						if (currentWeapon _player != "" && currentWeapon _player != handgunWeapon _player && !surfaceIsWater getPos _player) then
						{
							R3F_LOG_player_moves_object = objNull;
							_restaurer_arme = false;
						};

						sleep 0.015;
					};

					// Si l'objet est relach? (et donc pas charg? dans un v?hicule)
					if (isNull (_object getVariable ["R3F_LOG_is_transported_by", objNull])) then
					{
						//The object is no longer port?, there the refitting. The?ger setVelocity upwards is used? Defreezer objects that could float.
						// TODO gestion collision, en particulier si le joueur meurt

						[_object, [0, 0, 0.1]] remoteExec ["AdvLog_fnc_detach"];

						//[_object, "detachSetVelocity", [0, 0, 0.1]] call R3F_LOG_FNCT_exec_command_MP;
					};

					_player removeEventHandler ["Fired", _idx_eh_fired];
					(findDisplay 46) displayRemoveEventHandler ["KeyDown", _idx_eh_keyDown];
					(findDisplay 46) displayRemoveEventHandler ["KeyUp", _idx_eh_keyUp];

					_player removeAction _action_relacher;
					_player removeAction _action_aligner_pente;
					_player removeAction _action_aligner_sol;
					_player removeAction _action_aligner_horizon;
					_player removeAction _action_tourner;
					_player removeAction _action_rapprocher;
					if (!isNil "_action_cancel") then
					{
						_player removeAction _action_cancel;
					};

					if (_object getVariable["R3F_DeleteMe", false]) then
					{
						deleteVehicle _object;
					}
					else
					{
						_object setVariable ["R3F_LOG_is_moved_by", objNull, true];
						_object setVariable ["R3F_LOG_CF_depuis_factory", false, true];
					};
				}
				// Echec d'obtention de l'objet
				else
				{
					_object setVariable ["R3F_LOG_is_moved_by", objNull, true];
					R3F_LOG_mutex_local_lock = false;
				};

				_player forceWalk false;
				R3F_LOG_player_moves_object = objNull;



				// Reprise de l'arme et restauration de son mode de tir, si n?cessaire
				if (alive _player && !surfaceIsWater getPos _player && _restaurer_arme) then
				{
					for [{_idx_muzzle = 0},
						{currentWeapon _player != _arme_courante ||
						currentMuzzle _player != _muzzle_courant ||
						currentWeaponMode _player != _mode_muzzle_courant},
						{_idx_muzzle = _idx_muzzle+1}] do
					{
						_player action ["SWITCHWEAPON", _player, _player, _idx_muzzle];
					};
				};

				sleep 5; // 5 seconds to wait for the fall/stabilization
				if (!isNull _object) then
				{
					if (isNull (_object getVariable ["R3F_LOG_is_moved_by", objNull]) ||
						{(!alive (_object getVariable "R3F_LOG_is_moved_by")) || (!isPlayer (_object getVariable "R3F_LOG_is_moved_by"))}
					) then
					{
						_object allowDamage true;
					};
				};
			}
			else
			{
				hintC format [STR_R3F_LOG_player_dans_object, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
				R3F_LOG_mutex_local_lock = false;
			};
		}
		else
		{
			hintC format [STR_R3F_LOG_object_remorque_en_cours, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
			R3F_LOG_mutex_local_lock = false;
		};
	}
	else
	{
		hintC format [STR_R3F_LOG_object_in_course_transport, getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "displayName")];
		R3F_LOG_mutex_local_lock = false;
	};
};