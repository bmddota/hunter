local player = PlayerResource:GetPlayer(0)
local hero = player:GetAssignedHero()


require('spawner')
require('libraries/pathgraph')

if particles == nil then 
  particles = {}
else
  for _,particle in ipairs(particles) do
    ParticleManager:DestroyParticle(particle, false)
  end
  particles = {}
end

if timer then Timers:RemoveTimer(timer) end
timer = Timers:CreateTimer(.5, function()
  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_fg_aura_ground01.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(particle, 0, hero:GetAbsOrigin())
  table.insert(particles, particle)
  --return 3.0
end)

if true then return end

for i=0,9 do
  print(i, PlayerResource:IsValidPlayer(i),
    PlayerResource:GetSelectedHeroEntity(i),
    PlayerResource:GetSelectedHeroName(i),
    PlayerResource:GetSelectedHeroID(i),
    PlayerResource:GetPlayer(i))
  print(i, PlayerResource:GetPlayerCount(),
    PlayerResource:GetSteamAccountID(i),
    PlayerResource:GetTeam(i),
    PlayerResource:HasRandomed(i),
    PlayerResource:HasRepicked(i),
    PlayerResource:HasSelectedHero(i))
  print(i, PlayerResource:IsValidPlayer(i),
    PlayerResource:IsValidPlayerID(i),
    PlayerResource:IsValidTeamPlayer(i),
    PlayerResource:IsValidTeamPlayerID(i),
    PlayerResource:HasRepicked(i),
    PlayerResource:HasSelectedHero(i))
end

if true then return end

local ents = Entities:FindAllByClassname("npc_dota_creature")

thisEntity = Entities:FindByModel(nil, "models/heroes/shredder/shredder.vmdl")
require('ai/npc_timbersaw_boss')

for i=1,10 do
  print(DifficultyFactor(i-1, 20))
end

Spawn()

if true then return end

for _,hero in ipairs(HeroList:GetAllHeroes()) do
  --hero:RespawnHero(false,false,false)
end

