/*
    Author: eugene27
    Date: 21.08.2022
    
    Example:
        [] call P27_fnc_createIedOnRoads
*/


params [["_count", 10]];

private _junkClasses = (configObjects # 0) # 1;
private _mineClasses = (configObjects # 0) # 0;

private _roadIedPositions = [_count] call P27_fnc_getRandomRoadPositions;

private _allRoadIed = [];

for [{private _i = 0 }, { _i < (count _roadIedPositions) }, { _i = _i + 1 }] do {
	private _roadPosition = (_roadIedPositions # _i) # 0;

	private _ied = createMine [selectRandom _mineClasses, _roadPosition, [], 5];

	if ((random 1) < 0.7) then {
		createVehicle [selectRandom _junkClasses, position _ied, [], 0, "CAN_COLLIDE"];
	};

	_allRoadIed pushBack _ied;
	
	if (debugMode) then {
		["ied_" + (str _roadPosition), _roadPosition, "ELLIPSE", [5, 5], "COLOR:", "ColorRed", "ALPHA:", 1, "PERSIST"] call CBA_fnc_createMarker;
	};
};

missionNamespace setVariable ["iedOnRoads", _allRoadIed, true];


private _roadJunkPositions = [_count] call P27_fnc_getRandomRoadPositions;

for [{private _i = 0 }, { _i < (count _roadJunkPositions) }, { _i = _i + 1 }] do {
	private _junk = createVehicle [selectRandom _junkClasses, (_roadJunkPositions # _i) # 0, [], 0, "CAN_COLLIDE"];
};