--- A general kinematic unit to obtain information about the ship orientation, velocity, and acceleration.
--
-- Element class: GyroUnit
--
-- Extends: Element &gt; ElementWithState &gt; ElementWithToggle
-- @see Element
-- @see ElementWithState
-- @see ElementWithToggle
-- @module GyroUnit
-- @alias M

local MockElement = require "dumocks.Element"
local MockElementWithToggle = require "dumocks.ElementWithToggle"

local elementDefinitions = {}
elementDefinitions["gyroscope"] = {mass = 104.41, maxHitPoints = 50}
local DEFAULT_ELEMENT = "gyroscope"

local M = MockElementWithToggle:new()
M.elementClass = "GyroUnit"
M.widgetType = "gyro"

function M:new(o, id, elementName)
    local elementDefinition = MockElement.findElement(elementDefinitions, elementName, DEFAULT_ELEMENT)

    o = o or MockElementWithToggle:new(o, id, elementDefinition)
    setmetatable(o, self)
    self.__index = self

    o.localUp = {0, 0, 0}
    o.localForward = {0, 0, 0}
    o.localRight = {0, 0, 0}
    o.worldUp = {0, 0, 0}
    o.worldForward = {0, 0, 0}
    o.worldRight = {0, 0, 0}
    o.pitch = 0 -- deg
    o.roll = 0 -- deg
    o.yaw = 0 -- deg
    o.yawWorldReference = {0, 0, 0}

    -- only activateable when on a dynamic core, this allows for testing on a static core if needed for some reason
    o.dynamicCore = true

    return o
end

--- Switches the element on/open.
--
-- Note: Has no effect when called on a static core.
function M:activate()
    self.state = self.dynamicCore == true
end

--- Toggle the state of the element.
--
-- Note: Has no effect when called on a static core.
function M:toggle()
    self.state = self.dynamicCore == true and not self.state
end

local DATA_TEMPLATE = '{\"helperId\":\"gyro\",\"name\":\"%s\","pitch":%.17f,"roll":%.16f,\"type\":\"%s\"}'
--- Get element data as JSON.
--
-- Gyroscopes have a <code>gyro</code> widget, which contains the following fields (bold fields are visible when making
-- custom use of the widget):
-- <ul>
--   <li><b><span class="parameter">pitch</span></b> (<span class="type">float</span>) Pitch angle in degrees.</li>
--   <li><b><span class="parameter">roll</span></b> (<span class="type">float</span>) Roll angle in degrees.</li>
--   <li><span class="parameter">name</span> (<span class="type">string</span>) The name of the element.</li>
--   <li><span class="parameter">helperId</span> (<span class="type">string</span>) <code>gyro</code></li>
--   <li><span class="parameter">type</span> (<span class="type">string</span>) <code>gyro</code></li>
-- </ul>
-- @treturn string Data as JSON.
function M:getData()
    return string.format(DATA_TEMPLATE, self.name, self.pitch, self.roll, self:getWidgetType())
end

-- Override default with realistic patten to id.
function M:getDataId()
    return "e123456"
end

--- The up vector of the gyro unit, in construct local coordinates.
-- @return Normalized up vector of the gyro unit, in construct local coordinates.
function M:localUp()
    return self.localUp
end

--- The forward vector of the gyro unit, in construct local coordinates.
-- @return Normalized forward vector of the gyro unit, in construct local coordinates.
function M:localForward()
    return self.localForward
end

--- The right vector of the gyro unit, in construct local coordinates.
-- @return Normalized right vector of the gyro unit, in construct local coordinates.
function M:localRight()
    return self.localRight
end

--- The up vector of the gyro unit, in world coordinates.
-- @return Normalized up vector of the gyro unit, in world coordinates.
function M:worldUp()
    return self.worldUp
end

--- The forward vector of the gyro unit, in world coordinates.
-- @return Normalized forward vector of the gyro unit, in world coordinates.
function M:worldForward()
    return self.worldForward
end

--- The right vector of the gyro unit, in world coordinates.
-- @return Normalized right vector of the gyro unit, in world coordinates.
function M:worldRight()
    return self.worldRight
end

--- The pitch value relative to the gyro orientation and the local gravity.
-- @treturn deg The pitch angle in degrees, relative to the gyro orientation and the local gravity.
function M:getPitch()
    return self.pitch
end

--- The roll value relative to the gyro orientation and the local gravity.
-- @treturn deg The roll angle in degrees, relative to the gyro orientation and the local gravity.
function M:getRoll()
    return self.roll
end

--- Mock only, not in-game: Bundles the object into a closure so functions can be called with "." instead of ":".
-- @treturn table A table encompasing the api calls of object.
-- @see Element:mockGetClosure
function M:mockGetClosure()
    local closure = MockElementWithToggle.mockGetClosure(self)
    closure.localUp = function() return self:localUp() end
    closure.localForward = function() return self:localForward() end
    closure.localRight = function() return self:localRight() end
    closure.worldUp = function() return self:worldUp() end
    closure.worldForward = function() return self:worldForward() end
    closure.worldRight = function() return self:worldRight() end
    closure.getPitch = function() return self:getPitch() end
    closure.getRoll = function() return self:getRoll() end
    return closure
end

return M