function OnSpellStart(keys)
  print('fire_mage_flame_tornado, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  
  local ACT_FRAMES = 16
  local duration = 2.0
  local rise_speed = 500

  ApplyModifier(caster, caster, "stunned", {duration=duration})
  local angles = caster:GetAngles()
  StartAnimation(caster, {duration=duration+.5, activity=ACT_DOTA_SPAWN, rate=.5})

  caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
  caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
  caster:FollowNavMesh(true)
  caster:Hibernate(false)
  caster:SetAutoUnstuck(false)
  caster:SetPhysicsFriction(0)
  caster:SetPhysicsAcceleration(Vector(0,0,0))

  local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_NOTEAM)
  dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  dummy:AddNewModifier(dummy, nil, "modifier_invulnerable", {})
  dummy:AddNewModifier(dummy, nil, "modifier_phased", {})

  Timers:CreateTimer(function()
    if IsValidEntity(dummy) then
      dummy:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))

      local nDamageAmount = (caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage()) / 8
      local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      for _,enemy in ipairs(enemies) do

        ApplyDamage( {
          victim = enemy,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PURE,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = abil
        } )
      end

      return .03
    end
  end)

  local xydir = caster:GetForwardVector()
  local xydist = (400 + caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed()))*1.5

  caster:SetPhysicsVelocity(xydir * (xydist / duration) + Vector(0,0,rise_speed))

  local particle = ParticleManager:CreateParticle("particles/hunter_fire_mage/flame_tornado.vpcf", PATTACH_ABSORIGIN_FOLLOW, dummy)

  Timers:CreateTimer(duration/4, function()
    local vel = caster:GetPhysicsVelocity()
    local radius = caster:GetNightTimeVisionRange()
    if GameRules:IsDaytime() then radius = caster:GetDayTimeVisionRange() end

    caster.flyingVisionRadiusOverride = radius
    caster:SetPhysicsVelocity(Vector(vel.x, vel.y, 0))
  end)

  Timers:CreateTimer(3*duration/4, function()
    local vel = caster:GetPhysicsVelocity()

    caster.flyingVisionRadiusOverride = nil
    caster:SetPhysicsVelocity(Vector(vel.x, vel.y, -1 * rise_speed))
  end)  

  Timers:CreateTimer(duration, function()
    --StartAnimation(caster, {duration=.5, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.5})
    --StartAnimation(caster, {duration=.5, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})

    --caster:SetAngles(angles.x, angles.y, angles.z)
    caster:PreventDI(false)
    caster:SetNavCollisionType(PHYSICS_NAV_HALT)
    caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
    caster:FollowNavMesh(true)
    caster:Hibernate(true)
    ---caster:SetPhysicsVelocity(caster:GetPhysicsVelocity()/2)
    caster:SetPhysicsVelocity(Vector(0,0,0))
    caster:SetPhysicsFriction(caster.originalFriction or 0.05)
    caster:SetPhysicsAcceleration(caster.originalAcceleration)
    caster:Stop()

    Timers:CreateTimer(0.5, function() ParticleManager:DestroyParticle(particle, false); dummy:RemoveSelf() end)
  end)
end
