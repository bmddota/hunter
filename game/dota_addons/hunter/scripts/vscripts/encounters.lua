local ENCOUNTERS = {}

-------------
-- JUNGLE
-------------
--wolf roamer
ENCOUNTERS["wolf_roamer"] = {
  units = {
    {name="npc_big_wolf"},
    {name="npc_wolf", offset=Vector(-75,-75,0)},
    {name="npc_wolf", offset=Vector(75,-75,0)},
  },
  --[[
  units = function()
    return {
      {name="npc_big_wolf"},
      {name="npc_wolf", offset=Vector(-75,-75,0)},
      {name="npc_wolf", offset=Vector(75,-75,0), facing = Vector(-1,1,0)},
    }
  end
  ]]
  --type = "roamer",
  --pathingType = {type=RoamerEncounter.RANDOM, startChance=.1, stopChance=.25, roamingSpeed=200},
  --leashRange = 1000,
  --thinkDelay = .5,
}

-- wolf_camp
ENCOUNTERS["wolf_camp"] = {
  units = function()
    local t = {{name="npc_big_wolf"}}
    local num = RandomInt(2,4)
    for i=2,num do
      local offset = RandomVector(110)
      table.insert(t,{name="npc_big_wolf", offset=offset})--, offset = RandomVector(RandomFloat(100,300))})
    end

    return t
  end,
  --type = "guard"
}


ENCOUNTERS["mega_greevil"] = {
  units = {
    {name="npc_mega_greevil"}
  }
}

ENCOUNTERS["zombie_camp"] = {
  units = {
    {name="npc_big_zombie"},
    {name="npc_zombie", offset=Vector(-50,-50,0)},
    {name="npc_zombie", offset=Vector(-100,25,0)},
    {name="npc_zombie", offset=Vector(50,-50,0)},
    {name="npc_zombie", offset=Vector(100,25,0)},
  }
}

ENCOUNTERS["gold_zombie_camp"] = {
  units = {
    {name="npc_big_gold_zombie"},
    {name="npc_zombie", offset=Vector(-50,-50,0)},
    {name="npc_zombie", offset=Vector(-100,25,0)},
    {name="npc_zombie", offset=Vector(50,-50,0)},
    {name="npc_zombie", offset=Vector(100,25,0)},
  } 
}

ENCOUNTERS["razorback_roamer"] = {
  units = {
    {name="npc_razorback"},
    {name="npc_razorback", offset=Vector(0,-150,0)},
  },
  pathingType = {type=RoamerEncounter.FORWARD, startChance=.1, stopChance=.25, roamingSpeed=200},
}

ENCOUNTERS["snake_camp"] = {
  units = {
    {name="npc_snake"},
    {name="npc_snake", offset=Vector(-50,-50,0)},
    {name="npc_snake", offset=Vector(50,-50,0)},
  } 
}


-------------
-- DESERT
-------------
ENCOUNTERS["sand_king_roamer"] = {
  units = {
    {name="npc_sand_king_roamer"},
  },
  pathingType = {type=RoamerEncounter.RANDOM, roamingSpeed=270},--startChance=.1, stopChance=.25
}

ENCOUNTERS["desert_harpy_roamer"] = {
  units = {
    {name="npc_desert_harpy", offset=Vector(-50,0,0)},
    {name="npc_desert_harpy", offset=Vector(50,0,0)},
  },
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=225},
}

ENCOUNTERS["desert_centaur_camp"] = {
  units = {{name="npc_desert_centaur"},
          {name="npc_desert_centaur_small", offset=Vector(75,-75,0)}}
}

ENCOUNTERS["golem_camp"] = {
  units = function()
    local t = {}
    local roll = RandomFloat(0,1)

    if roll < .3 then
      t = {{name="npc_big_rock_golem"},
        {name="npc_rock_golem", offset=Vector(-100,-100,0)},
        {name="npc_rock_golem", offset=Vector(100,-100,0)}}
    elseif roll < .6 then
      t = {{name="npc_big_rock_golem"},
        {name="npc_rock_golem", offset=Vector(0,-100,0)}}
    else
      t = {{name="npc_rock_golem", offset=Vector(-100,-100,0)},
        {name="npc_rock_golem", offset=Vector(100,-100,0)}}
    end

    return t
  end,
}


