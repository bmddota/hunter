GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
GameRules:GetGameModeEntity():SetCameraDistanceOverride(-1)

local player = PlayerResource:GetPlayer(0)
local hero = player:GetAssignedHero()

hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
ApplyModifier(hero, hero, "dummy_unit", {})
hero:AddNoDraw()
PlayerResource:SetCameraTarget(0, nil)

local ents = Entities:FindAllByClassname("npc_dota_creature")
for _,ent in ipairs(ents) do
  ApplyModifier(ent, ent, "no_health_bar", {})
end

hero:AddNewModifier(hero, nil, "modifier_bloodseeker_thirst", {})
hero:FollowNavMesh(false)
hero:SetBaseMoveSpeed(1000)
hero:SetPhysicsFriction(0)
hero:SetPhysicsVelocity(Vector(0,0,0))

if points == nil then points = {} end

PrintTable(points)

points = {}
table.insert(points, Vector(-5974.158203,-6771.044434,640.000000))
table.insert(points, Vector(5878.156250,-6606.531250,1152.000000))
table.insert(points, Vector(5676.083008,4959.296875,480.598602))
table.insert(points, Vector(-6664.281250,6446.093750,1152.000000))
table.insert(points, Vector(-6416.625000,-3410.843750,768.000000))
table.insert(points, Vector(145.062500,-6289.843750,768.000000))
table.insert(points, Vector(65.906250,-76.250000,768.000000))

hero:MoveToPosition(points[1])

for _,point in ipairs(points) do

  
end

local pt = 1
local curPoint = points[pt]

if timer then Timers:RemoveTimer(timer) end

timer = Timers:CreateTimer(function()
  local rad2 = 200 * 200

  if VectorDistanceSq(hero:GetAbsOrigin(), points[pt]) < rad2 then
    pt = pt + 1
    curPoint = points[pt]

    if curPoint == nil then
      return
    end

    local wait = 5
    if pt >= 6 then wait = .01 end

    Timers:CreateTimer(wait, function()
      ExecuteOrderFromTable({
        UnitIndex = hero:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = curPoint,
        Queue = 1,
        })
      end)
  end

  return .03
end)