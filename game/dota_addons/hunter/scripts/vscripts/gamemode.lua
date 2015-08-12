-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 
DEBUG = false

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
require('libraries/notifications')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')
require('libraries/playersay')
require('utility')

require('libraries/animations')

require('libraries/pathgraph')
require('spawner')


LinkLuaModifier( "modifier_dummy", "modifier_dummy", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_animation", "modifiers/modifier_animation.lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_animation_translate", "modifiers/modifier_animation_translate.lua", LUA_MODIFIER_MOTION_NONE )
--

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")

  local globalUnit = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), false, nil, nil, DOTA_TEAM_NOTEAM)
  globalUnit:AddAbility("modifier_applier")
  GameRules.ModApplier = globalUnit:FindAbilityByName("modifier_applier")
  GameRules.ModApplier:SetLevel(1)
  ModApplier = GameRules.ModApplier
  ApplyModifier(globalUnit, globalUnit, "dummy_unit", {})

  GameRules.Timers = Timers

  local nightLord = Entities:FindByName(nil, "night_lord")
  ApplyModifier(nightLord, nightLord, "real_stunned", {})

  nightLord:SetForwardVector(Vector(.2,-1,0):Normalized())

  local children = nightLord:GetChildren()
  for k,v in pairs(children) do
    if v:GetModelName() == "models/items/abaddon/alliance_abba_mount/alliance_abba_mount.vmdl" then
      v:AddEffects(EF_NODRAW)
    end
    if v:GetModelName() == "models/items/abaddon/phantoms_reaper/phantoms_reaper.vmdl" then
      v:SetRenderColor(10,10,10)
    elseif v.SetRenderColor then v:SetRenderColor(60,60,60) 
    end
  end

  nightLord:SetRenderColor(60,60,60)


  local position = Vector(60, -400, 400)
  local dummy = CreateUnitByName("npc_dummy_unit", position, false, nil, nil, DOTA_TEAM_NOTEAM)
  dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  dummy:AddNewModifier(dummy, nil, "modifier_invulnerable", {})
  dummy:AddNewModifier(dummy, nil, "modifier_phased", {})

  Timers:CreateTimer(function() dummy:SetAbsOrigin(Vector(60, -400, 1000)) end)

  Physics:Unit(dummy)

  GameMode.dummy = dummy
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")

  PlayerSay:SendConfigToAll(false, true)

  PathGraph:Initialize()

  -- random for fake clients
  for i=0,9 do
    if PlayerResource:IsFakeClient(i) and PlayerResource:IsValidPlayer(i) and PlayerResource:GetSelectedHeroID(i) == -1 then
      PlayerResource:SetHasRandomed(i)
      PlayerResource:SetHasRepicked(i)
      local player = PlayerResource:GetPlayer(i)
      if player ~= nil then
        player:MakeRandomHeroSelection()
        
        PrecacheUnitByNameAsync(PlayerResource:GetSelectedHeroName(i), function()
          CreateHeroForPlayer(PlayerResource:GetSelectedHeroName(i), player)
        end, i)
      else
        print("WARNING, player " .. i .. " is reporting as nil")
      end
    end
  end
end

function GameMode:OnPreGame()
  print('OnPreGame')

  Spawner:Initialize()

  local fun = function(pid)
    return function()
      print('attempting to create for player', pid)
      local player = PlayerResource:GetPlayer(pid)
      if PlayerResource:IsValidPlayer(pid) and PlayerResource:GetSelectedHeroEntity(-1) == nil then
        CreateHeroForPlayer(PlayerResource:GetSelectedHeroName(pid), player)
      end
    end
  end
  -- force picks
  Timers:CreateTimer(1, function()
    print ('OnPreGame 1 sec timer')
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
    for i=0,9 do
      if PlayerResource:IsValidPlayer(i) and PlayerResource:GetSelectedHeroID(i) == -1 then
        PlayerResource:SetHasRandomed(i)
        PlayerResource:SetHasRepicked(i)
        local player = PlayerResource:GetPlayer(i)
        if player ~= nil then
          print('randoming for player', i)
          player:MakeRandomHeroSelection()
          
          PrecacheUnitByNameAsync(PlayerResource:GetSelectedHeroName(i), fun(i), i)
        else
          print("WARNING, player " .. i .. " is reporting as nil")
        end
      end
    end
  end)
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]

