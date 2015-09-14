// -----------------------------------------------------------------------------
// Automatically generated by 'functions_config.rb'
// DO NOT MANUALLY EDIT THIS FILE!
// -----------------------------------------------------------------------------

class CfgFunctions
{
    class CBA
    {
        class Ai
        {
            // CBA_fnc_addWaypoint
            class addWaypoint
            {
                description = "A function used to add a waypoint to a group. Parameters: - Group (Group or Object) - Position (XYZ, Object, Location or Group) Optional: - Radius (Scalar) - Waypoint Type (String) - Behaviour (String) - Combat Mode (String) - Speed Mode (String) - Formation (String) - Code To Execute at Each Waypoint (String) - TimeOut at each Waypoint (Array [Min, Med, Max]) - Waypoint Completion Radius (Scalar) Example: [this, this, 300, ""MOVE"", ""AWARE"", ""YELLOW"", ""FULL"", ""STAG COLUMN"", ""this spawn CBA_fnc_searchNearby"", [3,6,9]] Returns: Waypoint Author: Rommel";
                file = "\x\cba\addons\ai\fnc_addWaypoint.sqf";
            };
            // CBA_fnc_searchNearby
            class searchNearby
            {
                description = "A function for a group to search a nearby building. Parameters: Group (Group or Object) Example: [group player] spawn CBA_fnc_searchNearby Returns: Nil Author: Rommel";
                file = "\x\cba\addons\ai\fnc_searchNearby.sqf";
            };
            // CBA_fnc_taskAttack
            class taskAttack
            {
                description = "A function for a group to attack a parsed location. Parameters: - Group (Group or Object) - Position (XYZ, Object, Location or Group) Optional: - Search Radius (Scalar) Example: [group player, getpos (player findNearestEnemy player), 100] call CBA_fnc_taskAttack Returns: Nil Author: Rommel";
                file = "\x\cba\addons\ai\fnc_taskAttack.sqf";
            };
            // CBA_fnc_taskDefend
            class taskDefend
            {
                description = "A function for a group to defend a parsed location. Groups will mount nearby static machine guns, and bunker in nearby buildings. They may also patrol the radius unless otherwise specified. Parameters: - Group (Group or Object) Optional: - Position (XYZ, Object, Location or Group) - Defend Radius (Scalar) - Building Size Threshold (Integer, default 2) - Can patrol (boolean) Example: [this] call CBA_fnc_taskDefend Returns: Nil Author: Rommel";
                file = "\x\cba\addons\ai\fnc_taskDefend.sqf";
            };
            // CBA_fnc_taskPatrol
            class taskPatrol
            {
                description = "A function for a group to randomly patrol a parsed radius and location. Parameters: - Group (Group or Object) Optional: - Position (XYZ, Object, Location or Group) - Radius (Scalar) - Waypoint Count (Scalar) - Waypoint Type (String) - Behaviour (String) - Combat Mode (String) - Speed Mode (String) - Formation (String) - Code To Execute at Each Waypoint (String) - TimeOut at each Waypoint (Array [Min, Med, Max]) Example: [this, getmarkerpos ""objective1""] call CBA_fnc_taskPatrol [this, this, 300, 7, ""MOVE"", ""AWARE"", ""YELLOW"", ""FULL"", ""STAG COLUMN"", ""this spawn CBA_fnc_searchNearby"", [3,6,9]] call CBA_fnc_taskPatrol;";
                file = "\x\cba\addons\ai\fnc_taskPatrol.sqf";
            };
            // CBA_fnc_taskSearchArea
            class taskSearchArea
            {
                description = "A function used to have AI search a given marker or trigger area indefinitely. Includes random building searches.";
                file = "\x\cba\addons\ai\fnc_taskSearchArea.sqf";
            }
        };
    };
};
