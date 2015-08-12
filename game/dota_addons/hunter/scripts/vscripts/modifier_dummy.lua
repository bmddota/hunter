modifier_dummy = class({})

require('internal/util')
require('internal/eventtest')


function modifier_dummy:OnCreated(keys) 
  print('dummy_unit mod created')
  PrintTable(keys)

  print(IsServer())

  if not IsServer() then
    print(Convars:GetFloat("dota_camera_distance"))
    --print(Convars:SetFloat("dota_camera_distance", 1500))
    
    print('==============')
    GameMode:StartEventTest()
    ListenToGameEvent("test_event", Dynamic_Wrap(GameMode, "testevent"), GameMode)
    --PrintTable(_G)
  end
end

function GameMode:testevent(event)
  print('testevent client')
  PrintTable(event)

  local player = Convars:GetCommandClient()
  print(player)
  if player then
    print(player:entindex())
  end

  player = Convars:GetDOTACommandClient()
  print('----------')
  print(player)
  if player then
    print(player:entindex())
  end

  FireGameEvent("ttt", {data="sendback"})
end

function modifier_dummy:IsHidden() 
  print("------")
print('ishidden', IsServer())
print("-----")
  return true
end

function modifier_dummy:IsDebuff() 
  print("------")
print('IsDebuff', IsServer())
print("-----")
  return false
end

function modifier_dummy:IsPurgable() 
  print("------")
print('IsPurgable', IsServer())
print("-----")
  return false
end

--[[function modifier_dummy:DeclareFunction() 
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  }
 
  return funcs
end]]

function modifier_dummy:CheckState() 
  local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  }

  return state
end