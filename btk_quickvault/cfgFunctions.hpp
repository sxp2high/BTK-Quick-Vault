class btk_quickvault {

	tag = "BTK_quickvault";

	class Init {

		class init { file = "btk_quickvault\init.sqf"; postInit = 1; };

	};

	class Misc {

		file = "btk_quickvault\functions";

		class switchMove {};
		class vault {};

	};

};