--thunder lizard
--"models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl"
--"models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_small.vmdl"

-- black minion gold
--"models/items/undying/idol_of_ruination/ruin_wight_minion_gold.vmdl"
-- gold crawler
--"models/items/undying/idol_of_ruination/ruin_wight_minion_torso.vmdl"
-- black gold crawler
--"models/items/undying/idol_of_ruination/ruin_wight_minion_torso_gold.vmdl"


--red roshan
--"models/creeps/baby_rosh_halloween/baby_rosh_dire/baby_rosh_dire.vmdl"
--green roshan
--"models/creeps/baby_rosh_halloween/baby_rosh_radiant/baby_rosh_radiant.vmdl"


-------------
-- FOREST
-------------
ENCOUNTERS["warrior_camp"] = {
  units = {
    {name="npc_red_warrior"},
    {name="npc_red_warrior", offset=Vector(-50,-50,0)},
  }
}

ENCOUNTERS["forest_bear_camp"] = {
  units = {
    {name="npc_forest_bear"},
  }
}

ENCOUNTERS["forest_roamer"] = {
  units = {
    {name="npc_forest_warrior"},
    {name="npc_forest_archer", offset=Vector(-50,-50,0)},
  },
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=270},
}

ENCOUNTERS["treant_roamer"] = {
  units = {
    {name="npc_treant"},
  },
  pathingType = {type=RoamerEncounter.FORWARD, startChance=.1, stopChance=.25, roamingSpeed=200},
}

-------------
-- SNOW
-------------

ENCOUNTERS["snow_archer_camp"] = {
  units = {
    {name="npc_snow_archer"},
    {name="npc_snow_archer", offset=Vector(-50,-50,0)},
    {name="npc_snow_archer", offset=Vector(50,-50,0)},
  }
}

ENCOUNTERS["snow_bear_camp"] = {
  units = {
    {name="npc_snow_bear"},
  }
}


ENCOUNTERS["snow_gnoll_roamer"] = {
  units = function()
    local t = {{name="npc_snow_gnoll"}}
    local num = RandomInt(2,5)
    for i=2,num do
      local offset = RandomVector(110)
      table.insert(t,{name="npc_snow_gnoll", offset=offset})--, offset = RandomVector(RandomFloat(100,300))})
    end

    return t
  end,
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=250},
}

ENCOUNTERS["frost_wolf_roamer"] = {
  units = function()
    local t = {{name="npc_frost_wolf"}}
    local num = RandomInt(2,4)
    for i=2,num do
      local offset = RandomVector(110)
      table.insert(t,{name="npc_frost_wolf", offset=offset})--, offset = RandomVector(RandomFloat(100,300))})
    end

    return t
  end,
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=250},
}



--lone druid true forms, lone druid bears


-------------
-- LAKE
-------------
ENCOUNTERS["shroom_roamer"] = {
  units = function()
    local t = {{name="npc_big_shroom"}}
    local num = RandomInt(1,2)
    for i=1,num do
      local offset = RandomVector(110)
      table.insert(t,{name="npc_shroom", offset=offset})--, offset = RandomVector(RandomFloat(100,300))})
    end

    return t
  end,
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=250},
}

ENCOUNTERS["satyr_roamer"] = {
  units = function()
    local t = {{name="npc_blue_satyr"}}
    local num = RandomInt(1,2)
    for i=1,num do
      local offset = RandomVector(110)
      table.insert(t,{name="npc_white_satyr", offset=offset})--, offset = RandomVector(RandomFloat(100,300))})
    end

    return t
  end,
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=250},
}

--crocodile
--"models/creeps/neutral_creeps_desert/n_creep_crocoglodi/n_creep_crocoglodi_model.vmdl"

-------------
-- MINE
-------------

ENCOUNTERS["mine_spider_camp"] = {
  units = {
    {name="npc_mine_spider"},
    {name="npc_mine_spiderling", offset=Vector(-50,-100,0)},
    {name="npc_mine_spiderling", offset=Vector(-100,-25,0)},
    {name="npc_mine_spiderling", offset=Vector(50,-100,0)},
    {name="npc_mine_spiderling", offset=Vector(100,-25,0)},
  }
}

