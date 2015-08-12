function OnAbilityPhaseStart(keys)
  print('OnAbilityPhaseStart')
  local caster = keys.caster
  local abil = keys.ability 

  abil.start_particle = ParticleManager:CreateParticle("particles/hunter_fire_mage/blast_blastup_immortal1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

  StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_2, rate=.8})
end

function OnAbilityPhaseInterrupted(keys)
  print('OnAbilityPhaseInterrupted')
  local caster = keys.caster
  local abil = keys.ability 

  ParticleManager:DestroyParticle(abil.start_particle, false)
  EndAnimation(caster)
end


function OnSpellStart(keys)
  print('fire_mage_blast, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  
  local ACT_FRAMES = 390
  local duration = .5

  --ParticleManager:DestroyParticle(abil.start_particle, false)
  
  --local particle = ParticleManager:CreateParticle("particles/hunter_fire_mage/blast_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
  ParticleManager:SetParticleControl( particle, 1, Vector( 250, 1, 1 ) )
  ParticleManager:ReleaseParticleIndex( particle )

  --particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion_flash_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  --particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion_sparks.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

  --StartAnimation(caster, {duration=duration+.2, activity=ACT_DOTA_CAST_ABILITY_4, rae=2.0})
  ApplyModifier(caster, caster, "stunned", {duration=.2})

  local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
  for i=1,#enemies do
    local enemy = enemies[i]
    local nDamageAmount = (caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5) * 3
    ApplyDamage( {
      victim = enemy,
      attacker = caster,
      damage = nDamageAmount,
      damage_type = DAMAGE_TYPE_PURE,
      damage_flags = DOTA_DAMAGE_FLAG_NONE,
      ability = abil
    } )

  end
end