local first = true
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  local heroClass = string.match(hero:GetClassname(), "npc_dota_hero_(.*)")

  local heroscript = nil
  local status,ret = pcall(function()
    heroscript = require('heroes/' .. heroClass)
    if heroscript ~= nil then
      heroscript:InitializeClass(hero)
    end
  end)

  if not status then
    print("HeroScript Creation Failed: " .. heroClass .. " -- " .. ret)
  end

  if heroscript == nil then
    print('No hero script found for hero class: ' .. heroClass)
    heroscript = require('heroes/default'):InitializeClass(hero)
  end

  if not GameMode.started then
    Timers:CreateTimer(.1, function() StartAnimation(hero, {duration=20, activity=ACT_DOTA_DISABLED, rate=1.0}) end)
    hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
    ApplyModifier(hero, hero, "stunned", {})
    hero:SetForwardVector(Vector(0,1,0))

    hero:SetDayTimeVisionRange(1800)
    hero.flyingVisionRadiusOverride = 1800
  end

  if PlayerResource:IsValidPlayer(hero:GetPlayerID()) and not PlayerResource:IsFakeClient(hero:GetPlayerID()) then
    PlayerResource:SetCameraTarget(hero:GetPlayerID(), GameMode.dummy)
  end

  -- check if all players are in game
  Timers:CreateTimer(1, function()
    local allInGame = true
    if GameMode.started then return end

    for i=0,9 do
      print('player', i, PlayerResource:IsValidPlayer(i), PlayerResource:GetSelectedHeroEntity(i))
      if PlayerResource:IsValidPlayer(i) and PlayerResource:GetSelectedHeroEntity(i) == nil then
        print('not in game')
        allInGame = false
        break
      end
    end

    if allInGame then
      GameMode.started = true
      print('starting game')
      Timers:CreateTimer(2, function()
        GameMode:StartGame()
      end)
    end
  end)
end


function GameMode:StartGame()
  local nightLord = Entities:FindByName(nil, "night_lord")
  nightLord:SetForwardVector(Vector(.2,-1,0):Normalized())
  --GameRules:SetTimeOfDay(.5)

  local validSpots = {"corner_track2",
                      "corner_track4",
                      "corner_track6",
                      "corner_track7",
                      "corner_track8",
                      "corner_track9",
                      "corner_track10",
                      "corner_track11",
                      "corner_track14",
                      "corner_track17",
                      "corner_track20",
                      "corner_track21",
                      "corner_track22",
                      "corner_track23",
                     }



    local heroes = HeroList:GetAllHeroes()

    local position = Vector(60, -400, 400)
    local dummy = GameMode.dummy

    local collider = dummy:AddColliderFromProfile("gravity")
    collider.filter = heroes
    collider.radius = 2000
    collider.fullRadius = 0
    collider.minRadius = 0
    collider.force = 8000
    collider.linear = false
    collider.test = function(self, collider, collided)
      return IsPhysicsUnit(collided)
    end

    --[[collider = dummy:AddColliderFromProfile("blocker")
    collider.filter = heroes
    collider.radius = 0
    collider.test = function(self, collider, collided)
      return IsPhysicsUnit(collided)
    end]]

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, position)
    ParticleManager:SetParticleControl(particle, 1, position)

    local count = 0
    local max = 90
    position = GetGroundPosition(position, dummy)

    Timers:CreateTimer(.1, function()
      ParticleManager:SetParticleControl(particle, 0, position)
      ParticleManager:SetParticleControl(particle, 1, position)
      --dummy:SetAbsOrigin(position)
      position = position + Vector(0,0,400/max)
      count = count + 1

      if count == max then 
        collider.force = 5000
        Timers:CreateTimer(2, function()
          print('done')
          ParticleManager:DestroyParticle(particle, false)
          dummy:RemoveSelf()

          local particle2 = ParticleManager:CreateParticle("particles/night_lord/supernova.vpcf", PATTACH_WORLDORIGIN, nil)
          ParticleManager:SetParticleControl(particle2, 0, position)
          ParticleManager:ReleaseParticleIndex(particle2)

          Timers:CreateTimer(function()
            -- fire off heroes
            for _,hero in ipairs(heroes) do
              local spot = table.remove(validSpots, RandomInt(1, #validSpots))
              spot = Entities:FindByName(nil, spot)
              spot = GetGroundPosition(spot:GetAbsOrigin(), hero)

              local origin = hero:GetAbsOrigin()

              local zdist = origin.z - spot.z
              local time = 3.5

              --z = -g*t*t/2 + t*vz0 + z0
              --

              local vz0 = ((spot.z - origin.z) + hero.originalAcceleration.z * -.5 *time*time) / time

              origin.z = 0
              spot.z = 0
              local xy = (spot - origin) / time

              if hero:GetPlayerID() == 0 then print(xy) end 

              hero:SetPhysicsVelocity(Vector(xy.x, xy.y, vz0))
              hero:SetPhysicsAcceleration(hero.originalAcceleration)
              hero:FollowNavMesh(false)
              hero:SetDayTimeVisionRange(hero.originalDayVision)

              Timers:CreateTimer(.2, function()
                if not PlayerResource:IsFakeClient(hero:GetPlayerID()) then
                  PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
                end
              end)

              Timers:CreateTimer(time, function()
                local vel = hero:GetPhysicsVelocity()
                vel.z = 0
                hero:SetPhysicsVelocity(vel:Normalized() * 150)
                hero:FollowNavMesh(true)
                hero:SetPhysicsFriction(hero.originalFriction)

                hero.flyingVisionRadiusOverride = nil
                hero:RemoveModifierByName("modifier_invulnerable")
                hero:RemoveModifierByName("stunned")
                EndAnimation(hero)
              end)

            end
          end)
        end)
        return
      end
      return .03
    end)

    --ACT_DOTA_CAST_ABILITY_2
    StartAnimation(nightLord, {duration=10, activity=ACT_DOTA_FLAIL, rate=0.4})

    for _,hero in ipairs(heroes) do
      ApplyModifier(hero, hero, "stunned", {})
      hero:AddNewModifier(hero, nil, "modifier_invulnerable", {})
      StartAnimation(hero, {duration=20, activity=ACT_DOTA_FLAIL, rate=1.0})

      local diff = dummy:GetAbsOrigin() - hero:GetAbsOrigin()
      diff.z = 0

      local qangle = QAngle(0,75,0)
      if RandomInt(0,1) == 1 then
        qangle = QAngle(0,-75,0)
      end

      diff = RotatePosition(Vector(0,0,0), qangle, diff:Normalized()) * RandomFloat(800, 1400)
      hero:SetPhysicsVelocity(Vector(diff.x,diff.y,RandomFloat(600,900)))
      hero:SetPhysicsFriction(0)
      hero:SetPhysicsAcceleration(Vector(0,0,0))
      hero:FollowNavMesh(false)

      local trail = ParticleManager:CreateParticle("particles/night_lord/shadow_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
      Timers:CreateTimer(9.5, function()
        ParticleManager:DestroyParticle(trail, false)
      end)
    end

    Timers:CreateTimer(8.5, function()
      GameRules:GetGameModeEntity():SetCameraDistanceOverride(1200)
    end)
    --GameRules:GetGameModeEntity():SetCameraDistanceOverride(1200)
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")

  Timers:CreateTimer(30, -- Start this timer 30 game-time seconds later
    function()
      DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
      return 30.0 -- Rerun this timer every 30 game-time seconds 
    end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  GameMode.started = false
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, 'OrderFilter'), self)
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, 'DamageFilter'), self)

  PlayerSay:TeamChatHandler(function(player, text)
    local hero = player:GetAssignedHero()

    if hero ~= nil then
      if hero.bubble == nil then
        hero.bubble = -1
      end
      hero.bubble = (hero.bubble + 1) % 4

      if hero:IsAlive() then
        hero:AddSpeechBubble(hero.bubble, text, (string.len(text) / 13) + 1, 35 * (((hero.bubble % 2) * 2) - 1), -20 - (hero.bubble * 10))
      elseif hero.ghost ~= nil and IsValidEntity(hero.ghost) then
        local strTable = {}
        for i=1, string.len(text) do
          local c = text.sub(i,i)
          if c == " " then
            strTable[i] = c
          else
            if RollPercentage(50) then
              strTable[i] = "O"
            else
              strTable[i] = "o"
            end
          end
        end
        hero.ghost:AddSpeechBubble(hero.bubble, table.concat(strTable), (string.len(text) / 13) + 1, 35 * (((hero.bubble % 2) * 2) - 1), -20 - (hero.bubble * 10))
      end
    end
  end)

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end


