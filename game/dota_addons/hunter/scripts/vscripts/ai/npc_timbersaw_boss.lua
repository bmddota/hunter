local bottom_left = Vector(-7400, -7130, 640)
local top_right = Vector(-5900, -5950, 640)
local center = Vector(-6450, -6610, 640)

local tree_top_left = Vector(-8000, -4880, 768)
local tree_right_bottom = Vector(-4850, -7980, 768)

local tree_top_max = 8000 - 5390
local tree_right_max = 7980 - 5500
local tree_left_max = 7980 - 4800
local tree_bottom_max = 8000 - 4800

--[   PanoramaScript       ]: pos: Vector(-7895.3095703125, -7142.44482421875, 640)
--[   PanoramaScript       ]: pos: Vector(-7146.568359375, -7502.12841796875, 640)

function Spawn()
  print("timbersaw boss spawned")

  Physics:Unit(thisEntity)
  thisEntity:FollowNavMesh(false)
  thisEntity:SetPhysicsFriction(0)

  local NOTHING = 0
  local ATTACKING = 1
  local MOVE_TO_POINT = 2
  local CHAKRAM_SPAM = 3
  local TIMBER_CHAIN = 4

  local chakram_spam_cooldown = 25
  local timber_chain_cooldown = 11

  local state = ATTACKING
  local movePoint = nil
  local nextState = nil

  local aggroTime = nil
  local chakramSpamTime = nil
  local timberChainTime = nil
  local chains = 0

  local inCast = false

  local runningTimers = {}

  thisEntity:AddNewModifier(thisEntity, nil, "modifier_movespeed_cap", {})
  ApplyModifier(thisEntity, thisEntity, "modifier_damage_reduction", {})
  thisEntity:SetModifierStackCount("modifier_damage_reduction", thisEntity, 0)
  local baseMoveSpeed = thisEntity:GetBaseMoveSpeed()
  local hyperMoveSpeed = 900


  --"particle"      "particles/hunter_timbersaw_boss/mini_chakram.vpcf"
  --"particle"      "particles/units/heroes/hero_shredder/shredder_chakram.vpcf"
  --"particle"      "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf"

  function thisEntity:CastTimberChain()
    print('cast timber chain')
    inCast = true

    local chainSpeed = 5000
    local moveSpeed = 4000
    local chainWindUp = .3
    local treePoint = RandomTree(self)
    local dir = treePoint - self:GetAbsOrigin()
    dir.z = 0
    dir = dir:Normalized()

    local delta = RotationDelta(VectorToAngles(self:GetForwardVector()), VectorToAngles(dir)).y
    local qangle = QAngle(0,delta/10,0)

    local len = (treePoint - self:GetAbsOrigin()):Length2D()
    local duration = len / chainSpeed
    local moveDuration = len / moveSpeed 

    StartAnimation(thisEntity, {duration=chainWindUp + duration + moveDuration, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0})
    local count = 0

    table.insert(runningTimers, Timers:CreateTimer(function()
      count = count + 1

      if count >= chainWindUp * 30 then
        self:SetForwardVector(dir)
        FireTimberChain(self, treePoint, chainSpeed, moveSpeed)
        return
      end

      self:SetForwardVector(RotatePosition(Vector(0,0,0), qangle, self:GetForwardVector()))
      return .03
    end))

    table.insert(runningTimers, Timers:CreateTimer(chainWindUp + duration + moveDuration, function()
      inCast = false
      timberChainTime = GameRules:GetGameTime() + timber_chain_cooldown * RandomFloat(.5, 1.5)
      state = MOVE_TO_POINT

      chains = chains - 1
      if chains == 0 then
        nextState = ATTACKING
      else
        nextState = TIMBER_CHAIN
      end
      movePoint = RandomPoint()
    end))
  end

  function thisEntity:CastChakramSpam()
    inCast = true
    print('cast chakram spam')

    local ACT_FRAMES = 6

    local windUp = 1.5
    local startTime = GameRules:GetGameTime()
    local duration = RandomFloat(6, 12)
    local qangle = QAngle(0,6,0)
    if RandomInt(0,1) == 1 then qangle = QAngle(0,-6,0) end

    local count = 0

    StartAnimation(thisEntity, {duration=duration+windUp+1, activity=ACT_DOTA_VICTORY, rate=1.5})

    table.insert(runningTimers, Timers:CreateTimer(windUp, function()
      table.insert(runningTimers, Timers:CreateTimer(function()
        count = count + 1
        if count % 4 == 0 then
          FireChakram(self, RandomVector(1), Vector(RandomFloat(0,255), RandomFloat(0,255), RandomFloat(0,255)), Vector(RandomFloat(0,255), RandomFloat(0,255), RandomFloat(0,255)), false)
        end

        if count % 4 == 0 then
          FireChakram(self, RandomVector(1), Vector(RandomFloat(0,255), RandomFloat(0,255), RandomFloat(0,255)), Vector(RandomFloat(0,255), RandomFloat(0,255), RandomFloat(0,255)), true)
        end

        if GameRules:GetGameTime() - startTime > duration then
          return
        end

        
        self:SetForwardVector(RotatePosition(Vector(0,0,0), qangle, self:GetForwardVector()))
        return .03
      end))

      table.insert(runningTimers, Timers:CreateTimer(duration, function()
        state = ATTACKING 
        chakramSpamTime = GameRules:GetGameTime() + chakram_spam_cooldown * RandomFloat(.5, 1.5)
        inCast = false
      end))
    end))
  end



  function thisEntity:AILeash()
    print('Timbersaw Boss Leash')

    aggroTime = nil
    chakramSpamTime = nil
    timberChainTime = nil
    state = ATTACKING
    nextState = nil
    inCast = false
    chains = 0
    self.encounter.noHurtAggro = false
    self:SetPhysicsVelocity(Vector(0,0,0))
    self:SetBaseMoveSpeed(baseMoveSpeed)

    self:SetModifierStackCount("modifier_damage_reduction", self, 0)

    EndAnimation(self)
    for _,timer in ipairs(runningTimers) do
      Timers:RemoveTimer(timer)
    end

    runningTimers = {}
  end

  function thisEntity:AIThink()
    print('Timbersaw Boss Think', state)
    local time = GameRules:GetGameTime()

    -- run state
    if state == ATTACKING then
      local aggro = self:GetAggroTarget()
      local radius = 2500
      if aggroTime == nil then radius = 600 end

      local units = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

      if #units > 0 then
        local i,unit = next(units)

        self:SetModifierStackCount("modifier_damage_reduction", self, DifficultyFactor(#units-1, 20))

        -- first aggro
        if aggroTime == nil then
          self.encounter.noHurtAggro = true
          aggroTime = time
          chakramSpamTime = aggroTime + chakram_spam_cooldown * RandomFloat(.5, 1.5)
          timberChainTime = aggroTime + timber_chain_cooldown * RandomFloat(.5, 1.5)
        end

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
    elseif state == MOVE_TO_POINT then
      self:MoveToPosition(movePoint)
      self:SetBaseMoveSpeed(hyperMoveSpeed)
    elseif state == CHAKRAM_SPAM then
      if not inCast then
        self:CastChakramSpam()
        self:Stop()
      end
    elseif state == TIMBER_CHAIN then
      if not inCast then
        self:CastTimberChain()
        self:Stop()
      end
    end


    -- new state
    if aggroTime then 
      if state == ATTACKING then
        if time > timberChainTime then
          movePoint = RandomPoint()
          state = MOVE_TO_POINT
          nextState = TIMBER_CHAIN
          chains = RandomInt(1,4)
        elseif time > chakramSpamTime then
          movePoint = center
          state = MOVE_TO_POINT
          nextState = CHAKRAM_SPAM
        end
      elseif state == MOVE_TO_POINT then
        local rad2 = 100 * 100
        if VectorDistanceSq(movePoint, self:GetAbsOrigin()) < rad2 then
          state = nextState
          self:SetBaseMoveSpeed(baseMoveSpeed)
        end
      end
    end
  end
end






function RandomPoint()
  local diff = top_right - bottom_left
  return bottom_left + Vector(RandomFloat(0, diff.x), RandomFloat(0, diff.y), 0)
end

function RandomTree(caster)
  local origin = caster:GetAbsOrigin()
  local top_dist = tree_top_left.y - origin.y
  local right_dist = tree_right_bottom.x - origin.x
  local left_dist = origin.x - tree_top_left.x
  local bottom_dist = origin.y - tree_right_bottom.y

  print(top_dist, right_dist, left_dist, bottom_dist)

  local max = math.max(top_dist, right_dist, left_dist, bottom_dist)

  local point = nil

  if right_dist == max then
    -- right
    point = tree_right_bottom + Vector(0,RandomFloat(0, tree_right_max),0)
  elseif top_dist == max then
    -- top
    point = tree_top_left + Vector(RandomFloat(0, tree_top_max),0,0)
  elseif left_dist == max then
    --left
    point = Vector(tree_top_left.x, tree_right_bottom.y + RandomFloat(0, tree_left_max),0)
  else
    --bottom
    point = Vector(tree_top_left.x + RandomFloat(0, tree_bottom_max), tree_right_bottom.y,0)
  end

  return point
end

function FireTimberChain(caster, treePoint, chainSpeed, moveSpeed)
  local len = (treePoint - caster:GetAbsOrigin()):Length2D()
  local duration = len / chainSpeed
  local moveDuration = len / moveSpeed
  local dir = (treePoint - caster:GetAbsOrigin())
  dir.z = 0
  dir = dir:Normalized()

  local count = 0

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", PATTACH_CUSTOMORIGIN, caster)
  ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(particle, 1, treePoint)
  ParticleManager:SetParticleControl(particle, 2, Vector(chainSpeed,0,0))
  ParticleManager:SetParticleControl(particle, 3, Vector(10,0,0))
  

  local hitUnits = {}

  Timers:CreateTimer(duration, function()
    caster:SetPhysicsVelocity(dir * moveSpeed)
    Timers:CreateTimer(function()
      count = count + 1

      if count >= moveDuration * 30 then
        caster:SetPhysicsVelocity(Vector(0,0,0))
        ParticleManager:DestroyParticle(particle, false)
        return
      end

      local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 250, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

      local nDamageAmount = RandomInt(100,150)

      for _,unit in ipairs(units) do
        if hitUnits[unit:entindex()] == nil then
          ApplyDamage( {
            victim = unit,
            attacker = caster,
            damage = nDamageAmount,
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = nil
          } )

          hitUnits[unit:entindex()] = 1
        end
      end

      return .03
    end)
  end)
end

function FireChakram(caster, dir, color, color2, mini)
  local speed = 500
  local radius = 180
  local effect = "particles/hunter_timbersaw_boss/shredder_chakram.vpcf"
  local expire = 5.0
  local distance = 2500

  if mini then
    speed = 1300
    radius = 100
    effect = "particles/hunter_timbersaw_boss/mini_chakram.vpcf"
  end

  local projectile = {
    EffectName = effect,
    vSpawnOrigin = caster:GetAbsOrigin(), --{unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
    fDistance = distance,
    fStartRadius = radius,
    fEndRadius = radius,
    Source = caster,
    fExpireTime = expire,
    vVelocity = dir * speed,
    UnitBehavior = PROJECTILES_NOTHING,
    bMultipleHits = true,
    bIgnoreSource = true,
    TreeBehavior = PROJECTILES_NOTHING, -- PROJECTILES_DESTROY,
    bCutTrees = false,
    bTreeFullCollision = false,
    WallBehavior = PROJECTILES_NOTHING,
    GroundBehavior = PROJECTILES_NOTHING,
    fGroundOffset = 60,
    nChangeMax = 1,
    bRecreateOnChange = true,
    bZCheck = false,
    bGroundLock = true,
    bProvidesVision = false,
    iVisionRadius = 200,
    iVisionTeamNumber = caster:GetTeam(),
    bFlyingVision = false,
    fVisionTickTime = .1,
    fVisionLingerDuration = .1,
    --draw = true,
    --iPositionCP = 0,
    --iVelocityCP = 1,
    ControlPoints = {[15]=color, [16]=color2},
    --ControlPointForwards = {[4]=caster:GetForwardVector() * -1},
    --ControlPointOrientations = {[1]={caster:GetForwardVector() * -1, caster:GetForwardVector() * -1, caster:GetForwardVector() * -1}},
    --[[ControlPointEntityAttaches = {[0]={
      unit = caster,
      pattach = PATTACH_ABSORIGIN_FOLLOW,
      attachPoint = "attach_attack1", -- nil
      origin = Vector(0,0,0)
    }},]]
    fRehitDelay = .1,
    --fChangeDelay = 1,
    --fRadiusStep = 10,
    --bUseFindUnitsInRadius = false,

    UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() and not unit:IsInvulnerable() end,
    OnUnitHit = function(self, unit) 

      print ('HIT UNIT: ' .. unit:GetUnitName())

      ApplyModifier(caster, unit, "modifier_chakram_slow", {duration=.1})

      local nDamageAmount = 25

      ApplyDamage( {
        victim = unit,
        attacker = caster,
        damage = nDamageAmount,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = nil
      } )
    end,
    --OnTreeHit = function(self, tree) ... end,
    --OnWallHit = function(self, gnvPos) ... end,
    --OnGroundHit = function(self, groundPos) ... end,
    --OnFinish = function(self, pos) ... end,
  }

  Projectiles:CreateProjectile(projectile)
end