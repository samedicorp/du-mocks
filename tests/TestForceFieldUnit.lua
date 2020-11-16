#!/usr/bin/env lua
--- Tests on dumocks.ForceFieldUnit.
-- @see dumocks.ForceFieldUnit

-- set search path to include root of project
package.path = package.path..";../?.lua"

local lu = require("luaunit")

local mffu = require("dumocks.ForceFieldUnit")

_G.TestForceFieldUnit = {}

--- Verify constructor arguments properly handled and independent between instances.
function _G.TestForceFieldUnit.testConstructor()

    -- default element:
    -- ["force field xs"] = {mass = 110.62, maxHitPoints = 50.0}

    local field0 = mffu:new()
    local field1 = mffu:new(nil, 1, "Force Field XS")
    local field2 = mffu:new(nil, 2, "invalid")
    local field3 = mffu:new(nil, 3, "force field s")

    local fieldClosure0 = field0:mockGetClosure()
    local fieldClosure1 = field1:mockGetClosure()
    local fieldClosure2 = field2:mockGetClosure()
    local fieldClosure3 = field3:mockGetClosure()

    lu.assertEquals(fieldClosure0.getId(), 0)
    lu.assertEquals(fieldClosure1.getId(), 1)
    lu.assertEquals(fieldClosure2.getId(), 2)
    lu.assertEquals(fieldClosure3.getId(), 3)

    -- all force fields share attributes, can't verify element selection
end

--- Characterization test to determine in-game behavior, can run on mock and uses assert instead of luaunit to run
-- in-game.
--
-- Test setup:
-- 1. 1x Force Field, connected to Programming Board on slot1
--
-- Exercises: getElementClass, deactivate, activate, toggle, getState, setSignalIn, getSignalIn
function _G.TestForceFieldUnit.testGameBehavior()
    local mock = mffu:new(nil, 1)
    local slot1 = mock:mockGetClosure()

    -- stub this in directly to supress print in the unit test
    local unit = {}
    unit.exit = function() end
    local system = {}
    system.print = function() end

    ---------------
    -- copy from here to unit.start()
    ---------------
    -- verify expected functions
    local expectedFunctions = {"activate", "deactivate", "toggle", "getState", 
                               "show", "hide", "getData", "getDataId", "getWidgetType", "getIntegrity", "getHitPoints",
                               "getMaxHitPoints", "getId", "getMass", "getElementClass", "setSignalIn", "getSignalIn",
                               "load"}
    local unexpectedFunctions = {}
    for key, value in pairs(slot1) do
        if type(value) == "function" then
            for index, funcName in pairs(expectedFunctions) do
                if key == funcName then
                    table.remove(expectedFunctions, index)
                    goto continueOuter
                end
            end

            table.insert(unexpectedFunctions, key)
        end

        ::continueOuter::
    end
    local message = ""
    if #expectedFunctions > 0 then
        message = message .. "Missing expected functions: " .. table.concat(expectedFunctions, ", ") .. "\n"
    end
    if #unexpectedFunctions > 0 then
        message = message .. "Found unexpected functions: " .. table.concat(unexpectedFunctions, ", ") .. "\n"
    end
    assert(message:len() == 0, message)

    -- test element class and inherited methods
    assert(slot1.getElementClass() == "ForceFieldUnit")
    assert(slot1.getData() == "{}")
    assert(slot1.getDataId() == "")
    assert(slot1.getWidgetType() == "")
    slot1.show()
    slot1.hide()
    assert(slot1.getIntegrity() == 100.0 * slot1.getHitPoints() / slot1.getMaxHitPoints())
    assert(slot1.getMaxHitPoints() == 50.0)
    assert(slot1.getId() > 0)
    assert(slot1.getMass() == 110.62)

    -- play with set signal
    slot1.setSignalIn("in", 0.0)
    assert(slot1.getSignalIn("in") == 0.0)
    assert(slot1.getState() == 0)
    slot1.setSignalIn("in", 1.0)
    assert(slot1.getSignalIn("in") == 1.0)
    assert(slot1.getState() == 1)
    -- fractions within [0,1] work, and string numbers are cast
    slot1.setSignalIn("in", 0.7)
    assert(slot1.getSignalIn("in") == 0.7)
    assert(slot1.getState() == 1)
    slot1.setSignalIn("in", "0.5")
    assert(slot1.getSignalIn("in") == 0.5)
    assert(slot1.getState() == 1)
    slot1.setSignalIn("in", "0.0")
    assert(slot1.getSignalIn("in") == 0.0)
    assert(slot1.getState() == 0)
    slot1.setSignalIn("in", "7.0")
    assert(slot1.getSignalIn("in") == 1.0)
    assert(slot1.getState() == 1)
    -- invalid sets to 0
    slot1.setSignalIn("in", "text")
    assert(slot1.getSignalIn("in") == 0.0)
    assert(slot1.getState() == 0)
    slot1.setSignalIn("in", nil)
    assert(slot1.getSignalIn("in") == 0.0)
    assert(slot1.getState() == 0)

    -- ensure initial state
    slot1.deactivate()
    assert(slot1.getState() == 0)

    -- validate methods
    slot1.activate()
    assert(slot1.getState() == 1)
    slot1.deactivate()
    assert(slot1.getState() == 0)
    slot1.toggle()
    assert(slot1.getState() == 1)

    system.print("Success")
    unit.exit()
    ---------------
    -- copy to here to unit.start()
    ---------------
end

os.exit(lu.LuaUnit.run())