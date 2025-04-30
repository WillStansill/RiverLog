//SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

contract RiverLog {
    enum NavigationStyle {
        PaddleGuide,
        OarGuide,
        Paddler,
        R2
    }
    struct RaftTrip {
        uint8 date;
        uint8 riverClass;
        string riverName;
        bool swim;
        bool commercial;
        NavigationStyle navStyle;
        uint16 durationHours;
    }

    struct KayakTrip {
        uint8 date;
        uint8 riverClass;
        string riverName;
        bool swim;
        string boatUsed; //only given if Kayaking Trip
        uint16 durationHours;
    }

    KayakTrip[] public kayakRiverLog;
    RaftTrip[] public raftRiverLog;

    function addKayakTrip(
        uint8 _date,
        uint8 _riverClass,
        string memory _riverName,
        bool _swim,
        string memory _boatused,
        uint16 _durationHours
    ) public {
        KayakTrip memory newKayakTrip = KayakTrip({
            date: _date,
            riverClass: _riverClass,
            riverName: _riverName,
            swim: _swim,
            boatUsed: _boatused,
            durationHours: _durationHours
        });
        kayakRiverLog.push(newKayakTrip);
    }

    function addRaftingTrip(
        uint8 _date,
        uint8 _riverClass,
        string memory _riverName,
        bool _swim,
        bool _commercial,
        NavigationStyle _navStyle,
        uint16 _durationHours
    ) public {
        RaftTrip memory newRaftingTrip = RaftTrip({
            date: _date,
            riverClass: _riverClass,
            riverName: _riverName,
            swim: _swim,
            commercial: _commercial,
            navStyle: _navStyle,
            durationHours: _durationHours
        });
        raftRiverLog.push(newRaftingTrip);
    }
}
