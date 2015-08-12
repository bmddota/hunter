local HEROMODULE = {}

function HEROMODULE:InitializeClass(hero)
	require('heroes/default'):InitializeClass(hero)

	hero:FindAbilityByName("fire_mage_attack"):SetLevel(1)
  hero:FindAbilityByName("fire_mage_attack"):SetHidden(false)
  hero:FindAbilityByName("fire_mage_blast"):SetLevel(1)

  hero:FindAbilityByName("fire_mage_fire_skin"):SetLevel(1)
  hero:FindAbilityByName("fire_mage_flame_tornado"):SetLevel(1)
  
end

return HEROMODULE