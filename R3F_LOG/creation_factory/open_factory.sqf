/**
 * Modified by Sean Crowe
 * Ouvre la bo?te de dialogue du contenu de l'usine
 *
 * @param 0 l'usine qu'il faut ouvrir
 *
 * Copyright (C) 2014 Team ~R3F~
 *
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "dlg_constantes.h"

disableSerialization; // A cause des displayCtrl

private ["_factory", "_credits_factory", "_dlg_liste_objects", "_ctrl_liste_categories", "_sel_categorie"];

R3F_LOG_object_selectionne = objNull;

_factory = _this select 0;
uiNamespace setVariable ["R3F_LOG_dlg_LO_factory", _factory];

call R3F_LOG_VIS_FNCT_demarrer_visualisation;

createDialog "R3F_LOG_dlg_liste_objects";
_dlg_liste_objects = findDisplay R3F_LOG_IDD_dlg_liste_objects;

/**** DEBUT des traductions des labels ****/
(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_titre) ctrlSetText STR_R3F_LOG_dlg_LO_titre;
(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_btn_creer) ctrlSetText STR_R3F_LOG_dlg_LO_btn_creer;
(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_btn_fermer) ctrlSetText STR_R3F_LOG_dlg_LO_btn_fermer;
(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_infos_titre) ctrlSetText STR_R3F_LOG_name_fonctionnalite_proprietes;
/**** FIN des traductions des labels ****/

_ctrl_liste_categories = _dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_categories;
_sel_categorie = 0 max (_factory getVariable "R3F_LOG_CF_mem_idx_categorie");

// Insert each cat?categories available in the list
{
	_categorie = _x;
	private ["_categorie", "_config", "_name"];
	_name = _x;

	_index = _ctrl_liste_categories lbAdd format ["%1", _name];
	_ctrl_liste_categories lbSetData [_index, _categorie];
} forEach ([_factory] call AdvLog_fnc_getCategoryList);

_ctrl_liste_categories lbSetCurSel _sel_categorie;

while {!isNull _dlg_liste_objects} do
{
	_credits_factory = _factory getVariable "R3F_LOG_CF_credits";

	// Activer le bouton de cr?ation que s'il y a assez de cr?dits
	(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_btn_creer) ctrlEnable (_credits_factory != 0);

	if (_credits_factory == -1) then
	{
		(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_credits_restants) ctrlSetText (format [STR_R3F_LOG_dlg_LO_credits_restants, "unlimited"]);
	}
	else
	{
		(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_credits_restants) ctrlSetText (format [STR_R3F_LOG_dlg_LO_credits_restants, _credits_factory]);
	};

	// Afficher les infos de l'objet
	if (lbCurSel R3F_LOG_IDC_dlg_LO_liste_objects != -1) then
	{
		//(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_infos) ctrlSetStructuredText ([lbData [R3F_LOG_IDC_dlg_LO_liste_objects, lbCurSel R3F_LOG_IDC_dlg_LO_liste_objects]] call R3F_LOG_FNCT_format_features_logistics);
	};

	// Fermer la bo?te de dialogue si l'usine n'est plus accessible
	if (!alive _factory || (_factory getVariable "R3F_LOG_CF_disabled")) then
	{
		closeDialog 0;
	};

	sleep 0.15;
};

call R3F_LOG_VIS_FNCT_terminer_visualisation;