require('encounters/base')

GuardEncounter = class({}, nil, Encounter)--class({},nil,Encounter)

GuardEncounter.IDLE = 1
GuardEncounter.MOVING = 2
GuardEncounter.LEASHING = 3

GuardEncounter.thinkDelay = 1
GuardEncounter.awakeStickiness = 2.0

GuardEncounter.state = GuardEncounter.IDLE
GuardEncounter.leashRange = 1000
GuardEncounter.leashCheckRadius = 50
GuardEncounter.noHurtAggro = false


function GuardEncounter:constructor(units, camp, leashRange)
  --print('GE constructor2')
  --print(self)
  --PrintTable(self)
  --PrintTable(getmetatable(self))
  self.__base__.constructor(self, units, false)

  for _,unit in ipairs(units) do
    unit.initialPosition = unit:GetAbsOrigin()
    unit.initialFacing = unit:GetForwardVector()
    unit:SetIdleAcquire(false)
    unit:SetAcquisitionRange(0)
  end

  self.checkLeash = false
  self.camp = camp
  self.leashRange = leashRange or 1000
  self.state = self.IDLE
end

function GuardEncounter:Awake()
  print('GE awake', self.state)
end

function GuardEncounter:Sleep()
  print('GE sleeping', self.state)
  if self.state ~= self.LEASHING and self.checkLeash then
    self:Leash()
    self.state = self.IDLE
    for _,unit in ipairs(self.units) do
      if unit:HasModifier("modifier_leashing") then
        unit:RemoveModifierByName("modifier_leashing")
        unit:SetHealth(unit:GetMaxHealth())
      end
    end
  end
end

function GuardEncounter:OnHurt(unit, damager, damagingAbility)
  if unit:GetTeam() == damager:GetTeam() or self.state == self.LEASHING or self.noHurtAggro then return end

  local aggro = unit:GetAggroTarget()
  if aggro ~= nil then return end

  self.checkLeash = true
  for _,eunit in ipairs(self.units) do
    aggro = eunit:GetAggroTarget()
    if aggro == nil then 
      eunit:MoveToTargetToAttack(damager)
    end
  end
end

function GuardEncounter:Think()
  --print('GE thinking', self.state)
  if self.state == self.LEASHING then
    local done = true
    local rad2 = self.leashCheckRadius * self.leashCheckRadius
    for _,unit in ipairs(self.units) do
      if VectorDistanceSq(unit:GetAbsOrigin(), unit.initialPosition) > rad2 then
        done = false
        break
      end
    end

    if done then
      self.state = self.IDLE
      for _,unit in ipairs(self.units) do
        unit:RemoveModifierByName("modifier_leashing")
        unit:SetHealth(unit:GetMaxHealth())
      end
    else
      self:Leash()
    end
  end

  if self.state == self.IDLE then
    if self.checkLeash then
      local rad2 = self.leashRange * self.leashRange
      for _,unit in ipairs(self.units) do
        if VectorDistanceSq(unit:GetAbsOrigin(), unit.initialPosition) > rad2 then
          self:Leash()
          return
        end
      end
    end

    for _,unit in ipairs(self.units) do 
      local result
      if unit.AIThink then 
        local status = nil
        status, result = pcall(unit.AIThink, unit)
        if not status then
          print('[GuardEncounter] AIThink Failure!: ' .. result)
          result = nil
        end
      end

      if result or self.state == self.LEASHING then break end
    end

  elseif self.state == self.MOVING then

  end
end

function GuardEncounter:Leash()
  print('GE leash', self.state)
  self.state = self.LEASHING
  for _,unit in ipairs(self.units) do
    ExecuteOrderFromTable({
      UnitIndex = unit:entindex(),
      OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
      Position = unit.initialPosition - 2*unit.initialFacing,
      Queue = 0,
      })

    ExecuteOrderFromTable({
      UnitIndex = unit:entindex(),
      OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
      Position = unit.initialPosition,
      Queue = 1,
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
        print('[GuardEncounter] AILeash Failure!: ' .. result)
        result = nil
      end

      if result then break end
    end
  end
end