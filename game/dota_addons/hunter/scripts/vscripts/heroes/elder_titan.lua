local HEROMODULE = {}

function HEROMODULE:InitializeClass(hero)
	require('heroes/default'):InitializeClass(hero)

	hero:FindAbilityByName("brawler_attack"):SetLevel(1)
  hero:FindAbilityByName("brawler_attack"):SetHidden(false)
  hero:FindAbilityByName("brawler_stomp"):SetLevel(1)
  hero:FindAbilityByName("brawler_stomp"):SetHidden(false)

  hero:FindAbilityByName("brawler_frenzy"):SetLevel(1)
  hero:FindAbilityByName("brawler_blitz"):SetLevel(1)

  -- hide cosmetics
  Timers:CreateTimer(function()
    local children = hero:GetChildren()

    for _,child in ipairs(children) do
      print(child:GetClassname())
      if child:GetClassname() == "dota_item_wearable" then
        print("",child:GetModelName())
        child:AddEffects(EF_NODRAW)
      end
    end
  end)

  Timers:CreateTimer(1, function()
    --AddAnimationTranslate(hero, "haste")
  end)
  
end

return HEROMODULE