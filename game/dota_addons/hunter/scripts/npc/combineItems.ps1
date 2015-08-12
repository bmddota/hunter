echo """DOTAAbilities""" > npc_items_custom.txt
echo "{" >> npc_items_custom.txt
echo "  ""Version"" ""1""" >> npc_items_custom.txt
gc items/*.* >> npc_items_custom.txt
echo "}" >> npc_items_custom.txt