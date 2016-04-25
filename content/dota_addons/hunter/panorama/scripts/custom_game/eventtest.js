/*
npc_spawned
entity_hurt
entity_killed
dota_combatlog
custom_game_difficulty
dashboard_caches_cleared
dota_ability_changed
dota_barracks_kill
dota_chat_event
dota_enemy_money_changed
dota_glyph_used
dota_hud_error_message
dota_illusions_created
dota_inventory_changed
dota_inventory_item_added
dota_inventory_item_changed
dota_item_drag_begin
dota_item_drag_end
dota_item_purchase
dota_link_clicked
dota_match_done_client
dota_money_changed
dota_player_details_changed
dota_player_gained_level
dota_player_hero_selection_dirty
dota_player_kill
dota_player_learned_ability
dota_player_pick_hero
dota_player_shop_changed
dota_player_take_tower_damage
dota_player_update_assigned_hero
dota_player_update_hero_selection
dota_player_update_killcam_unit
dota_player_update_selected_unit
dota_portrait_ability_layout_changed
dota_portrait_unit_modifiers_changed
dota_portrait_unit_stats_changed
dota_roshan_kill
dota_rune_pickup
dota_set_quick_buy
dota_starting_position_changed
dota_team_player_list_changed
dota_tower_kill
game_end_visible
game_rules_state_change
gameui_activated
gameui_hidden
hero_picker_hidden
map_shutdown
player_spawn
player_team
rich_presence_updated
spec_item_pickup
*/

  GameEvents.Subscribe("team_info", On_team_info );
  GameEvents.Subscribe("team_score", On_team_score );
  GameEvents.Subscribe("teamplay_broadcast_audio", On_teamplay_broadcast_audio );
  GameEvents.Subscribe("player_team", On_player_team );
  GameEvents.Subscribe("player_class", On_player_class );
  GameEvents.Subscribe("player_death", On_player_death  );
  GameEvents.Subscribe("player_hurt", On_player_hurt  );
  GameEvents.Subscribe("player_chat", On_player_chat  );
  GameEvents.Subscribe("player_score", On_player_score );
  GameEvents.Subscribe("player_spawn", On_player_spawn );
  GameEvents.Subscribe("player_shoot", On_player_shoot );
  GameEvents.Subscribe("player_use", On_player_use );
  GameEvents.Subscribe("player_changename", On_player_changename );
  GameEvents.Subscribe("player_hintmessage", On_player_hintmessage );
  GameEvents.Subscribe("player_reconnected", On_player_reconnected  );
  GameEvents.Subscribe("game_init", On_game_init );
  GameEvents.Subscribe("game_newmap", On_game_newmap );
  GameEvents.Subscribe("game_start", On_game_start );
  GameEvents.Subscribe("game_end", On_game_end );
  GameEvents.Subscribe("round_start", On_round_start );
  GameEvents.Subscribe("round_end", On_round_end );
  GameEvents.Subscribe("round_start_pre_entity", On_round_start_pre_entity );
  GameEvents.Subscribe("teamplay_round_start", On_teamplay_round_start );
  GameEvents.Subscribe("hostname_changed", On_hostname_changed );
  GameEvents.Subscribe("difficulty_changed", On_difficulty_changed );
  GameEvents.Subscribe("finale_start", On_finale_start );
  GameEvents.Subscribe("game_message", On_game_message );
  GameEvents.Subscribe("break_breakable", On_break_breakable );
  GameEvents.Subscribe("break_prop", On_break_prop );
  //GameEvents.Subscribe("npc_spawned", On_npc_spawned );
  GameEvents.Subscribe("npc_replaced", On_npc_replaced );
  //GameEvents.Subscribe("entity_killed", On_entity_killed );
  //GameEvents.Subscribe("entity_hurt", On_entity_hurt );
  GameEvents.Subscribe("bonus_updated", On_bonus_updated );
  GameEvents.Subscribe("player_stats_updated", On_player_stats_updated );
  GameEvents.Subscribe("achievement_event", On_achievement_event );
  GameEvents.Subscribe("achievement_earned", On_achievement_earned );
  GameEvents.Subscribe("achievement_write_failed", On_achievement_write_failed );
  GameEvents.Subscribe("physgun_pickup", On_physgun_pickup );
  GameEvents.Subscribe("flare_ignite_npc", On_flare_ignite_npc );
  GameEvents.Subscribe("helicopter_grenade_punt_miss", On_helicopter_grenade_punt_miss );
  GameEvents.Subscribe("user_data_downloaded", On_user_data_downloaded );
  GameEvents.Subscribe("ragdoll_dissolved", On_ragdoll_dissolved );
  GameEvents.Subscribe("gameinstructor_draw", On_gameinstructor_draw );
  GameEvents.Subscribe("gameinstructor_nodraw", On_gameinstructor_nodraw );
  GameEvents.Subscribe("map_transition", On_map_transition );
  GameEvents.Subscribe("instructor_server_hint_create", On_instructor_server_hint_create );
  GameEvents.Subscribe("instructor_server_hint_stop", On_instructor_server_hint_stop );
  GameEvents.Subscribe("chat_new_message", On_chat_new_message );
  GameEvents.Subscribe("chat_members_changed", On_chat_members_changed );
  GameEvents.Subscribe("game_rules_state_change", On_game_rules_state_change );
  GameEvents.Subscribe("inventory_updated", On_inventory_updated );
  GameEvents.Subscribe("cart_updated", On_cart_updated );
  GameEvents.Subscribe("store_pricesheet_updated", On_store_pricesheet_updated );
  GameEvents.Subscribe("gc_connected", On_gc_connected );
  GameEvents.Subscribe("item_schema_initialized", On_item_schema_initialized );
  GameEvents.Subscribe("drop_rate_modified", On_drop_rate_modified );
  GameEvents.Subscribe("event_ticket_modified", On_event_ticket_modified );
  GameEvents.Subscribe("modifier_event", On_modifier_event );
  GameEvents.Subscribe("dota_player_kill", On_dota_player_kill );
  GameEvents.Subscribe("dota_player_deny", On_dota_player_deny );
  GameEvents.Subscribe("dota_barracks_kill", On_dota_barracks_kill );
  GameEvents.Subscribe("dota_tower_kill", On_dota_tower_kill );
  GameEvents.Subscribe("dota_roshan_kill", On_dota_roshan_kill );
  GameEvents.Subscribe("dota_courier_lost", On_dota_courier_lost );
  GameEvents.Subscribe("dota_courier_respawned", On_dota_courier_respawned );
  GameEvents.Subscribe("dota_glyph_used", On_dota_glyph_used );
  GameEvents.Subscribe("dota_super_creeps", On_dota_super_creeps );
  GameEvents.Subscribe("dota_item_purchase", On_dota_item_purchase );
  GameEvents.Subscribe("dota_item_gifted", On_dota_item_gifted );
  GameEvents.Subscribe("dota_rune_pickup", On_dota_rune_pickup );
  GameEvents.Subscribe("dota_rune_spotted", On_dota_rune_spotted );
  GameEvents.Subscribe("dota_item_spotted", On_dota_item_spotted );
  GameEvents.Subscribe("dota_no_battle_points", On_dota_no_battle_points );
  GameEvents.Subscribe("dota_chat_informational", On_dota_chat_informational );
  GameEvents.Subscribe("dota_action_item", On_dota_action_item );
  GameEvents.Subscribe("dota_chat_ban_notification", On_dota_chat_ban_notification );
  GameEvents.Subscribe("dota_chat_event", On_dota_chat_event );
  GameEvents.Subscribe("dota_chat_timed_reward", On_dota_chat_timed_reward );
  GameEvents.Subscribe("dota_pause_event", On_dota_pause_event );
  GameEvents.Subscribe("dota_chat_kill_streak", On_dota_chat_kill_streak );
  GameEvents.Subscribe("dota_chat_first_blood", On_dota_chat_first_blood );
  GameEvents.Subscribe("dota_player_update_hero_selection", On_dota_player_update_hero_selection );
  GameEvents.Subscribe("dota_player_update_selected_unit", On_dota_player_update_selected_unit );
  GameEvents.Subscribe("dota_player_update_query_unit", On_dota_player_update_query_unit );
  GameEvents.Subscribe("dota_player_update_killcam_unit", On_dota_player_update_killcam_unit );
  GameEvents.Subscribe("dota_player_take_tower_damage", On_dota_player_take_tower_damage );
  GameEvents.Subscribe("dota_hud_error_message", On_dota_hud_error_message );
  //GameEvents.Subscribe("dota_action_success", On_dota_action_success );
  GameEvents.Subscribe("dota_starting_position_changed", On_dota_starting_position_changed );
  GameEvents.Subscribe("dota_money_changed", On_dota_money_changed );
  GameEvents.Subscribe("dota_enemy_money_changed", On_dota_enemy_money_changed );
  GameEvents.Subscribe("dota_portrait_unit_stats_changed", On_dota_portrait_unit_stats_changed );
  GameEvents.Subscribe("dota_portrait_unit_modifiers_changed", On_dota_portrait_unit_modifiers_changed );
  GameEvents.Subscribe("dota_force_portrait_update", On_dota_force_portrait_update );
  GameEvents.Subscribe("dota_inventory_changed", On_dota_inventory_changed );
  GameEvents.Subscribe("dota_item_picked_up", On_dota_item_picked_up );
  GameEvents.Subscribe("dota_inventory_item_changed", On_dota_inventory_item_changed );
  GameEvents.Subscribe("dota_ability_changed", On_dota_ability_changed );
  GameEvents.Subscribe("dota_portrait_ability_layout_changed", On_dota_portrait_ability_layout_changed );
  GameEvents.Subscribe("dota_inventory_item_added", On_dota_inventory_item_added );
  GameEvents.Subscribe("dota_inventory_changed_query_unit", On_dota_inventory_changed_query_unit );
  GameEvents.Subscribe("dota_link_clicked", On_dota_link_clicked );
  GameEvents.Subscribe("dota_set_quick_buy", On_dota_set_quick_buy );
  GameEvents.Subscribe("dota_quick_buy_changed", On_dota_quick_buy_changed );
  GameEvents.Subscribe("dota_player_shop_changed", On_dota_player_shop_changed );
  GameEvents.Subscribe("dota_player_show_killcam", On_dota_player_show_killcam );
  GameEvents.Subscribe("dota_player_show_minikillcam", On_dota_player_show_minikillcam );
  GameEvents.Subscribe("gc_user_session_created", On_gc_user_session_created );
  GameEvents.Subscribe("team_data_updated", On_team_data_updated );
  GameEvents.Subscribe("guild_data_updated", On_guild_data_updated );
  GameEvents.Subscribe("guild_open_parties_updated", On_guild_open_parties_updated );
  GameEvents.Subscribe("fantasy_updated", On_fantasy_updated );
  GameEvents.Subscribe("fantasy_league_changed", On_fantasy_league_changed );
  GameEvents.Subscribe("fantasy_score_info_changed", On_fantasy_score_info_changed );
  GameEvents.Subscribe("player_info_updated", On_player_info_updated );
  GameEvents.Subscribe("game_rules_state_change", On_game_rules_state_change );
  GameEvents.Subscribe("match_history_updated", On_match_history_updated );
  GameEvents.Subscribe("match_details_updated", On_match_details_updated );
  GameEvents.Subscribe("live_games_updated", On_live_games_updated );
  GameEvents.Subscribe("recent_matches_updated", On_recent_matches_updated );
  GameEvents.Subscribe("news_updated", On_news_updated );
  GameEvents.Subscribe("persona_updated", On_persona_updated );
  GameEvents.Subscribe("tournament_state_updated", On_tournament_state_updated );
  GameEvents.Subscribe("party_updated", On_party_updated );
  GameEvents.Subscribe("lobby_updated", On_lobby_updated );
  GameEvents.Subscribe("dashboard_caches_cleared", On_dashboard_caches_cleared );
  GameEvents.Subscribe("last_hit", On_last_hit );
  GameEvents.Subscribe("player_completed_game", On_player_completed_game );
  //GameEvents.Subscribe("dota_combatlog", On_dota_combatlog );
  GameEvents.Subscribe("player_reconnected", On_player_reconnected );
  GameEvents.Subscribe("nommed_tree", On_nommed_tree );
  GameEvents.Subscribe("dota_rune_activated_server", On_dota_rune_activated_server );
  GameEvents.Subscribe("dota_player_gained_level", On_dota_player_gained_level );
  GameEvents.Subscribe("dota_player_pick_hero", On_dota_player_pick_hero );
  GameEvents.Subscribe("dota_player_learned_ability", On_dota_player_learned_ability );
  GameEvents.Subscribe("dota_player_used_ability", On_dota_player_used_ability );
  GameEvents.Subscribe("dota_non_player_used_ability", On_dota_non_player_used_ability );
  GameEvents.Subscribe("dota_ability_channel_finished", On_dota_ability_channel_finished );
  GameEvents.Subscribe("dota_holdout_revive_complete", On_dota_holdout_revive_complete );
  GameEvents.Subscribe("dota_player_killed", On_dota_player_killed );
  GameEvents.Subscribe("bindpanel_open", On_bindpanel_open );
  GameEvents.Subscribe("bindpanel_close", On_bindpanel_close );
  GameEvents.Subscribe("keybind_changed", On_keybind_changed );
  GameEvents.Subscribe("dota_item_drag_begin", On_dota_item_drag_begin );
  GameEvents.Subscribe("dota_item_drag_end", On_dota_item_drag_end );
  GameEvents.Subscribe("dota_shop_item_drag_begin", On_dota_shop_item_drag_begin );
  GameEvents.Subscribe("dota_shop_item_drag_end", On_dota_shop_item_drag_end );
  GameEvents.Subscribe("dota_item_purchased", On_dota_item_purchased );
  GameEvents.Subscribe("dota_item_used", On_dota_item_used );
  GameEvents.Subscribe("dota_item_auto_purchase", On_dota_item_auto_purchase );
  GameEvents.Subscribe("dota_unit_event", On_dota_unit_event );
  GameEvents.Subscribe("dota_quest_started", On_dota_quest_started );
  GameEvents.Subscribe("dota_quest_completed", On_dota_quest_completed );
  GameEvents.Subscribe("gameui_activated", On_gameui_activated );
  GameEvents.Subscribe("gameui_hidden", On_gameui_hidden );
  GameEvents.Subscribe("player_fullyjoined", On_player_fullyjoined );
  GameEvents.Subscribe("dota_spectate_hero", On_dota_spectate_hero );
  GameEvents.Subscribe("dota_match_done", On_dota_match_done );
  GameEvents.Subscribe("dota_match_done_client", On_dota_match_done_client );
  GameEvents.Subscribe("set_instructor_group_enabled", On_set_instructor_group_enabled );
  GameEvents.Subscribe("joined_chat_channel", On_joined_chat_channel );
  GameEvents.Subscribe("left_chat_channel", On_left_chat_channel );
  GameEvents.Subscribe("gc_chat_channel_list_updated", On_gc_chat_channel_list_updated );
  GameEvents.Subscribe("today_messages_updated", On_today_messages_updated );
  GameEvents.Subscribe("file_downloaded", On_file_downloaded );
  GameEvents.Subscribe("player_report_counts_updated", On_player_report_counts_updated );
  GameEvents.Subscribe("scaleform_file_download_complete", On_scaleform_file_download_complete );
  GameEvents.Subscribe("item_purchased", On_item_purchased );
  GameEvents.Subscribe("gc_mismatched_version", On_gc_mismatched_version );
  GameEvents.Subscribe("demo_skip", On_demo_skip );
  GameEvents.Subscribe("demo_start", On_demo_start );
  GameEvents.Subscribe("demo_stop", On_demo_stop );
  GameEvents.Subscribe("map_shutdown", On_map_shutdown );
  GameEvents.Subscribe("dota_workshop_fileselected", On_dota_workshop_fileselected );
  GameEvents.Subscribe("dota_workshop_filecanceled", On_dota_workshop_filecanceled );
  GameEvents.Subscribe("rich_presence_updated", On_rich_presence_updated );
  GameEvents.Subscribe("dota_hero_random", On_dota_hero_random );
  GameEvents.Subscribe("dota_rd_chat_turn", On_dota_rd_chat_turn );
  GameEvents.Subscribe("dota_favorite_heroes_updated", On_dota_favorite_heroes_updated );
  GameEvents.Subscribe("profile_closed", On_profile_closed );
  GameEvents.Subscribe("item_preview_closed", On_item_preview_closed );
  GameEvents.Subscribe("dashboard_switched_section", On_dashboard_switched_section );
  GameEvents.Subscribe("dota_tournament_item_event", On_dota_tournament_item_event );
  GameEvents.Subscribe("dota_hero_swap", On_dota_hero_swap );
  GameEvents.Subscribe("dota_reset_suggested_items", On_dota_reset_suggested_items );
  GameEvents.Subscribe("halloween_high_score_received", On_halloween_high_score_received );
  GameEvents.Subscribe("halloween_phase_end", On_halloween_phase_end );
  GameEvents.Subscribe("halloween_high_score_request_failed", On_halloween_high_score_request_failed );
  GameEvents.Subscribe("dota_hud_skin_changed", On_dota_hud_skin_changed );
  GameEvents.Subscribe("dota_inventory_player_got_item", On_dota_inventory_player_got_item );
  GameEvents.Subscribe("player_is_experienced", On_player_is_experienced );
  GameEvents.Subscribe("player_is_notexperienced", On_player_is_notexperienced );
  GameEvents.Subscribe("dota_tutorial_lesson_start", On_dota_tutorial_lesson_start );
  GameEvents.Subscribe("map_location_updated", On_map_location_updated );
  GameEvents.Subscribe("richpresence_custom_updated", On_richpresence_custom_updated );
  GameEvents.Subscribe("game_end_visible", On_game_end_visible );
  GameEvents.Subscribe("antiaddiction_update", On_antiaddiction_update );
  GameEvents.Subscribe("highlight_hud_element", On_highlight_hud_element );
  GameEvents.Subscribe("hide_highlight_hud_element", On_hide_highlight_hud_element );
  GameEvents.Subscribe("intro_video_finished", On_intro_video_finished );
  GameEvents.Subscribe("matchmaking_status_visibility_changed", On_matchmaking_status_visibility_changed );
  GameEvents.Subscribe("practice_lobby_visibility_changed", On_practice_lobby_visibility_changed );
  GameEvents.Subscribe("dota_courier_transfer_item", On_dota_courier_transfer_item );
  GameEvents.Subscribe("full_ui_unlocked", On_full_ui_unlocked );
  GameEvents.Subscribe("client_connectionless_packet", On_client_connectionless_packet );
  GameEvents.Subscribe("hero_selector_preview_set", On_hero_selector_preview_set );
  GameEvents.Subscribe("antiaddiction_toast", On_antiaddiction_toast );
  GameEvents.Subscribe("hero_picker_shown", On_hero_picker_shown );
  GameEvents.Subscribe("hero_picker_hidden", On_hero_picker_hidden );
  GameEvents.Subscribe("dota_local_quickbuy_changed", On_dota_local_quickbuy_changed );
  GameEvents.Subscribe("show_center_message", On_show_center_message );
  GameEvents.Subscribe("hud_flip_changed", On_hud_flip_changed );
  GameEvents.Subscribe("frosty_points_updated", On_frosty_points_updated );
  GameEvents.Subscribe("defeated", On_defeated );
  GameEvents.Subscribe("reset_defeated", On_reset_defeated );
  GameEvents.Subscribe("booster_state_updated", On_booster_state_updated );
  GameEvents.Subscribe("event_points_updated", On_event_points_updated );
  GameEvents.Subscribe("local_player_event_points", On_local_player_event_points );
  GameEvents.Subscribe("custom_game_difficulty", On_custom_game_difficulty );
  GameEvents.Subscribe("tree_cut", On_tree_cut );
  GameEvents.Subscribe("ugc_details_arrived", On_ugc_details_arrived );
  GameEvents.Subscribe("ugc_subscribed", On_ugc_subscribed );
  GameEvents.Subscribe("ugc_unsubscribed", On_ugc_unsubscribed );
  GameEvents.Subscribe("prizepool_received", On_prizepool_received );
  GameEvents.Subscribe("microtransaction_success", On_microtransaction_success );
  GameEvents.Subscribe("dota_rubick_ability_steal", On_dota_rubick_ability_steal );
  GameEvents.Subscribe("compendium_event_actions_loaded", On_compendium_event_actions_loaded );
  GameEvents.Subscribe("compendium_selections_loaded", On_compendium_selections_loaded );
  GameEvents.Subscribe("compendium_set_selection_failed", On_compendium_set_selection_failed );
  GameEvents.Subscribe("community_cached_names_updated", On_community_cached_names_updated );
  GameEvents.Subscribe("dota_team_kill_credit", On_dota_team_kill_credit );

  GameEvents.Subscribe("dota_effigy_kill", On_dota_effigy_kill );
  GameEvents.Subscribe("dota_chat_assassin_announce", On_dota_chat_assassin_announce );
  GameEvents.Subscribe("dota_chat_assassin_denied", On_dota_chat_assassin_denied );
  GameEvents.Subscribe("dota_chat_assassin_success", On_dota_chat_assassin_success );
  GameEvents.Subscribe("player_info_individual_updated", On_player_info_individual_updated );
  GameEvents.Subscribe("dota_player_begin_cast", On_dota_player_begin_cast );
  GameEvents.Subscribe("dota_non_player_begin_cast", On_dota_non_player_begin_cast );
  GameEvents.Subscribe("dota_item_combined", On_dota_item_combined );
  GameEvents.Subscribe("profile_opened", On_profile_opened );
  GameEvents.Subscribe("dota_tutorial_task_advance", On_dota_tutorial_task_advance );
  GameEvents.Subscribe("dota_tutorial_shop_toggled", On_dota_tutorial_shop_toggled );
  GameEvents.Subscribe("ugc_download_requested", On_ugc_download_requested );
  GameEvents.Subscribe("ugc_installed", On_ugc_installed );
  GameEvents.Subscribe("compendium_trophies_loaded", On_compendium_trophies_loaded );
  GameEvents.Subscribe("spec_item_pickup", On_spec_item_pickup );
  GameEvents.Subscribe("spec_aegis_reclaim_time", On_spec_aegis_reclaim_time );
  GameEvents.Subscribe("account_trophies_changed", On_account_trophies_changed );
  GameEvents.Subscribe("account_all_hero_challenge_changed", On_account_all_hero_challenge_changed );
  GameEvents.Subscribe("team_showcase_ui_update", On_team_showcase_ui_update );
  GameEvents.Subscribe("ingame_events_changed", On_ingame_events_changed );
  GameEvents.Subscribe("dota_match_signout", On_dota_match_signout );
  GameEvents.Subscribe("dota_illusions_created", On_dota_illusions_created );
  GameEvents.Subscribe("dota_year_beast_killed", On_dota_year_beast_killed );
  GameEvents.Subscribe("dota_hero_undoselection", On_dota_hero_undoselection );
  GameEvents.Subscribe("dota_challenge_socache_updated", On_dota_challenge_socache_updated );
  GameEvents.Subscribe("party_invites_updated", On_party_invites_updated );
  GameEvents.Subscribe("lobby_invites_updated", On_lobby_invites_updated );
  GameEvents.Subscribe("custom_game_mode_list_updated", On_custom_game_mode_list_updated );
  GameEvents.Subscribe("custom_game_lobby_list_updated", On_custom_game_lobby_list_updated );
  GameEvents.Subscribe("friend_lobby_list_updated", On_friend_lobby_list_updated );
  GameEvents.Subscribe("dota_team_player_list_changed", On_dota_team_player_list_changed );
  GameEvents.Subscribe("dota_player_details_changed", On_dota_player_details_changed );
  GameEvents.Subscribe("player_profile_stats_updated", On_player_profile_stats_updated );
  GameEvents.Subscribe("custom_game_player_count_updated", On_custom_game_player_count_updated );
  GameEvents.Subscribe("custom_game_friends_played_updated", On_custom_game_friends_played_updated );
  GameEvents.Subscribe("custom_games_friends_play_updated", On_custom_games_friends_play_updated );
  GameEvents.Subscribe("dota_player_update_assigned_hero", On_dota_player_update_assigned_hero );
  GameEvents.Subscribe("dota_player_hero_selection_dirty", On_dota_player_hero_selection_dirty );
  GameEvents.Subscribe("dota_npc_goal_reached", On_dota_npc_goal_reached );
  GameEvents.Subscribe("dota_player_selected_custom_team", On_dota_player_selected_custom_team );