local trail = ParticleManager:CreateParticle("particles/night_lord/shadow_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
Timers:CreateTimer(4, function()
  ParticleManager:DestroyParticle(trail, false)
end)
--Timers:CreateTimer(2, function() GameMode:StartGame() end)
if true then return end

--local children = Entities:FindByName(nil, "night_lord"):GetChildren()

local axes = Entities:FindAllByClassname("npc_dota_hero_axe")
print(#axes)

for _,axe in ipairs(axes) do
  local count = 0

  Timers:CreateTimer(1, function()
    count = count + 1

    axe:MoveToPosition(axe:GetAbsOrigin() + RandomVector(RandomFloat(300, 800)))

    if count == 5 then return end
    return 1
  end)
end

--AddAnimationTranslate(hero, "haste")
--RemoveAnimationTranslate(hero)

--PathGraph:DrawPaths(Entities:FindByName(nil, "corner1"))
--GameRules:GetGameModeEntity():SetCameraDistanceOverride(4000)
GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)

GameRules:GetGameModeEntity():SetCameraDistanceOverride(-1)
--GameRules:GetGameModeEntity():SetFogOfWarDisabled(false)

--if true then return end
--hero:ForceKill(false)
Spawner:Initialize()

--local trees = Entities:FindAllByClassname("ent_dota_tree")
--print(#trees)
--[[local offset = 250

for name,table in pairs(NPC_UNITS) do
  if name ~= "Version" and name ~= "npc_dummy_unit" and name ~= "npc_night_lord" and name ~= "npc_ghost_hero" and name ~= "npc_the_beast" then
    print(name)
    unit = CreateUnitByName(name, hero:GetAbsOrigin() + Vector(offset,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
    unit:SetForwardVector(Vector(0,-1,0))
    unit:SetIdleAcquire(false)
    unit:SetAcquisitionRange(0)

    offset = offset + 180
  end
end]]

if true then return end


PathGraph:DrawPaths(nil, 60)

if true then return end

--package.loaded["libraries/physics"] = nil
--require('libraries/physics')

--Physics:Unit(hero)

hero:FindAbilityByName("berserker_blitz"):SetLevel(1)
hero:FindAbilityByName("berserker_berserk"):SetLevel(1)
StartAnimation(hero, {duration=5, activity=ACT_DOTA_TAUNT, rate=4.0, translate2="good_day_sir"})

PlayerResource:SetCameraTarget(0, nil)
--StartAnimation(hero, {duration=5, activity=ACT_DOTA_CAST_ABILITY_3, rate=.5, translate2="blood_chaser"})
--StartAnimation(hero, {duration=5, activity=ACT_DOTA_CAST_ABILITY_4, rate=.5, translate2="rampant"})
--[[StartAnimation(hero, {duration=1, activity=ACT_DOTA_FLAIL, rate=.2, translate="forcestaff_friendly"})
Timers:CreateTimer(1, function()
  StartAnimation(hero, {duration=1, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=0.5, translate="rampant"})
  --StartAnimation(hero, {duration=1, activity=ACT_DOTA_RUN, rate=2.0, translate="haste"})
end)]]

if true then
  return
end

lord:SetModelScale(2.5)
lord:SetAbsOrigin(lord:GetAbsOrigin() + Vector(0,-10,0))

Entities:FindByName(nil, "night_lord"):SetForwardVector(Vector(.2,-1,0):Normalized())

for k,v in pairs(children) do
  print(v:GetModelName())
  if v:GetModelName() == "models/items/abaddon/alliance_abba_mount/alliance_abba_mount.vmdl" then
    v:AddEffects(EF_NODRAW)
  end
  if v:GetModelName() == "models/items/abaddon/phantoms_reaper/phantoms_reaper.vmdl" then
    v:SetRenderColor(10,10,10)
  elseif v.SetRenderColor then v:SetRenderColor(50,50,50) 
  end
end

Entities:FindByName(nil, "night_lord"):SetRenderColor(50,50,50)

particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, night_lord)
--ParticleManager:SetParticleControlEnt(particle2, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
--ParticleManager:SetParticleControlEnt(particle2, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)



--hero:SetRenderColor(100,100,100)

if true then
  return
end

particle2 = ParticleManager:CreateParticle("particles/the_beast/chaos_knight_diabolic_big_flame_2_a.vpcf", PATTACH_POINT_FOLLOW, hero)
ParticleManager:SetParticleControlEnt(particle2, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle2, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true)

if true then
  return
end

if particle then
  ParticleManager:DestroyParticle(particle, true)
  --return
end

if particle2 then 
    ParticleManager:DestroyParticle(particle2, true)
  end

for i=1,#ents do
  beast = ents[i]
  print(beast:GetUnitName())
  FindClearSpaceForUnit(beast, hero:GetAbsOrigin(), true)
  
  particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_POINT_FOLLOW, beast)
  ParticleManager:SetParticleControlEnt(particle, 0, beast, PATTACH_POINT_FOLLOW, "attach_mane", beast:GetAttachmentOrigin(beast:ScriptLookupAttachment("attach_mane")), true)
  ParticleManager:SetParticleControlEnt(particle, 1, beast, PATTACH_POINT_FOLLOW, "attach_mane", beast:GetAttachmentOrigin(beast:ScriptLookupAttachment("attach_mane")), true)

  particle2 = ParticleManager:CreateParticle("particles/the_beast/chaos_knight_diabolic_big_flame_2_a.vpcf", PATTACH_POINT_FOLLOW, beast)
  ParticleManager:SetParticleControlEnt(particle2, 0, beast, PATTACH_POINT_FOLLOW, "attach_mane", beast:GetAttachmentOrigin(beast:ScriptLookupAttachment("attach_mane")), true)
  ParticleManager:SetParticleControlEnt(particle2, 1, beast, PATTACH_POINT_FOLLOW, nil, beast:GetAbsOrigin(), true)
end
