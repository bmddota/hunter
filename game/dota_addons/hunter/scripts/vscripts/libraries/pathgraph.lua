PATHGRAPH_VERSION = "0.80"

--[[
  Lua-controlled Animations Library by BMD

  Installation
  -"require" this file inside your code in order to gain access to the StartAnmiation and EndAnimation global.
  -Additionally, ensure that this file is placed in the vscripts/libraries path and that the vscripts/libraries/modifiers/modifier_animation.lua, modifier_animation_translate.lua, and modifier_animation_translate_permanent.lua files exist and are in the correct path

  Usage
  -Animations can be started for any unit and are provided as a table of information to the StartAnimation call
  -Repeated calls to StartAnimation for a single unit will cancel any running animation and begin the new animation
  -EndAnimation can be called in order to cancel a running animation
  -Animations are specified by a table which has as potential parameters:
    -duration: The duration to play the animation.  The animation will be cancelled regardless of how far along it is at the end fo the duration.
    -activity: An activity code which will be used as the base activity for the animation i.e. DOTA_ACT_RUN, DOTA_ACT_ATTACK, etc.
    -rate: An optional (will be 1.0 if unspecified) animation rate to be used when playing this animation.
    -translate: An optional translate activity modifier string which can be used to modify the animation sequence.
      Example: For ACT_DOTA_RUN+haste, this should be "haste"
    -translate2: A second optional translate activity modifier string which can be used to modify the animation sequence further.
      Example: For ACT_DOTA_ATTACK+sven_warcry+sven_shield, this should be "sven_warcry" or "sven_shield" while the translate property is the other translate modifier
  -A permanent activity translate can be applied to a unit by calling AddAnimationTranslate for that unit.  This allows for a permanent "injured" or "aggressive" animation stance.
  -Permanent activity translate modifiers can be removed with RemoveAnimationTranslate.

  Notes
  -Animations can only play for valid activities/sequences possessed by the model the unit is using.
  -Sequences requiring 3+ activity modifier translates (i.e "stun+fear+loadout" or similar) are not possible currently in this library.
  -Calling EndAnimation and attempting to StartAnimation a new animation for the same unit withing ~2 server frames of the animation end will likely fail to play the new animation.  
    Calling StartAnimation directly without ending the previous animation will automatically add in this delay and cancel the previous animation.
  -The maximum animation rate which can be used is 12.75, and animation rates can only exist at a 0.05 resolution (i.e. 1.0, 1.05, 1.1 and not 1.06)
  -StartAnimation and EndAnimation functions can also be accessed through GameRules as GameRules.StartAnimation and GameRules.EndAnimation for use in scoped lua files (triggers, vscript ai, etc)
  -This library requires that the "libraries/timers.lua" be present in your vscripts directory.

  Examples:
  --Start a running animation at 2.5 rate for 2.5 seconds
    StartAnimation(unit, {duration=2.5, activity=ACT_DOTA_RUN, rate=2.5})

  --End a running animation
    EndAnimation(unit)

  --Start a running + hasted animation at .8 rate for 5 seconds
    StartAnimation(unit, {duration=5, activity=ACT_DOTA_RUN, rate=0.8, translate="haste"})

  --Start a shield-bash animation for sven with variable rate
    StartAnimation(unit, {duration=1.5, activity=ACT_DOTA_ATTACK, rate=RandomFloat(.5, 1.5), translate="sven_warcry", translate2="sven_shield"})

  --Start a permanent injured translate modifier
    AddAnimationTranslate(unit, "injured")

  --Remove a permanent activity translate modifier
    RemoveAnimationTranslate(unit)

]]

if not PathGraph then
  PathGraph = class({})
end

local TableCount = function(t)
  local n = 0
  for _ in pairs( t ) do
    n = n + 1
  end
  return n
end

function PathGraph:Initialize()
  local corners = Entities:FindAllByClassname('path_corner')
  local points = {} 
  for _,corner in ipairs(corners) do
    points[corner:entindex()] = corner
  end

  local names = {}

  for _,corner in ipairs(corners) do
    local name = corner:GetName()
    if names[name] ~= nil then
      print("[PathGraph] Initialization error, duplicate path_corner named '" .. name .. "' found. Skipping...")
    else
      local parents = Entities:FindAllByTarget(corner:GetName())
      corner.edges = corner.edges or {}
      
      for _,parent in ipairs(parents) do
        corner.edges[parent:entindex()] = parent
        parent.edges = parent.edges or {}
        parent.edges[corner:entindex()] = corner
      end
    end
  end
end

function PathGraph:DrawPaths(pathCorner, duration, color)
  duration = duration or 10
  color = color or Vector(255,255,255)
  if pathCorner ~= nil then
    if pathCorner:GetClassname() ~= "path_corner" or pathCorner.edges == nil then
      print("[PathGraph] An invalid path_corner was passed to PathGraph:DrawPaths.")
      return
    end

    local seen = {}
    local toDo = {pathCorner}

    repeat 
      local corner = table.remove(toDo)
      local edges = corner.edges
      DebugDrawCircle(corner:GetAbsOrigin(), color, 50, 20, true, duration)
      seen[corner:entindex()] = corner

      for index,edge in pairs(edges) do
        if seen[index] == nil then
          DebugDrawLine_vCol(corner:GetAbsOrigin(), edge:GetAbsOrigin(), color, true, duration)
          table.insert(toDo, edge)
        end
      end
    until (#toDo == 0)
  else
    local corners = Entities:FindAllByClassname('path_corner')
    local points = {} 
    for _,corner in ipairs(corners) do
      points[corner:entindex()] = corner
    end

    repeat 
      local seen = {}
      local k,v = next(points)
      local toDo = {v}

      repeat 
        local corner = table.remove(toDo)
        points[corner:entindex()] = nil
        local edges = corner.edges
        DebugDrawCircle(corner:GetAbsOrigin(), color, 50, 20, true, duration)
        seen[corner:entindex()] = corner

        for index,edge in pairs(edges) do
          if seen[index] == nil then
            DebugDrawLine_vCol(corner:GetAbsOrigin(), edge:GetAbsOrigin(), color, true, duration)
            table.insert(toDo, edge)
          end
        end
      until (#toDo == 0)
    until (TableCount(points) == 0)
  end
end

--PathGraph:Initialize()

GameRules.PathGraph = PathGraph