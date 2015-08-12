function OnAbilityPhaseStart(keys)
  print('OnAbilityPhaseStart')
  local caster = keys.caster
  local abil = keys.ability

  local ACT_FRAMES = 39
  local duration = .8

  abil.particle = ParticleManager:CreateParticle("particles/econ/items/windrunner/windrunner_cape_cascade/windrunner_windrun_magic_trail_cascade.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  --abil.particle = ParticleManager:CreateParticle("particles/hunter_ranger/ranger_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
  

  StartAnimation(caster, {duration=duration+.2, activity=ACT_DOTA_CAST_ABILITY_2, rate=ACT_FRAMES / (30 * duration)})
end

function OnAbilityPhaseInterrupted(keys)
  print('OnAbilityPhaseStart')
  local caster = keys.caster
  local abil = keys.ability

  EndAnimation(caster)

  ParticleManager:DestroyParticle(abil.particle, false) 
end

function OnSpellStart(keys)
  print('ranger_split_shot, onspellstart')

  local caster = keys.caster
  local abil = keys.ability

  StartAnimation(caster, {duration=.2, activity=ACT_DOTA_OVERRIDE_ABILITY_2, rate=1.5})

  local particle = abil.particle

  Timers:CreateTimer(1, function() ParticleManager:DestroyParticle(particle, false) end)

  

  local sweep_angle = 50
  local shots = 4
  local distance = 600
  local speed = 1500

  local start_angle = -.5 * sweep_angle 
  local angle_step = sweep_angle / shots

  for i=1,shots do

    local dir = caster:GetForwardVector()
    dir.z = 0
    dir = RotatePosition(Vector(0,0,0), QAngle(0,start_angle + (i-1) * angle_step,0), dir:Normalized())

    local projectile = {
      EffectName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf",
      vSpawnOrigin = caster:GetAbsOrigin() + Vector(0,0,100),--{unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},
      fDistance = distance,
      fStartRadius = 100,
      fEndRadius = 100,
      Source = caster,
      fExpireTime = 8.0,
      vVelocity = dir * speed,
      UnitBehavior = PROJECTILES_NOTHING,
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
  end
end
