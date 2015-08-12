local player = PlayerResource:GetPlayer(0)
local hero = player:GetAssignedHero()

Physics:Unit(hero)
hero:SetPhysicsFriction(hero.originalFriction)
hero:SetNavCollisionType(PHYSICS_NAV_SLIDE)
hero:FollowNavMesh(true)
hero:SetPhysicsAcceleration(hero.originalAcceleration)
hero:SetAutoUnstuck(false)
hero:SetVelocityClamp(10)

if timer then Timers:RemoveTimer(timer) end

timer = Timers:CreateTimer(.3, function()
  -- prioritize valid jump down, valid jump up, tree climb
  hero.nearestJumpDown = nil
  hero.nearestJumpUp = nil
  hero.nearestTree = nil

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

  --[[if hero.canJumpDown then
    local jumpdowns = Entities:FindAllByNameWithin("jump_down", origin, 300)

    for i=1,#jumpdowns do
      local jd = jumpdowns[i]
      local pos = jd:GetAbsOrigin()
      if origin.z > pos.z + 40 then
        print('jd -- ' .. tostring((pos - origin):Length()))
        local dist2 = VectorDistanceSq(pos, origin)
        if dist2 < mindist then
          mindist = dist2
          min = jd;
        end
        DebugDrawCircle(pos, Vector(0,0,200), 30, 10, true, .3)
      end
    end
    if min then 
      hero.nearestJumpDown = min 
      if active:GetAbilityName() ~= "jump_down" then
        hero:SwapAbilities(active:GetAbilityName(), "jump_down", false, true)
      end
      return .3
    end
  end


  mindist = 1000 * 1000
  min = nil

  if hero.canJumpUp then
    local highjumps = Entities:FindAllByNameWithin("jump_up", origin, 300)

    for i=1,#highjumps do
      local ju = highjumps[i]
      local pos = ju:GetAbsOrigin()

      if origin.z + 40 < pos.z then
        print('hj -- ' .. tostring((pos - origin):Length()))
        local dist2 = VectorDistanceSq(pos, origin)
        if dist2 < mindist then
          mindist = dist2
          min = ju;
        end
        DebugDrawCircle(pos, Vector(200,0,0), 30, 10, true, .3)
      end
    end
    if min then 
      hero.nearestJumpUp = min
      if active:GetAbilityName() ~= "jump_up" then
        hero:SwapAbilities(active:GetAbilityName(), "jump_up", false, true)
      end
      return .3
    end
  end]]


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