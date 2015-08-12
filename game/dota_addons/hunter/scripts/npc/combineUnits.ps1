echo """DOTAAbilities""" > npc_units_custom.txt
echo "{" >> npc_units_custom.txt
echo "  ""Version"" ""1""" >> npc_units_custom.txt
gc units/*.* >> npc_units_custom.txt
echo "}" >> npc_units_custom.txt