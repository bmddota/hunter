function ClimbTree(keys)
  local caster = keys.caster
  local ability = keys.ability

  local duration = ability:GetLevelSpecialValueFor("climb_duration", ability:GetLevel())

  if caster.nearestTree then
    local origin = caster:GetAbsOrigin()
    ability.startOrigin = origin
    local target = caster.nearestTree:GetAbsOrigin() + Vector(0,0,240)
    local zdist = target.z - origin.z
    local xyvec = Vector(target.x,target.y,0) - Vector(origin.x,origin.y,0)
    local xydist = xyvec:Length()
    local xydir = xyvec:Normalized()

    caster:PreventDI(true)
    --caster:StartGesture(ACT_DOTA_FLAIL)
    caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
    caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
    caster:FollowNavMesh(false)
    caster:Hibernate(false)
    caster:SetAutoUnstuck(false)
    caster:StartGesture(ACT_DOTA_RUN)
    caster:SetPhysicsFriction(0)

    caster:SetForwardVector(xydir)
    caster:SetPhysicsAcceleration(Vector(0,0,0))
    caster:SetPhysicsVelocity(xydir * (xydist / duration) + Vector(0,0,zdist/duration))
    ApplyModifier(caster, caster, "stunned", {duration=duration})
    caster:Stop()

    caster:SwapAbilities("climb_tree", "climb_down", false, true)
    local climbdown = caster:FindAbilityByName("climb_down")
    climbdown:EndCooldown()
    climbdown:StartCooldown(duration + .1)

    Timers:CreateTimer(duration, function()
      duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel())
      caster:PreventDI(true)
      caster:SetNavCollisionType(PHYSICS_NAV_NOTHING)
      caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
      caster:FollowNavMesh(false)
      caster:Hibernate(false)
      caster:RemoveGesture(ACT_DOTA_FLAIL)
      caster:SetPhysicsAcceleration(Vector(0,0,0))
      caster:SetPhysicsVelocity(Vector(0,0,0))

      caster:SetAbsOrigin(target)

      caster:RemoveGesture(ACT_DOTA_RUN)
      caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)

      local radius = caster:GetNightTimeVisionRange()
      if GameRules:IsDaytime() then radius = caster:GetDayTimeVisionRange() end

      caster.flyingVisionRadiusOverride = radius
      ApplyModifier(caster, caster, "tree_climbed", {duration=duration})

      ability.complete = function()
        target = ability.startOrigin
        origin = caster:GetAbsOrigin()
        zdist = target.z - origin.z
        xyvec = Vector(target.x,target.y,0) - Vector(origin.x,origin.y,0)
        xydist = xyvec:Length()
        xydir = xyvec:Normalized()
        duration = ability:GetLevelSpecialValueFor("jump_duration", ability:GetLevel())

        caster:StartPhysicsSimulation()
        caster:PreventDI(true)
        --caster:StartGesture(ACT_DOTA_FLAIL)
        caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
        caster:SetGroundBehavior(PHYSICS_GROUND_NONE)
        caster:FollowNavMesh(false)
        caster:Hibernate(false)
        caster:StartGesture(ACT_DOTA_FLAIL)
        caster:SetPhysicsFriction(0)

        caster:SetForwardVector(xydir)
        caster:SetPhysicsAcceleration(Vector(0,0, zdist * 2 / (duration * duration)))
        caster:SetPhysicsVelocity(xydir * (xydist / duration))
        ApplyModifier(caster, caster, "stunned", {duration=duration})
        caster:RemoveModifierByName("tree_climbed")
        caster:Stop()
        caster.flyingVisionRadiusOverride = nil
        caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)

        Timers:CreateTimer(duration, function()
          FindClearSpaceForUnit(caster, target, false)
          caster:PreventDI(false)
          caster:SetNavCollisionType(PHYSICS_NAV_HALT)
          caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
          caster:FollowNavMesh(true)
          caster:Hibernate(true)
          caster:RemoveGesture(ACT_DOTA_FLAIL)
          caster:SetPhysicsAcceleration(caster.originalAcceleration)
          caster:SetPhysicsVelocity(Vector(0,0,0))
          caster:SetPhysicsFriction(caster.originalFriction or 0.05)

          caster:SwapAbilities("climb_tree", "climb_down", true, false)
        end)
 
      end

      ability.timer = Timers:CreateTimer(duration, ability.complete)
    end)
    
  else
    ability:EndCooldown()
  end
end