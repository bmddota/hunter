function bushStart(trigger)
  print('bush start')
  print(trigger.activator:GetClassname())

  local hero = trigger.activator

  if hero.IsRealHero and hero:IsRealHero()then
    hero.isInBushes = true
    if hero.canHideInBushes and not hero:HasModifier("modifier_bush_hiding") and not hero:HasModifier("modifier_bush_hidden") then
      ApplyModifier(hero, hero, "modifier_bush_hiding", {duration=hero.bushHideTime})
    end
  end
end

function bushEnd(trigger)
  print('bush end')
  print(trigger.activator:GetClassname())

  local hero = trigger.activator

  if hero.IsRealHero and hero:IsRealHero() then
    hero.isInBushes = false
    Timers:CreateTimer(.2, function()
      if not hero.isInBushes then
        hero:RemoveModifierByName("modifier_bush_hiding")
      end
    end)

    if hero:HasModifier("modifier_bush_hidden") then
      Timers:CreateTimer(.5, function()
        if not hero.isInBushes then
          hero:RemoveModifierByName("modifier_bush_hidden")
          hero:RemoveModifierByName("modifier_invisible")
        end
      end)
    end
  end
end


function waterStart(trigger)
  print('water start')
  print(trigger.activator:GetClassname())
end

function waterEnd(trigger)
  print('water end')
  print(trigger.activator:GetClassname())
end

function shrineEnd(trigger)
  print('shrine end')
  print(trigger.activator:GetClassname())

  local ghost = trigger.activator

  if ghost.GetUnitName and ghost:GetUnitName() == "npc_ghost_hero" then
    if ghost.resTimer then
      Timers:RemoveTimer(ghost.resTimer)
      ghost.resTimer = nil
    end
  end
end

function shrineStart(trigger)
  print('shrine start')
  print(trigger.activator:GetClassname())

  local ghost = trigger.activator


  if ghost.GetUnitName and ghost:GetUnitName() == "npc_ghost_hero" then
    if ghost:HasModifier("modifier_ghost_delay") then
      Notifications:Bottom(ghost.hero:GetPlayerID(), {text="You can't ressurect yet.", style={color='red'}, duration=1.5})
    end
    ghost.resTimer = Timers:CreateTimer(function()
      if not ghost:HasModifier("modifier_ghost_delay") then
        print('ghost')
        local hero = ghost.hero

        if not PlayerResource:IsFakeClient(hero:GetPlayerID()) then
          PlayerResource:SetOverrideSelectionEntity(hero:GetPlayerID(), hero)
          PlayerResource:SetCameraTarget(hero:GetPlayerID(), hero)
        end

        hero:SetRespawnPosition(ghost:GetAbsOrigin())
        hero:RespawnHero(false, false, false)
        ghost:RemoveSelf()

        hero.ghost = nil

        return
      end
      return .3
    end)
    
  end
end