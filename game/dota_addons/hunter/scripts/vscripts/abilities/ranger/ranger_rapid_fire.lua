function OnAbilityPhaseStart(keys)
  print('OnAbilityPhaseStart')
  local caster = keys.caster
  StartAnimation(caster, {duration=1, activity=ACT_DOTA_SPAWN, rate=1.0, translate="loadout"})
end

function OnAbilityPhaseInterrupted(keys)
  print('OnAbilityPhaseInterrupted')
  local caster = keys.caster
  EndAnimation(caster)
end

function OnSpellStart(keys)
  print('ranger_rapid_fire, onspellstart')

  local abil = keys.ability
  local caster = keys.caster

  --StartAnimation(caster, {duration=1, activity=ACT_DOTA_CAST_ABILITY_1, rate=2.0})

  ApplyModifier(caster, caster, "stunned", {duration=.2})
end

function OnCreated(keys)
  local caster = keys.caster
  local abil = keys.ability
  local bat_bonus = abil:GetSpecialValueFor("bat_boost")

  print(bat_bonus, caster:GetBaseAttackTime())

  abil.bonusSet = bat_bonus
  caster:SetBaseAttackTime(caster:GetBaseAttackTime() / bat_bonus)
end

function OnDestroy(keys)
  local caster = keys.caster
  local abil = keys.ability

  caster:SetBaseAttackTime(caster:GetBaseAttackTime() * abil.bonusSet)
end
