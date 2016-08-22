params ["_message"];

format ["%1", _message] remoteExec ['systemChat',[0,-2] select isDedicated,true];