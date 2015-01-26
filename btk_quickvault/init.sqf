/*
	BTK Quick Vault main init.
*/


private ["_path","_keyNames","_keyIndex"];


// Wait for player
waitUntil {(isDedicated) || !(isNull player)};


// No dedicated
if (isDedicated) exitWith {};


// Userconfig
_path = if (isClass (configFile >> "CfgPatches" >> "btk_quickvault")) then { "\userconfig\btk\btk_quickvault.hpp"; } else { "btk_quickvault\btk_quickvault.hpp"; };
[] call (compile (preprocessFileLineNumbers _path));


// Userconfig not found
if (isNil "btk_quickvault_enabled") then {
	[] call (compile (preprocessFileLineNumbers "btk_quickvault\btk_quickvault.hpp"));
	[] spawn { sleep 1; hint parseText format["<t align='left'><t color='#ff0000'>WARNING</t><br />BTK Quick Vault userconfig is missing!<br />Using default config...</t>"]; };
};


// Exit if already initialized or disabled
if (!(isNil "btk_quickvault_init") || !(btk_quickvault_enabled)) exitWith {};


// Variables
_keys = (actionKeys "GetOver");
_keyNames = "";
_keyIndex = 0;


// Compile key names
{

	private ["_keyName","_fontFace"];

	_keyName = (keyName (_keys select _keyIndex));
	_fontFace = format["<font color='%1'>", ([(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.3843]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.7019]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.8862]), (profileNamespace getVariable ["GUI_BCG_RGB_A", 0.7])] call BIS_fnc_colorRGBAtoHTML)];

	if (_keyIndex == ((count _keys) - 1)) then {
		_keyNames = (_keyNames + _fontFace + _keyName + "</font>");
	} else {
		_keyNames = (_keyNames + _fontFace + _keyName + "</font>" + " + ");
	};

	_keyIndex = _keyIndex + 1;

} forEach _keys;


// Note
player createDiarySubject ["BTK", "BTK"];
player createDiaryRecord ["BTK", ["BTK Quick Vault", format["<br /><font color='%2'>Addon:</font> BTK Quick Vault<br /><font color='%2'>Version:</font> 1.0.1<br /><font color='%2'>Author:</font> sxp2high (BTK) (btk@arma3.cc)<br /><br /><font color='%2'>Readme, Changelog, License</font> <br />https://github.com/sxp2high/BTK-Quick-Vault<br /><br /><font color='%2'>Key bindings</font><br />Press %3 to jump.", ([(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.3843]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.7019]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.8862]), (profileNamespace getVariable ["GUI_BCG_RGB_A", 0.7])] call BIS_fnc_colorRGBAtoHTML), "#c9cacc", _keyNames]]];


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
	_keyHandlerDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (((_this select 1) in (actionKeys 'GetOver')) && (isNil {player getVariable 'btk_quickvault_busy'}) && (alive player) && ((vehicle player) isKindOf 'Man') && ((speed player) > 10) && ((currentWeapon player) == (primaryWeapon player)) && (primaryWeapon player != '') && ((getFatigue player) < 0.6) && (isTouchingGround player)) then { [player] call BTK_quickvault_fnc_vault; };"];

	// Sitting anim restores stamina
	while {true} do {
		
		waitUntil { sleep 2.127; ((animationState player) =="amovpsitmstpslowwrfldnon") && ((getFatigue player) > 0)};

		for "_j" from 1 to (5 + (floor(random 4))) do { player setFatigue ((getFatigue player) - 0.01); sleep 0.05; };
		sleep (1 + (random 3));

	};

};


// All done
btk_quickvault_init = true;