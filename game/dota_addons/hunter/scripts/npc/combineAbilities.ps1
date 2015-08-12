echo """DOTAAbilities""" > npc_abilities_custom.txt
echo "{" >> npc_abilities_custom.txt
echo "  ""Version"" ""1""" >> npc_abilities_custom.txt
gc abilities/*.* >> npc_abilities_custom.txt
echo "}" >> npc_abilities_custom.txt