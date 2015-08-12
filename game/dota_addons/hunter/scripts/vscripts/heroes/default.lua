local HERODEFAULT = {}

function HERODEFAULT:InitializeClass(hero)
	hero:SetGold(0, false)

  hero:FindAbilityByName("jump_down"):SetLevel(1)
  hero:FindAbilityByName("jump_up"):SetLevel(1)
  hero:FindAbilityByName("climb_tree"):SetLevel(1)
  hero:FindAbilityByName("climb_down"):SetLevel(1)
  hero:FindAbilityByName("dodge"):SetLevel(1)
  hero:FindAbilityByName("dodge"):SetHidden(false)
  hero:FindAbilityByName("mark_for_death"):SetLevel(1)

  hero.originalDayVision = hero:GetDayTimeVisionRange()
  hero.originalNightVision = hero:GetNightTimeVisionRange()
  hero.originalFlyingVisionRadius = 300
  hero.flyingVisionRadius = 300
  hero.flyingVisionRadiusOverride = nil

  hero.originalTruesightRadius = 200
  hero.truesightRadius = 200
  hero.truesightRadiusOverride = nil

  hero.canClimbTrees = true
  hero.canJumpUp = true
  hero.canJumpDown = true
  hero.canHideInBushes = true

  hero.originalAcceleration = Vector(0,0,-900)
  hero.originalFriction = 0.05
  hero.bushHideTime = 2

  print('hero spawn, ', hero:GetPlayerID())
  if not PlayerResource:IsFakeClient(hero:GetPlayerID()) then
    PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
  end

  Physics:Unit(hero)
  hero:SetPhysicsFriction(hero.originalFriction)
  hero:SetNavCollisionType(PHYSICS_NAV_SLIDE)
  hero:FollowNavMesh(true)
  hero:SetPhysicsAcceleration(hero.originalAcceleration)
  hero:SetAutoUnstuck(false)

  hero.markedHero = nil
  hero.aggroHeroes = {}

  hero.wakeUpTimer = Timers:CreateTimer(function()
    if hero:IsAlive() and not hero:IsInvulnerable() then
      local units = FindUnitsInRadius(hero:GetTeam(), hero:GetAbsOrigin(), nil, 1300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      for _,unit in ipairs(units) do
        if unit.encounter and unit.encounter.WakeUp then unit.encounter:WakeUp() end
      end
    end
    return .5
  end)

  hero.truesightTimer = Timers:CreateTimer(.3, function()
    if hero:IsAlive() then
      local enemies = FindUnitsInRadius(hero:GetTeam(), hero:GetAbsOrigin(), nil, hero.truesightRadiusOverride or hero.truesightRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
      for i=1,#enemies do
        enemies[i]:AddNewModifier(hero, nil, "modifier_truesight", {duration=.5})
      end
    end
    return .3
  end)

  hero.visionTimer = Timers:CreateTimer(.1, function()
    if hero:IsAlive() then
      AddFOWViewer(hero:GetTeam(), hero:GetAbsOrigin(), hero.flyingVisionRadiusOverride or hero.flyingVisionRadius, .1, false)
    end
    return .1
  end)

  hero.contextTimer = Timers:CreateTimer(.3, function()
    -- prioritize valid jump down, valid jump up, tree climb
    hero.nearestJumpDown = nil
    hero.nearestJumpUp = nil
    hero.nearestTree = nil

    if not hero:IsAlive() then return .3 end

    local abilities = {"context_sensitive_ability", "jump_down", "jump_up", "climb_tree"}

    if hero:GetPhysicsVelocity() ~= Vector(0,0,0) then return .3 end

    local active = nil
    for i=1,#abilities do
      local abil = hero:FindAbilityByName(abilities[i])
      if not abil:IsHidden() then
        active = abil
        break
      end
    end

    if active == nil then return .3 end

    local origin = hero:GetAbsOrigin()
    local forward = hero:GetForwardVector()

    local mindist = 1000 * 1000
    local min = nil

    if hero.canJumpDown then
      local target = GetGroundPosition(origin + forward * 325, hero)
      local blocked = not GridNav:IsTraversable(target) or GridNav:IsBlocked(target)
      local zdiff = (origin.z - target.z)
      local nearTree = GridNav:IsNearbyTree(target, 150, true)

      if not blocked and zdiff > 72 and zdiff < 150 and not nearTree then
        blocked = false
        for i=32,160,32 do
          blocked = not GridNav:IsTraversable(origin + i*forward) or GridNav:IsBlocked(origin + i*forward)
          if blocked then
            break
          end
        end
        if blocked then 
          hero.nearestJumpDown = target 
          --DebugDrawCircle(target, Vector(0,0,200), 30, 10, true, .3)
          if active:GetAbilityName() ~= "jump_down" then
            hero:SwapAbilities(active:GetAbilityName(), "jump_down", false, true)
          end
          return .3
        else
          --DebugDrawCircle(target, Vector(200,200,200), 30, 10, true, .3)
        end
      else
        --DebugDrawCircle(target, Vector(200,200,0), 30, 10, true, .3)
      end
    end

    if hero.canJumpUp then
      local target = GetGroundPosition(origin + forward * 325, hero)
      local blocked = not GridNav:IsTraversable(target) or GridNav:IsBlocked(target)
      local zdiff = (target.z - origin.z)
      local nearTree = GridNav:IsNearbyTree(target, 150, true)

      if not blocked and zdiff > 72 and zdiff < 150 and not nearTree then
        blocked = false
        for i=32,160,32 do
          blocked = not GridNav:IsTraversable(origin + i*forward) or GridNav:IsBlocked(origin + i*forward)
          if blocked then
            break
          end
        end
        if blocked then 
          hero.nearestJumpUp = target 
          --DebugDrawCircle(target, Vector(0,0,200), 30, 10, true, .3)
          if active:GetAbilityName() ~= "jump_up" then
            hero:SwapAbilities(active:GetAbilityName(), "jump_up", false, true)
          end
          return .3
        else
          --DebugDrawCircle(target, Vector(200,200,200), 30, 10, true, .3)
        end
      else
        --DebugDrawCircle(target, Vector(200,200,0), 30, 10, true, .3)
      end
    end


    mindist = 1000 * 1000
    min = nil

    if hero.canClimbTrees then
      local trees = GridNav:GetAllTreesAroundPoint(origin, 64, true)

      for i=1,#trees do
        local tree = trees[i]
        local pos = tree:GetAbsOrigin()

        if math.abs(origin.z - pos.z) < 30 then
          local dist2 = VectorDistanceSq(pos, origin)
          if dist2 < mindist then
            mindist = dist2
            min = tree;
          end
          --DebugDrawCircle(pos, Vector(0,200,0), 30, 10, true, .3)
        end
      end
      if min then 
        hero.nearestTree = min 
        if active:GetAbilityName() ~= "climb_tree" then
          hero:SwapAbilities(active:GetAbilityName(), "climb_tree", false, true)
        end
        return .3
      end
    end


    if active:GetAbilityName() ~= "context_sensitive_ability" then
      hero:SwapAbilities(active:GetAbilityName(), "context_sensitive_ability", false, true)
    end

    return .3
  end)

  function hero:IsFriendlyHero(target)
    if target and target.IsHero and target:IsHero() and hero.aggroHeroes[target:entindex()] == nil then
      return true
    end

    return false
  end

  function hero:IsEnemyHero(target)
    if target and hero.aggroHeroes[target:entindex()] ~= nil then
      return true
    end

    return false
  end

  -- Called on every spawn of this hero
  function hero:OnSpawn()
    --hero:AddNewModifier(hero, nil, 'modifier_greevil_truesight', {true_sight_range = hero.truesightRadiusOverride or hero.truesightRadius})
    print('onspawn')
  end

	function hero:OnLand()
		--print('[HeroClass-Default] OnLand')
	end

	function hero:OnTakeOff()
		--print('[HeroClass-Default] OnTakeOff')
	end

	function hero:OnFrame()
		--print('[HeroClass-Default] OnPhysicsFrame')
	end

	function hero:OnDeath()
		--print('[HeroClass-Default] OnDeath')
		hero:SetPhysicsVelocity(Vector(0,0,hero:GetPhysicsVelocity().z))
		EndAnimation(hero)

		Timers:CreateTimer(1, function()
      print ('making ghost1')
      local ghost = CreateUnitByName("npc_ghost_hero", hero:GetAbsOrigin(), true, nil, nil, hero:GetTeam())
      ApplyModifier(ghost, ghost, "stunned", {duration=1.5})
      ApplyModifier(ghost, ghost, "modifier_ghost_hero", {})
      ApplyModifier(ghost, ghost, "modifier_ghost_time", {duration=30})
      ApplyModifier(ghost, ghost, "modifier_ghost_delay", {duration=10})
      hero.ghost = ghost
      ghost.hero = hero
      ghost:SetAbsOrigin(ghost:GetAbsOrigin() - Vector(0,0,300))
      print ('making ghost2')

      local count = 0

      Timers:CreateTimer(function()
        print ('making ghost4')
        ghost:SetAbsOrigin(ghost:GetAbsOrigin() + Vector(0,0,300/45))
        count = count + 1
        if count == 45 then
          print ('making ghost41')
          --if not PlayerResource:IsFakeClient(hero:GetPlayerID()) then
            --PlayerResource:SetOverrideSelectionEntity(hero:GetPlayerID(), ghost)
            print ('making ghost31')
            ghost:SetControllableByPlayer(hero:GetPlayerID(), true)
            print ('making ghost32')
            ghost:SetOwner(hero)
            ghost.ready = true
            print ('making ghost33')
            PlayerResource:SetCameraTarget(hero:GetPlayerID(), ghost)
            print('making ghost34')
          --end
          return
        end
        return .03
      end)

      Timers:CreateTimer(30, function()
        print ('making ghost5')
        if not hero:IsAlive() and hero.ghost == ghost then
          -- correct ghost
          local mindist = 10000 * 10000
          local shrine = nil
          local shrines = Entities:FindAllByName("*trigger_shrine")
          print(#shrines)

          for i=1,#shrines do
            local dist2 = VectorDistanceSq(shrines[i]:GetAbsOrigin(), ghost:GetAbsOrigin())
            if dist2 < mindist then
              mindist = dist2
              shrine = shrines[i]
            end
          end

          ApplyModifier(ghost, ghost, "modifier_ghost_resurrection", {})
          ghost:MoveToPosition(shrine:GetAbsOrigin())
        end
      end)
    end)
	end

	function hero:OnKillUnit(hero)
		--print('[HeroClass-Default] OnKillUnit')
	end
end

return HERODEFAULT