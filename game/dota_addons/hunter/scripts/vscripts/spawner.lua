AREA_START = 1
AREA_JUNGLE = 1
AREA_DESERT = 2
AREA_FOREST = 3
AREA_SNOW = 4
AREA_LAKE = 5
AREA_MINE = 6
AREA_CASTLE = 7
AREA_END = 7

require('encounters/guard')
require('encounters/roamer')

local BACKOFF_TIME = 10


local ENCOUNTERS = require('encounters')
local SPAWNTABLE = require('spawnTables')

local AI_Roamer = function(self)
  --print('Roamer AI')
  local units = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, 400, 
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
  if #units > 0 then
    local i,unit = next(units)
    --print(i, unit:GetDebugName())

    if not self.encounter.checkLeash then 
      self.encounter.checkLeash = true
      for _,eunit in ipairs(self.encounter.units) do
        eunit.lastPosition = eunit:GetAbsOrigin() 
        eunit:RemoveModifierByName("modifier_roaming")
        eunit:SetBaseMoveSpeed(eunit.baseMoveSpeed)
        eunit:MoveToTargetToAttack(unit)
      end
      return true
    else
      local aggro = self:GetAggroTarget()
      if aggro then
        local origin = self:GetAbsOrigin()
        local aggroDist = (origin - aggro:GetAbsOrigin()):Length2D()
        local unitDist = (origin - unit:GetAbsOrigin()):Length2D()
        if aggroDist > unitDist + 100 then
          self:MoveToTargetToAttack(unit)
        end
      else
        self:MoveToTargetToAttack(unit)
      end
    end
  elseif self.encounter.checkLeash and self:IsIdle() and GameRules:GetGameTime() > self:GetLastIdleChangeTime() + self.encounter.awakeStickiness then
    self.encounter:Leash()
  end
end

local AI_Guard = function(self)
  --print('Guard AI')
  local units = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, 400, 
    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
    DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

  if #units > 0 then
    local i,unit = next(units)

    local aggro = self:GetAggroTarget()
    if aggro == nil then 
      self.encounter.checkLeash = true
      for _,eunit in ipairs(self.encounter.units) do
        eunit:MoveToTargetToAttack(unit)
      end
      return true
    else
      local origin = self:GetAbsOrigin()
      local aggroDist = (origin - aggro:GetAbsOrigin()):Length2D()
      local unitDist = (origin - unit:GetAbsOrigin()):Length2D()
      if aggroDist > unitDist + 100 then
        self:MoveToTargetToAttack(unit)
      end
    end
  elseif self.encounter.checkLeash and self:IsIdle() and GameRules:GetGameTime() > self:GetLastIdleChangeTime() + self.encounter.awakeStickiness then
    self.encounter:Leash()
  end
end




if Spawner == nil then
  Spawner = class({})
  Spawner.AI_Roamer = AI_Roamer
  Spawner.AI_Guard = AI_Guard
end

function Spawner:Initialize()
  local dist = 400

  if self.encounters then
    for enc,_ in pairs(self.encounters) do
      enc:Destroy()
      for _,u in ipairs(enc.units) do
        if u and IsValidEntity(u) then u:RemoveSelf() end
      end
    end
  end

  if self.timers then
    for timer,_ in pairs(self.timers) do
      Timers:RemoveTimer(timer)
    end
  end

  self.camps = {}
  self.timers = {}
  self.encounters = {}
  self.campCount = {}

  local camps = Entities:FindAllByName("guard_camp")
  for _,camp in ipairs(camps) do 
    camp.spawnTime = 0
    local area = camp:Attribute_GetIntValue("area", -1)
    if self.camps[area] == nil then self.camps[area] = {} end
    if self.campCount[area] == nil then self.campCount[area] = 0 end
    self.camps[area][camp:entindex()] = camp
    self.campCount[area] = self.campCount[area] + SPAWNTABLE.campCount[area]
  end



  for v,num in pairs(SPAWNTABLE.pathCount) do
    for i=1,num do
      Spawner:SpawnRoamer(v)
    end
  end


  for i=AREA_START,AREA_END do
    print('campcount',i,self.campCount[i])
    if self.campCount[i] ~= nil then
      local count = math.floor(self.campCount[i])

      for j=1,count do
        Spawner:SpawnCamp(i)
      end
    end
  end

  Spawner:SpawnBoss(AREA_DESERT)
  Spawner:SpawnBoss(AREA_FOREST)
  Spawner:SpawnBoss(AREA_SNOW)
  Spawner:SpawnBoss(AREA_MINE)