function On_team_info(data){
  $.Msg("[BAREBONES] team_info");
  $.Msg(data, "\n------");
}


function On_team_score(data){
  $.Msg("[BAREBONES] team_score");
  $.Msg(data, "\n------");
}


function On_teamplay_broadcast_audio(data){
  $.Msg("[BAREBONES] teamplay_broadcast_audio");
  $.Msg(data, "\n------");
}


function On_player_team(data){
  $.Msg("[BAREBONES] player_team");
  $.Msg(data, "\n------");
}


function On_player_class(data){
  $.Msg("[BAREBONES] player_class");
  $.Msg(data, "\n------");
}


function On_player_death (data){
  $.Msg("[BAREBONES] player_death");
  $.Msg(data, "\n------");
}


function On_player_hurt (data){
  $.Msg("[BAREBONES] player_hurt");
  $.Msg(data, "\n------");
}


function On_player_chat (data){
  $.Msg("[BAREBONES] player_chat");
  $.Msg(data, "\n------");
}


function On_player_score(data){
  $.Msg("[BAREBONES] player_score");
  $.Msg(data, "\n------");
}


function On_player_spawn(data){
  $.Msg("[BAREBONES] player_spawn");
  $.Msg(data, "\n------");
}


function On_player_shoot(data){
  $.Msg("[BAREBONES] player_shoot");
  $.Msg(data, "\n------");
}


