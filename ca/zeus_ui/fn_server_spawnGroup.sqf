/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Spawns a group with the given parameters, using ca_fnc_spawngroup or ca_fnc_spawnvehiclegroup.
		All spawned units and vehicles will be added as editable objects to all curators.
		This functions is designed to be executed on the server (e.g. via remoteExec).
	Arguments:
		0:      <ARRAY>		Array of F3-compatible roles for the units to be spawned
		1:	<ARRAY>		Spawn position of the units
		2:	<STRING>	Faction of the group, as used in F3
		3:	<SIDE>		Side of the group to be spawned (west, east, resistance, civilian)
		4:	<STRING>	(optional) Class of the vehicle to spawn
		5:	<BOOL>		(optional) Whether or not to enable VCOM AI
		6:	<ARRAY>		(optional) Array with Guerrilla AI relevant settings; set to false to ignore
		7:	<ARRAY>		(optional) Array with Suppressive AI relevant settings; set to false to ignore
	Returns:
		(nothing)
-------------------------------------------------------------------------------------------------------------------- */

#include "config\macros.hpp"

// Fetch our params
params ["_roles", "_pos", "_gear", "_side", ["_vehicleClass", ""], ["_enableVCOM", false], ["_guerrillaAI", false], ["_suppressiveAI", false]];

// Don't execute the function if this isn't the server
if (!isServer) exitWith {};





// Set up some variables
private _group = grpNull;
private _vehicle = objNull;

// If we have a vehicle, create it along with the units
if (_vehicleClass != "") then {
	private _ret = [_roles, _pos, _vehicleClass, _gear, _side] call ca_fnc_spawnvehiclegroup;
	_group = _ret param [0, grpNull];
	_vehicle = _ret param [1, objNull];

// Otherwise, only create the units
} else {
	_group = [_roles, _pos, _gear, _side] call ca_fnc_spawngroup;
};

// Add the units as editable objects
private _allObjects = (units _group) + [_vehicle];
{
	_x addCuratorEditableObjects [_allObjects, true];
} forEach allCurators;





// Disable VCOM, if desired
if (!_enableVCOM) then {
	_group setVariable [MACRO_VCOM_VARNAME_NOAI, true, true];
};

// Enable guerrilla AI, if desired
if (_guerrillaAI isEqualType []) then {
	([_group] + _guerrillaAI) spawn ca_fnc_groupGuerrillaAI;
};

// Enable suppressive AI, if desired
if (_suppressiveAI isEqualType []) then {
	([_group] + _suppressiveAI) spawn ca_fnc_groupSuppressiveAI;
};
