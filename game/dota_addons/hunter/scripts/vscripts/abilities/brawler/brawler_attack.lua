function OnSpellStart(keys)
  print('brawler_attack, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  --self.BaseClass.SetHidden(true)
  --abil:SetInAbilityPhase(true)

  local ACT_FRAMES = 35
  local duration = 1 / caster:GetAttacksPerSecond()

  caster.cancelAction = function()
    print("CANCEL")
    EndAnimation(caster)
    --caster.animationEndTime = GameRules:GetGameTime()
    abil:EndCooldown()
    caster.cancelAction = nil
    Timers:RemoveTimer(abil.castPointTimer)
    --Timers:RemoveTimer(abil.lateTimer)
  end

  --if caster.animationEndTime and caster.animationEndTime + .067 > GameRules:GetGameTime() then
    --print('too soon', caster.animationEndTime + .067, GameRules:GetGameTime())
    --abil.lateTimer = Timers:CreateTimer(.067, function()
      --StartAnimation(caster, {duration=duration, activity=ACT_DOTA_ATTACK, rate=ACT_FRAMES / (30 * duration)})
    --end)
  --else
    StartAnimation(caster, {duration=duration, activity=ACT_DOTA_ATTACK, rate=ACT_FRAMES / (30 * duration)})
  --end
  print('start')

  abil.castPointTimer = Timers:CreateTimer(duration/3, function()
    print('end')
    caster.cancelAction = nil
    abil:EndCooldown()
      abil:StartCooldown(2*duration/3)
    --self.BaseClass:SetInAbilityPhase(false)

    local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
    ApplyDamage( {
      victim = keys.target,
      attacker = caster,
      damage = nDamageAmount,
      damage_type = DAMAGE_TYPE_PHYSICAL,
      damage_flags = DOTA_DAMAGE_FLAG_NONE,
      ability = abil
    } )
  end)
end
