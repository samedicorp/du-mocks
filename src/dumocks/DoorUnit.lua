--- A door that can be opened or closed.
--
-- Applies to doors, hatches, gates, etc.
--
-- Element Class: DoorUnit
--
-- Extends: Element &gt; ElementWithState &gt; ElementWithToggle
-- @see Element
-- @see ElementWithState
-- @see ElementWithToggle
-- @module DoorUnit
-- @alias M

local MockElement = require "dumocks.Element"
local MockElementWithToggle = require "dumocks.ElementWithToggle"

local elementDefinitions = {}
elementDefinitions["airlock"] = {mass = 4197.11, maxHitPoints = 663.0}
elementDefinitions["fuel intake xs"] = {mass = 4.12, maxHitPoints = 50.0}
elementDefinitions["gate xs"] = {mass = 122752.84, maxHitPoints = 50029.0}
elementDefinitions["expanded gate s"] = {mass = 122752.84, maxHitPoints = 74872.0}
elementDefinitions["gate m"] = {mass = 122752.84, maxHitPoints = 150117.0}
elementDefinitions["expanded gate l"] = {mass = 122752.84, maxHitPoints = 199892.0}
elementDefinitions["gate xl"] = {mass = 122752.84, maxHitPoints = 448208.0}
elementDefinitions["hatch s"] = {mass = 98.56, maxHitPoints = 969.0}
elementDefinitions["interior door"] = {mass = 4197.11, maxHitPoints = 560.0}
elementDefinitions["reinforced sliding door"] = {mass = 4197.11, maxHitPoints = 969.0}
elementDefinitions["sliding door s"] = {mass = 749.15, maxHitPoints = 56.0}
elementDefinitions["sliding door m"] = {mass = 1006.01, maxHitPoints = 450.0}
local DEFAULT_ELEMENT = "sliding door s"

local M = MockElementWithToggle:new()
M.elementClass = "DoorUnit"

function M:new(o, id, elementName)
    local elementDefinition = MockElement.findElement(elementDefinitions, elementName, DEFAULT_ELEMENT)

    o = o or MockElementWithToggle:new(o, id, elementDefinition)
    setmetatable(o, self)
    self.__index = self

    self.plugIn = 0.0

    return o
end

--- Set the value of a signal in the specified IN plug of the element.
--
-- Valid plug names are:
-- <ul>
-- <li>"in" for the in signal (has no actual effect on door state when modified this way).</li>
-- </ul>
-- @tparam string plug A valid plug name to set.
-- @tparam 0/1 state The plug signal state
function M:setSignalIn(plug, state)
    if plug == "in" then
        local value = tonumber(state)
        if type(value) ~= "number" then
            value = 0.0
        end

        -- expected behavior, but in fact nothing happens in-game
        if value > 0.0 then
            -- self:activate()
        else
            -- self:deactivate()
        end

        if value <= 0 then
            self.plugIn = 0
        elseif value >= 1.0 then
            self.plugIn = 1.0
        else
            self.plugIn = value
        end
    end
end

--- Return the value of a signal in the specified IN plug of the element.
--
-- Valid plug names are:
-- <ul>
-- <li>"in" for the in signal.</li>
-- </ul>
-- @tparam string plug A valid plug name to query.
-- @treturn 0/1 The plug signal state
function M:getSignalIn(plug)
    if plug == "in" then
        -- clamp to valid values
        local value = tonumber(self.plugIn)
        if type(value) ~= "number" then
            return 0.0
        elseif value >= 1.0 then
            return 1.0
        elseif value <= 0.0 then
            return 0.0
        else
            return value
        end
    end
    return MockElement.getSignalIn(self)
end

--- Mock only, not in-game: Bundles the object into a closure so functions can be called with "." instead of ":".
-- @treturn table A table encompasing the api calls of object.
-- @see Element:mockGetClosure
function M:mockGetClosure()
    local closure = MockElementWithToggle.mockGetClosure(self)

    closure.setSignalIn = function(plug, state) return self:setSignalIn(plug, state) end
    closure.getSignalIn = function(plug) return self:getSignalIn(plug) end
    return closure
end

return M