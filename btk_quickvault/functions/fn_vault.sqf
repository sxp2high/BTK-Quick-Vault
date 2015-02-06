/*
	File: fn_vault.sqf
	Author: sxp2high (BTK) (btk@arma3.cc)

	Description:
	Execute vault.

	Parameter(s):
		0: OBJECT - Target unit

	Returns:
	BOOLEAN - true when started

	Syntax:
	[player] call BTK_quickvault_fnc_vault;
*/


private ["_unit"];


// Parameter
_unit = (_this select 0);


// Only local
if (!(local _unit)) exitWith {};


// Spawn
[_unit] spawn {

	// Unit
	_unit = _this select 0;
	_stance = stance _unit;

	// Flag busy
	_unit setVariable ["btk_quickvault_busy", true, false];

	// Broadcast switchmove
	[[_unit, "AovrPercMrunSrasWrflDf"], "BTK_quickvault_fnc_switchMove", nil, false, true] call BIS_fnc_MP;

	// Cam shake & blur
	btk_quickvault_blur ppEffectEnable true;
	btk_quickvault_blur ppEffectAdjust [0.01, 0.01, 0.45, 0.45];
	btk_quickvault_blur ppEffectCommit 1;

	addCamShake [3, 1, 6];

	// Low fatigue, maybe black out
	if (((random 1) < 0.7) && ((getFatigue _unit) > 0.5)) then {

		cutText ["", "BLACK OUT", 0.5];
		sleep 0.5;

		cutText ["", "BLACK IN", 0.5];
		sleep 0.5;

	} else {

		sleep 1;

	};

	// Crouch
	if (_stance == "CROUCH") then { _unit playActionNow "PlayerCrouch"; };

	// Disable blur
	btk_quickvault_blur ppEffectAdjust [0, 0, 0, 0];
	btk_quickvault_blur ppEffectCommit 0;

	// Cool down
	sleep 1;

	// Unflag
	_unit setVariable ["btk_quickvault_busy", nil, false];

	// Set fatigue
	for "_j" from 1 to (9 + (floor(random 3))) do { _unit setFatigue ((getFatigue _unit) - 0.01); sleep 0.05; };

};


true