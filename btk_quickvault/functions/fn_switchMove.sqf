/*
	File: fn_switchMove.sqf
	Author: sxp2high (BTK) (btk@arma3.cc)

	Description:
	Global switchMove for MP.

	Parameter(s):
		0: OBJECT - Target unit
		1: STRING - Animation

	Returns:
	BOOLEAN - true when done

	Syntax:
	[[player, "AovrPercMrunSrasWrflDf"], "BTK_quickvault_fnc_switchMove", nil, false, true] call BIS_fnc_MP;
*/


private ["_unit","_anim"];


// Parameter
_unit = _this select 0;
_anim = _this select 1;


// Execute
_unit switchMove _anim;


true