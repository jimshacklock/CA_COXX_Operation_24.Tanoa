// ====================================================================================

// F3 - Disable Saving and Auto Saving
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

enableSaving [false, false];

// ====================================================================================

// F3 - Mute Orders and Reports
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
enableSentences false;
// Wait until initServer.sqf is done to get all the variables we need.
waitUntil {!isnil {ca_initserver}};
if (didJIP) then {[] spawn ca_fnc_setupJIP};
// ====================================================================================

// F3 - MapClick Teleport
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
/*
 f_var_mapClickTeleport_Uses = 0;										// How often the teleport action can be used. 0 = infinite usage.
 f_var_mapClickTeleport_TimeLimit = 0; 								// If higher than 0 the action will be removed after the given time.
 f_var_mapClickTeleport_GroupTeleport = false; 						// False: everyone can teleport. True: Only group leaders can teleport and will move their entire group.
 f_var_mapClickTeleport_Units = [];									// Restrict map click teleport to these units
 f_var_mapClickTeleport_Height = 0;									// If > 0 map click teleport will act as a HALO drop and automatically assign parachutes to units
 [] execVM "f\mapClickTeleport\f_mapClickTeleportAction.sqf";
*/
// F3 - MapClick Supply Drop
// Credits: Created by Volc, from the F3 mapClickTeleport script, and the dropit script by Kronzky http://www.kronzky.info/

f_var_mapClickSupplyDrop_Uses = 0;										// How often the Supply Drop action can be used. 0 = infinite usage.
f_var_mapClickSupplyDrop_Units = [];									// Restrict map click Supply Drop to these units - units must be the leaders of their groups.
f_var_mapClickSupplyDrop_Height = 1000;									// If > 0 map click Supply Drop will act as a HALO drop and automatically assign parachutes to units
// [] execVM "f\mapClickSupplyDrop\f_mapClickSupplyDropAction.sqf";		// Uncommenting assigns addaction to all group leaders to call Supply Drops.

// ====================================================================================
// Thanks to http://killzonekid.com/arma-scripting-tutorials-mission-root/
MISSION_ROOT = call
{
    private "_arr";
    _arr = toArray str missionConfigFile;
    _arr resize (count _arr - 15);
    toString _arr
};

// ====================================================================================
// F3 - Briefing
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_script_briefing = [] execVM "f\briefing\briefing.sqf";

// ====================================================================================

// F3 - Buddy Team Colours
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

f_script_setTeamColours = [] execVM "f\setTeamColours\f_setTeamColours.sqf";

// ====================================================================================

// F3 - Fireteam Member Markers
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] spawn f_fnc_SetLocalFTMemberMarkers;

// ====================================================================================

// CA - Smooth squad markers, by Bubbus
// See initServer.sqf for configuration.

[] spawn ca_fnc_initSmoothSquadMarkers;

// ====================================================================================

// F3 - F3 Common Local Variables
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// WARNING: DO NOT DISABLE THIS COMPONENT
if(isServer) then {
	f_script_setLocalVars = [] execVM "f\common\f_setLocalVars.sqf";
};

// ====================================================================================

// F3 - Assign Gear AI
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

// [] execVM "f\assignGear\f_assignGear_AI.sqf";

// ====================================================================================

// F3 - ORBAT Notes
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] execVM "f\briefing\f_orbatNotes.sqf";

// ====================================================================================

// F3 - Loadout Notes
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] execVM "f\briefing\f_loadoutNotes.sqf";

// ====================================================================================

// F3 - Mission Timer/Safe Start
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] execVM "f\safeStart\f_safeStart.sqf";

// ====================================================================================

// F3 - Radio Systems Support
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)

[] execVM "f\acre2\acre2_init.sqf";

// ====================================================================================

// CA - Initialize CA framework
[] execVM "ca\ca_init.sqf";

// Disables users from accessing DMS missile system, and permits restricted access if the other lines are uncommented.
[] spawn {sleep 1; dmsRestrictUsers=true};

// This line permits the NATO UAV Operator class to access the DMS launcher.
//[] spawn {sleep 1; dmsAuthorizedClasses=['B_soldier_UAV_F']};

// This line permits specific units by variable name to access the DMS launcher. Do not put variable names in quotes.
//[] spawn {sleep 1; dmsAuthorizedUnits=[launchman]};
