function OnSpellStart(keys)
  print('ranger_attack, onspellstart')

  local abil = keys.ability
  local caster = keys.caster
  local point = keys.target_points[1]
  --self.BaseClass.SetHidden(true)
  --abil:SetInAbilityPhase(true)

  local ACT_FRAMES = 30
  local duration = 1 / caster:GetAttacksPerSecond()

  caster.cancelAction = function()
    print("CANCEL")
    --StartAnimation(caster, {duration=.1, activity=ACT_DOTA_IDLE, rate=1.0})  
    EndAnimation(caster)
    --caster.animationEndTime = GameRules:GetGameTime()
    abil:EndCooldown()
    caster.cancelAction = nil
    Timers:RemoveTimer(abil.castPointTimer)
    --Timers:RemoveTimer(abil.lateTimer)
  end

  --if caster.animationEndTime and caster.animationEndTime + .067 > GameRules:GetGameTime() then
    --print('too soon', caster.animationEndTime + .067, GameRules:GetGameTime())
    --abil.lateTimer = Timers:CreateTimer(.067, function()
      --StartAnimation(caster, {duration=duration, activity=ACT_DOTA_ATTACK, rate=ACT_FRAMES / (30 * duration)})
    --end)
  --else
    StartAnimation(caster, {duration=duration, activity=ACT_DOTA_ATTACK, rate=ACT_FRAMES / (30 * duration)})
  --end

  abil.castPointTimer = Timers:CreateTimer(.45*duration, function()

    if keys.target ~= nil and keys.target ~= keys.caster then
      point = keys.target:GetAbsOrigin()
    end

    local dir = (point - caster:GetAbsOrigin())
    dir.z = 0
    dir = dir:Normalized()

    -- handle perfect origin click
    if dir == Vector(0,0,0) then
      dir = caster:GetForwardVector()
    end

    caster.cancelAction = nil
    abil:EndCooldown()
    abil:StartCooldown(.55*duration)

    local projectile = {
      EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
      vSpawnOrigin = caster:GetAbsOrigin() + Vector(0,0,100),--{unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
      fDistance = 800,
      fStartRadius = 100,
      fEndRadius = 100,
      Source = caster,
      fExpireTime = 8.0,
      vVelocity = dir * 2300,
      UnitBehavior = PROJECTILES_DESTROY,
      bMultipleHits = false,
      bIgnoreSource = true,
      TreeBehavior = PROJECTILES_NOTHING, -- PROJECTILES_DESTROY,
      bCutTrees = false,
      bTreeFullCollision = false,
      WallBehavior = PROJECTILES_NOTHING,
      GroundBehavior = PROJECTILES_NOTHING,
      fGroundOffset = 120,
      nChangeMax = 1,
      bRecreateOnChange = true,
      bZCheck = false,
      bGroundLock = true,
      bProvidesVision = true,
      iVisionRadius = 200,
      iVisionTeamNumber = caster:GetTeam(),
      bFlyingVision = false,
      fVisionTickTime = .1,
      fVisionLingerDuration = .1,
      --draw = true,
      --iPositionCP = 0,
      --iVelocityCP = 1,
      --ControlPoints = {[5]=Vector(100,0,0), [10]=Vector(0,0,1)},
      --ControlPointForwards = {[4]=caster:GetForwardVector() * -1},
      --ControlPointOrientations = {[1]={caster:GetForwardVector() * -1, caster:GetForwardVector() * -1, caster:GetForwardVector() * -1}},
      --[[ControlPointEntityAttaches = {[0]={
        unit = caster,
        pattach = PATTACH_ABSORIGIN_FOLLOW,
        attachPoint = "attach_attack1", -- nil
        origin = Vector(0,0,0)
      }},]]
      --fRehitDelay = .3,
      --fChangeDelay = 1,
      --fRadiusStep = 10,
      --bUseFindUnitsInRadius = false,

      UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= caster:GetTeamNumber() and not unit:IsInvulnerable() and not caster:IsFriendlyHero(unit) end,
      OnUnitHit = function(self, unit) 
        print ('HIT UNIT: ' .. unit:GetUnitName())
        local nDamageAmount = caster:GetAverageTrueAttackDamage() + abil:GetAbilityDamage() + RandomInt( 0, 10 ) - 5
        ApplyDamage( {
          victim = unit,
          attacker = caster,
          damage = nDamageAmount,
          damage_type = DAMAGE_TYPE_PHYSICAL,
          damage_flags = DOTA_DAMAGE_FLAG_NONE,
          ability = abil
        } )
      end,
      --OnTreeHit = function(self, tree) ... end,
      --OnWallHit = function(self, gnvPos) ... end,
      --OnGroundHit = function(self, groundPos) ... end,
      --OnFinish = function(self, pos) ... end,
    }

    Projectiles:CreateProjectile(projectile)

    
  end)
end
