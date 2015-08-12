function OnSpellStart(keys)
  print('brawler_stomp, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  
  local ACT_FRAMES = 62
  local duration = 1.0
  local jump_force = 600
  local crack_distance = 500
  local crack_sweep = 70

  
  ApplyModifier(caster, caster, "stunned", {duration=2*duration/3+.1})
  local particle = ParticleManager:CreateParticle("particles/hunter_brawler/blitz.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

  StartAnimation(caster, {duration=duration+.2, activity=ACT_DOTA_CAST_ABILITY_1, rate=ACT_FRAMES / (30 * duration)})

  caster:AddPhysicsVelocity(Vector(0,0,jump_force))

  Timers:CreateTimer(duration/2, function()
    caster:AddPhysicsVelocity(Vector(0,0,jump_force * -1.5))

    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_cast_crack.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, caster:GetAbsOrigin() + caster:GetForwardVector() * crack_distance)
    ParticleManager:ReleaseParticleIndex(particle2)

    particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_cast_crack.vpcf", PATTACH_ABSORIGIN, caster)
    local org = caster:GetAbsOrigin() + crack_distance * RotatePosition(Vector(0,0,0), QAngle(0,crack_sweep/2,0), caster:GetForwardVector())
    ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, org)
    ParticleManager:ReleaseParticleIndex(particle2)

    org = caster:GetAbsOrigin() + crack_distance * RotatePosition(Vector(0,0,0), QAngle(0,crack_sweep/-2,0), caster:GetForwardVector())
    particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_cast_crack.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(particle2, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle2, 1, org)
    ParticleManager:ReleaseParticleIndex(particle2)

    Timers:CreateTimer(duration/6, function()

      ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter_cast_b.vpcf", PATTACH_ABSORIGIN, caster))

      local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin() + caster:GetForwardVector() * crack_distance / 2, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      for i=1,#enemies do
        local enemy = enemies[i]
        local nDamageAmount = (caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5) * 2
        ApplyDamage( {
          victim = enemy,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PHYSICAL,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = abil
        } )

      end

      Timers:CreateTimer(.2, function() ParticleManager:DestroyParticle(particle, false) end)
    end)
  end)
end
