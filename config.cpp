////////////////////////////////////////////////////////////////////
//DeRap: Produced from mikero's Dos Tools Dll version 5.24
//Produced on Sun Oct 11 01:09:09 2015 : Created on Sun Oct 11 01:09:09 2015
//http://dev-heaven.net/projects/list_files/mikero-pbodll
////////////////////////////////////////////////////////////////////

#include "R3F_LOG\creation_factory\dlg_liste_objects.h"
#include "functions\r3f\transport\dlg_content_vehicle.h"


class CfgPatches
{
	class lt_transfer
	{
		name = "Loadout Transfer";
		author = "Sean Crowe";
		url = "https://forums.bistudio.com/topic/184651-loadout-transfer/";
		requiredVersion = 1.60;
		requiredAddons[] = {"ace_interact_menu"};
		units[] = {};
		weapons[] = {"AdvLog_TowCable"};
	};
};

class CfgFunctions
{
	class AdvLog
	{
		tag = "AdvLog";

		class ace
		{
			file = "r3fAdvLog\functions\ace";
			class aceAddExtra {};
		};

		class creation
		{
			file = "r3fAdvLog\functions\r3f\creation";
			class factoryInit {};
			class factoryResell {};
			class getCategoryList {};
			class getClassList {};
			class getCreationCosts {};
		};

		class general
		{
			file="r3fAdvLog\functions\general";
			class detach {};
			class fileExists {};
			class globalMessage {};
			class setOwner {};
			class setDir {};
			class globalAddAction {};
			class timerCheck {};
		};

		class object
		{
			file = "r3fAdvLog\functions\r3f\object";
			class moveObj {};
			class objectInit {};
			class releaseObj {};
		};

		class objectAbility
		{
			file = "r3fAdvLog\functions\r3f\object\ability";
			class canBeTowed {};
			class canETow {};
			class canTow {};
			class canBeTransported {};
			class canBeTransportedClass {};
			class canMove {};
			class canMoveClass {};
			class canTransport {};
			class getObjectHeritage {};
			class canPush {};
			class buildCosts {};
		};

		class towing
		{
			file = "r3fAdvLog\functions\towing";
			class attachECable {};
			class attachTowRopes {};
			class canAttachTowRopes {};
			class canTakeTowRopes {};
			class canPickupTowRopes {};
			class dropTowRopes {};
			class getCornerPoints {};
			class getHitchPoints {};
			class pickupTowRopes {};
			class putAwayTowRopes {};
			class removeECable {};
			class simulateTowing {};
			class takeTowRopes {};
			class towingEmergInit {};
			class towingInit {};
			class towingSpeed {};
			class windTowRope {};
		};

		class transport
		{
			file = "r3fAdvLog\functions\r3f\transport";
			class autoload {};
			class calculateSpace {};
			class loadSelection {};
			class seeCargo {};
			class selected {};
			class transportInit {};
			class unloading {};
		};

		class intFunc
		{
			class init {
                description = "Runs Init and InitPost event handlers on this object.";
                file = "r3fAdvLog\init.sqf";
                preInit = 1;
            };

		};
	};
};

class CBA_Extended_EventHandlers_base;

class CfgVehicles {
    class Static;
    class Building : Static {
        class EventHandlers {
            class CBA_Extended_EventHandlers: CBA_Extended_EventHandlers_base {};
        };
    };
};

class Extended_Init_EventHandlers {


	class LandVehicle
	{
		init = "[_this select 0] call AdvLog_fnc_objectInit; [_this select 0] call AdvLog_fnc_aceAddExtra;";
	};

	class Ship
	{
		init = "[_this select 0] call AdvLog_fnc_objectInit;";
	};

	class Air
	{
		init = "[_this select 0] call AdvLog_fnc_objectInit;";
	};

	class Building
	{
		init = "[_this select 0] call AdvLog_fnc_objectInit;";
	};

	class ThingX
	{
		init = "[_this select 0] call AdvLog_fnc_objectInit;";
	};
};


class CfgWeapons {
    class ACE_ItemCore;
    class InventoryItem_Base_F;

    class AdvLog_TowCable: ACE_ItemCore {
        displayName = "Emergency Tow Cable";
        descriptionShort = "Used for towing vehicles incase of an emergency.";
        model = "\A3\Structures_F_EPA\Items\Tools\MetalWire_F.p3d";
        picture = "\r3fAdvLog\data\tow.paa";
        scope = 2;
        class ItemInfo: InventoryItem_Base_F {
        	mass = 12;
        };
    };
};