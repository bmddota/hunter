function OnSpellStart(keys)
  print('brawler_blitz, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  
  local ACT_FRAMES = 16
  local duration = .4

  ApplyModifier(caster, caster, "stunned", {duration=duration})
  local angles = caster:GetAngles()
  caster:SetAngles(angles.x+20, angles.y, angles.z)
  StartAnimation(caster, {duration=duration+.5, activity=ACT_DOTA_FLAIL, rate=1.0, translate="forcestaff_friendly"})

  caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
  caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
  caster:FollowNavMesh(true)
  caster:Hibernate(false)
  caster:SetAutoUnstuck(false)
  caster:SetPhysicsFriction(0)

  local xydir = caster:GetForwardVector()
  local xydist = 400 + caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed())

  caster:SetPhysicsVelocity(xydir * (xydist / duration))

  ApplyModifier(caster, caster, "stunned", {duration=duration+.4})

  local particle = ParticleManager:CreateParticle("particles/hunter_brawler/blitz.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

  local endAbility = function(param)
    Timers:RemoveTimer(abil.endTimer)
    Timers:RemoveTimer(abil.collideTimer)

    StartAnimation(caster, {duration=.5, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.5})
    --StartAnimation(caster, {duration=.5, activity=ACT_DOTA_FORCESTAFF_END, rate=1.0})

    caster:SetAngles(angles.x+70, angles.y, angles.z)
    local count = 12
    Timers:CreateTimer(function()
      count = count - 1
      caster:SetAngles(angles.x+count*70/12, angles.y, angles.z)
      if count == 0 then return else return .03 end
    end)

    if param == "hit" then
      caster:SetPhysicsVelocity(Vector(0,0,0))
    else
      caster:SetPhysicsVelocity(caster:GetPhysicsVelocity()/5)
    end

    Timers:CreateTimer(.4, function()
      caster:SetAngles(angles.x, angles.y, angles.z)
      caster:PreventDI(false)
      caster:SetNavCollisionType(PHYSICS_NAV_HALT)
      caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
      caster:FollowNavMesh(true)
      caster:Hibernate(true)
      caster:SetPhysicsVelocity(caster:GetPhysicsVelocity()/2)
      caster:SetPhysicsFriction(caster.originalFriction or 0.05)
      caster:Stop()

      local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
      local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      for _,enemy in ipairs(enemies) do

        ApplyDamage( {
          victim = enemy,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PHYSICAL,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = abil
        } )
      end

      Timers:CreateTimer(.5, function() ParticleManager:DestroyParticle(particle, false) end)
    end)
  end

  abil.endTimer = Timers:CreateTimer(duration, endAbility)

  abil.collideTimer = Timers:CreateTimer(function()
    local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    if #enemies > 0 then
      for _,enemy in ipairs(enemies) do
        if not caster:IsFriendlyHero(enemy) then
          enemy:AddNewModifier(caster, nil, "modifier_stunned", {duration=.3})
        end
      end

      endAbility("hit")
      return
    end
    return .03
  end)
end
