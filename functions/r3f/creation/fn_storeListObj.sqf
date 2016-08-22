disableSerialization; // A cause des displayCtrl

private ["_dlg_liste_objects"];

#include "dlg_constantes.h"

_dlg_liste_objects = findDisplay R3F_LOG_IDD_dlg_liste_objects;

(uiNamespace getVariable "R3F_LOG_dlg_LO_factory") setVariable ["R3F_LOG_CF_mem_idx_categorie", lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_categories)];
(uiNamespace getVariable "R3F_LOG_dlg_LO_factory") setVariable ["R3F_LOG_CF_mem_idx_object", lbCurSel (_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_liste_objects)];