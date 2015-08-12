function OnSpellStart(keys)
  print('ranger_backflip, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  
  local ACT_FRAMES = 19
  local duration = 0.8
  local forward_pitch = 0
  local arrow_distance = 1200
  local arrow_speed = 2300


  local forward = caster:GetForwardVector()
  forward.z = 0
  forward = forward:Normalized()

  local angles = caster:GetAngles()
  angles.x = 0
  caster:SetAngles(angles.x+forward_pitch, angles.y, angles.z)
  --StartAnimation(caster, {duration=duration+.5, activity=ACT_DOTA_FLAIL, rate=1.0, translate="forcestaff_friendly"})

  caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
  caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
  caster:FollowNavMesh(true)
  caster:Hibernate(false)
  caster:SetAutoUnstuck(false)
  caster:SetPhysicsFriction(0)
  --caster:SetPhysicsAcceleration(Vector(0,0,-1800))

  local xydir = -1 * forward
  local xydist = 400 + caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed())

  caster:SetPhysicsVelocity(xydir * (xydist / duration) + Vector(0,0,caster:GetPhysicsAcceleration().z / -2 * duration))


  local particle = ParticleManager:CreateParticle("particles/hunter_ranger/ranger_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

  ApplyModifier(caster, caster, "stunned", {duration=duration+.4})
  StartAnimation(caster, {duration=duration+.1, activity=ACT_DOTA_SPAWN, rate=duration * 30 / ACT_FRAMES})

  local flip = 360 + forward_pitch
  local flip_step = flip / duration / 30
  local count = 0

  local random = RandomInt(0,1)
  -- flip timer
  Timers:CreateTimer(function()
    local pitch = angles.x+forward_pitch - flip_step*count

    --if random == 0 then
      --caster:SetAngles(pitch, angles.y + flip_step*count, angles.z)
    if random == 1 then
      caster:SetAngles(pitch, angles.y, angles.z)
    else 
      caster:SetAngles(angles.x, angles.y + flip_step*count, angles.z)
    end

    local factor = (180 - math.abs(pitch)) / 5
    if random == 0 then factor = factor / 2 end

    if count < duration * 15 then
      caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,factor))
    else
      caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,factor))
    end
    if count >= duration * 30 then
      caster:SetAngles(angles.x, angles.y, angles.z)
      return
    end
    count = count + 1
    return .03
  end)

  Timers:CreateTimer(duration+.03, function()
    StartAnimation(caster, {duration=.5, activity=ACT_DOTA_OVERRIDE_ABILITY_2, rate=1.5})
    --StartAnimation(caster, {duration=.5, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})

    caster:SetPhysicsVelocity(caster:GetPhysicsVelocity()/20)

    caster:PreventDI(false)
    caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
    caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
    caster:FollowNavMesh(true)
    caster:Hibernate(true)
    caster:SetPhysicsFriction(caster.originalFriction or 0.05)
    --caster:SetPhysicsAcceleration(caster.originalAcceleration)
    caster:Stop()

    local dir = caster:GetForwardVector()

    local projectile = {
      EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
      vSpawnOrigin = caster:GetAbsOrigin() + Vector(0,0,100),--{unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
      fDistance = arrow_distance,
      fStartRadius = 100,
      fEndRadius = 100,
      Source = caster,
      fExpireTime = 8.0,
      vVelocity = dir * arrow_speed,
      UnitBehavior = PROJECTILES_NOTHING,
      bMultipleHits = false,
      bIgnoreSource = true,
      TreeBehavior = PROJECTILES_NOTHING, -- PROJECTILES_DESTROY,
      bCutTrees = false,
      bTreeFullCollision = false,
      WallBehavior = PROJECTILES_NOTHING,
      GroundBehavior = PROJECTILES_NOTHING,
      fGroundOffset = 120,
      nChangeMax = 1,
      bRecreateOnChange = true,
      bZCheck = false,
      bGroundLock = true,
      bProvidesVision = true,
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

      UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() and not unit:IsInvulnerable() and not caster:IsFriendlyHero(unit) end,
      OnUnitHit = function(self, unit) 
        print ('HIT UNIT: ' .. unit:GetUnitName())
        local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
        ApplyDamage( {
          victim = unit,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PHYSICAL,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = abil
        } )
      end,
      --OnTreeHit = function(self, tree) ... end,
      --OnWallHit = function(self, gnvPos) ... end,
      --OnGroundHit = function(self, groundPos) ... end,
      --OnFinish = function(self, pos) ... end,
    }

    Projectiles:CreateProjectile(projectile)

    Timers:CreateTimer(1, function() ParticleManager:DestroyParticle(particle, false) end)
  end)
end
