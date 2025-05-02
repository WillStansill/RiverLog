🌊 RiverLog Smart Contract
==========================

**Version:** Solidity 0.8.28\
**License:** MIT

The `RiverLog` contract is an on-chain logging system for tracking kayaking and rafting adventures. It records detailed trip data, computes aggregate statistics, and provides insights into river usage, swims, and trip durations.

* * * * *

🚀 Features
-----------

-   Record **kayak trips** and **rafting trips** with detailed metadata:

    -   Date

    -   River class

    -   Cubic feet per second (CFS)

    -   River name

    -   Swim occurrence

    -   Trip duration (hours)

    -   Kayak: boat used

    -   Raft: commercial or private, navigation style

-   Track unique rivers and categorize them by difficulty class.

-   Compute aggregate stats:

    -   Total hours kayaked & rafted

    -   Total trips taken

    -   Longest kayak and rafting trips

    -   Swim counts and swim rates per activity

    -   Commercial rafting trips

-   Query trips by river name or class.

* * * * *

🏗 Contract Overview
--------------------

### Enums

solidity

CopyEdit

`enum NavigationStyle { PaddleGuide, OarGuide, Paddler, R2 }`

* * * * *

### Structs

solidity

CopyEdit

`struct KayakTrip {
    uint8 date;
    uint8 riverClass;
    uint16 cubicFeetPerSecond;
    string riverName;
    bool swim;
    string boatUsed;
    uint16 durationHours;
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
}`

* * * * *

### Core Functions

-   `addKayakTrip(...)` --- Log a kayak trip

-   `addRaftingTrip(...)` --- Log a rafting trip

-   `getTotalKayakTrips()` --- Get kayak trip count

-   `getTotalRaftTrips()` --- Get rafting trip count

-   `getTotalTripsTaken()` --- Get total trips count

-   `getRiversAccordingToClass(uint8)` --- List rivers by class

-   `getSwimData()` --- Get swim stats and lists

-   `getTripsByRiverName(string)` --- Get all trips by river

-   `getCommercialTripsRun()` --- Get all commercial rafting trips

-   `getTotalHoursKayaked()` / `getTotalHoursRafted()` --- Get total hours by type

-   `getTotalHoursOnTheRiver()` --- Combined total hours

-   `getLongestKayakTripData()` / `getLongestRaftingTripData()` --- Get longest trip

-   `getLongestTripData()` --- Get longest overall trip details

* * * * *

📊 Statistics Calculated
------------------------

-   **Swim Rate** → `(swims * 10,000) / total trips` (`PERCISION = 1e4`)

-   **Longest trip** → Compared across kayak and raft trips

-   **Unique rivers** → Collected across all trip types

* * * * *

🔍 Example Queries
------------------

solidity

CopyEdit

`(string memory tripType, uint8 date, uint256 duration, uint8 riverClass, string memory riverName, uint16 cfs, bool swim) = riverLog.getLongestTripData();`

solidity

CopyEdit

`(uint256 totalCommercialRaftTrips, RaftTrip[] memory commercialTrips) = riverLog.getCommercialTripsRun();`

solidity

CopyEdit

`(uint256 totalSwims, uint256 kayakSwimRate, uint256 raftSwimRate, uint256 totalSwimRate, KayakTrip[] memory kayakSwims, RaftTrip[] memory raftSwims) = riverLog.getSwimData();`

* * * * *

⚙️ Deployment
-------------

-   Solidity version: `^0.8.28`

-   SPDX License Identifier: `MIT`

* * * * *

💡 Notes
--------

-   River class → stored as `uint8` (recommended: 1--6)

-   Date → stored as `uint8` (suggested format: days or trip index, *not a full date timestamp*)

-   Swim rates and percentages use a precision constant (`PERCISION = 1e4`) for fixed-point math

-   All string-based indexing (river names) is **case-sensitive**

* * * * *

🛡 Potential Improvements
-------------------------

✅ Add proper date handling (e.g., Unix timestamp)\
✅ Add owner/admin permissions\
✅ Optimize storage (consider events vs. arrays)\
✅ Add remove/update trip functions\
✅ Consider off-chain indexing with The Graph or a subgraph

* * * * *

🏞 About
--------

**RiverLog** is inspired by the love of whitewater adventure, helping paddlers, guides, and outfitters keep a transparent and immutable history of their time on the water.