function On_player_use(data){
  $.Msg("[BAREBONES] player_use");
  $.Msg(data, "\n------");
}


function On_player_changename(data){
  $.Msg("[BAREBONES] player_changename");
  $.Msg(data, "\n------");
}


function On_player_hintmessage(data){
  $.Msg("[BAREBONES] player_hintmessage");
  $.Msg(data, "\n------");
}


function On_player_reconnected (data){
  $.Msg("[BAREBONES] player_reconnected");
  $.Msg(data, "\n------");
}


function On_game_init(data){
  $.Msg("[BAREBONES] game_init");
  $.Msg(data, "\n------");
}


function On_game_newmap(data){
  $.Msg("[BAREBONES] game_newmap");
  $.Msg(data, "\n------");
}


function On_game_start(data){
  $.Msg("[BAREBONES] game_start");
  $.Msg(data, "\n------");
}


function On_game_end(data){
  $.Msg("[BAREBONES] game_end");
  $.Msg(data, "\n------");
}


function On_round_start(data){
  $.Msg("[BAREBONES] round_start");
  $.Msg(data, "\n------");
}


function On_round_end(data){
  $.Msg("[BAREBONES] round_end");
  $.Msg(data, "\n------");
}


function On_round_start_pre_entity(data){
  $.Msg("[BAREBONES] round_start_pre_entity");
  $.Msg(data, "\n------");
}


