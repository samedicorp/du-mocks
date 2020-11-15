--- This is the heart of your construct. It represents the construct and gives access to all construct-related
-- information.
-- @module CoreUnit
-- @alias M

local MockElement = require "dumocks.Element"

local elementDefinitions = {}
elementDefinitions["dynamic core unit xs"] = {mass = 70.89, maxHitPoints = 50.0, class = "CoreUnitDynamic"}
elementDefinitions["dynamic core unit s"] = {mass = 375.97, maxHitPoints = 183.0, class = "CoreUnitDynamic"}
elementDefinitions["dynamic core unit m"] = {mass = 1984.6, maxHitPoints = 1288.0, class = "CoreUnitDynamic"}
elementDefinitions["dynamic core unit l"] = {mass = 12141.47, maxHitPoints = 11541.0, class = "CoreUnitDynamic"}
elementDefinitions["space core unit xs"] = {mass = 38.99, maxHitPoints = 50.0, class = "CoreUnitSpace"}
elementDefinitions["static core unit xs"] = {mass = 70.89, maxHitPoints = 50.0, class = "CoreUnitStatic"}
elementDefinitions["static core unit s"] = {mass = 360.18, maxHitPoints = 167.0, class = "CoreUnitStatic"}
elementDefinitions["static core unit m"] = {mass = 1926.91, maxHitPoints = 1184.0, class = "CoreUnitStatic"}
elementDefinitions["static core unit l"] = {mass = 10066.3, maxHitPoints = 10710.0, class = "CoreUnitStatic"}
-- TODO others
local DEFAULT_ELEMENT = "dynamic core unit xs"

local M = MockElement:new()
M.widgetType = "core"

function M:new(o, id, elementName)
    local elementDefinition = MockElement.findElement(elementDefinitions, elementName, DEFAULT_ELEMENT)

    o = o or MockElement:new(o, id, elementDefinition)
    setmetatable(o, self)
    self.__index = self

    self.elementClass = elementDefinition.class

    o.constructMass = 0 -- kg
    o.constructIMass = 0 -- kg*m2
    o.constructCrossSection = 0 -- m2
    o.constructWorldPos = {0, 0, 0} -- vec3
    o.constructId = 0
    o.worldAirFrictionAngularAcceleration = {0, 0, 0} -- vec3
    o.worldAirFrictionAcceleration = {0, 0, 0} -- vec3
    o.elements = {} -- map: UID => {name="", type="", position={0,0,0}, hp=0.0, maxHp=0.0, mass=0.0}
    o.altitude = 0 -- m
    o.g = 0 -- m/s2
    o.worldGravity = 0 -- m/s2
    o.worldVertical = 0 -- m/s2
    o.angularVelocity = 0 -- rad/s
    o.worldAngularVelocity = 0 -- rad/s
    o.angularAcceleration = 0 -- rad/s2
    o.worldAngularAcceleration = 0 -- rad/s2
    o.velocity = 0 -- m/s
    o.worldVelocity = {0, 0, 0} -- m/s
    o.acceleration = 0 -- m/s2
    o.worldAcceleration = 0 -- m/s2
    o.constructOrientationUp = {0, 0, 0} -- vec3
    o.constructOrientationRight = {0, 0, 0} -- vec3
    o.constructOrientationForward = {0, 0, 0} -- vec3
    o.constructWorldOrientationUp = {0, 0, 0} -- vec3
    o.constructWorldOrientationRight = {0, 0, 0} -- vec3
    o.constructWorldOrientationForward = {0, 0, 0} -- vec3

    return o
end

--- Returns the mass of the construct.
-- @treturn kg The mass of the construct.
function M:getConstructMass()
    return self.constructMass
end

--- Returns the inertial mass of the construct, calculated as 1/3 of the trace of the inertial tensor.
-- @treturn kg*m2 The inertial mass of the construct.
function M:getConstructIMass()
    return self.constructIMass
end

--- Returns the construct's cross sectional surface in the current direction of movement.
-- @treturn m2 The construct's surface exposed in the current direction of movement.
function M:getConstructCrossSection()
    return self.constructCrossSection
end

