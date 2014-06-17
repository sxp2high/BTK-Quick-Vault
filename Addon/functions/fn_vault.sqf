// Only works with rifle
if ((currentWeapon player) != (primaryWeapon player)) then {

	false

} else {

	// Vault
	[] spawn {

		// Flag busy
		btk_quickvault_busy = true;
		_playerAnim = animationState player;
		_playerStance = stance player;

		// Broadcast switchmove
		[[player, "AovrPercMrunSrasWrflDf"], "BTK_quickvault_fnc_switchMove", nil, false] call BIS_fnc_MP;

		// Cam shake
		addCamShake [3, 1, 6];

		// Blur
		btk_quickvault_blur ppEffectEnable true;
		btk_quickvault_blur ppEffectAdjust [0.01, 0.01, 0.45, 0.45];
		btk_quickvault_blur ppEffectCommit 1;

		// Low fatigue
		if ((getFatigue player) < 0.9) then {

			player setFatigue ((getFatigue player) + ((load player) / 6.66));
			sleep 1;

		} else {

			// Maybe black out
			if ((random 1) > 0.4) then {

				cutText ["", "BLACK OUT", 0.5];
				sleep 0.5;
				cutText ["", "BLACK IN", 0.5];
				sleep 0.5;

			} else {

				sleep 1;

			};

		};

		// Crouch
		if (_playerStance == "CROUCH") then { player playActionNow "PlayerCrouch"; };

		// Fade out blur
		btk_quickvault_blur ppEffectAdjust [0, 0, 0, 0];
		btk_quickvault_blur ppEffectCommit 0;

		// Disable blur and unflag
		sleep 1;
		btk_quickvault_blur ppEffectEnable false;
		btk_quickvault_busy = nil;

	};

	true

};