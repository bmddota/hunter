require('encounters/base')

RoamerEncounter = class({}, nil, Encounter)--class({},nil,Encounter)

RoamerEncounter.IDLE = 1
RoamerEncounter.MOVING = 2
RoamerEncounter.LEASHING = 3

RoamerEncounter.FORWARD = 1
RoamerEncounter.RANDOM = 2

RoamerEncounter.thinkDelay = .5
RoamerEncounter.awakeStickiness = 2.0

RoamerEncounter.state = RoamerEncounter.IDLE
RoamerEncounter.leashRange = 1000
RoamerEncounter.reachRange = 175
RoamerEncounter.leashCheckRadius = 50
RoamerEncounter.noHurtAggro = false

function RoamerEncounter:constructor(units, initialCorner, pathingType, leashRange)
  --print('RE constructor2')
  self.__base__.constructor(self, units, true)

  self.pathingType = pathingType or {}
  self.pathingType.type = self.pathingType.type or RoamerEncounter.FORWARD
  self.pathingType.stopChance = self.pathingType.stopChance or 0
  self.pathingType.startChance = self.pathingType.startChance or 0
  self.pathingType.roamingSpeed = self.pathingType.roamingSpeed or 200

  self.initialCorner = initialCorner
  self.nextCorner = initialCorner
  self.leashRange = leashRange or 1000
  self.state = self.MOVING

  self.lastCorner = initialCorner

  self.initialDirection = nil
  self.checkLeash = false
  self.queueMove = 1
  local offset = nil

  for _,unit in ipairs(units) do
    local origin = unit:GetAbsOrigin()
    if offset == nil then 
      offset = origin
      self.initialDirection = self.nextCorner:GetAbsOrigin() - origin
      self.initialDirection.z = 0
      self.initialDirection = self.initialDirection:Normalized()
    end

    unit.formationOffset = offset - origin
    unit.formationOffset.z = 0
    unit.lastPosition = nil
    unit.baseMoveSpeed = unit:GetBaseMoveSpeed()

    unit.nextPosition = self.nextCorner:GetAbsOrigin() + unit.formationOffset
    
    ExecuteOrderFromTable({
      UnitIndex = unit:entindex(),
      OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
      Position = unit.nextPosition,
      Queue = 1,
      })

    unit:SetIdleAcquire(false)
    unit:SetAcquisitionRange(0)

    --DebugDrawCircle(unit.nextPosition, Vector(255,0,0), 50, 25, true, 2)
  end  
end

function RoamerEncounter:RotateFormation(offset, direction)
  if offset == Vector(0,0,0) then return offset end
  if direction == Vector(0,0,0) then direction = self.initialDirection end
  direction.z = 0

  return -1 * RotatePosition(Vector(0,0,0), QAngle(0,RotationDelta(VectorToAngles(self.initialDirection), VectorToAngles(direction)).y,0), offset)
end

function RoamerEncounter:MoveQueue(unit)
  local nextCorner = self.nextCorner:GetAbsOrigin()
  local lastCorner = self.lastCorner:GetAbsOrigin()
  --local queueCorner = self.queueCorner:GetAbsOrigin()

  unit.nextPosition = nextCorner + self:RotateFormation(unit.formationOffset, (nextCorner - lastCorner))
  --unit.queuePosition = queueCorner + self:RotateFormation(unit.formationOffset, (queueCorner - nextCorner))

  --DebugDrawCircle(unit.nextPosition, Vector(255,0,0), 50, 25, true, 2)

  ExecuteOrderFromTable({
    UnitIndex = unit:entindex(),
    OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
    Position = unit.nextPosition,
    Queue = self.queueMove,
    })

  --self.queueMove = 0

  unit:SetIdleAcquire(false)
  unit:SetAcquisitionRange(0)
  ApplyModifier(unit, unit, "modifier_roaming", {})
  unit:SetBaseMoveSpeed(self.pathingType.roamingSpeed)

  --DebugDrawCircle(unit.queuePosition, Vector(0,255,0), 50, 25, true, 5)

  --[[ExecuteOrderFromTable({
    UnitIndex = unit:entindex(),
    OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
    Position = unit.queuePosition,
    Queue = 1,
    })]]
end

function RoamerEncounter:PickNextCorner(corner)
  if self.pathingType.type == RoamerEncounter.FORWARD then
    local nextCorner = RandomFromTable(corner.edges, self.lastCorner)
    return nextCorner or self.lastCorner
  elseif self.pathingType.type == RoamerEncounter.RANDOM then
    return RandomFromTable(corner.edges)
  end
end

function RoamerEncounter:Awake()
  print('RE awake', self.state)
end

