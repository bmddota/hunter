Encounter = class({})

Encounter.units = {}
Encounter.awake = false
Encounter.destroyed = false
Encounter.awakeStickiness = 3.0
Encounter.awakeTime = 0
Encounter.thinkTimer = nil
Encounter.thinkDelay = 1
Encounter.alwaysThink = false

function Encounter:constructor(units, alwaysThink)
  --print('E constructor2')
  --print(self)
  --PrintTable(self)
  --PrintTable(getmetatable(self))
  self.units = units
  if alwaysThink then 
    self.alwaysThink = alwaysThink 
    self.thinkTimer = Timers:CreateTimer(self._Think, self)
  end

  for _,unit in ipairs(units) do
    unit.encounter = self
  end
end

function Encounter:OnDeath(unit, killer, killingAbility)
  for i,v in ipairs(self.units) do
    if v == unit then 
      table.remove(self.units, i)
      break 
    end
  end

  if #self.units == 0 then
    self:OnComplete()
    self:Destroy()
  end
end

function Encounter:OnHurt(unit, damager, damagingAbility)
  
end

function Encounter:OnComplete()

end

function Encounter:Awake()

end

function Encounter:Sleep()

end

function Encounter:Think()

end

function Encounter:Destroy()
  if self.destroyed then return end 
  self.destroyed = true
  for _,unit in ipairs(self.units) do
    if unit.EncounterDestroy then unit:EncounterDestroy() end
    unit.encounter = nil
  end
  if self.thinkTimer then Timers:RemoveTimer(self.thinkTimer) end
  if Spawner and Spawner.DestroyEncounter then Spawner:DestroyEncounter(self) end
end

function Encounter:WakeUp()
  if not self.destroyed and not self.awake then
    self.awake = true
    if not self.alwaysThink then self.thinkTimer = Timers:CreateTimer(self._Think, self) end
    self:Awake()
  end

  self.awakeTime = GameRules:GetGameTime() + self.awakeStickiness
end

function Encounter:_Sleep()
  --print('E sleep')
  --PrintTable(self)
  if self.awake then
    self.awake = false
    self:Sleep()
  end
end

function Encounter:_Think()
  --print('E thinking')
  --PrintTable(self)

  if GameRules:GetGameTime() > self.awakeTime then
    self:_Sleep()
    if not self.alwaysThink then return end
  end

  self:Think()

  return self.thinkDelay
end