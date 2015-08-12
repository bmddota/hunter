function OnAbilityPhaseStart(keys)
  print('OnAbilityPhaseStart')
  local caster = keys.caster
  StartAnimation(caster, {duration=1, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=.5})
end

function OnAbilityPhaseInterrupted(keys)
  print('OnAbilityPhaseInterrupted')
  local caster = keys.caster
  EndAnimation(caster)
end

function OnSpellStart(keys)
  print('berserker_berserk, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  --self.BaseClass.SetHidden(true)
  --abil:SetInAbilityPhase(true)

  ApplyModifier(caster, caster, "stunned", {duration=.3})
end
