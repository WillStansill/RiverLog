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
        bool commercial; //only given if Rafting Trip
        NavigationStyle navStyle; //only given if Rafting Trip
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
    string[] public uniqueRivers;

    uint256 public totalHoursKayaked = 0;
    uint256 public totalHoursRafted = 0;
    uint256 public longestKayakTrip;
    uint256 public longestKayakTripIndex;
    uint256 public longestRaftTrip;
    uint256 public longestRaftTripIndex;
    uint256 public constant PERCISION = 1e4;

    mapping(uint8 => string[]) public riversByClass;
    mapping(string => uint[]) public kayakTripsByRiverName;
    mapping(string => uint[]) public raftTripsByRiverName;
    mapping(string => bool) public isUniqueRiver;
    mapping(uint8 => mapping(string => bool)) public isRiverInClass;

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
        if (!isRiverInClass[_riverClass][_riverName]) {
            riversByClass[_riverClass].push(_riverName);
            isRiverInClass[_riverClass][_riverName] = true;
        }
        if (_swim == true) {
            kayakSwims.push(newKayakTrip);
        }
        if (!isUniqueRiver[_riverName]) {
            uniqueRivers.push(_riverName);
            isUniqueRiver[_riverName] = true;
        }
        if (longestKayakTrip < _durationHours) {
            longestKayakTrip = _durationHours;
            longestKayakTripIndex = kayakRiverLog.length - 1;
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
        raftRiverLog.push(newRaftingTrip);
        raftTripsByRiverName[_riverName].push(raftRiverLog.length);

        if (_swim == true) {
            raftSwims.push(newRaftingTrip);
        }
        if (_commercial == true) {
            commercialTrips.push(newRaftingTrip);
        }
        if (!isUniqueRiver[_riverName]) {
            uniqueRivers.push(_riverName);
            isUniqueRiver[_riverName] = true;
        }
        if (longestRaftTrip < _durationHours) {
            longestRaftTrip = _durationHours;
            longestRaftTripIndex = raftRiverLog.length - 1;
        }
        totalHoursRafted += _durationHours;
        if (!isRiverInClass[_riverClass][_riverName]) {
            riversByClass[_riverClass].push(_riverName);
            isRiverInClass[_riverClass][_riverName] = true;
        }
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
            uint256 kayakSwimRate,
            uint256 raftSwimRate,
            uint256 totalSwimRate,
            KayakTrip[] memory kayaks,
            RaftTrip[] memory rafts
        )
    {
        totalSwims = (kayakSwims.length) + (raftSwims.length);

        uint256 totalKayaktrips = getTotalKayakTrips();
        uint256 totalRaftTrips = getTotalRaftTrips();

        if (totalKayaktrips > 0) {
            kayakSwimRate =
                ((kayakSwims.length) * PERCISION) /
                (getTotalKayakTrips());
        } else {
            kayakSwimRate = 0;
        }
        if (totalRaftTrips > 0) {
            raftSwimRate =
                ((raftSwims.length) * PERCISION) /
                (getTotalRaftTrips());
        } else {
            raftSwimRate = 0;
        }
        totalSwimRate = (totalSwims * PERCISION) / getTotalTripsTaken();
        return (
            totalSwims,
            kayakSwimRate,
            raftSwimRate,
            totalSwimRate,
            kayakSwims,
            raftSwims
        );
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

    function getAllRiversRan() public view returns (string[] memory) {
        return uniqueRivers;
    }

    function getTotalHoursOnTheRiver()
        public
        view
        returns (uint256 totalHoursOnTheRiver)
    {
        totalHoursOnTheRiver = (getTotalHoursKayaked() + getTotalHoursRafted());
        return totalHoursOnTheRiver;
    }

    function getLongestKayakTripData()
        public
        view
        returns (uint256, KayakTrip memory)
    {
        return (longestKayakTrip, kayakRiverLog[longestKayakTripIndex]);
    }

    function getLongestRaftingTripData()
        public
        view
        returns (uint256, RaftTrip memory)
    {
        return (longestRaftTrip, raftRiverLog[longestRaftTrip]);
    }

    function getLongestTripData()
        public
        view
        returns (
            string memory tripType,
            uint8 date,
            uint256 duration,
            uint8 riverClass,
            string memory riverName,
            uint16 cfs,
            bool swim
        )
    {
        (
            uint256 kayakDuration,
            KayakTrip memory kayakTrip
        ) = getLongestKayakTripData();
        (
            uint256 raftDuration,
            RaftTrip memory raftTrip
        ) = getLongestRaftingTripData();

        if (raftDuration >= kayakDuration) {
            return (
                "raft",
                raftTrip.date,
                raftDuration,
                raftTrip.riverClass,
                raftTrip.riverName,
                raftTrip.cubicFeetPerSecond,
                raftTrip.swim
            );
        } else {
            return (
                "kayak",
                kayakTrip.date,
                kayakDuration,
                kayakTrip.riverClass,
                kayakTrip.riverName,
                kayakTrip.cubicFeetPerSecond,
                kayakTrip.swim
            );
        }
    }
}
