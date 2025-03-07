--- Broadcasts data to radars, that can access more information if their transponder tags are matching.
--
-- Element class: CombatDefense
--
-- Extends: Element &gt; ElementWithState &gt; ElementWithToggle
-- @see Element
-- @see ElementWithState
-- @see ElementWithToggle
-- @module TransponderUnit
-- @alias M

local MockElement = require "dumocks.Element"
local MockElementWithToggle = require "dumocks.ElementWithToggle"

local elementDefinitions = {}
elementDefinitions["transponder"] = {mass = 340, maxHitPoints = 50.0}
local DEFAULT_ELEMENT = "transponder"

local M = MockElementWithToggle:new()
M.elementClass = "CombatDefense"

function M:new(o, id, elementName)
    local elementDefinition = MockElement.findElement(elementDefinitions, elementName, DEFAULT_ELEMENT)

    o = o or MockElementWithToggle:new(o, id, elementDefinition)
    setmetatable(o, self)
    self.__index = self

    o.toggledCallbacks = {}

    self.plugIn = 0.0

    self.tags = {}

    return o
end

-- Behavior override to trigger event.
function M:activate()
    self:mockDoToggled(1)
end

-- Behavior override to trigger event.
function M:deactivate()
    self:mockDoToggled(0)
end

-- Behavior override to trigger event.
function M:toggle()
    if self.state then
        self:mockDoToggled(0)
    else
        self:mockDoToggled(1)
    end
end

local BAD_TAG_PATTERN = "%s"
--- Set the tags list with up to 8 entries. Returns 1 if the application was successful, 0 if the tag format is invalid.
--
-- Note: Calling too frequently (< 0.5 seconds between calls) will display an "Invalid request timing" message. Also,
--   providing too many tags truncates the list instead of returning 0, but spaces in tags aren't allowed.
-- @tparam list tags List of up to 8 transponder tag strings.
-- @treturn 0/1 1 if transponder tags were set, 0 if an error occurred.
function M:setTags(tags)
    if type(tags) ~= "table" then
        self.tags = {}
        return 1
    end

    local result = {}
    for _, tag in pairs(tags) do
        if string.match(tag, BAD_TAG_PATTERN) then
            return 0
        end

        if #result >= 8 then
            break
        elseif string.len(tag) > 0 then
            table.insert(result, tag)
        end
    end
    self.tags = result
    return 1
end

--- Returns the tag list.
-- @treturn list List of up to 8 transponder tag strings.
function M:getTags(tags)
    return self.tags
end

--- Set the value of a signal in the specified IN plug of the element.
--
-- Valid plug names are:
-- <ul>
-- <li>"in" for the in signal (has no actual effect on agg state when modified this way).</li>
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

--- Event: Emitted when the transponder is started or stopped.
--
-- Note: This is documentation on an event handler, not a callable method.
-- @tparam 0/1 active 1 if the element was activated, 0 otherwise.
function M.EVENT_toggled()
    assert(false, "This is implemented for documentation purposes. For test usage see mockRegisterToggled")
end

--- Mock only, not in-game: Register a handler for the in-game `toggled(active)` event.
-- @tparam function callback The function to call when the shield state changes.
-- @tparam string active The state to filter for or "*" for all.
-- @treturn int The index of the callback.
-- @see EVENT_toggled
function M:mockRegisterToggled(callback, active)
    local index = #self.toggledCallbacks + 1
    self.toggledCallbacks[index] = {
        callback = callback,
        active = active
    }
    return index
end

--- Mock only, not in-game: Simulates the transponder changing state.
--
-- Note: The state updates after the event handlers are called.
-- @tparam 0/1 active The new state, 0 for off, 1 for on.
function M:mockDoToggled(active)
    -- bail if already in desired state
    if self.state == (active == 1) then
        return
    end

    -- call callbacks in order, saving exceptions until end
    local activeString = tostring(active) -- in case registered with string argument, following "*" pattern
    local errors = ""
    for i, callback in pairs(self.toggledCallbacks) do
        -- filter on active
        if (callback.active == "*" or callback.active == active or callback.active == activeString) then
            local status, err = pcall(callback.callback, active)
            if not status then
                errors = errors .. "\nError while running callback " .. i .. ": " .. err
            end
        end
    end

    self.state = (active == 1)

    -- propagate errors
    if string.len(errors) > 0 then
        error("Errors raised in callbacks:" .. errors)
    end
end

--- Mock only, not in-game: Bundles the object into a closure so functions can be called with "." instead of ":".
-- @treturn table A table encompasing the api calls of object.
-- @see Element:mockGetClosure
function M:mockGetClosure()
    local closure = MockElementWithToggle.mockGetClosure(self)
    closure.setTags = function(tags) return self:setTags(tags) end
    closure.getTags = function() return self:getTags() end

    closure.setSignalIn = function(plug, state) return self:setSignalIn(plug, state) end
    closure.getSignalIn = function(plug) return self:getSignalIn(plug) end
    return closure
end

return M