LinkLuaModifier("modifier_movespeed_cap", "modifiers/modifier_movespeed_cap", LUA_MODIFIER_MOTION_NONE)

local hero = PlayerResource:GetSelectedHeroEntity(0)

hero:AddNewModifier(hero, nil, "modifier_movespeed_cap", {})
hero:SetBaseMoveSpeed(522) 
Timers:CreateTimer(2, function()
  hero:SetBaseMoveSpeed(1000)
end)
--hero:SetAbsOrigin(hero:GetAbsOrigin() + Vector(0,1000,0))