local SPAWNS = {}
local ROAMERS = {}
local CAMPS = {}
local BOSSES = {}

local PATHCOUNT={
  ["corner_sjungle"]=1,
  ["corner_wjungle"]=1,
  ["corner_nwjungle"]=1,
  ["corner_nejungle"]=1,
  ["corner_ejungle"]=1,
  ["corner_sejungle"]=1,

  ["corner_sforest"]=1,
  ["corner_wforest"]=1,
  ["corner_swforest"]=2,

  ["corner_wriver"]=1,
  ["corner_eriver"]=1,
  ["corner_lake"]=1,

  ["corner_stone"]=1,
  ["corner_sdesert"]=2,
  ["corner_edesert"]=2,
  ["corner_plateau"]=1,

  ["corner_mine"]=2,

  ["corner_nsnow"]=1,
  ["corner_wsnow"]=1,
  ["corner_snowgarden"]=1,
}

local PATHAREA = {
  ["corner_sjungle"]=AREA_JUNGLE,
  ["corner_wjungle"]=AREA_JUNGLE,
  ["corner_nwjungle"]=AREA_JUNGLE,
  ["corner_nejungle"]=AREA_JUNGLE,
  ["corner_ejungle"]=AREA_JUNGLE,
  ["corner_sejungle"]=AREA_JUNGLE,

  ["corner_sforest"]=AREA_FOREST,
  ["corner_wforest"]=AREA_FOREST,
  ["corner_swforest"]=AREA_FOREST,

  ["corner_wriver"]=AREA_LAKE,
  ["corner_eriver"]=AREA_LAKE,
  ["corner_lake"]=AREA_LAKE,

  ["corner_stone"]=AREA_DESERT,
  ["corner_sdesert"]=AREA_DESERT,
  ["corner_edesert"]=AREA_DESERT,
  ["corner_plateau"]=AREA_DESERT,

  ["corner_mine"]=AREA_MINE,

  ["corner_nsnow"]=AREA_SNOW,
  ["corner_wsnow"]=AREA_SNOW,
  ["corner_snowgarden"]=AREA_SNOW,
}

local CAMPCOUNT = {
  [AREA_JUNGLE] = .8,
  [AREA_DESERT] = .8,
  [AREA_FOREST] = .8,
  [AREA_SNOW] = .8,
  [AREA_LAKE] = .8,
  [AREA_MINE] = .8,
  [AREA_CASTLE] = .8,
}

--"corner_track"
ROAMERS[AREA_JUNGLE] = {
  {name="wolf_roamer", rarity=1, difficulty=1},
  {name="razorback_roamer", rarity=1, difficulty=1},
}

ROAMERS[AREA_DESERT] = {
  {name="sand_king_roamer", rarity=1, difficulty=1},
  {name="desert_harpy_roamer", rarity=1, difficulty=1},
}

ROAMERS[AREA_FOREST] = {
  {name="forest_roamer", rarity=1, difficulty=1},
  {name="treant_roamer", rarity=1, difficulty=1},
}

ROAMERS[AREA_SNOW] = {
  {name="frost_wolf_roamer", rarity=1, difficulty=1},
  {name="snow_gnoll_roamer", rarity=1, difficulty=1},
}

ROAMERS[AREA_LAKE] = {
  {name="shroom_roamer", rarity=1, difficulty=1},
  {name="satyr_roamer", rarity=1, difficulty=1},
}

ROAMERS[AREA_MINE] = {
  {name="mine_wolf_roamer", rarity=1, difficulty=1},
  {name="mine_golem_roamer", rarity=1, difficulty=1},
}

ROAMERS[AREA_CASTLE] = {
  
}




CAMPS[AREA_JUNGLE] = {
  {name="wolf_camp", rarity=1, difficulty=1},
  {name="zombie_camp", rarity=1, difficulty=1},
  {name="snake_camp", rarity=1, difficulty=1},
  {name="mega_greevil", rarity=.5, difficulty=2},
  {name="gold_zombie_camp", rarity=.2, difficulty=1},
}

CAMPS[AREA_DESERT] = {
  {name="desert_centaur_camp", rarity=1, difficulty=1},
  {name="golem_camp", rarity=1, difficulty=1},
}

CAMPS[AREA_FOREST] = {
  {name="warrior_camp", rarity=1, difficulty=1},
  {name="forest_bear_camp", rarity=1, difficulty=1},
}

CAMPS[AREA_SNOW] = {
  {name="zombie_camp", rarity=1, difficulty=1},
  {name="snow_archer_camp", rarity=1, difficulty=1},
  {name="snow_bear_camp", rarity=1, difficulty=1},
}

CAMPS[AREA_LAKE] = {
  {name="mega_greevil", rarity=.5, difficulty=2},
  {name="snake_camp", rarity=1, difficulty=1},
  {name="gold_zombie_camp", rarity=.2, difficulty=1},
}

CAMPS[AREA_MINE] = {
  {name="warrior_camp", rarity=1, difficulty=1},
  {name="mine_spider_camp", rarity=1, difficulty=1},
}

CAMPS[AREA_CASTLE] = {
  
}


BOSSES[AREA_JUNGLE] = {
}

BOSSES[AREA_DESERT] = {
  {name="morphling_boss", rarity=1, difficulty=1},
}

BOSSES[AREA_FOREST] = {
  {name="timbersaw_boss", rarity=1, difficulty=1},
}

BOSSES[AREA_SNOW] = {
  {name="ww_boss", rarity=1, difficulty=1},
}

BOSSES[AREA_LAKE] = {
  
}

BOSSES[AREA_MINE] = {
  {name="sf_boss", rarity=1, difficulty=1},
}

BOSSES[AREA_CASTLE] = {
  
}



SPAWNS.pathToArea = PATHAREA
SPAWNS.campCount = CAMPCOUNT
SPAWNS.pathCount = PATHCOUNT
SPAWNS.roamers = ROAMERS
SPAWNS.camps = CAMPS
SPAWNS.bosses = BOSSES
return SPAWNS