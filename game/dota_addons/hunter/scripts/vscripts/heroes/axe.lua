local HEROMODULE = {}

function HEROMODULE:InitializeClass(hero)
	require('heroes/default'):InitializeClass(hero)

	hero:FindAbilityByName("berserker_attack"):SetLevel(1)
  hero:FindAbilityByName("berserker_attack"):SetHidden(false)
  hero:FindAbilityByName("berserker_helix"):SetLevel(1)
  hero:FindAbilityByName("berserker_helix"):SetHidden(false)

  hero:FindAbilityByName("berserker_berserk"):SetLevel(1)
  hero:FindAbilityByName("berserker_blitz"):SetLevel(1)
  
end

return HEROMODULE