function On_teamplay_round_start(data){
  $.Msg("[BAREBONES] teamplay_round_start");
  $.Msg(data, "\n------");
}


function On_hostname_changed(data){
  $.Msg("[BAREBONES] hostname_changed");
  $.Msg(data, "\n------");
}


function On_difficulty_changed(data){
  $.Msg("[BAREBONES] difficulty_changed");
  $.Msg(data, "\n------");
}


function On_finale_start(data){
  $.Msg("[BAREBONES] finale_start");
  $.Msg(data, "\n------");
}


function On_game_message(data){
  $.Msg("[BAREBONES] game_message");
  $.Msg(data, "\n------");
}


function On_break_breakable(data){
  $.Msg("[BAREBONES] break_breakable");
  $.Msg(data, "\n------");
}


function On_break_prop(data){
  $.Msg("[BAREBONES] break_prop");
  $.Msg(data, "\n------");
}


function On_npc_spawned(data){
  $.Msg("[BAREBONES] npc_spawned");
  $.Msg(data, "\n------");
}


function On_npc_replaced(data){
  $.Msg("[BAREBONES] npc_replaced");
  $.Msg(data, "\n------");
}


function On_entity_killed(data){
  $.Msg("[BAREBONES] entity_killed");
  $.Msg(data, "\n------");
}


function On_entity_hurt(data){
  $.Msg("[BAREBONES] entity_hurt");
  $.Msg(data, "\n------");
}


function On_bonus_updated(data){
  $.Msg("[BAREBONES] bonus_updated");
  $.Msg(data, "\n------");
}


function On_player_stats_updated(data){
  $.Msg("[BAREBONES] player_stats_updated");
  $.Msg(data, "\n------");
}


function On_achievement_event(data){
  $.Msg("[BAREBONES] achievement_event");
  $.Msg(data, "\n------");
}


function On_achievement_earned(data){
  $.Msg("[BAREBONES] achievement_earned");
  $.Msg(data, "\n------");
}


function On_achievement_write_failed(data){
  $.Msg("[BAREBONES] achievement_write_failed");
  $.Msg(data, "\n------");
}


function On_physgun_pickup(data){
  $.Msg("[BAREBONES] physgun_pickup");
  $.Msg(data, "\n------");
}


function On_flare_ignite_npc(data){
  $.Msg("[BAREBONES] flare_ignite_npc");
  $.Msg(data, "\n------");
}


function On_helicopter_grenade_punt_miss(data){
  $.Msg("[BAREBONES] helicopter_grenade_punt_miss");
  $.Msg(data, "\n------");
}


function On_user_data_downloaded(data){
  $.Msg("[BAREBONES] user_data_downloaded");
  $.Msg(data, "\n------");
}


function On_ragdoll_dissolved(data){
  $.Msg("[BAREBONES] ragdoll_dissolved");
  $.Msg(data, "\n------");
}


function On_gameinstructor_draw(data){
  $.Msg("[BAREBONES] gameinstructor_draw");
  $.Msg(data, "\n------");
}


function On_gameinstructor_nodraw(data){
  $.Msg("[BAREBONES] gameinstructor_nodraw");
  $.Msg(data, "\n------");
}


function On_map_transition(data){
  $.Msg("[BAREBONES] map_transition");
  $.Msg(data, "\n------");
}


function On_instructor_server_hint_create(data){
  $.Msg("[BAREBONES] instructor_server_hint_create");
  $.Msg(data, "\n------");
}


function On_instructor_server_hint_stop(data){
  $.Msg("[BAREBONES] instructor_server_hint_stop");
  $.Msg(data, "\n------");
}


function On_chat_new_message(data){
  $.Msg("[BAREBONES] chat_new_message");
  $.Msg(data, "\n------");
}


function On_chat_members_changed(data){
  $.Msg("[BAREBONES] chat_members_changed");
  $.Msg(data, "\n------");
}


function On_game_rules_state_change(data){
  $.Msg("[BAREBONES] game_rules_state_change");
  $.Msg(data, "\n------");
}


function On_inventory_updated(data){
  $.Msg("[BAREBONES] inventory_updated");
  $.Msg(data, "\n------");
}


function On_cart_updated(data){
  $.Msg("[BAREBONES] cart_updated");
  $.Msg(data, "\n------");
}


