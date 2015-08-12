function ApplyModifier(source, target, name, args)
  if not GameRules.ModApplier then GameRules.ModApplier = ModApplier end
  GameRules.ModApplier:ApplyDataDrivenModifier(source, target, name, args)
end

function RandomFromTable(t, exclude)
  local array = {}
  local n = 0
  for _,v in pairs(t) do
    if v ~= exclude then
      array[#array+1] = v
      n = n + 1
    end
  end

  if n == 0 then return nil end

  return array[RandomInt(1,n)]
end

function TableCount(t)
  local n = 0
  for _ in pairs( t ) do
    n = n + 1
  end
  return n
end

function GetItemByName( unit, name )
  for i=0,11 do
    local item = unit:GetItemInSlot( i )
    if item ~= nil then
      local lname = item:GetAbilityName()
      if lname == name then
        return item
      end
    end
  end

  return nil
end

function DifficultyFactor(n, perc)
  local r = 0
  for i=1,n do 
    r = r + math.pow((100-perc)/100, i-1)
  end

  return r*perc
end