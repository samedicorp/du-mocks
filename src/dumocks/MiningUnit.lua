--- Extracts a regular amount of resources from the ground.
--
-- Element Class: MiningUnit
--
-- Extends: Element
-- @see Element
-- @module MiningUnit
-- @alias M

local MockElement = require "dumocks.Element"

local elementDefinitions = {}
elementDefinitions["basic mining unit s"] = {mass = 180.0, maxHitPoints = 2500.0}
elementDefinitions["basic mining unit l"] = {mass = 5130.0, maxHitPoints = 11250.0}
elementDefinitions["uncommon mining unit l"] = {mass = 5160.0, maxHitPoints = 11250.0}
elementDefinitions["advanced mining unit l"] = {mass = 7500.0, maxHitPoints = 11250.0}
elementDefinitions["rare mining unit l"] = {mass = 7800.0, maxHitPoints = 11250.0}
elementDefinitions["exotic mining unit l"] = {mass = 8500.0, maxHitPoints = 11250.0}
-- elementDefinitions["space mining unit l"] = {mass = 6500, maxHitPoints = }
local DEFAULT_ELEMENT = "basic mining unit s"

local M = MockElement:new()
M.elementClass = "MiningUnit"

function M:new(o, id, elementName)
    local elementDefinition = MockElement.findElement(elementDefinitions, elementName, DEFAULT_ELEMENT)

    o = o or MockElement:new(o, id, elementDefinition)
    setmetatable(o, self)
    self.__index = self

    return o
end

--- Returns the current status of the mining unit.
-- @treturn string The status of the minign unit can be: "STOPPED", "RUNNING", "JAMMED_OUTPUT_FULL".
function M:getStatus()
    return "STOPPED"
end

--- Returns the remaining time of the current batch extraction process.
-- @treturn float The remaining time in seconds.
function M:getRemainingTime()
end

--- Returns the item ID of the currently selected ore.
-- @treturn int The item ID of the selected ore.
function M:getActiveOre()
end

--- Returns the list of ore pools in the territory.
-- @treturn table A list of tables composed with {[integer] oreId, [number] available, [number] maximum}
function M:getOrePools()
end

--- Returns the base production rate of the mining unit.
-- @treturn float The production rate in L/h.
function M:getBaseRate()
end

--- Returns the efficiency rate of the mining unit.
-- @treturn float The efficiency rate.
function M:getEfficiency()
end

--- Returns the territory's adjacency bonus to the territory of the mining unit.
-- @treturn float The territory's adjacency bonus.
function M:getAdjacencyBonus()
end

--- Returns the calibration rate of the mining unit.
-- @treturn float The calibration rate of the mining unit.
function M:getCalibrationRate()
end

--- Returns the optimal calibration rate of the mining unit.
-- @treturn float the optimal calibration rate of the mining unit.
function M:getOptimalRate()
end

--- Returns the current production rate of the mining unit.
-- @treturn float The production rate in L/h.
function M:getProductionRate()
end

--- Returns the position of the last calibration excavation, in world coordinates.
-- @treturn The coordinates in world coordinates.
function M:getLastExtractionPosition()
end

--- Returns the ID of the last player who calibrated the mining unit.
-- @treturn int The ID of the player.
function M:getLastExtractingPlayerId()
end

--- Returns the time in seconds since the last calibration of the mining unit.
-- @treturn float The time in seconds with milliseconds precision.
function M:getLastExtractionTime()
end

--- Returns the item ID of the ore extracted during the last calibration excavation.
-- @treturn int The item ID of the extracted ore.
function M:getLastExtractedOre()
end

--- Returns the volume of ore extracted during the last calibration excavation.
-- @treturn float The volume of ore extracted in L.
function M:getLastExtractedVolume()
end

--- Event: Emitted when the mining unit status is changed.
--
-- Note: This is documentation on an event handler, not a callable method.
-- @tparam string status The new status of the mining unit, can be: "STOPPED", "RUNNING", "JAMMED_OUTPUT_FULL".
function M.EVENT_statusChanged(status)
    assert(false, "This is implemented for documentation purposes.")
end

--- Event: Emitted when the mining unit completes a batch.
--
-- Note: This is documentation on an event handler, not a callable method.
-- @tparam int oreId The item ID of the ore mined during the extraction process.
-- @tparam float amount Amount of ore mined.
function M.EVENT_completed(oreId, amount)
    assert(false, "This is implemented for documentation purposes.")
end

--- Event: Emitted when the mining unit is calibrated.
--
-- Note: This is documentation on an event handler, not a callable method.
-- @tparam int oreId The item ID of the ore extracted during the calibration process.
-- @tparam float amount Amount of ore extracted during the calibration process.
-- @tparam float rate The new calibration rate after calibration process.
function M.EVENT_calibrated(oreId, amount, rate)
    assert(false, "This is implemented for documentation purposes.")
end

--- Mock only, not in-game: Bundles the object into a closure so functions can be called with "." instead of ":".
-- @treturn table A table encompasing the api calls of object.
-- @see Element:mockGetClosure
function M:mockGetClosure()
    local closure = MockElement.mockGetClosure(self)
    closure.getStatus = function() return self:getStatus() end
    closure.getRemainingTime = function() return self:getRemainingTime() end
    closure.getActiveOre = function() return self:getActiveOre() end
    closure.getOrePools = function() return self:getOrePools() end
    closure.getBaseRate = function() return self:getBaseRate() end
    closure.getEfficiency = function() return self:getEfficiency() end
    closure.getAdjacencyBonus = function() return self:getAdjacencyBonus() end
    closure.getCalibrationRate = function() return self:getCalibrationRate() end
    closure.getOptimalRate = function() return self:getOptimalRate() end
    closure.getProductionRate = function() return self:getProductionRate() end
    closure.getLastExtractionPosition = function() return self:getLastExtractionPosition() end
    closure.getLastExtractingPlayerId = function() return self:getLastExtractingPlayerId() end
    closure.getLastExtractionTime = function() return self:getLastExtractionTime() end
    closure.getLastExtractedOre = function() return self:getLastExtractedOre() end
    closure.getLastExtractedVolume = function() return self:getLastExtractedVolume() end
    return closure
end

return M