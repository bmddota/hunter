function OnSpellStart(keys)
  print('berserker_helix, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  --self.BaseClass.SetHidden(true)
  --abil:SetInAbilityPhase(true)

  local ACT_FRAMES = 8
  --ACT_DOTA_CAST_ABILITY_3
  local duration = .2

  --[[caster.cancelAction = function()
    print("CANCEL")
    StartAnimation(caster, {duration=.1, activity=ACT_DOTA_IDLE, rate=1.0})  
    --caster.animationEndTime = GameRules:GetGameTime()
    abil:EndCooldown()
    caster.cancelAction = nil
    Timers:RemoveTimer(abil.castPointTimer)
    --Timers:RemoveTimer(abil.lateTimer)
  end]]

  --if caster.animationEndTime and caster.animationEndTime + .067 > GameRules:GetGameTime() then
    --print('too soon', caster.animationEndTime + .067, GameRules:GetGameTime())
    --abil.lateTimer = Timers:CreateTimer(.067, function()
      --StartAnimation(caster, {duration=duration, activity=ACT_DOTA_ATTACK, rate=ACT_FRAMES / (30 * duration)})
    --end)
  --else
    StartAnimation(caster, {duration=duration+.2, activity=ACT_DOTA_CAST_ABILITY_3, rate=ACT_FRAMES / (30 * duration)})
    --ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster))
  --end
  print('start')

  Timers:CreateTimer(duration/2, function()
    print('end')
    

    local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for i=1,#enemies do
      local enemy = enemies[i]
      local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
      ApplyDamage( {
        victim = enemy,
        attacker = caster,
        damage = nDamageAmount,
        damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = abil
      } )
    end

    Timers:CreateTimer(duration/2, function()
      StartAnimation(caster, {duration=duration+.2, activity=ACT_DOTA_CAST_ABILITY_3, rate=ACT_FRAMES / (30 * duration)})
      --ParticleManager:ReleaseParticleIndex(ParticleManager:CreateParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster))

      Timers:CreateTimer(duration/2, function()
        local enemies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
        for i=1,#enemies do
          local enemy = enemies[i]
          local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
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
    end)
    
  end)
end