--- Returns the construct max kinematics parameters in both atmo and space range, in newtons. Kinematics parameters
-- designate here the maximal positive and negative base force the construct is capable of producing along the chosen
-- Axisvector, as defined by the core unit or the gyro unit, if active. In practice, this gives you an estimate of the
-- maximum thrust your ship is capable of producing in space or in atmosphere, as well as the max reverse thrust. These
-- are theoretical estimates and correspond with the addition of the maxThrustBase along the corresponding axis. It
-- might not reflect the accurate current max thrust capacity of your ship, which depends on various local conditions
-- (atmospheric density, orientation, obstruction, engine damage, etc). This is typically used in conjunction with the
-- control unit throttle to setup the desired forward acceleration.
-- @tparam csv taglist Comma (for union) or space (for intersection) separated list of tags. You can set tags directly
-- on the engines in the right-click menu.
-- @tparam vec3 CRefAxis Axis along which to compute the max force (in construct reference).
-- @treturn vec4,Newton The kinematics parameters in the order: atmoRange.FMaxPlus, atmoRange.FMaxMinus,
-- spaceRange.FMaxPlus, spaceRange.FMaxMinus
function M:getMaxKinematicsParametersAlongAxis(taglist, CRefAxis)
    -- TODO implement something to mock this method
end

--- Returns the world position of the construct.
-- @treturn vec3 The xyz world coordinates of the construct core unit position.
function M:getConstructWorldPos()
    return self.constructWorldPos
end

--- Returns the construct unique ID.
-- @treturn int The unique ID. Can be used with database.getConstruct to retrieve info about the construct.
function M:getConstructId()
    return self.constructId
end

--- Returns the acceleration torque generated by air resistance.
-- @treturn vec3 The xyz world acceleration torque generated by air resistance.
function M:getWorldAirFrictionAngularAcceleration()
    return self.worldAirFrictionAngularAcceleration
end

--- Returns the acceleration generated by air resistance.
-- @treturn vec3 The xyz world acceleration generated by air resistance.
function M:getWorldAirFrictionAcceleration()
    return self.worldAirFrictionAcceleration
end

--- Spawns a number sticker in the 3D world, with coordinates relative to the construct.
-- @tparam 0-9 nb The number to display.
-- @tparam meter x The x-coordinate in the construct. 0 = center.
-- @tparam meter y The y-coordinate in the construct. 0 = center.
-- @tparam meter z The z-coordinate in the construct. 0 = center.
-- @tparam string orientation Orientation of the number. Possible values are "front", "side".
-- @treturn int An index that can be used later to delete or move the item. -1 if error or maxnumber reached.
function M:spawnNumberSticker(nb, x, y, z, orientation)
    -- TODO implement something to mock this method
    return -1
end

--- Spawns an arrow sticker in the 3D world, with coordinates relative to the construct.
-- @tparam meter x The x-coordinate in the construct. 0 = center.
-- @tparam meter y The y-coordinate in the construct. 0 = center.
-- @tparam meter z The z-coordinate in the construct. 0 = center.
-- @tparam string orientation Orientation of the number. Possible values are "up", "down", "north", "south", "east",
-- "west".
-- @treturn int An index that can be used later to delete or move the item. -1 if error or maxnumber reached.
function M:spawnArrowSticker(x, y, z, orientation)
    -- TODO implement something to mock this method
    return -1
end

--- Delete the referenced sticker.
-- @tparam int index Index of the sticker to delete.
-- @treturn int 1 in case of success, 0 otherwise.
function M:deleteSticker(index)
    -- TODO implement something to mock this method
    return 0
end

--- Move the referenced sticker.
-- @tparam int index Index of the sticker to move.
-- @tparam meter x The x-coordinate in the construct. 0 = center.
-- @tparam meter y The y-coordinate in the construct. 0 = center.
-- @tparam meter z The z-coordinate in the construct. 0 = center.
-- @treturn int 1 in case of success, 0 otherwise
function M:moveSticker(index, x, y, z)
    -- TODO implement something to mock this method
    return 0
end

--- Rotate the referenced sticker.
-- @tparam int index Index of the sticker to move.
-- @tparam deg angle_x Rotation along the x-axis.
-- @tparam deg angle_y Rotation along the y-axis.
-- @tparam deg angle_z Rotation along the z-axis.
-- @treturn int 1 in case of success, 0 otherwise
function M:rotateSticker(index, angle_x, angle_y, angle_z)
    -- TODO implement something to mock this method
    return 0
end

--- List of all the UIDs of the elements of this construct.
-- @treturn list List of element UIDs.
function M:getElementIdList()
    local ids = {}
    for id,_ in pairs(self.elements) do
        table.insert(ids, id)
    end
    return ids
end

--- Name of the element, identified by its UID.
-- @tparam int uid The UID of the element.
-- @treturn string Name of the element.
function M:getElementNameById(uid)
    if self.elements[uid] and self.elements[uid].name then
        return self.elements[uid].name
    end
    return ""
end