function On_store_pricesheet_updated(data){
  $.Msg("[BAREBONES] store_pricesheet_updated");
  $.Msg(data, "\n------");
}


function On_gc_connected(data){
  $.Msg("[BAREBONES] gc_connected");
  $.Msg(data, "\n------");
}


function On_item_schema_initialized(data){
  $.Msg("[BAREBONES] item_schema_initialized");
  $.Msg(data, "\n------");
}


function On_drop_rate_modified(data){
  $.Msg("[BAREBONES] drop_rate_modified");
  $.Msg(data, "\n------");
}


function On_event_ticket_modified(data){
  $.Msg("[BAREBONES] event_ticket_modified");
  $.Msg(data, "\n------");
}


function On_modifier_event(data){
  $.Msg("[BAREBONES] modifier_event");
  $.Msg(data, "\n------");
}


function On_dota_player_kill(data){
  $.Msg("[BAREBONES] dota_player_kill");
  $.Msg(data, "\n------");
}


function On_dota_player_deny(data){
  $.Msg("[BAREBONES] dota_player_deny");
  $.Msg(data, "\n------");
}


function On_dota_barracks_kill(data){
  $.Msg("[BAREBONES] dota_barracks_kill");
  $.Msg(data, "\n------");
}


function On_dota_tower_kill(data){
  $.Msg("[BAREBONES] dota_tower_kill");
  $.Msg(data, "\n------");
}


function On_dota_roshan_kill(data){
  $.Msg("[BAREBONES] dota_roshan_kill");
  $.Msg(data, "\n------");
}


function On_dota_courier_lost(data){
  $.Msg("[BAREBONES] dota_courier_lost");
  $.Msg(data, "\n------");
}


function On_dota_courier_respawned(data){
  $.Msg("[BAREBONES] dota_courier_respawned");
  $.Msg(data, "\n------");
}


function On_dota_glyph_used(data){
  $.Msg("[BAREBONES] dota_glyph_used");
  $.Msg(data, "\n------");
}


function On_dota_super_creeps(data){
  $.Msg("[BAREBONES] dota_super_creeps");
  $.Msg(data, "\n------");
}


function On_dota_item_purchase(data){
  $.Msg("[BAREBONES] dota_item_purchase");
  $.Msg(data, "\n------");
}


function On_dota_item_gifted(data){
  $.Msg("[BAREBONES] dota_item_gifted");
  $.Msg(data, "\n------");
}


function On_dota_rune_pickup(data){
  $.Msg("[BAREBONES] dota_rune_pickup");
  $.Msg(data, "\n------");
}


function On_dota_rune_spotted(data){
  $.Msg("[BAREBONES] dota_rune_spotted");
  $.Msg(data, "\n------");
}


function On_dota_item_spotted(data){
  $.Msg("[BAREBONES] dota_item_spotted");
  $.Msg(data, "\n------");
}


function On_dota_no_battle_points(data){
  $.Msg("[BAREBONES] dota_no_battle_points");
  $.Msg(data, "\n------");
}


function On_dota_chat_informational(data){
  $.Msg("[BAREBONES] dota_chat_informational");
  $.Msg(data, "\n------");
}


function On_dota_action_item(data){
  $.Msg("[BAREBONES] dota_action_item");
  $.Msg(data, "\n------");
}


function On_dota_chat_ban_notification(data){
  $.Msg("[BAREBONES] dota_chat_ban_notification");
  $.Msg(data, "\n------");
}


function On_dota_chat_event(data){
  $.Msg("[BAREBONES] dota_chat_event");
  $.Msg(data, "\n------");
}


function On_dota_chat_timed_reward(data){
  $.Msg("[BAREBONES] dota_chat_timed_reward");
  $.Msg(data, "\n------");
}


function On_dota_pause_event(data){
  $.Msg("[BAREBONES] dota_pause_event");
  $.Msg(data, "\n------");
}


function On_dota_chat_kill_streak(data){
  $.Msg("[BAREBONES] dota_chat_kill_streak");
  $.Msg(data, "\n------");
}


function On_dota_chat_first_blood(data){
  $.Msg("[BAREBONES] dota_chat_first_blood");
  $.Msg(data, "\n------");
}


function On_dota_player_update_hero_selection(data){
  $.Msg("[BAREBONES] dota_player_update_hero_selection");
  $.Msg(data, "\n------");
}


function On_dota_player_update_selected_unit(data){
  $.Msg("[BAREBONES] dota_player_update_selected_unit");
  $.Msg(data, "\n------");
}


function On_dota_player_update_query_unit(data){
  $.Msg("[BAREBONES] dota_player_update_query_unit");
  $.Msg(data, "\n------");
}


function On_dota_player_update_killcam_unit(data){
  $.Msg("[BAREBONES] dota_player_update_killcam_unit");
  $.Msg(data, "\n------");
}


function On_dota_player_take_tower_damage(data){
  $.Msg("[BAREBONES] dota_player_take_tower_damage");
  $.Msg(data, "\n------");
}


function On_dota_hud_error_message(data){
  $.Msg("[BAREBONES] dota_hud_error_message");
  $.Msg(data, "\n------");
}


function On_dota_action_success(data){
  $.Msg("[BAREBONES] dota_action_success");
  $.Msg(data, "\n------");
}


function On_dota_starting_position_changed(data){
  $.Msg("[BAREBONES] dota_starting_position_changed");
  $.Msg(data, "\n------");
}


function On_dota_money_changed(data){
  $.Msg("[BAREBONES] dota_money_changed");
  $.Msg(data, "\n------");
}


function On_dota_enemy_money_changed(data){
  $.Msg("[BAREBONES] dota_enemy_money_changed");
  $.Msg(data, "\n------");
}


function On_dota_portrait_unit_stats_changed(data){
  $.Msg("[BAREBONES] dota_portrait_unit_stats_changed");
  $.Msg(data, "\n------");
}


function On_dota_portrait_unit_modifiers_changed(data){
  $.Msg("[BAREBONES] dota_portrait_unit_modifiers_changed");
  $.Msg(data, "\n------");
}


function On_dota_force_portrait_update(data){
  $.Msg("[BAREBONES] dota_force_portrait_update");
  $.Msg(data, "\n------");
}


function On_dota_inventory_changed(data){
  $.Msg("[BAREBONES] dota_inventory_changed");
  $.Msg(data, "\n------");
}


function On_dota_item_picked_up(data){
  $.Msg("[BAREBONES] dota_item_picked_up");
  $.Msg(data, "\n------");
}


function On_dota_inventory_item_changed(data){
  $.Msg("[BAREBONES] dota_inventory_item_changed");
  $.Msg(data, "\n------");
}


function On_dota_ability_changed(data){
  $.Msg("[BAREBONES] dota_ability_changed");
  $.Msg(data, "\n------");
}


function On_dota_portrait_ability_layout_changed(data){
  $.Msg("[BAREBONES] dota_portrait_ability_layout_changed");
  $.Msg(data, "\n------");
}


function On_dota_inventory_item_added(data){
  $.Msg("[BAREBONES] dota_inventory_item_added");
  $.Msg(data, "\n------");
}


function On_dota_inventory_changed_query_unit(data){
  $.Msg("[BAREBONES] dota_inventory_changed_query_unit");
  $.Msg(data, "\n------");
}


function On_dota_link_clicked(data){
  $.Msg("[BAREBONES] dota_link_clicked");
  $.Msg(data, "\n------");
}


function On_dota_set_quick_buy(data){
  $.Msg("[BAREBONES] dota_set_quick_buy");
  $.Msg(data, "\n------");
}


function On_dota_quick_buy_changed(data){
  $.Msg("[BAREBONES] dota_quick_buy_changed");
  $.Msg(data, "\n------");
}


function On_dota_player_shop_changed(data){
  $.Msg("[BAREBONES] dota_player_shop_changed");
  $.Msg(data, "\n------");
}


function On_dota_player_show_killcam(data){
  $.Msg("[BAREBONES] dota_player_show_killcam");
  $.Msg(data, "\n------");
}


