// CA - Filling listbox for the ca marker management system.
_display = findDisplay 1996;
_isadmin = serverCommandAvailable '#kick';
if((ca_respawnmode != 2 && rankid player > ca_corank) && !_isadmin) exitWith {systemChat "This mission does not allow respawn!"; _display closeDisplay 1};
_side = side player;



while {!(isnull findDisplay 1996)} do {
    disableSerialization;
    _display = findDisplay 1996;
    _lb1ctrl = _display displayCtrl 1500;
    lbClear _lb1ctrl;
    _listplayers = [];
    _specplayers = [] call ace_spectator_fnc_players;
    _allWestPlayerGroupsfill = [];
    _allEastPlayerGroupsfill = [];
    _allIndependentPlayerGroupsfill = [];
    {
        if (side _x == west) then {_allWestPlayerGroupsfill pushBackUnique _x};
        if (side _x == east) then {_allEastPlayerGroupsfill pushBackUnique _x};
        if (side _x == independent) then {_allIndependentPlayerGroupsfill pushBackUnique _x};
    } forEach _specplayers;

    _sidetickets = ca_WestTickets;
    if (_isadmin) then {
        _listplayers = _specplayers;

    } else {
        switch (_side) do {
            case west: {
            _listplayers = _allWestPlayerGroupsfill;
            _sidetickets = ca_WestTickets;
            };
            case east: {
            _listplayers = _allEastPlayerGroupsfill;
            _sidetickets = ca_EastTickets;
            };
            case independent: {
            _listplayers = _allIndependentPlayerGroupsfill;
            _sidetickets = ca_IndependentTickets;
            };
        };
    };


    
    { _lb1ctrl lbAdd (name _x); _lb1ctrl lbSetData [_forEachIndex, (name _x)];} forEach _listplayers;

    _waves = _display displayCtrl 1004;
    _noplayers = _display displayCtrl 1005;
    _timer = _display displayCtrl 1006;


    _waves ctrlSetText ('Tickets left:'+ str(_sidetickets));
    _noplayers ctrlSetText (str(count _specplayers) + ' players in spectate');

    _time = (ca_wavetime + ca_wavecooldown + ca_respawntime - time);
    if ( 0 > _time) then {
        _timer ctrlSetText ('Respawn wave available');
    }else {
        _timer ctrlSetText (str(round _time) + ' Seconds until wave available');
    };
sleep 1;
};