--- Type of the element, identified by its UID.
-- @tparam int uid The UID of the element.
-- @treturn string The type of the element.
function M:getElementTypeById(uid)
    if self.elements[uid] and self.elements[uid].type then
        return self.elements[uid].type
    end
    return ""
end

--- Position of the element, identified by its UID.
-- @tparam int uid The UID of the element.
-- @treturn vec3 The position of the element.
function M:getElementPositionById(uid)
    if self.elements[uid] and self.elements[uid].position then
        return self.elements[uid].position
    end
    return {}
end

--- Current level of hit points of the element, identified by its UID.
-- @tparam int uid The UID of the element.
-- @treturn float Current level of hit points of the element.
function M:getElementHitPointsById(uid)
    if self.elements[uid] and self.elements[uid].hp then
        return self.elements[uid].hp
    end
    return 0.0
end

--- Max level of hit points of the element, identified by its UID.
-- @tparam int uid The UID of the element.
-- @treturn float Max level of hit points of the element.
function M:getElementMaxHitPointsById(uid)
    if self.elements[uid] and self.elements[uid].maxHp then
        return self.elements[uid].maxHp
    end
    return 0.0
end

--- Mass of the element, identified by its UID.
-- @tparam int uid The UID of the element.
-- @treturn float Mass of the element.
function M:getElementMassById(uid)
    if self.elements[uid] and self.elements[uid].mass then
        return self.elements[uid].mass
    end
    return 0.0
end

--- Altitude above sea level, with respect to the closest planet (0 in space).
-- @treturn m The sea level altitude.
function M:getAltitude()
    -- TODO returns 0.0 for space construct
    return self.altitude
end

--- Local gravity intensity.
-- @treturn m/s2 The gravitation acceleration where the construct is located.
function M:g()
    -- TODO returns 0.0 for static and space construct
    return self.g
end

--- Local gravity vector in world coordinates.
-- @treturn m/s2 The local gravity field vector in world coordinates.
function M:getWorldGravity()
    -- TODO returns {0.0, 0.0, 0.0} for static and space construct
    -- sample dynamic value: {1.5739563655308,-9.33176430249,-2.8107843460705}
    return self.worldGravity
end

--- Vertical unit vector along gravity, in world coordinates (0 in space).
-- @treturn m/s2 The local vertical vector in world coordinates.
function M:getWorldVertical()
    -- TODO returns {0.0, 0.0, 0.0} for static and space construct
    -- sample dynamic value: {0.15943373305866,-0.94526001568521, -0.28471808426895}
    return self.worldVertical
end

--- The construct's angular velocity, in construct local coordinates.
-- @treturn rad/s Angular velocity vector, in construct local coordinates.
function M:getAngularVelocity()
    -- TODO returns {0.0, 0.0, 0.0} for static and space construct
    return self.angularVelocity
end

--- The constructs angular velocity, in world coordinates.
-- @treturn rad/s Angular velocity vector, in world coordinates.
function M:getWorldAngularVelocity()
    -- TODO returns {0.0, 0.0, 0.0} for static and space construct
    return self.worldAngularVelocity
end

--- The construct's angular acceleration, in construct local coordinates.
-- @treturn rad/s2 Angular acceleration vector, in construct local coordinates.
function M:getAngularAcceleration()
    -- TODO returns {0.0, 0.0, 0.0} for static and space construct
    return self.angularAcceleration
end

--- The construct's angular acceleration, in world coordinates.
-- @treturn rad/s2 Angular acceleration vector, in world coordinates.
function M:getWorldAngularAcceleration()
    -- TODO returns {0.0, 0.0, 0.0} for static and space construct
    return self.worldAngularAcceleration
end

--- The construct's linear velocity, in construct local coordinates.
-- @treturn m/s Linear velocity vector, in construct local coordinates.
function M:getVelocity()
    return self.velocity
end

--- The construct's linear velocity, in world coordinates.
-- @treturn m/s Linear velocity vector, in world coordinates.
function M:getWorldVelocity()
    return self.worldVelocity
end

--- The construct's linear acceleration, in world coordinates.
-- @treturn m/s2 Linear acceleration vector, in world coordinates.
function M:getWorldAcceleration()
    return self.worldAcceleration
end

--- The construct's linear acceleration, in construct local coordinates.
-- @treturn m/s2 Linear acceleration vector, in construct local coordinates.
function M:getAcceleration()
    return self.acceleration
end

--- The construct's current orientation up vector, in construct local coordinates.
-- @treturn vec3 Up vector of current orientation, in local coordinates.
function M:getConstructOrientationUp()
    return self.constructOrientationUp
end

