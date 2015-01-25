/*
	BTK Quick Vault main init.
*/


private ["_path"];


// Wait for player
waitUntil {(isDedicated) || !(isNull player)};


// No dedicated
if (isDedicated) exitWith {};


// Userconfig
_path = if (isClass (configFile >> "CfgPatches" >> "btk_quickvault")) then { "\userconfig\btk_quickvault\config.hpp"; } else { "btk_quickvault\config.hpp"; };
[] call (compile (preprocessFileLineNumbers _path));


// Exit if already initialized or disabled
if (!(isNil "btk_quickvault_init") || !(btk_quickvault_enabled)) exitWith {};


// Note
player createDiarySubject ["BTK", "BTK"];
player createDiaryRecord ["BTK", ["BTK Quick Vault", format["<br /><font color='%2'>Addon:</font> BTK Quick Vault<br /><font color='%2'>Version:</font> 1.0.1<br /><font color='%2'>Author:</font> sxp2high (BTK) (btk@arma3.cc)<br /><font color='%2'>Source:</font> https://github.com/sxp2high/BTK-Quick-Vault<br /><br /><font color='%2'>Description</font><br />Unlocks the Arma 3 jumping animation, so the player can get over obstacles quicker.<br /><br /><font color='%2'>Controls</font><br />Press <font color='%1'>Get Over</font> to jump.", ([(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.3843]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.7019]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.8862]), (profileNamespace getVariable ["GUI_BCG_RGB_A", 0.7])] call BIS_fnc_colorRGBAtoHTML), "#c9cacc"]]];


// Create blur
btk_quickvault_blur = ppEffectCreate ["radialBlur", 110];
btk_quickvault_blur ppEffectEnable false;
btk_quickvault_blur ppEffectAdjust [0, 0, 0, 0];
btk_quickvault_blur ppEffectCommit 0;


// Main flow
[] spawn {

	// Wait until ingame
	waituntil {!(isNull (finddisplay 46))};
	sleep 0.1;

	// Add keyhandler
	_keyHandlerDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (((_this select 1) in (actionKeys 'GetOver')) && (isNil {player getVariable 'btk_quickvault_busy'}) && (alive player) && ((vehicle player) isKindOf 'Man') && ((speed player) > 10.5) && ((currentWeapon player) == (primaryWeapon player)) && (primaryWeapon player != '') && ((getFatigue player) < 0.6)) then { [player] call BTK_quickvault_fnc_vault; };"];

};


// All done
btk_quickvault_init = true;