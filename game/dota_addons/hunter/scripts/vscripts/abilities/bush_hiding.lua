function BushHidingDestroyed(keys)
  local caster = keys.caster

  if caster.isInBushes then
    ApplyModifier(caster, caster, "modifier_bush_hidden", {})
    caster:AddNewModifier(caster, nil, "modifier_invisible", {})
  end
end

function BushHiddenThink(keys)
  local caster = keys.caster
  if not caster:HasModifier("modifier_invisible") and caster.isInBushes then
    ApplyModifier(caster, caster, "modifier_bush_hiding", {duration=caster.bushHideTime})
    caster:RemoveModifierByName("modifier_bush_hidden")
  end
end