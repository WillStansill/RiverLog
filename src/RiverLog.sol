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
        uint16 cubicFeetPerSecond;
        string riverName;
        bool swim;
        bool commercial;
        NavigationStyle navStyle;
        uint16 durationHours;
    }

    struct KayakTrip {
        uint8 date;
        uint8 riverClass;
        uint16 cubicFeetPerSecond;
        string riverName;
        bool swim;
        string boatUsed; //only given if Kayaking Trip
        uint16 durationHours;
    }

    KayakTrip[] public kayakRiverLog;
    KayakTrip[] public kayakSwims;
    RaftTrip[] public raftRiverLog;
    RaftTrip[] public raftSwims;
    RaftTrip[] public commercialTrips;

    uint256 public totalHoursKayaked = 0;
    uint256 public totalHoursRafted = 0;

    mapping(uint8 => string[]) public riversByClass;
    mapping(string => uint[]) public kayakTripsByRiverName;
    mapping(string => uint[]) public raftTripsByRiverName;
    mapping(bool => uint[]) public raftTripsIfCommercial;

    function addKayakTrip(
        uint8 _date,
        uint8 _riverClass,
        uint16 _cubicFeetPerSecond,
        string memory _riverName,
        bool _swim,
        string memory _boatused,
        uint16 _durationHours
    ) public {
        KayakTrip memory newKayakTrip = KayakTrip({
            date: _date,
            riverClass: _riverClass,
            cubicFeetPerSecond: _cubicFeetPerSecond,
            riverName: _riverName,
            swim: _swim,
            boatUsed: _boatused,
            durationHours: _durationHours
        });
        totalHoursKayaked += _durationHours;
        kayakTripsByRiverName[_riverName].push(kayakRiverLog.length);
        kayakRiverLog.push(newKayakTrip);
        riversByClass[_riverClass].push(_riverName);
        if (_swim == true) {
            kayakSwims.push(newKayakTrip);
        }
    }

    function addRaftingTrip(
        uint8 _date,
        uint8 _riverClass,
        uint16 _cubicFeetPerSecond,
        string memory _riverName,
        bool _swim,
        bool _commercial,
        NavigationStyle _navStyle,
        uint16 _durationHours
    ) public {
        RaftTrip memory newRaftingTrip = RaftTrip({
            date: _date,
            riverClass: _riverClass,
            cubicFeetPerSecond: _cubicFeetPerSecond,
            riverName: _riverName,
            swim: _swim,
            commercial: _commercial,
            navStyle: _navStyle,
            durationHours: _durationHours
        });
        if (_swim == true) {
            raftSwims.push(newRaftingTrip);
        }
        if (_commercial == true) {
            commercialTrips.push(newRaftingTrip);
        }
        totalHoursRafted += _durationHours;
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

    function getTripsByRiverName(
        string memory riverName
    )
        public
        view
        returns (
            uint256 totalKayakTripsOnGivenRiver,
            uint256 totalRaftTripsOnGivenRiver,
            uint256 totalTripsOnGivenRiver,
            KayakTrip[] memory kayakTrips,
            RaftTrip[] memory raftTrips
        )
    {
        uint256[] memory kayakIndexes = kayakTripsByRiverName[riverName];
        uint256[] memory raftIndexes = raftTripsByRiverName[riverName];

        totalKayakTripsOnGivenRiver = kayakIndexes.length;
        totalRaftTripsOnGivenRiver = raftIndexes.length;
        totalTripsOnGivenRiver = (totalKayakTripsOnGivenRiver +
            totalRaftTripsOnGivenRiver);

        kayakTrips = new KayakTrip[](totalKayakTripsOnGivenRiver);
        raftTrips = new RaftTrip[](totalRaftTripsOnGivenRiver);

        for (uint256 i = 0; i < totalKayakTripsOnGivenRiver; i++) {
            kayakTrips[i] = kayakRiverLog[kayakIndexes[i]];
        }

        for (uint256 i = 0; i < totalRaftTripsOnGivenRiver; i++) {
            raftTrips[i] = raftRiverLog[raftIndexes[i]];
        }

        return (
            totalKayakTripsOnGivenRiver,
            totalRaftTripsOnGivenRiver,
            totalTripsOnGivenRiver,
            kayakTrips,
            raftTrips
        );
    }

    function getCommercialTripsRun()
        public
        view
        returns (
            uint256 totalCommercialRaftTrips,
            RaftTrip[] memory allCommercialRaftTrips
        )
    {
        totalCommercialRaftTrips = commercialTrips.length;
        allCommercialRaftTrips = commercialTrips;

        return (totalCommercialRaftTrips, allCommercialRaftTrips);
    }

    function getTotalHoursKayaked()
        public
        view
        returns (uint256 _totalHoursKayaked)
    {
        _totalHoursKayaked = totalHoursKayaked;
        return _totalHoursKayaked;
    }

    function getTotalHoursRafted()
        public
        view
        returns (uint256 _totalHoursRafted)
    {
        _totalHoursRafted = totalHoursRafted;
        return _totalHoursRafted;
    }
}
