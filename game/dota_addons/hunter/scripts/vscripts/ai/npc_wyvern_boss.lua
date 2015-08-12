function Spawn()
  print("wyvern boss spawned")

  local NOTHING = 0
  local ATTACKING = 1
  local ICE_BREATH = 2
  local ICE_RAIN_MOVE = 3
  local ICE_RAIN_CAST = 4

  local ice_breath_cooldown = 20
  local ice_rain_cooldown = 35

  local state = ATTACKING
  local aggroTime = nil
  local iceBreathTime = nil
  local iceRainTime = nil

  ApplyModifier(thisEntity, thisEntity, "modifier_damage_reduction", {})
  thisEntity:SetModifierStackCount("modifier_damage_reduction", thisEntity, 0)

  local breaths = 0
  local inCast = false

  local runningTimers = {}

  function thisEntity:CastIceBreath()
    inCast = true
    print('cast breath', breaths)

    local ACT_FRAMES = 44
    local BREATH_FRAME = 10

    local startTime = GameRules:GetGameTime()
    local units = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, 1500, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

    if #units == 0 then
      breaths = breaths - 1
      if breaths == 0 then 
        state = ATTACKING 
        iceBreathTime = GameRules:GetGameTime() + ice_breath_cooldown * RandomFloat(.5, 1.5)
      end
      inCast = false
      return
    end

    local target = units[RandomInt(1, #units)]

    StartAnimation(thisEntity, {duration=3, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.0, translate="injured"})

    table.insert(runningTimers, Timers:CreateTimer(function()
      local dir = target:GetAbsOrigin() - self:GetAbsOrigin()
      dir.z = 0
      dir = dir:Normalized()

      if GameRules:GetGameTime() - startTime > BREATH_FRAME/30 then
        --cast
        FireIceShard(self, dir)
        return
      end

      
      self:SetForwardVector(dir)
      return .03
    end))

    table.insert(runningTimers, Timers:CreateTimer(1, function()
      breaths = breaths - 1
      if breaths == 0 then 
        state = ATTACKING 
        iceBreathTime = GameRules:GetGameTime() + ice_breath_cooldown * RandomFloat(.5, 1.5)
      end
      inCast = false
    end))
  end

  function thisEntity:CastIceRain()
    inCast = true
    print('cast ice rain')

    local ACT_FRAMES = 44
    local BREATH_FRAME = 10

    local startTime = GameRules:GetGameTime()
    local duration = RandomFloat(6, 12)
    local qangle = QAngle(0,6,0)
    if RandomInt(0,1) == 1 then qangle = QAngle(0,-6,0) end

    local count = 0

    StartAnimation(thisEntity, {duration=duration+1, activity=ACT_DOTA_CAST_ABILITY_3, rate=.5})

    table.insert(runningTimers, Timers:CreateTimer(function()
      count = (count + 1) % 2
      if count == 0 then
        FireIceRain(self)
      end

      if GameRules:GetGameTime() - startTime > duration then
        return
      end

      
      self:SetForwardVector(RotatePosition(Vector(0,0,0), qangle, self:GetForwardVector()))
      return .03
    end))

    table.insert(runningTimers, Timers:CreateTimer(duration, function()
      state = ATTACKING 
      iceRainTime = GameRules:GetGameTime() + ice_rain_cooldown * RandomFloat(.5, 1.5)
      inCast = false
    end))
  end



  function thisEntity:AILeash()
    print('Wyvern Boss Leash')

    aggroTime = nil
    iceBreathTime = nil
    iceRainTime = nil
    state = ATTACKING
    inCast = false
    breaths = 0
    self.encounter.noHurtAggro = false

    thisEntity:SetModifierStackCount("modifier_damage_reduction", thisEntity, 0)

    EndAnimation(self)
    for _,timer in ipairs(runningTimers) do
      Timers:RemoveTimer(timer)
    end

    runningTimers = {}
  end

  function thisEntity:AIThink()
    print('Wyvern Boss Think', state)
    local time = GameRules:GetGameTime()

    -- run state
    if state == ATTACKING then
      local aggro = self:GetAggroTarget()
      local radius = 1500
      if aggro == nil then radius = 800 end

      local units = FindUnitsInRadius(self:GetTeam(), self:GetAbsOrigin(), nil, radius, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

      if #units > 0 then
        local i,unit = next(units)

        self:SetModifierStackCount("modifier_damage_reduction", self, DifficultyFactor(#units-1, 20))

        -- first aggro
        if aggroTime == nil then
          self.encounter.noHurtAggro = true
          aggroTime = time
          iceBreathTime = aggroTime + ice_breath_cooldown * RandomFloat(.5, 1.5)
          iceRainTime = aggroTime + ice_rain_cooldown * RandomFloat(.5, 1.5)
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
    elseif state == ICE_BREATH then
      if not inCast then
        self:Stop()
        self:CastIceBreath()
      end
    elseif state == ICE_RAIN_MOVE then
      self:MoveToPosition(self.initialPosition)
    elseif state == ICE_RAIN_CAST then
      if not inCast then
        self:CastIceRain()
        self:Stop()
      end
    end


    -- new state
    if aggroTime then 
      if state == ATTACKING then
        if time > iceRainTime then
          state = ICE_RAIN_MOVE
        elseif time > iceBreathTime then
          state = ICE_BREATH
          breaths = RandomInt(4,10)
        end
      elseif state == ICE_RAIN_MOVE then
        local rad2 = 100 * 100
        if VectorDistanceSq(self.initialPosition, self:GetAbsOrigin()) < rad2 then
          state = ICE_RAIN_CAST
          self:MoveToPosition(self.initialPosition + self.initialFacing * 10)
        end
      end
    end
  end
end

function FireIceRain(caster)
  local pos = Vector(0,0,0)

  while math.abs(pos.z - caster.initialPosition.z) > 5 do
    pos = caster.initialPosition + RandomVector(RandomFloat(0,2000))
  end

  local particle = ParticleManager:CreateParticle("particles/hunter_wyvern_boss/ice_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(particle, 0, pos)
  ParticleManager:SetParticleControl(particle, 1, pos + Vector(0,0,700))
  ParticleManager:ReleaseParticleIndex(particle)

  Timers:CreateTimer(.8, function()
    local units = FindUnitsInRadius(caster:GetTeam(), pos, nil, 200, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

      local nDamageAmount = RandomInt(80,120)

      for _,unit in ipairs(units) do
        ApplyDamage( {
          victim = unit,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PURE,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = nil
        } )
      end
  end)
end

function FireIceShard(caster, dir)
  local projectile = {
    EffectName = "particles/units/heroes/hero_tusk/tusk_ice_shards_projectile.vpcf",
    vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
    fDistance = 1500,
    fStartRadius = 150,
    fEndRadius = 150,
    Source = caster,
    fExpireTime = 8.0,
    vVelocity = dir * 1250,
    UnitBehavior = PROJECTILES_DESTROY,
    bMultipleHits = false,
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
    --ControlPoints = {[5]=Vector(100,0,0), [10]=Vector(0,0,1)},
    --ControlPointForwards = {[4]=caster:GetForwardVector() * -1},
    --ControlPointOrientations = {[1]={caster:GetForwardVector() * -1, caster:GetForwardVector() * -1, caster:GetForwardVector() * -1}},
    --[[ControlPointEntityAttaches = {[0]={
      unit = caster,
      pattach = PATTACH_ABSORIGIN_FOLLOW,
      attachPoint = "attach_attack1", -- nil
      origin = Vector(0,0,0)
    }},]]
    --fRehitDelay = .3,
    --fChangeDelay = 1,
    --fRadiusStep = 10,
    --bUseFindUnitsInRadius = false,

    UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() and not unit:IsInvulnerable() end,
    OnUnitHit = function(self, unit) 

      print ('HIT UNIT: ' .. unit:GetUnitName())

      local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_ice_shards_base.vpcf", PATTACH_WORLDORIGIN, nil)
      ParticleManager:SetParticleControl(particle, 0, self.pos)
      ParticleManager:SetParticleControl(particle, 1, self.pos)
      ParticleManager:ReleaseParticleIndex(particle)

      local units = FindUnitsInRadius(caster:GetTeam(), self.pos, nil, 200, 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, 
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

      local nDamageAmount = RandomInt(80,120)

      for _,unit in ipairs(units) do
        ApplyDamage( {
          victim = unit,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PURE,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = nil
        } )
      end
    end,
    --OnTreeHit = function(self, tree) ... end,
    --OnWallHit = function(self, gnvPos) ... end,
    --OnGroundHit = function(self, groundPos) ... end,
    --OnFinish = function(self, pos) ... end,
  }

  Projectiles:CreateProjectile(projectile)
end