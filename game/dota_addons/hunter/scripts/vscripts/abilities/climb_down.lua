function ClimbDown(keys)
  local caster = keys.caster
  local ability = keys.ability

  local climbTree = caster:FindAbilityByName("climb_tree")
  Timers:RemoveTimer(climbTree.timer)
  climbTree.complete()
end