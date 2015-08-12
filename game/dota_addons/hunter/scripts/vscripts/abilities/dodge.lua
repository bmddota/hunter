function OnSpellStart(keys)
  print('dodge, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  local point = keys.target_points[1]
  local direction = (point - caster:GetAbsOrigin()):Normalized()

  local ACT_FRAMES = 20
  local duration = .3
  local force = 1000

  ApplyModifier(caster, caster, "stunned", {duration=duration})

  --[[caster.cancelAction = function()
    print("CANCEL")
    StartAnimation(caster, {duration=.1, activity=ACT_DOTA_IDLE, rate=1.0})  
    --caster.animationEndTime = GameRules:GetGameTime()
    abil:EndCooldown()
    caster.cancelAction = nil
    Timers:RemoveTimer(abil.castPointTimer)
    --Timers:RemoveTimer(abil.lateTimer)
  end]]

  local particle = ParticleManager:CreateParticle("particles/hunter_dodge/dodge_sparrowhawk.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  --ParticleManager:ReleaseParticleIndex(particle)

  StartAnimation(caster, {duration=duration, activity=ACT_DOTA_RUN, rate=ACT_FRAMES / (30 * duration), translate="haste"})
  print('start')

  caster:SetForwardVector(direction)

  caster:PreventDI(false)
  caster:SetNavCollisionType(PHYSICS_NAV_SLIDE)
  caster:SetGroundBehavior(PHYSICS_GROUND_ABOVE)
  caster:FollowNavMesh(true)
  caster:Hibernate(true)
  caster:SetPhysicsVelocity(direction * force)
  caster:SetPhysicsFriction(0)
  caster:Stop()

  Timers:CreateTimer(duration, function()
    caster:SetPhysicsVelocity(Vector(0,0,0))
    caster:SetPhysicsFriction(caster.originalFriction or 0.05)
    ParticleManager:DestroyParticle(particle, false)
  end)
end