function On_dota_player_show_minikillcam(data){
  $.Msg("[BAREBONES] dota_player_show_minikillcam");
  $.Msg(data, "\n------");
}


function On_gc_user_session_created(data){
  $.Msg("[BAREBONES] gc_user_session_created");
  $.Msg(data, "\n------");
}


function On_team_data_updated(data){
  $.Msg("[BAREBONES] team_data_updated");
  $.Msg(data, "\n------");
}


function On_guild_data_updated(data){
  $.Msg("[BAREBONES] guild_data_updated");
  $.Msg(data, "\n------");
}


function On_guild_open_parties_updated(data){
  $.Msg("[BAREBONES] guild_open_parties_updated");
  $.Msg(data, "\n------");
}


function On_fantasy_updated(data){
  $.Msg("[BAREBONES] fantasy_updated");
  $.Msg(data, "\n------");
}


function On_fantasy_league_changed(data){
  $.Msg("[BAREBONES] fantasy_league_changed");
  $.Msg(data, "\n------");
}


function On_fantasy_score_info_changed(data){
  $.Msg("[BAREBONES] fantasy_score_info_changed");
  $.Msg(data, "\n------");
}


function On_player_info_updated(data){
  $.Msg("[BAREBONES] player_info_updated");
  $.Msg(data, "\n------");
}


function On_game_rules_state_change(data){
  $.Msg("[BAREBONES] game_rules_state_change");
  $.Msg(data, "\n------");
}


function On_match_history_updated(data){
  $.Msg("[BAREBONES] match_history_updated");
  $.Msg(data, "\n------");
}


function On_match_details_updated(data){
  $.Msg("[BAREBONES] match_details_updated");
  $.Msg(data, "\n------");
}


function On_live_games_updated(data){
  $.Msg("[BAREBONES] live_games_updated");
  $.Msg(data, "\n------");
}


function On_recent_matches_updated(data){
  $.Msg("[BAREBONES] recent_matches_updated");
  $.Msg(data, "\n------");
}


function On_news_updated(data){
  $.Msg("[BAREBONES] news_updated");
  $.Msg(data, "\n------");
}


function On_persona_updated(data){
  $.Msg("[BAREBONES] persona_updated");
  $.Msg(data, "\n------");
}


function On_tournament_state_updated(data){
  $.Msg("[BAREBONES] tournament_state_updated");
  $.Msg(data, "\n------");
}


function On_party_updated(data){
  $.Msg("[BAREBONES] party_updated");
  $.Msg(data, "\n------");
}


function On_lobby_updated(data){
  $.Msg("[BAREBONES] lobby_updated");
  $.Msg(data, "\n------");
}


function On_dashboard_caches_cleared(data){
  $.Msg("[BAREBONES] dashboard_caches_cleared");
  $.Msg(data, "\n------");
}


function On_last_hit(data){
  $.Msg("[BAREBONES] last_hit");
  $.Msg(data, "\n------");
}


function On_player_completed_game(data){
  $.Msg("[BAREBONES] player_completed_game");
  $.Msg(data, "\n------");
}

function On_dota_combatlog(data){
  $.Msg("[BAREBONES] dota_combatlog");
  $.Msg(data, "\n------");
}


function On_player_reconnected(data){
  $.Msg("[BAREBONES] player_reconnected");
  $.Msg(data, "\n------");
}


function On_nommed_tree(data){
  $.Msg("[BAREBONES] nommed_tree");
  $.Msg(data, "\n------");
}


function On_dota_rune_activated_server(data){
  $.Msg("[BAREBONES] dota_rune_activated_server");
  $.Msg(data, "\n------");
}


function On_dota_player_gained_level(data){
  $.Msg("[BAREBONES] dota_player_gained_level");
  $.Msg(data, "\n------");
}

function On_dota_player_pick_hero(data){
  $.Msg("[BAREBONES] dota_player_pick_hero");
  $.Msg(data, "\n------");
}

function On_dota_player_learned_ability(data){
  $.Msg("[BAREBONES] dota_player_learned_ability");
  $.Msg(data, "\n------");
}


function On_dota_player_used_ability(data){
  $.Msg("[BAREBONES] dota_player_used_ability");
  $.Msg(data, "\n------");
}


function On_dota_non_player_used_ability(data){
  $.Msg("[BAREBONES] dota_non_player_used_ability");
  $.Msg(data, "\n------");
}


function On_dota_ability_channel_finished(data){
  $.Msg("[BAREBONES] dota_ability_channel_finished");
  $.Msg(data, "\n------");
}


function On_dota_holdout_revive_complete(data){
  $.Msg("[BAREBONES] dota_holdout_revive_complete");
  $.Msg(data, "\n------");
}


function On_dota_player_killed(data){
  $.Msg("[BAREBONES] dota_player_killed");
  $.Msg(data, "\n------");
}


function On_bindpanel_open(data){
  $.Msg("[BAREBONES] bindpanel_open");
  $.Msg(data, "\n------");
}


function On_bindpanel_close(data){
  $.Msg("[BAREBONES] bindpanel_close");
  $.Msg(data, "\n------");
}


function On_keybind_changed(data){
  $.Msg("[BAREBONES] keybind_changed");
  $.Msg(data, "\n------");
}


function On_dota_item_drag_begin(data){
  $.Msg("[BAREBONES] dota_item_drag_begin");
  $.Msg(data, "\n------");
}


function On_dota_item_drag_end(data){
  $.Msg("[BAREBONES] dota_item_drag_end");
  $.Msg(data, "\n------");
}


function On_dota_shop_item_drag_begin(data){
  $.Msg("[BAREBONES] dota_shop_item_drag_begin");
  $.Msg(data, "\n------");
}


function On_dota_shop_item_drag_end(data){
  $.Msg("[BAREBONES] dota_shop_item_drag_end");
  $.Msg(data, "\n------");
}


function On_dota_item_purchased(data){
  $.Msg("[BAREBONES] dota_item_purchased");
  $.Msg(data, "\n------");
}


function On_dota_item_used(data){
  $.Msg("[BAREBONES] dota_item_used");
  $.Msg(data, "\n------");
}


function On_dota_item_auto_purchase(data){
  $.Msg("[BAREBONES] dota_item_auto_purchase");
  $.Msg(data, "\n------");
}


function On_dota_unit_event(data){
  $.Msg("[BAREBONES] dota_unit_event");
  $.Msg(data, "\n------");
}


function On_dota_quest_started(data){
  $.Msg("[BAREBONES] dota_quest_started");
  $.Msg(data, "\n------");
}


function On_dota_quest_completed(data){
  $.Msg("[BAREBONES] dota_quest_completed");
  $.Msg(data, "\n------");
}


function On_gameui_activated(data){
  $.Msg("[BAREBONES] gameui_activated");
  $.Msg(data, "\n------");
}


function On_gameui_hidden(data){
  $.Msg("[BAREBONES] gameui_hidden");
  $.Msg(data, "\n------");
}


function On_player_fullyjoined(data){
  $.Msg("[BAREBONES] player_fullyjoined");
  $.Msg(data, "\n------");
}


function On_dota_spectate_hero(data){
  $.Msg("[BAREBONES] dota_spectate_hero");
  $.Msg(data, "\n------");
}


function On_dota_match_done(data){
  $.Msg("[BAREBONES] dota_match_done");
  $.Msg(data, "\n------");
}


function On_dota_match_done_client(data){
  $.Msg("[BAREBONES] dota_match_done_client");
  $.Msg(data, "\n------");
}


function On_set_instructor_group_enabled(data){
  $.Msg("[BAREBONES] set_instructor_group_enabled");
  $.Msg(data, "\n------");
}


function On_joined_chat_channel(data){
  $.Msg("[BAREBONES] joined_chat_channel");
  $.Msg(data, "\n------");
}


function On_left_chat_channel(data){
  $.Msg("[BAREBONES] left_chat_channel");
  $.Msg(data, "\n------");
}


function On_gc_chat_channel_list_updated(data){
  $.Msg("[BAREBONES] gc_chat_channel_list_updated");
  $.Msg(data, "\n------");
}


