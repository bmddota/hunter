local HEROMODULE = {}

function HEROMODULE:InitializeClass(hero)
  require('heroes/default'):InitializeClass(hero)

  hero:FindAbilityByName("ranger_attack"):SetLevel(1)
  hero:FindAbilityByName("ranger_attack"):SetHidden(false)
  hero:FindAbilityByName("ranger_split_shot"):SetLevel(1)

  hero:FindAbilityByName("ranger_rapid_fire"):SetLevel(1)
  hero:FindAbilityByName("ranger_backflip"):SetLevel(1)
  
end

return HEROMODULE