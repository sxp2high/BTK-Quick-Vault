// Wait for player
waitUntil {(isDedicated) || !(isNull player)};


// Userconfig
if (isClass (configFile >> "CfgPatches" >> "btk_quickvault")) then {
	call compile (preprocessFileLineNumbers "\userconfig\btk_quickvault\config.hpp");
} else {
	call compile (preprocessFileLineNumbers "btk_quickvault\config.hpp");
};


// Set version
_version = "1.0.0";
_versionDate = "2014-05-01";
btk_quickvault_version = if (isClass (configFile >> "CfgPatches" >> "btk_quickvault")) then { format["%1 (Addon)", _version]; } else { format["%1 (Script)", _version]; };


// Log
diag_log text format["=== btk_quickvault %1 initializing...", btk_quickvault_version];


// Exit if already initialized
if (!(isNil "btk_quickvault_init")) exitWith { diag_log text format["===! btk_quickvault %1 is already initialized!", btk_quickvault_version]; };


// Exit if disabled
if (!btk_quickvault_enabled) exitWith { diag_log text format["===! btk_quickvault %1 disabled by userconfig, exiting!", btk_quickvault_version]; };


// Exit dedicated here
if (isDedicated) exitWith { diag_log text format["===! btk_quickvault %1 dedicated exiting!", btk_quickvault_version]; };


// Create background blur
btk_quickvault_blur = ppEffectCreate ["radialBlur", 110];
btk_quickvault_blur ppEffectEnable false;
btk_quickvault_blur ppEffectAdjust [0, 0, 0, 0];
btk_quickvault_blur ppEffectCommit 0;


// Get user color
_userColor = [(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.3843]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.7019]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.8862]), (profileNamespace getVariable ["GUI_BCG_RGB_A", 0.7])] call BIS_fnc_colorRGBAtoHTML;
_colorLink = "#c9cacc";


// Note
player createDiarySubject ["BTK", "BTK"];
player createDiaryRecord ["BTK", ["BTK Quick Vault", format["<br /><font color='%1'>BTK Quick Vault</font><br /><br /><font color='%1'>Version:</font> %2<br /><font color='%1'>Date:</font> %3<br /><font color='%1'>Author:</font> sxp2high (BTK) (btk@arma3.cc)<br /><br /><font color='%1'>Description</font><br />Replaces the default vaulting animation with a quicker, jump-like animation at jogging, running, and sprinting speeds.<br />- Only works with rifle equipped.<br />- Jumping fatigues the player based on carry weight.<br />- Player can't jump when too fatigued.<br /><br /><font color='%1'>Controls</font><br />Press <font color='%4'>Get Over</font> to quick vault.<br /><br /><font color='%1'>Userconfig</font><br /><font color='%4'>Steam\SteamApps\common\Arma 3\userconfig\btk_quickvault</font><br /><br /><font color='%1'>Readme, license and changelog</font><br /><font color='%4'>%5</font>", _userColor, btk_quickvault_version, _versionDate, _colorLink, "https://github.com/sxp2high/btk-quick-vault"]]];


// Add key handler
[] spawn {

	waituntil {!(isNull (finddisplay 46))};

	_keyHandlerDown = (findDisplay 46) displayAddEventHandler ["KeyDown", "if (((_this select 1) in (actionKeys 'GetOver')) && (isNil 'btk_quickvault_busy') && ((speed player) > 7) && ((vehicle player) isKindOf 'Man') && (alive player)) then { [] call BTK_quickvault_fnc_vault; };"];

};


// All done
btk_quickvault_init = true;


// Log
diag_log text format["=====> btk_quickvault %1 initialized!", btk_quickvault_version];