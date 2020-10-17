/*
 * Author: Poulern
 * When pressing an element in the tree view, fill in the relevant boxes on the hierarchy interface.
 * 
 * Called on opening the interface
 */


params ["_groupid"];

_side = side player;

_display = findDisplay 1809;

_aliveplayers = _display displayCtrl 1812;
_deadplayers = _display displayCtrl 1813;
_shortrangech = _display displayCtrl 1814;
_longrangechannels = _display displayCtrl 1815;
_sideticketcontrol = _display displayCtrl 1816;
_squadticketcontrol = _display displayCtrl 1817;
_selectedgroupcontrol = _display displayCtrl 1818;
_superiorgroupcontrol = _display displayCtrl 1819;
_grouprespawntimer = _display displayCtrl 1820;




_allplayergroups = [];

_sidetickets = 0;
_squadtickets = 0;

_allWestPlayerGroupsfill = [];
_allEastPlayerGroupsfill = [];
_allIndependentPlayerGroupsfill = [];

_sidespectators = [];
_specplayers = [] call ace_spectator_fnc_players;

{
	if (side _x == west) then {_allWestPlayerGroupsfill pushBackUnique group _x};
	if (side _x == east) then {_allEastPlayerGroupsfill pushBackUnique group _x};
	if (side _x == independent) then {_allIndependentPlayerGroupsfill pushBackUnique group _x};
} forEach allunits;




switch (_side) do {
	case west: {
    _allplayergroups = _allWestPlayerGroupsfill;
	_sidetickets = ca_WestTickets;
	};
	case east: {
    _allplayergroups = _allEastPlayerGroupsfill;
	_sidetickets = ca_EastTickets;
	};
	case independent: {
    _allplayergroups = _allIndependentPlayerGroupsfill;
	_sidetickets = ca_IndependentTickets;
	};
};
// ---------------------------------------------------------------------
// Setup controls 
_findgroup = _allplayergroups select { (groupid _x) == _groupid};

lbClear _aliveplayers;
lbClear _deadplayers;


if(count _findgroup == 0) exitwith {
	if (_groupid == "Overflow/Dead") then {
			systemChat "This is the remaining groups that arent in the hierarchy because they don't have a superior, register if necessary, then use select group and assign subgroup to place them in the hierarchy.";
		ca_selectedgroup = group player;
		ca_selectedgroupid = "Overflow/Dead";
	} else {
	systemChat "Group doesnt exists in game anymore or is bugged.";
	};
};
_group = _findgroup select 0;

ca_selectedgroup = _group;
ca_selectedgroupid = _groupid;

{
if (_x in _specplayers) then {
	_deadplayers lbAdd (name _x); _deadplayers lbSetData [_forEachIndex, (name _x)];	
} else {
	if (alive _x) then {

_aliveplayers lbAdd (name _x); _aliveplayers lbSetData [_forEachIndex, (name _x)];	
};

}
} forEach (units _group);


{	
	if (!(_x in units _group)) then {
	_acepreviousgrouparray = _x getvariable "ca_originalgroup";
	if (_acepreviousgrouparray == _group) then {
		_deadplayers lbAdd (name _x); _deadplayers lbSetData [_forEachIndex, (name _x)];	
	};
	};
} forEach _specplayers;


_shortrangech = _display displayCtrl 1814;
_longrangechannels = _display displayCtrl 1815;

_shortrangechannel = (_group) getVariable ["ca_SRradioCH",1];
_longrangeArray = (_group) getVariable ["ca_LRradioarray",[4]];

_shortrangech ctrlSetText (format ["%1",(_shortrangechannel)]);
_longrangechannels ctrlSetText (format ["%1",(_longrangeArray)]);

_aliveplayers lbSetCurSel 1;


_squadtickets = _group getVariable ["ca_grouptickets","Not registered!"];




_sideticketcontrol ctrlSetText (format ["%1 Tickets: %2",_side,_sidetickets]);
_squadticketcontrol ctrlSetText (format ["%2 Tickets: %1",(_squadtickets),_groupid]);


_superiorgroupcontrol ctrlSetText (format ["%1",(ca_selectedgroup getVariable ["ca_superior","None"])]);


_respawntime = _group getVariable ["ca_grouprespawntime",900000];

_infotime = ceil (_respawntime - time);
if (lbSize _deadplayers == 0 || _infotime > 90000 || ca_respawnmode < 3 || (_infotime < 1)) then {
	_grouprespawntimer ctrlSetText (format ["%1 is ready to respawn!",_groupid]);
} else {
	_grouprespawntimer ctrlSetText (format ["%2 can deploy in about %1 sec",(_infotime),_groupid]);
};


if (isnil {ca_switchgroupthiscycle}) then {
	_selectedgroupcontrol ctrlSetText ("None");
} else {
if (ca_switchgroupthiscycle ) then {

_selectedgroupcontrol ctrlSetText (format ["%1",(groupid ca_previousgroup)]);

} else {
		_selectedgroupcontrol ctrlSetText ("None");
};	
};
