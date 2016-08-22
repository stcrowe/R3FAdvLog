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

private ["_dlg_liste_objects"];

#include "dlg_constantes.h"

_dlg_liste_objects = findDisplay R3F_LOG_IDD_dlg_liste_objects;

(uiNamespace getVariable "R3F_LOG_dlg_LO_factory") setVariable ["R3F_LOG_CF_mem_idx_categorie", lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_categories)];
(uiNamespace getVariable "R3F_LOG_dlg_LO_factory") setVariable ["R3F_LOG_CF_mem_idx_object", lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_objects)];