private ["_ctrl", "_fileExists"];
disableSerialization;

_ctrl = findDisplay 911911 ctrlCreate ["RscHTML", -1];
_ctrl htmlLoad _this;
_fileExists = ctrlHTMLLoaded _ctrl;
ctrlDelete _ctrl;
_fileExists