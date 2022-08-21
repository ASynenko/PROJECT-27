/*
    Author: eugene27
    Date: 11.08.2022
    
    Example:
        [_sectorTrigger] spawn P27_fnc_createSector;
    
    Return:
		nothing
*/

params ["_sectorTrigger"];

private _triggerIsActive = _sectorTrigger getVariable ["isActive", false];
private _sectorIsCaptured = _sectorTrigger getVariable ["isCaptured", false];
private _spawnConfig = _sectorTrigger getVariable ["spawnConfig", []];


if (_triggerIsActive || _spawnConfig isEqualTo []) exitWith {};


private _triggerPosition = position _sectorTrigger;
private _triggerRadius = (triggerArea _sectorTrigger) # 0;
private _sectorRadius = _triggerRadius - (configSectors # 1);

private _spawnEnemyConfig = _spawnConfig # 0;
private _spawnCivConfig = _spawnConfig # 1;


_sectorTrigger setVariable ["isActive", true];


private _allSpawnedEntities = [[], []];

private _enemyConfig = configUnits # 0;

private _enemySide = _enemyConfig # 0;
private _enemyClasses = _enemyConfig # 1;
private _civClasses = configUnits # 1;

if (!_sectorIsCaptured) then {
	[_sectorTrigger, _sectorRadius, _enemyClasses # 1, _enemySide, _spawnEnemyConfig # 0] spawn P27_fnc_createHouseUnits;
	[_sectorTrigger, _sectorRadius, _enemyClasses # 1, _enemySide, _spawnEnemyConfig # 1] spawn P27_fnc_createPatrolUnits;
	[_sectorTrigger, _sectorRadius, (_enemyClasses # 2) + (_enemyClasses # 3), _enemyClasses # 1, _enemySide, _spawnEnemyConfig # 2] spawn P27_fnc_createPatrolVehicles;
	[_sectorTrigger, _sectorRadius, _enemyClasses # 4, _enemyClasses # 1, _enemySide, _spawnEnemyConfig # 3] spawn P27_fnc_createPatrolVehicles;
	[_sectorTrigger, _sectorRadius, _enemyClasses # 5, _enemyClasses # 1, _enemySide, _spawnEnemyConfig # 4] spawn P27_fnc_createTurrets;

	([
		_triggerPosition,
		"AREA:", [_sectorRadius, _sectorRadius, 0, false],
		"ACT:", ["WEST SEIZED", "PRESENT", true],
		"STATE:", ["this", "[thisTrigger] call P27_fnc_setSectorCaptureState", ""]
	] call CBA_fnc_createTrigger) params ["_captureTrigger", "_captureTriggerOptions"];;

	_captureTrigger setVariable ["spawnTrigger", _sectorTrigger];
	_sectorTrigger setVariable ["captureTrigger", _captureTrigger];
};

[_sectorTrigger, _sectorRadius, _civClasses # 0, civilian, _spawnCivConfig # 0] spawn P27_fnc_createHouseUnits;
[_sectorTrigger, _sectorRadius, _civClasses # 0, civilian, _spawnCivConfig # 1] spawn P27_fnc_createPatrolUnits;
[_sectorTrigger, _sectorRadius, _civClasses # 1, _civClasses # 0, civilian, _spawnCivConfig # 2] spawn P27_fnc_createPatrolVehicles;


[_sectorTrigger] spawn P27_fnc_clearSector;