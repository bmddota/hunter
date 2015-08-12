function OnSpellStart(keys)
  print('brawler_blitz, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  
  local ACT_FRAMES = 16
  local duration = .3

  ApplyModifier(caster, caster, "stunned", {duration=duration})
  local angles = caster:GetAngles()
  angles.x = 0
  caster:SetAngles(angles.x, angles.y, angles.z)
  --StartAnimation(caster, {duration=duration, activity=ACT_DOTA_FLAIL, rate=.4, translate="forcestaff_friendly"})
  StartAnimation(caster, {duration=duration, activity=ACT_DOTA_DISABLED, rate=.8})

  caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
  caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
  caster:FollowNavMesh(true)
  caster:Hibernate(false)
  caster:SetAutoUnstuck(false)
  caster:SetPhysicsFriction(0)

  caster:SetPhysicsVelocity(Vector(0,0,600))

  ApplyModifier(caster, caster, "stunned", {duration=duration+30/30})

  local particle = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, caster) -- particles/hunter_berserker/flame.vpcf

  Timers:CreateTimer(duration, function()

    --StartAnimation(caster, {duration=.5, activity=ACT_DOTA_CAST_ABILITY_5, rate=.8})

    --caster:SetAngles(angles.x+160, angles.y, angles.z)
    --caster:SetAbsOrigin(caster:GetAbsOrigin()+ Vector(0,0,300))
    local count = 0
    local cap = 8
    Timers:CreateTimer(function()
      count = count + 1
      caster:SetAngles(angles.x+count*180/cap, angles.y, angles.z)
      caster:SetAbsOrigin(caster:GetAbsOrigin() + Vector(0,0,300/cap))
      if count == cap then 
        count = 0
        caster:AddPhysicsVelocity(Vector(0,0,-1000))
        Timers:CreateTimer(function()
          count = count + 1
          caster:SetAngles(angles.x+180, angles.y+66*count, angles.z)
          if count == 20 then 
            caster:PreventDI(false)
            caster:SetNavCollisionType(PHYSICS_NAV_HALT)
            caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
            caster:FollowNavMesh(true)
            caster:Hibernate(true)
            caster:SetPhysicsVelocity(caster:GetPhysicsVelocity()/2)
            caster:SetPhysicsFriction(caster.originalFriction or 0.05)
            caster:Stop()
            caster:SetAngles(angles.x, angles.y, angles.z)
            ParticleManager:DestroyParticle(particle, false) 
            return 
          end
          return .03
        end)
        return 
      else return .03 end
    end)

    --caster:SetPhysicsVelocity(caster:GetPhysicsVelocity()/6)

    local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage()
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
  end)
end
