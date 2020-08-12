#!/usr/bin/env lua
--- Tests on dumocks.AntiGravityGeneratorUnit.
-- @see dumocks.AntiGravityGeneratorUnit

-- set search path to include root of project
package.path = package.path..";../?.lua"

local lu = require("luaunit")

local maggu = require("dumocks.AntiGravityGeneratorUnit")

TestAntiGravityGeneratorUnit = {}

--- Verify element class is correct.
function TestAntiGravityGeneratorUnit.testGetElementClass()
    local element = maggu:new():mockGetClosure()
    lu.fail("Not Yet Implemented")
    lu.assertEquals(element.getElementClass(), "Unit")
end

--- Sample block to test in-game behavior, can run on mock and uses assert instead of luaunit to run in-game.
function TestAntiGravityGeneratorUnit.testGameBehavior()
    local mock = maggu:new()
    local slot1 = mock:mockGetClosure()

    -- copy from here to unit.start
    assert(false, "Not Yet Implemented")

    assert(slot1.getElementClass() == "Unit")

    -- copy to here to unit.start
end

os.exit(lu.LuaUnit.run())