local ghostOrders = {[DOTA_UNIT_ORDER_MOVE_ITEM]=1,
                     [DOTA_UNIT_ORDER_HOLD_POSITION]=1,
                     [DOTA_UNIT_ORDER_MOVE_TO_DIRECTION]=1,
                     [DOTA_UNIT_ORDER_MOVE_TO_POSITION]=1,
                     [DOTA_UNIT_ORDER_MOVE_TO_TARGET]=1,
                     [DOTA_UNIT_ORDER_STOP]=1,
                   }

function GameMode:OrderFilter(order)
  --PrintTable(order)
  --print('---------')
  --print('')

  local unit = order.units["0"]
  if unit then
    unit = EntIndexToHScript(unit)
    if unit and unit.cancelAction then
      print("CANCELLING")
      unit.cancelAction()
    end

    if unit:IsRealHero() and not unit:IsAlive() and unit.ghost and unit.ghost.ready and ghostOrders[order.order_type] then
      order.units["0"] = unit.ghost:entindex()
    end

    if unit:GetTeam() ~= DOTA_TEAM_NEUTRALS then
      order.queue = 0
    end
  end

  --[[local pos = Vector(order.position_x, order.position_y, 0)
  local unit = order.units["0"]

  if (order.position_z ~= 0 or pos ~= Vector(0,0,0)) and unit ~= nil then
    unit = EntIndexToHScript(unit)
    if unit.GetPhysicsVelocity == nil or unit:GetPhysicsVelocity() == Vector(0,0,0) then
      local dir = unit:GetAbsOrigin()
      dir.z = 0
      dir = (pos - dir):Normalized()
      unit:SetForwardVector(dir)
    end
  end]]

  return true
end

function GameMode:DamageFilter(table)
  --[[
  [   VScript              ]: damage: 20
  [   VScript              ]: damagetype_const: 1
  [   VScript              ]: entindex_attacker_const: 347
  [   VScript              ]: entindex_inflictor_const: 359
  [   VScript              ]: entindex_victim_const: 395
]]

  local attacker = EntIndexToHScript(table.entindex_attacker_const)
  local victim = EntIndexToHScript(table.entindex_victim_const)

  if attacker.IsFriendlyHero and attacker:IsFriendlyHero(victim) then
    return false
  end

  return true
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end