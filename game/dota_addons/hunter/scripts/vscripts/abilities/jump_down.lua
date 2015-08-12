function JumpDown(keys)
  local caster = keys.caster
  local ability = keys.ability

  local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel())

  if caster.nearestJumpDown then
    local target = caster.nearestJumpDown
    local origin = caster:GetAbsOrigin()
    local zdist = target.z - origin.z
    local xyvec = Vector(target.x,target.y,0) - Vector(origin.x,origin.y,0)
    local xydist = xyvec:Length()
    local xydir = xyvec:Normalized()

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
    caster:Stop()

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
    end)
  else
    ability:EndCooldown()
  end
end