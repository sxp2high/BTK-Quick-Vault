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


// Spawn
[_unit] spawn {

	// Unit
	_unit = _this select 0;
	_isLocal = local _unit;
	_stance = stance _unit;
	_isPlayer = isPlayer _unit;

	// Only local
	if (!_isLocal) exitWith {};

	// Flag busy
	_unit setVariable ["btk_quickvault_busy", true, false];

	// Broadcast switchmove
	[[_unit, "AovrPercMrunSrasWrflDf"], "BTK_quickvault_fnc_switchMove", nil, false, true] call BIS_fnc_MP;

	// Cam shake & blur
	if (_isPlayer) then {

		btk_quickvault_blur ppEffectEnable true;
		btk_quickvault_blur ppEffectAdjust [0.01, 0.01, 0.45, 0.45];
		btk_quickvault_blur ppEffectCommit 1;

		addCamShake [3, 1, 6];

	};

	// Low fatigue, maybe black out
	if (((random 1) < 0.7) && _isPlayer && ((getFatigue _unit) > 0.5)) then {

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
	if (_isPlayer) then {

		btk_quickvault_blur ppEffectAdjust [0, 0, 0, 0];
		btk_quickvault_blur ppEffectCommit 0;

	};

	// Cool down
	sleep 1;

	// Set fatigue
	for "_j" from 1 to 10 do { _unit setFatigue ((getFatigue _unit) - 0.012); sleep 0.1; };

	// Unflag
	_unit setVariable ["btk_quickvault_busy", nil, false];

};


true