--- The construct's current orientation right vector, in construct local coordinates.
-- @treturn vec3 Right vector of current orientation, in local coordinates.
function M:getConstructOrientationRight()
    return self.constructOrientationRight
end

--- The construct's current orientation forward vector, in construct local coordinates.
-- @treturn vec3 Forward vector of current orientation, in local coordinates.
function M:getConstructOrientationForward()
    return self.constructOrientationForward
end

--- The construct's current orientation up vector, in world coordinates.
-- @treturn vec3 Up vector of current orientation, in world coordinates.
function M:getConstructWorldOrientationUp()
    return self.constructWorldOrientationUp
end

--- The construct's current orientation right vector, in world coordinates.
-- @treturn vec3 Right vector of current orientation, in world coordinates.
function M:getConstructWorldOrientationRight()
    return self.constructWorldOrientationRight
end

--- The construct's current orientation forward vector, in world coordinates.
-- @treturn vec3 Forward vector of current orientation, in world coordinates.
function M:getConstructWorldOrientationForward()
    return self.constructWorldOrientationForward
end

--- Mock only, not in-game: Bundles the object into a closure so functions can be called with "." instead of ":".
-- @treturn table A table encompasing the api calls of object.
-- @see Element:mockGetClosure
function M:mockGetClosure()
    local closure = MockElement.mockGetClosure(self)
    closure.getConstructMass = function() return self:getConstructMass() end
    closure.getConstructIMass = function() return self:getConstructIMass() end
    closure.getConstructCrossSection = function() return self:getConstructCrossSection() end
    closure.getMaxKinematicsParametersAlongAxis = function(taglist, CRefAxis)
        return self:getMaxKinematicsParametersAlongAxis(taglist, CRefAxis)
    end
    closure.getConstructWorldPos = function() return self:getConstructWorldPos() end
    closure.getConstructId = function() return self:getConstructId() end
    closure.getWorldAirFrictionAngularAcceleration = function() return self:getWorldAirFrictionAngularAcceleration() end
    closure.getWorldAirFrictionAcceleration = function() return self:getWorldAirFrictionAcceleration() end
    closure.spawnNumberSticker = function(nb, x, y, z, orientation)
        return self:spawnNumberSticker(nb, x, y, z, orientation)
    end
    closure.spawnArrowSticker = function(x, y, z, orientation) return self:spawnArrowSticker(x, y, z, orientation) end
    closure.deleteSticker = function(index) return self:deleteSticker(index) end
    closure.moveSticker = function(index, x, y, z) return self:moveSticker(index, x, y, z) end
    closure.rotateSticker = function(index, angle_x, angle_y, angle_z)
        return self:rotateSticker(index, angle_x, angle_y, angle_z)
    end
    closure.getElementIdList = function() return self:getElementIdList() end
    closure.getElementNameById = function(uid) return self:getElementNameById(uid) end
    closure.getElementTypeById = function(uid) return self:getElementTypeById(uid) end
    closure.getElementPositionById = function(uid) return self:getElementPositionById(uid) end
    closure.getElementHitPointsById = function(uid) return self:getElementHitPointsById(uid) end
    closure.getElementMaxHitPointsById = function(uid) return self:getElementMaxHitPointsById(uid) end
    closure.getElementMassById = function(uid) return self:getElementMassById(uid) end
    closure.getAltitude = function() return self:getAltitude() end
    closure.g = function() return self:g() end
    closure.getWorldGravity = function() return self:getWorldGravity() end
    closure.getWorldVertical = function() return self:getWorldVertical() end
    closure.getAngularVelocity = function() return self:getAngularVelocity() end
    closure.getWorldAngularVelocity = function() return self:getWorldAngularVelocity() end
    closure.getAngularAcceleration = function() return self:getAngularAcceleration() end
    closure.getWorldAngularAcceleration = function() return self:getWorldAngularAcceleration() end
    closure.getVelocity = function() return self:getVelocity() end
    closure.getWorldVelocity = function() return self:getWorldVelocity() end
    closure.getWorldAcceleration = function() return self:getWorldAcceleration() end
    closure.getAcceleration = function() return self:getAcceleration() end
    closure.getConstructOrientationUp = function() return self:getConstructOrientationUp() end
    closure.getConstructOrientationRight = function() return self:getConstructOrientationRight() end
    closure.getConstructOrientationForward = function() return self:getConstructOrientationForward() end
    closure.getConstructWorldOrientationUp = function() return self:getConstructWorldOrientationUp() end
    closure.getConstructWorldOrientationRight = function() return self:getConstructWorldOrientationRight() end
    closure.getConstructWorldOrientationForward = function() return self:getConstructWorldOrientationForward() end
    return closure
end

return M