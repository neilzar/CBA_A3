// Init/InitPost per Object

// #define DEBUG_MODE_FULL
#include "script_component.hpp"

/*  Extended event handlers by Solus
*
*  Get all inherited classes, then check if each inherited class has a counter-
*  part in the extended event handlers classes, then and add all lines from
*  each matching EH class and exec them.
*/
private [
	"_slx_xeh_unit", "_Extended_Init_Class", "_isRespawn", "_unitClass",
	"_inits", "_init", "_excludeClass", "_excludeClasses", "_isExcluded",
	"_u", "_sim", "_data",
	"_isMan", "_fSetInit", "_post", "_isDelayed", "_sys_inits", "_slx_xeh_unitAr"
];

#ifdef DEBUG_MODE_FULL
	format["XEH BEG: %2, %3", time, _this, local (_this select 0), typeOf (_this select 0)] call SLX_XEH_LOG;
#endif

// Get unit.
PARAMS_2(_slx_xeh_unit,_Extended_Init_Class);

if (isNull _slx_xeh_unit) exitWith {
	#ifdef DEBUG_MODE_FULL
		format["XEH EXIT - NULL OBJECT: %2", time, _this] call SLX_XEH_LOG;
	#endif
};

DEFAULT_PARAM(2,_isRespawn,false);
DEFAULT_PARAM(3,_isDelayed,false);
_unitClass = typeOf _slx_xeh_unit;
_post = _Extended_Init_Class == "Extended_InitPost_EventHandlers";

if !(_post) then {
	// Pre Cache the "Other" EventHandlers
	if !(SLX_XEH_RECOMPILE) then { _unitClass call FUNC(init_others_enum_cache) };

	// TODO: PreCache "Init" and "InitPost" eventhandlers?
	// As in MP we will spawn because of need to delay the initialization, see below notes for details.
};


// Multiplayer respawn handling
// Bug #7432 fix - all machines will re-run the init EH where the unit is not local, when a unit respawns
_sim = getText(configFile/"CfgVehicles"/_unitClass/"simulation");
_isMan = _slx_xeh_unit isKindOf "Man" || { _sim == _x }count["soldier"] > 0; // "invisible"

if (count _this == 2 && _isMan && (time>0) && (SLX_XEH_MACHINE select 9) && !_post) exitWith
{
	// Delay initialisation until we can check if it's a respawned unit
	// or a createUnit:ed one. (Respawned units will have the object variable
	// "slx_xeh_isplayable" set to true)
	#ifdef DEBUG_MODE_FULL
		format["XEH: (Bug #7432) deferring init for %2 ",time, _this] call SLX_XEH_LOG;
	#endif

	// Wait for the unit to be fully "ready"
	if (SLX_XEH_MACHINE select 7) then {
		_h = [_slx_xeh_unit] spawn FUNC(init_delayed);
	} else {
		SLX_XEH_DELAYED set [count SLX_XEH_DELAYED, _slx_xeh_unit];
	};

	#ifdef DEBUG_MODE_FULL
	format["XEH END: %2", time, _this] call SLX_XEH_LOG;
	#endif
	nil;
};

if (_isMan) then { if !(isNil "SLX_XEH_INIT_MEN") then { PUSH(SLX_XEH_INIT_MEN,_slx_xeh_unit) } }; // naughty JIP crew double init!

_inits = [];

// Naughty but more flexible...
_sys_inits = [];
if !(_isRespawn) then {
	// Compile code for other EHs to run and put them in the setVariable.
	// Set up code for the remaining event handlers too...
	// This is in PostInit as opposed to (pre)Init,
	// because units in a player's group setVariables are lost (counts at least for disabledAI = 1;)
	// Run men's FUNC(init_others) in PostInit, only when in Multiplayer
	// Run supportM
	if (_post) then {
		if (_isMan) then {
			_sys_inits set [count _sys_inits, {_this call FUNC(init_playable) }];
			if (isMultiplayer) then { _sys_inits set [count _sys_inits, {_this call FUNC(init_others)}] };
		};
	} else {
		_sys_inits set [count _sys_inits, {_this call FUNC(support_monitor2)}];
		if (!_isMan || !isMultiplayer) then { _sys_inits set [count _sys_inits, {_this call FUNC(init_others)}] };
	};
};

if !(_post) then { _sys_inits set [count _sys_inits, compile format ['[_this select 0, %1, %2] call FUNC(init_post)',_isRespawn,_isDelayed]] };


/*
*  Several BIS vehicles use a set of EH:s in the BIS "DefaultEventhandlers"
*  ("DEH" in the following) class - Car, Tank, Helicopter, Plane and Ship.
*
*  Further, The AAV class uses a variation of this DefaultEventhandlers set with
*  it's own specific init EH.  Here, we make sure to include the BIS DEH init
*  event handler and make it the first one that will be called by XEH. The AAV
*  is accomodated by code further below and two composite
*  Extended_Init_EventHandlers definitions in the config.cpp that define
*  a property "replaceDefault" which will replace the DEH init with the
*  class-specific BIS init EH for that vehicle.
*/

// TODO: What if SuperOfSuper inheritsFrom DefaultEventhandlers?
_useDEHinit = false;
if !(_post) then
{
	_ehSuper = inheritsFrom(configFile/"CfgVehicles"/_unitClass/"EventHandlers");
	if (configName(_ehSuper)=="DefaultEventhandlers") then
	{
		if (isText (configFile/"DefaultEventhandlers"/"init")) then
		{
			_useDEHinit = true;
			_DEHinit = getText(configFile/"DefaultEventhandlers"/"init");
			_inits = [compile(_DEHinit)];
		};
	};
};

// All inits
_inits = [_unitClass, _useDEHinit, _Extended_Init_Class, _isRespawn] call FUNC(init_enum_cache);

if (count _sys_inits > 0) then { _inits = [_sys_inits] + _inits };

// Now call all the init EHs on the unit.
#ifdef DEBUG_MODE_FULL
	format["XEH RUN: %2 - %3 - %4", time, _this, typeOf _slx_xeh_unit, _inits] call SLX_XEH_LOG;
#endif

_slx_xeh_unitAr = [_slx_xeh_unit];
{
	{
		if (typeName _x=="CODE") then
		{
			// Normal code type handler
			_slx_xeh_unitAr call _x;
		} else {
			// It's an array of handlers (all, server, client)
			{_slx_xeh_unitAr call _x} forEach _x;
		};
	} forEach _x;
} forEach _inits;

#ifdef DEBUG_MODE_FULL
	format["XEH END: %2", time, _this] call SLX_XEH_LOG;
#endif

nil;