function On_today_messages_updated(data){
  $.Msg("[BAREBONES] today_messages_updated");
  $.Msg(data, "\n------");
}


function On_file_downloaded(data){
  $.Msg("[BAREBONES] file_downloaded");
  $.Msg(data, "\n------");
}


function On_player_report_counts_updated(data){
  $.Msg("[BAREBONES] player_report_counts_updated");
  $.Msg(data, "\n------");
}


function On_scaleform_file_download_complete(data){
  $.Msg("[BAREBONES] scaleform_file_download_complete");
  $.Msg(data, "\n------");
}


function On_item_purchased(data){
  $.Msg("[BAREBONES] item_purchased");
  $.Msg(data, "\n------");
}


function On_gc_mismatched_version(data){
  $.Msg("[BAREBONES] gc_mismatched_version");
  $.Msg(data, "\n------");
}


function On_demo_skip(data){
  $.Msg("[BAREBONES] demo_skip");
  $.Msg(data, "\n------");
}


function On_demo_start(data){
  $.Msg("[BAREBONES] demo_start");
  $.Msg(data, "\n------");
}


function On_demo_stop(data){
  $.Msg("[BAREBONES] demo_stop");
  $.Msg(data, "\n------");
}


function On_map_shutdown(data){
  $.Msg("[BAREBONES] map_shutdown");
  $.Msg(data, "\n------");
}


function On_dota_workshop_fileselected(data){
  $.Msg("[BAREBONES] dota_workshop_fileselected");
  $.Msg(data, "\n------");
}


function On_dota_workshop_filecanceled(data){
  $.Msg("[BAREBONES] dota_workshop_filecanceled");
  $.Msg(data, "\n------");
}


function On_rich_presence_updated(data){
  $.Msg("[BAREBONES] rich_presence_updated");
  $.Msg(data, "\n------");
}


function On_dota_hero_random(data){
  $.Msg("[BAREBONES] dota_hero_random");
  $.Msg(data, "\n------");
}


function On_dota_rd_chat_turn(data){
  $.Msg("[BAREBONES] dota_rd_chat_turn");
  $.Msg(data, "\n------");
}


function On_dota_favorite_heroes_updated(data){
  $.Msg("[BAREBONES] dota_favorite_heroes_updated");
  $.Msg(data, "\n------");
}


function On_profile_closed(data){
  $.Msg("[BAREBONES] profile_closed");
  $.Msg(data, "\n------");
}


function On_item_preview_closed(data){
  $.Msg("[BAREBONES] item_preview_closed");
  $.Msg(data, "\n------");
}


function On_dashboard_switched_section(data){
  $.Msg("[BAREBONES] dashboard_switched_section");
  $.Msg(data, "\n------");
}


function On_dota_tournament_item_event(data){
  $.Msg("[BAREBONES] dota_tournament_item_event");
  $.Msg(data, "\n------");
}


function On_dota_hero_swap(data){
  $.Msg("[BAREBONES] dota_hero_swap");
  $.Msg(data, "\n------");
}


function On_dota_reset_suggested_items(data){
  $.Msg("[BAREBONES] dota_reset_suggested_items");
  $.Msg(data, "\n------");
}


function On_halloween_high_score_received(data){
  $.Msg("[BAREBONES] halloween_high_score_received");
  $.Msg(data, "\n------");
}


function On_halloween_phase_end(data){
  $.Msg("[BAREBONES] halloween_phase_end");
  $.Msg(data, "\n------");
}


function On_halloween_high_score_request_failed(data){
  $.Msg("[BAREBONES] halloween_high_score_request_failed");
  $.Msg(data, "\n------");
}


function On_dota_hud_skin_changed(data){
  $.Msg("[BAREBONES] dota_hud_skin_changed");
  $.Msg(data, "\n------");
}


function On_dota_inventory_player_got_item(data){
  $.Msg("[BAREBONES] dota_inventory_player_got_item");
  $.Msg(data, "\n------");
}


function On_player_is_experienced(data){
  $.Msg("[BAREBONES] player_is_experienced");
  $.Msg(data, "\n------");
}


function On_player_is_notexperienced(data){
  $.Msg("[BAREBONES] player_is_notexperienced");
  $.Msg(data, "\n------");
}


function On_dota_tutorial_lesson_start(data){
  $.Msg("[BAREBONES] dota_tutorial_lesson_start");
  $.Msg(data, "\n------");
}


function On_map_location_updated(data){
  $.Msg("[BAREBONES] map_location_updated");
  $.Msg(data, "\n------");
}


function On_richpresence_custom_updated(data){
  $.Msg("[BAREBONES] richpresence_custom_updated");
  $.Msg(data, "\n------");
}


function On_game_end_visible(data){
  $.Msg("[BAREBONES] game_end_visible");
  $.Msg(data, "\n------");
}


function On_antiaddiction_update(data){
  $.Msg("[BAREBONES] antiaddiction_update");
  $.Msg(data, "\n------");
}


function On_highlight_hud_element(data){
  $.Msg("[BAREBONES] highlight_hud_element");
  $.Msg(data, "\n------");
}


function On_hide_highlight_hud_element(data){
  $.Msg("[BAREBONES] hide_highlight_hud_element");
  $.Msg(data, "\n------");
}


function On_intro_video_finished(data){
  $.Msg("[BAREBONES] intro_video_finished");
  $.Msg(data, "\n------");
}


function On_matchmaking_status_visibility_changed(data){
  $.Msg("[BAREBONES] matchmaking_status_visibility_changed");
  $.Msg(data, "\n------");
}


function On_practice_lobby_visibility_changed(data){
  $.Msg("[BAREBONES] practice_lobby_visibility_changed");
  $.Msg(data, "\n------");
}


function On_dota_courier_transfer_item(data){
  $.Msg("[BAREBONES] dota_courier_transfer_item");
  $.Msg(data, "\n------");
}


function On_full_ui_unlocked(data){
  $.Msg("[BAREBONES] full_ui_unlocked");
  $.Msg(data, "\n------");
}


function On_client_connectionless_packet(data){
  $.Msg("[BAREBONES] client_connectionless_packet");
  $.Msg(data, "\n------");
}


function On_hero_selector_preview_set(data){
  $.Msg("[BAREBONES] hero_selector_preview_set");
  $.Msg(data, "\n------");
}


function On_antiaddiction_toast(data){
  $.Msg("[BAREBONES] antiaddiction_toast");
  $.Msg(data, "\n------");
}


function On_hero_picker_shown(data){
  $.Msg("[BAREBONES] hero_picker_shown");
  $.Msg(data, "\n------");
}


function On_hero_picker_hidden(data){
  $.Msg("[BAREBONES] hero_picker_hidden");
  $.Msg(data, "\n------");
}


function On_dota_local_quickbuy_changed(data){
  $.Msg("[BAREBONES] dota_local_quickbuy_changed");
  $.Msg(data, "\n------");
}


function On_show_center_message(data){
  $.Msg("[BAREBONES] show_center_message");
  $.Msg(data, "\n------");
}


function On_hud_flip_changed(data){
  $.Msg("[BAREBONES] hud_flip_changed");
  $.Msg(data, "\n------");
}


function On_frosty_points_updated(data){
  $.Msg("[BAREBONES] frosty_points_updated");
  $.Msg(data, "\n------");
}


function On_defeated(data){
  $.Msg("[BAREBONES] defeated");
  $.Msg(data, "\n------");
}


function On_reset_defeated(data){
  $.Msg("[BAREBONES] reset_defeated");
  $.Msg(data, "\n------");
}


function On_booster_state_updated(data){
  $.Msg("[BAREBONES] booster_state_updated");
  $.Msg(data, "\n------");
}


function On_event_points_updated(data){
  $.Msg("[BAREBONES] event_points_updated");
  $.Msg(data, "\n------");
}


function On_local_player_event_points(data){
  $.Msg("[BAREBONES] local_player_event_points");
  $.Msg(data, "\n------");
}