end

function Spawner:DestroyEncounter(encounter)
  self.encounters[encounter] = nil
  if encounter.boss then
    return
  end

  if encounter.camp then
    local area = encounter.camp:Attribute_GetIntValue("area", -1)
    self.camps[area][encounter.camp:entindex()] = encounter.camp
    encounter.camp.spawnTime = GameRules:GetGameTime() + 15

    if encounter.respawn then
      local respawn = encounter.respawnTime or 60
      local timer = Timers:CreateTimer(respawn, function()
        print("SpawnCamp respawning")
        Spawner:SpawnCamp(encounter.camp)
      end)
      self.timers[timer] = 1
    end
  elseif encounter.initialCorner then
    if encounter.respawn then
      local respawn = encounter.respawnTime or 60
      local timer = Timers:CreateTimer(respawn, function()
        print("SpawnRoamer respawning")
        Spawner:SpawnRoamer(encounter.initialCorner)
      end)
      self.timers[timer] = 1
    end
  end
end

function Spawner:SpawnBoss(area)
  if type(area) ~= "number" then area = campOrArea:Attribute_GetIntValue("area", -1) end

  local camp = nil
  local camps = Entities:FindAllByName("boss_camp")
  local found = false
  for _,bosscamp in ipairs(camps) do
    if bosscamp:Attribute_GetIntValue("area", -1) == area then
      found = true
      camp = bosscamp
      break
    end
  end

  if not found then
    print("Spawner: Unable to find boss_camp for area: " .. area)
    return
  end

  local encs = SPAWNTABLE.bosses[area]

  if #encs == 0 then return end

  local e = ENCOUNTERS[encs[RandomInt(1, #encs)].name]

  local pos = camp:GetAbsOrigin()
  local forward = camp:GetForwardVector()

  local units = e.units
  if type(units) == "function" then
    units = units()
  end

  local uu = {}
  for _,unit in ipairs(units) do
    local offset = unit.offset or Vector(0,0,0)
    if offset ~= Vector(0,0,0) then
      offset = RotatePosition(Vector(0,0,0), QAngle(0,RotationDelta(VectorToAngles(Vector(0,1,0)), VectorToAngles(forward)).y,0), offset)
    end
    local u = CreateUnitByName(unit.name, pos + offset, true, nil, nil, DOTA_TEAM_NEUTRALS)
    if unit.facing then
      u:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,RotationDelta(VectorToAngles(Vector(0,1,0)), VectorToAngles(forward)).y,0), unit.facing))
    else
      u:SetForwardVector(forward)
    end

    Timers:CreateTimer(.1, function()
      u:SetAbsOrigin(camp:GetAbsOrigin())
    end)

    --u.AIThink = AI_Guard
    table.insert(uu, u)
  end
  local enc = GuardEncounter(uu, camp, e.leashRange)
  enc.thinkDelay = e.thinkDelay or enc.thinkDelay
  enc.awakeStickiness = e.awakeStickiness or 15
  enc.respawn = false
  enc.respawnTime = 0
  enc.boss = true

  self.encounters[enc] = 1
end