ENCOUNTERS["mine_golem_roamer"] = {
  units = {
    {name="npc_mine_golem"},
  }
}

ENCOUNTERS["mine_wolf_roamer"] = {
  units = function()
    local t = {{name="npc_mine_wolf"}}
    local num = RandomInt(2,4)
    for i=2,num do
      local offset = RandomVector(110)
      table.insert(t,{name="npc_mine_wolf", offset=offset})--, offset = RandomVector(RandomFloat(100,300))})
    end

    return t
  end,
  pathingType = {type=RoamerEncounter.FORWARD, roamingSpeed=250},
}

--golem
--"models/heroes/warlock/warlock_demon.vmdl"
--"models/items/warlock/golem/ahmhedoq/ahmhedoq.vmdl"
--"models/items/warlock/golem/doom_of_ithogoaki/doom_of_ithogoaki.vmdl"
--"models/items/warlock/golem/grimoires_pitlord_ultimate/grimoires_pitlord_ultimate.vmdl"
--"models/items/warlock/golem/obsidian_golem/obsidian_golem.vmdl"
--"models/items/warlock/golem/tevent_2_gatekeeper_golem/tevent_2_gatekeeper_golem.vmdl"
--"models/items/warlock/golem/the_torchbearer/the_torchbearer.vmdl"

--spiderlings
--"models/items/broodmother/spiderling/perceptive_spiderling/perceptive_spiderling.vmdl"
--"models/items/broodmother/spiderling/spiderling_dlotus_red/spiderling_dlotus_red.vmdl"
--"models/items/broodmother/spiderling/thistle_crawler/thistle_crawler.vmdl"
--"models/items/broodmother/spiderling/virulent_matriarchs_spiderling/virulent_matriarchs_spiderling.vmdl"

--fire elementals
--"models/items/invoker/forge_spirit/infernus/infernus.vmdl"
--"models/items/invoker/forge_spirit/sempiternal_revelations_forged_spirits/sempiternal_revelations_forged_spirits.vmdl"
--"models/items/invoker/forge_spirit/iceforged_spirit/iceforged_spirit.vmdl"
--"models/items/invoker/forge_spirit/arsenal_magus_forged_spirit/arsenal_magus_forged_spirit.vmdl"
--"models/items/invoker/forge_spirit/cadenza_spirit/cadenza_spirit.vmdl"
--"models/items/invoker/forge_spirit/grievous_ingots/grievous_ingots.vmdl"


-------------
-- CASTLE
-------------
--mega guard
--"models/creeps/lane_creeps/creep_bad_melee/creep_bad_melee_mega.vmdl"

--mega raange
--"models/creeps/lane_creeps/creep_bad_ranged/lane_dire_ranged_mega.vmdl"

--demon
--"models/heroes/terrorblade/demon.vmdl"

--corrupted form
--"models/items/terrorblade/corrupted_form/corrupted_form.vmdl"

--metamorph
--"models/items/terrorblade/dotapit_s3_fallen_light_metamorphosis/dotapit_s3_fallen_light_metamorphosis.vmdl"

--endless purgatory
--"models/items/terrorblade/endless_purgatory_demon/endless_purgatory_demon.vmdl"

--marauders
--"models/items/terrorblade/marauders_demon/marauders_demon.vmdl"


--------------
-- BOSSES
--------------

ENCOUNTERS["sf_boss"] = {
  units={
    {name="npc_sf_boss"}
  },
  leashRange = 2500,
  thinkDelay = .5,
  awakeStickiness = 20,
}

ENCOUNTERS["ww_boss"] = {
  units={
    {name="npc_wyvern_boss"}
  },
  leashRange = 2500,
  thinkDelay = .5,
  awakeStickiness = 20,
}

ENCOUNTERS["timbersaw_boss"] = {
  units={
    {name="npc_timbersaw_boss"}
  },
  leashRange = 3000,
  thinkDelay = .2,
  awakeStickiness = 20,
}

ENCOUNTERS["morphling_boss"] = {
  units={
    {name="npc_morphling_boss"}
  },
  leashRange = 2500,
  thinkDelay = .5,
  awakeStickiness = 20,
}


return ENCOUNTERS