function On_custom_game_difficulty(data){
  $.Msg("[BAREBONES] custom_game_difficulty");
  $.Msg(data, "\n------");
}


function On_tree_cut(data){
  $.Msg("[BAREBONES] tree_cut");
  $.Msg(data, "\n------");
}


function On_ugc_details_arrived(data){
  $.Msg("[BAREBONES] ugc_details_arrived");
  $.Msg(data, "\n------");
}


function On_ugc_subscribed(data){
  $.Msg("[BAREBONES] ugc_subscribed");
  $.Msg(data, "\n------");
}


function On_ugc_unsubscribed(data){
  $.Msg("[BAREBONES] ugc_unsubscribed");
  $.Msg(data, "\n------");
}


function On_prizepool_received(data){
  $.Msg("[BAREBONES] prizepool_received");
  $.Msg(data, "\n------");
}


function On_microtransaction_success(data){
  $.Msg("[BAREBONES] microtransaction_success");
  $.Msg(data, "\n------");
}


function On_dota_rubick_ability_steal(data){
  $.Msg("[BAREBONES] dota_rubick_ability_steal");
  $.Msg(data, "\n------");
}


function On_compendium_event_actions_loaded(data){
  $.Msg("[BAREBONES] compendium_event_actions_loaded");
  $.Msg(data, "\n------");
}


function On_compendium_selections_loaded(data){
  $.Msg("[BAREBONES] compendium_selections_loaded");
  $.Msg(data, "\n------");
}


function On_compendium_set_selection_failed(data){
  $.Msg("[BAREBONES] compendium_set_selection_failed");
  $.Msg(data, "\n------");
}

function On_community_cached_names_updated(data){
  $.Msg("[BAREBONES] community_cached_names_updated");
  $.Msg(data, "\n------");
}

function On_dota_team_kill_credit(data){
  $.Msg("[BAREBONES] dota_team_kill_credit");
  $.Msg(data, "\n------");
}

function On_dota_effigy_kill(data){
  $.Msg("[BAREBONES] dota_effigy_kill");
  $.Msg(data, "\n------");
}

function On_dota_chat_assassin_announce(data){
  $.Msg("[BAREBONES] dota_chat_assassin_announce");
  $.Msg(data, "\n------");
}


function On_dota_chat_assassin_denied(data){
  $.Msg("[BAREBONES] dota_chat_assassin_denied");
  $.Msg(data, "\n------");
}


function On_dota_chat_assassin_success(data){
  $.Msg("[BAREBONES] dota_chat_assassin_success");
  $.Msg(data, "\n------");
}


function On_player_info_individual_updated(data){
  $.Msg("[BAREBONES] player_info_individual_updated");
  $.Msg(data, "\n------");
}


function On_dota_player_begin_cast(data){
  $.Msg("[BAREBONES] dota_player_begin_cast");
  $.Msg(data, "\n------");
}


function On_dota_non_player_begin_cast(data){
  $.Msg("[BAREBONES] dota_non_player_begin_cast");
  $.Msg(data, "\n------");
}


function On_dota_item_combined(data){
  $.Msg("[BAREBONES] dota_item_combined");
  $.Msg(data, "\n------");
}


function On_profile_opened(data){
  $.Msg("[BAREBONES] profile_opened");
  $.Msg(data, "\n------");
}


function On_dota_tutorial_task_advance(data){
  $.Msg("[BAREBONES] dota_tutorial_task_advance");
  $.Msg(data, "\n------");
}


function On_dota_tutorial_shop_toggled(data){
  $.Msg("[BAREBONES] dota_tutorial_shop_toggled");
  $.Msg(data, "\n------");
}


function On_ugc_download_requested(data){
  $.Msg("[BAREBONES] ugc_download_requested");
  $.Msg(data, "\n------");
}


function On_ugc_installed(data){
  $.Msg("[BAREBONES] ugc_installed");
  $.Msg(data, "\n------");
}


function On_compendium_trophies_loaded(data){
  $.Msg("[BAREBONES] compendium_trophies_loaded");
  $.Msg(data, "\n------");
}


function On_spec_item_pickup(data){
  $.Msg("[BAREBONES] spec_item_pickup");
  $.Msg(data, "\n------");
}


function On_spec_aegis_reclaim_time(data){
  $.Msg("[BAREBONES] spec_aegis_reclaim_time");
  $.Msg(data, "\n------");
}


function On_account_trophies_changed(data){
  $.Msg("[BAREBONES] account_trophies_changed");
  $.Msg(data, "\n------");
}


function On_account_all_hero_challenge_changed(data){
  $.Msg("[BAREBONES] account_all_hero_challenge_changed");
  $.Msg(data, "\n------");
}


function On_team_showcase_ui_update(data){
  $.Msg("[BAREBONES] team_showcase_ui_update");
  $.Msg(data, "\n------");
}


function On_ingame_events_changed(data){
  $.Msg("[BAREBONES] ingame_events_changed");
  $.Msg(data, "\n------");
}


function On_dota_match_signout(data){
  $.Msg("[BAREBONES] dota_match_signout");
  $.Msg(data, "\n------");
}


function On_dota_illusions_created(data){
  $.Msg("[BAREBONES] dota_illusions_created");
  $.Msg(data, "\n------");
}


function On_dota_year_beast_killed(data){
  $.Msg("[BAREBONES] dota_year_beast_killed");
  $.Msg(data, "\n------");
}


function On_dota_hero_undoselection(data){
  $.Msg("[BAREBONES] dota_hero_undoselection");
  $.Msg(data, "\n------");
}


function On_dota_challenge_socache_updated(data){
  $.Msg("[BAREBONES] dota_challenge_socache_updated");
  $.Msg(data, "\n------");
}


function On_party_invites_updated(data){
  $.Msg("[BAREBONES] party_invites_updated");
  $.Msg(data, "\n------");
}


function On_lobby_invites_updated(data){
  $.Msg("[BAREBONES] lobby_invites_updated");
  $.Msg(data, "\n------");
}


function On_custom_game_mode_list_updated(data){
  $.Msg("[BAREBONES] custom_game_mode_list_updated");
  $.Msg(data, "\n------");
}


function On_custom_game_lobby_list_updated(data){
  $.Msg("[BAREBONES] custom_game_lobby_list_updated");
  $.Msg(data, "\n------");
}


function On_friend_lobby_list_updated(data){
  $.Msg("[BAREBONES] friend_lobby_list_updated");
  $.Msg(data, "\n------");
}


function On_dota_team_player_list_changed(data){
  $.Msg("[BAREBONES] dota_team_player_list_changed");
  $.Msg(data, "\n------");
}


function On_dota_player_details_changed(data){
  $.Msg("[BAREBONES] dota_player_details_changed");
  $.Msg(data, "\n------");
}


function On_player_profile_stats_updated(data){
  $.Msg("[BAREBONES] player_profile_stats_updated");
  $.Msg(data, "\n------");
}


function On_custom_game_player_count_updated(data){
  $.Msg("[BAREBONES] custom_game_player_count_updated");
  $.Msg(data, "\n------");
}


function On_custom_game_friends_played_updated(data){
  $.Msg("[BAREBONES] custom_game_friends_played_updated");
  $.Msg(data, "\n------");
}


function On_custom_games_friends_play_updated(data){
  $.Msg("[BAREBONES] custom_games_friends_play_updated");
  $.Msg(data, "\n------");
}


function On_dota_player_update_assigned_hero(data){
  $.Msg("[BAREBONES] dota_player_update_assigned_hero");
  $.Msg(data, "\n------");
}


function On_dota_player_hero_selection_dirty(data){
  $.Msg("[BAREBONES] dota_player_hero_selection_dirty");
  $.Msg(data, "\n------");
}


function On_dota_npc_goal_reached(data){
  $.Msg("[BAREBONES] dota_npc_goal_reached");
  $.Msg(data, "\n------");
}


function On_dota_player_selected_custom_team(data){
  $.Msg("[BAREBONES] dota_player_selected_custom_team");
  $.Msg(data, "\n------");
}