function Spawner:SpawnCamp(campOrArea)
  local area = campOrArea
  if type(area) ~= "number" then area = campOrArea:Attribute_GetIntValue("area", -1) end

  local camp = nil
  local camps = {}
  for index,cc in pairs(self.camps[area]) do
    table.insert(camps, cc)
  end

  while #camps > 0 do
    local temp = table.remove(camps, RandomInt(1, #camps))
    if temp.spawnTime == nil or GameRules:GetGameTime() > temp.spawnTime then
      local heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, temp:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      if #heroes == 0 then
        camp = temp
        break
      end
      print("SpawnCamp, heroes near spawn", #heroes, ", skipping.")
    end
  end

  if camp == nil then
    -- no space found
    print("SpawnCamp, no space found, backing off")
    local timer = nil
    timer = Timers:CreateTimer(BACKOFF_TIME, function()
      print("SpawnCamp, backoff")
      Spawner.timers[timer] = nil
      Spawner:SpawnCamp(campOrArea)
    end)
    self.timers[timer] = 1
    return
  end

  local encs = SPAWNTABLE.camps[area]

  if #encs == 0 then return end

  local e = ENCOUNTERS[encs[RandomInt(1, #encs)].name]

  local pos = camp:GetAbsOrigin()
  local forward = camp:GetForwardVector()

  local units = e.units
  if type(units) == "function" then
    units = units()
  end

  local uu = {}
  for _,unit in ipairs(units) do
    local offset = unit.offset or Vector(0,0,0)
    if offset ~= Vector(0,0,0) then
      offset = RotatePosition(Vector(0,0,0), QAngle(0,RotationDelta(VectorToAngles(Vector(0,1,0)), VectorToAngles(forward)).y,0), offset)
    end
    local u = CreateUnitByName(unit.name, pos + offset, true, nil, nil, DOTA_TEAM_NEUTRALS)
    if unit.facing then
      u:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,RotationDelta(VectorToAngles(Vector(0,1,0)), VectorToAngles(forward)).y,0), unit.facing))
    else
      u:SetForwardVector(forward)
    end

    u.AIThink = AI_Guard
    table.insert(uu, u)
  end
  local enc = GuardEncounter(uu, camp, e.leashRange)
  enc.thinkDelay = e.thinkDelay or enc.thinkDelay
  enc.respawn = e.respawn or true
  enc.respawnTime = e.respawnTime or 60

  self.camps[area][camp:entindex()] = nil
  self.encounters[enc] = 1
end

function Spawner:SpawnRoamer(path)
  if type(path) ~= "string" then
    local pathName = path:GetName()
    local m1 = string.match(pathName, "^(.*[^%d])%d+$")
    path = m1
  end

  local corners = Entities:FindAllByName(path .. "*")
  local corner = nil
  while #corners > 0 do
    local temp = table.remove(corners, RandomInt(1, #corners))
    local heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, temp:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #heroes == 0 then
      corner = temp
      break
    end
    print("SpawnRoamer, heroes near spawn", #heroes, ", skipping.")
  end

  if corner == nil then
    -- no space found
    print("SpawnRoamer, no space found, backing off")
    local timer = nil
    timer = Timers:CreateTimer(BACKOFF_TIME, function()
      print("SpawnRoamer, backoff")
      Spawner.timers[timer] = nil
      Spawner:SpawnRoamer(path)
    end)
    self.timers[timer] = 1
    return
  end

  local pos = corner:GetAbsOrigin() + Vector(0,-10,0)

  local area = SPAWNTABLE.pathToArea[path]
  local encs = SPAWNTABLE.roamers[area]

  if #encs == 0 then return end

  local e = ENCOUNTERS[encs[RandomInt(1, #encs)].name]

  local units = e.units
  if type(units) == "function" then
    units = units()
  end

  local uu = {}
  for _,unit in ipairs(units) do
    local u = CreateUnitByName(unit.name, pos + (unit.offset or Vector(0,0,0)), true, nil, nil, DOTA_TEAM_NEUTRALS)
    u:SetForwardVector(unit.facing or Vector(0,1,0))
    u.AIThink = AI_Roamer
    table.insert(uu, u)
  end
  --local enc = RoamerEncounter({u1, u2, u3}, corner, {type=RoamerEncounter.RANDOM, startChance=.1, stopChance=.25}, 1000)
  local enc = RoamerEncounter(uu, corner, e.pathingType, e.leashRange)
  enc.thinkDelay = e.thinkDelay or enc.thinkDelay
  enc.respawn = e.respawn or true
  enc.respawnTime = e.respawnTime or 60

  self.encounters[enc] = 1
end