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





#include "dlg_constantes.h"

disableSerialization; // A cause des displayCtrl

private ["_transporteur", "_chargement", "_chargement_precedent", "_contenu"];
private ["_tab_objects", "_tab_quantite", "_i", "_dlg_contenu_vehicule", "_ctrl_liste"];

R3F_LOG_object_selectionne = objNull;

params [["_transporteur", objNull]];

if (isNull _transporteur) exitWith{["Error! Object is null"] call AdvLog_fnc_globalMessage;};

uiNamespace setVariable ["R3F_LOG_dlg_CV_transporteur", _transporteur];

createDialog "R3F_LOG_dlg_contenu_vehicule";
waitUntil (uiNamespace getVariable "R3F_LOG_dlg_contenu_vehicule");
_dlg_contenu_vehicule = findDisplay R3F_LOG_IDD_dlg_contenu_vehicule;

/**** DEBUT des traductions des labels ****/
(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_titre) ctrlSetText STR_R3F_LOG_dlg_CV_titre;
(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_credits) ctrlSetText "[R3F] Logistics";
(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_decharger) ctrlSetText STR_R3F_LOG_dlg_CV_btn_decharger;
(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_fermer) ctrlSetText STR_R3F_LOG_dlg_CV_btn_fermer;
/**** FIN des traductions des labels ****/

_ctrl_liste = _dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_liste_contenu;


while {!isNull _dlg_contenu_vehicule} do
{
	_chargement = [_transporteur] call AdvLog_fnc_calculateSpace;

	// Get the contents of the vehicle
	_contenu = _transporteur getVariable ["R3F_LOG_objects_charges", []];

	/** List of the names of the class of the objects contained in the vehicle without duplicate */
	_tab_objects = [];
	/** Quantities? Associated with? (By the index) to the names of class in _tab_objects*/
	_tab_quantite = [];
	/** Cost of associated loading? (By the index) to the names of class in _tab_objects */
	_tab_cost_chargement = [];

	// preparing the content list and quantities?s associated with?es to objects
	for [{_i = 0}, {_i < count _contenu}, {_i = _i + 1}] do
	{
		private ["_object"];
		_object = _contenu select _i;

		if !((typeOf _object) in _tab_objects) then
		{
			_tab_objects pushBack (typeOf _object);
			_tab_quantite pushBack 1;

			_tab_cost_chargement pushBack (([_object] call AdvLog_fnc_canBeTransported) param [1, 0]);

		}
		else
		{
			private ["_idx_object"];
			_idx_object = _tab_objects find (typeOf _object);
			_tab_quantite set [_idx_object, ((_tab_quantite select _idx_object) + 1)];
		};
	};

	lbClear _ctrl_liste;
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_capacite_vehicule) ctrlSetText (format [STR_R3F_LOG_dlg_CV_capacite_vehicule+" pl.", _chargement select 0, _chargement select 1]);
	if (_chargement select 1 != 0) then {(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_jauge_chargement) progressSetPosition ((_chargement select 0) / (_chargement select 1));};
	(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_jauge_chargement) ctrlShow ((_chargement select 0) != 0);

	if (count _tab_objects == 0) then
	{
		(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_decharger) ctrlEnable false;
	}
	else
	{
		// Insertion de chaque type d'objets dans la liste
		for [{_i = 0}, {_i < count _tab_objects}, {_i = _i + 1}] do
		{
			private ["_classe", "_quantite", "_icone", "_tab_icone", "_index"];

			_classe = _tab_objects select _i;
			_quantite = _tab_quantite select _i;
			_cout_chargement = _tab_cost_chargement select _i;
			_icone = getText (configFile >> "CfgVehicles" >> _classe >> "icon");

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

			_index = _ctrl_liste lbAdd (getText (configFile >> "CfgVehicles" >> _classe >> "displayName") + format [" (%1x %2pl.)", _quantite, _cout_chargement]);
			_ctrl_liste lbSetPicture [_index, _icone];
			_ctrl_liste lbSetData [_index, _classe];

			if (uiNamespace getVariable ["R3F_LOG_dlg_CV_lbCurSel_data", ""] == _classe) then
			{
				_ctrl_liste lbSetCurSel _index;
			};
		};

		(_dlg_contenu_vehicule displayCtrl R3F_LOG_IDC_dlg_CV_btn_decharger) ctrlEnable true;
	};

	sleep 0.15;
};