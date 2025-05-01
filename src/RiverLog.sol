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
    KayakTrip[] public kayakSwims;
    RaftTrip[] public raftRiverLog;
    RaftTrip[] public raftSwims;

    mapping(uint8 => string[]) public riversByClass;

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
        riversByClass[_riverClass].push(_riverName);
        if (_swim == true) {
            kayakSwims.push(newKayakTrip);
        }
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
        if (_swim == true) {
            raftSwims.push(newRaftingTrip);
        }
        riversByClass[_riverClass].push(_riverName);
        raftRiverLog.push(newRaftingTrip);
    }

    function getTotalKayakTrips()
        public
        view
        returns (uint256 totalKayakTrips)
    {
        totalKayakTrips = kayakRiverLog.length;
        return totalKayakTrips;
    }

    function getTotalRaftTrips() public view returns (uint256 totalRaftTrips) {
        totalRaftTrips = raftRiverLog.length;
        return totalRaftTrips;
    }

    function getTotalTripsTaken()
        public
        view
        returns (uint256 totalTripsTaken)
    {
        totalTripsTaken = (getTotalKayakTrips() + getTotalRaftTrips());
        return totalTripsTaken;
    }

    function getRiversAccordingToClass(
        uint8 riverClass
    ) public view returns (string[] memory) {
        return riversByClass[riverClass];
    }

    function getSwimData()
        public
        view
        returns (
            uint256 totalSwims,
            KayakTrip[] memory kayaks,
            RaftTrip[] memory rafts
        )
    {
        totalSwims = (kayakSwims.length) + (raftSwims.length);
        return (totalSwims, kayakSwims, raftSwims);
    }
}
