disableSerialization; // A cause des displayCtrl

private ["_factory", "_credits_factory", "_dlg_liste_objects", "_ctrl_liste_categories", "_sel_categorie"];

R3F_LOG_object_selectionne = objNull;

_factory = param [0, objNull];
uiNamespace setVariable ["R3F_LOG_dlg_LO_factory", _factory];

[] call R3F_LOG_VIS_FNCT_demarrer_visualisation;

// Pr?-calculer une fois pour toutes les usines la liste des objets du CfgVehicles class?s par cat?gorie
if (isNil {_factory getVariable "R3F_LOG_CF_cfgVehicles_par_categories"}) then
{
	private ["_retour_liste_cfgVehicles_par_categories"];

	_factory setVariable ["R3F_LOG_CF_cfgVehicles_categories", + (R3F_CF_global_costs select 0)];
	_factory setVariable ["R3F_LOG_CF_cfgVehicles_par_categories", + (R3F_CF_global_costs select 1)];
	_factory setVariable ["R3F_LOG_CF_cfgVehicles_costs", + (R3F_CF_global_costs select 2)];
};

createDialog "R3F_LOG_dlg_liste_objects";

_dlg_liste_objects = findDisplay 65861;

/**** DEBUT des traductions des labels ****/
(_dlg_liste_objects displayCtrl 65862) ctrlSetText STR_R3F_LOG_dlg_LO_titre;
(_dlg_liste_objects displayCtrl 65866) ctrlSetText STR_R3F_LOG_dlg_LO_btn_creer;
(_dlg_liste_objects displayCtrl 65867) ctrlSetText STR_R3F_LOG_dlg_LO_btn_fermer;
(_dlg_liste_objects displayCtrl 65868) ctrlSetText STR_R3F_LOG_name_fonctionnalite_proprietes;
/**** FIN des traductions des labels ****/

_ctrl_liste_categories = _dlg_liste_objects displayCtrl 65864;
_sel_categorie = 0 max (_factory getVariable "R3F_LOG_CF_mem_idx_categorie");

// Insert each cat?categories available in the list
{
	_categorie = _x;
	private ["_categorie", "_config", "_name"];
	_name = _x;

	_index = _ctrl_liste_categories lbAdd format ["%1", _name];
	_ctrl_liste_categories lbSetData [_index, _categorie];
} forEach (_factory getVariable "R3F_LOG_CF_cfgVehicles_categories");

_ctrl_liste_categories lbSetCurSel _sel_categorie;

while {!isNull _dlg_liste_objects} do
{
	_credits_factory = _factory getVariable ["R3F_LOG_CF_credits", -1];

	// Activer le bouton de cr?ation que s'il y a assez de cr?dits
	(_dlg_liste_objects displayCtrl 65866) ctrlEnable (_credits_factory != 0);

	if (_credits_factory == -1) then
	{
		(_dlg_liste_objects displayCtrl 65863) ctrlSetText (format [STR_R3F_LOG_dlg_LO_credits_restants, "unlimited"]);
	}
	else
	{
		(_dlg_liste_objects displayCtrl 65863) ctrlSetText (format [STR_R3F_LOG_dlg_LO_credits_restants, _credits_factory]);
	};

	// Show info of the object
	if (lbCurSel 65865 != -1) then
	{
		//(_dlg_liste_objects displayCtrl R3F_LOG_IDC_dlg_LO_infos) ctrlSetStructuredText ([lbData [R3F_LOG_IDC_dlg_LO_liste_objects, lbCurSel R3F_LOG_IDC_dlg_LO_liste_objects]] call R3F_LOG_FNCT_format_features_logistics);
	};

	// Fermer la bo?te de dialogue si l'usine n'est plus accessible
	if (!alive _factory || (_factory getVariable ["R3F_LOG_CF_disabled", false])) then
	{
		closeDialog 0;
	};

	sleep 0.15;
};

call R3F_LOG_VIS_FNCT_terminer_visualisation;