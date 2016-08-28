/**
 * Enregistre les valeurs des champs avant fermeture de la bo?te de dialogue de l'usine de cr?ation.
 * ouvrir_factory.sqf s'en servira pour la pr?remplir ? l'ouverture
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

disableSerialization; // A cause des displayCtrl

private ["_factory", "_dlg_liste_objects", "_ctrl_liste_objects", "_sel_categorie", "_sel_object"];

#include "dlg_constantes.h"

_factory = uiNamespace getVariable "R3F_LOG_dlg_LO_factory";

_dlg_liste_objects = findDisplay R3F_LOG_IDD_dlg_liste_objects;

_ctrl_liste_objects = _dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_objects;

_sel_categorie = lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_categories);
_sel_object = 0 max (_factory getVariable "R3F_LOG_CF_mem_idx_object");
_factory setVariable ["R3F_LOG_CF_mem_idx_object", 0];

lbClear _ctrl_liste_objects;

_classList = [_factory, _sel_categorie] call AdvLog_fnc_getClassList;

if ((count _classList) > 0) then
{
	// Insertion de chaque type d'objets disponibles dans la liste
	{
		private ["_classe", "_config", "_name", "_icone", "_cout", "_tab_icone", "_index"];

		_classe = _x;
		_config = configFile >> "CfgVehicles" >> _classe;
		_name = getText (_config >> "displayName");
		_icone = getText (_config >> "icon");
		//_cout = [_classe] call R3F_LOG_FNCT_determine_cost_creation;
		_cout = ([_factory, _sel_categorie, _forEachIndex] call AdvLog_fnc_getCreationCosts);

		// Ic?ne par d?faut
		if (_icone == "") then
		{
			_icone = "\A3\ui_f\data\map\VehicleIcons\iconObject_ca.paa";
		};

		// Si le chemin commence par A3\ ou a3\, on rajoute un \ au d?but
		_tab_icone = toArray toLower _icone;
		if (count _tab_icone >= 3 &&
			{
				_tab_icone select 0 == (toArray "a" select 0) &&
				_tab_icone select 1 == (toArray "3" select 0) &&
				_tab_icone select 2 == (toArray "\" select 0)
			}) then
		{
			_icone = "\" + _icone;
		};

		// Si ic?ne par d?faut, on rajoute le chemin de base par d?faut
		_tab_icone = toArray _icone;
		if (_tab_icone select 0 != (toArray "\" select 0)) then
		{
			_icone = format ["\A3\ui_f\data\map\VehicleIcons\%1_ca.paa", _icone];
		};

		// Si pas d'extension de fichier, on rajoute ".paa"
		_tab_icone = toArray _icone;
		if (count _tab_icone >= 4 && {_tab_icone select (count _tab_icone - 4) != (toArray "." select 0)}) then
		{
			_icone = _icone + ".paa";
		};

		_index = _ctrl_liste_objects lbAdd format ["%1 (%2 cred.)", _name, [_cout] call R3F_LOG_FNCT_format_number_of_integer_thousands];
		_ctrl_liste_objects lbSetPicture [_index, _icone];
		_ctrl_liste_objects lbSetData [_index, _classe];
	} forEach _classList;

	// Ajout d'une ligne vide car l'affichage des listes de BIS est bugu? (dernier ?l?ment masqu?).....
	_ctrl_liste_objects lbSetData [_ctrl_liste_objects lbAdd "", ""];

	// S?lectionner l'objet m?moriser en le pla?ant visuellement au centre de la liste
	_ctrl_liste_objects lbSetCurSel (lbSize _ctrl_liste_objects - 1);
	_ctrl_liste_objects lbSetCurSel (_sel_object - 8 max 0);
	_ctrl_liste_objects lbSetCurSel _sel_object;
};