function RoamerEncounter:Sleep()
  print('RE sleeping', self.state)
  if self.checkLeash then
    self:Leash()
  else
    self.state = self.MOVING
    for _,unit in ipairs(self.units) do
      unit.lastPosition = nil
      if unit:HasModifier("modifier_leashing") then
        unit:RemoveModifierByName("modifier_leashing")
        unit:SetHealth(unit:GetMaxHealth())
      end
      self:MoveQueue(unit)
    end
  end
end

function RoamerEncounter:OnHurt(unit, damager, damagingAbility)
  if unit:GetTeam() == damager:GetTeam() or self.state == self.LEASHING or self.noHurtAggro then return end

  local aggro = unit:GetAggroTarget()
  if aggro ~= nil then return end

  self.checkLeash = true
  for _,eunit in ipairs(self.units) do
    aggro = eunit:GetAggroTarget()
    if aggro == nil then 
      if eunit.lastPosition == nil then eunit.lastPosition = eunit:GetAbsOrigin() end
      eunit:RemoveModifierByName("modifier_roaming")
      eunit:SetBaseMoveSpeed(eunit.baseMoveSpeed)
      eunit:MoveToTargetToAttack(damager)
    end
  end
end

function RoamerEncounter:Think()
  --print('RE thinking', self.state)

  if self.state == self.LEASHING then
    local done = true
    local rad2 = self.leashCheckRadius * self.leashCheckRadius
    for _,unit in ipairs(self.units) do
      --DebugDrawCircle(unit.lastPosition, Vector(0,0,255), 50, 25, true, 1)
      if VectorDistanceSq(unit:GetAbsOrigin(), unit.lastPosition) > rad2 then
        done = false
        break
      end
    end

    if done then
      self.state = self.MOVING
      for _,unit in ipairs(self.units) do
        unit.lastPosition = nil
        unit:RemoveModifierByName("modifier_leashing")
        unit:SetHealth(unit:GetMaxHealth())
        self:MoveQueue(unit)
      end
    else
      self:Leash()
    end
  end

  if self.checkLeash then
    local leash2 = self.leashRange * self.leashRange
    for _,unit in ipairs(self.units) do
      if unit.lastPosition and VectorDistanceSq(unit:GetAbsOrigin(), unit.lastPosition) > leash2 then
        self:Leash()
        return
      end
    end
  end

  if self.state == self.IDLE then
    if RandomFloat(0,1) < self.pathingType.startChance then
      local temp = self.nextCorner
      self.nextCorner = self:PickNextCorner(self.nextCorner)
      self.lastCorner = temp

      for _,unit in ipairs(self.units) do
        self:MoveQueue(unit)
      end

      self.state = self.MOVING
      return
    end

    if self.awake then
      for _,unit in ipairs(self.units) do 
        if unit.AIThink then unit:AIThink() end
      end
    end
  end

  if self.state == self.MOVING then
    local rad2 = self.reachRange * self.reachRange
    local reached = true

    for _,unit in ipairs(self.units) do
      if VectorDistanceSq(unit:GetAbsOrigin(), unit.nextPosition) > rad2 then
        reached = false
      end
    end

    if reached then
      if RandomFloat(0,1) < self.pathingType.stopChance then
        self.state = self.IDLE
        return
      end

      local temp = self.nextCorner
      self.nextCorner = self:PickNextCorner(self.nextCorner)
      self.lastCorner = temp

      for _,unit in ipairs(self.units) do
        self:MoveQueue(unit)
      end
    elseif self.awake then
      for _,unit in ipairs(self.units) do 
        local result
        if unit.AIThink then 
          local status = nil
          status, result = pcall(unit.AIThink, unit)
          if not status then
            print('[RoamerEncounter] AIThink Failure!: ' .. result)
            result = nil
          end
        end

        if result or self.state == self.LEASHING then break end
      end
    end
  end
end

function RoamerEncounter:Leash()
  --print('RE leash', self.state)
  self.state = self.LEASHING
  for _,unit in ipairs(self.units) do
    ExecuteOrderFromTable({
      UnitIndex = unit:entindex(),
      OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
      Position = unit.lastPosition,
      Queue = 0,
      })

    unit:SetIdleAcquire(false)
    unit:SetAcquisitionRange(0)
    self.checkLeash = false
    ApplyModifier(unit, unit, "modifier_leashing", {})
  end

  for _,unit in ipairs(self.units) do 
    if unit.AILeash then
      local status = nil
      local result = nil
      status, result = pcall(unit.AILeash, unit)
      if not status then
        print('[RoamerEncounter] AILeash Failure!: ' .. result)
        result = nil
      end

      if result then break end
    end
  end
end