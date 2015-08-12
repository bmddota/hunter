function OnSpellStart(keys)
  print('mark_for_death, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  local target = keys.target

  local color = Vector(255,0,0)

  if caster.aggroHeroes[target:entindex()] ~= nil then
    color = Vector(0,255,0)
    caster.aggroHeroes[target:entindex()] = nil
  else
    caster.aggroHeroes[target:entindex()] = target
  end

  local particle = ParticleManager:CreateParticleForPlayer("particles/ui_mouseactions/ping_player.vpcf", PATTACH_ABSORIGIN_FOLLOW, target, PlayerResource:GetPlayer(caster:GetPlayerID()))
  ParticleManager:SetParticleControl(particle, 1, color)
  ParticleManager:ReleaseParticleIndex(particle)
end
