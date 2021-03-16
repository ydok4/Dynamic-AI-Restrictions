-- Mock Data
testCharacter = {
    cqi = function() return 123 end,
    get_forename = function() return "Direfan"; end,
    get_surname = function() return "Cylostra"; end,
    character_subtype_key = function() return "brt_louen_leoncouer"; end,
    command_queue_index = function() end,
    has_military_force = function() return true end,
    military_force = function() return testMilitaryForce; end,
    faction = function() return humanFaction; end,
    region = function() return get_cm():get_region(); end,
    logical_position_x = function() return 100; end,
    logical_position_y = function() return 110; end,
    command_queue_index = function() return 10; end,
    character_type = function() return false; end,
    is_null_interface = function() return false; end,
    is_wounded = function() return false; end,
}

testMilitaryForce = {
    is_null_interface = function() return false; end,
    command_queue_index = function() return 10; end,
    is_armed_citizenry = function () return false; end,
    general_character = function() return testCharacter; end,
    faction = function() return humanFaction; end,
    unit_list = function() return {
        num_items = function() return 2; end,
        item_at = function(self, index)
            return test_unit;
        end,
        is_null_interface = function() return false; end,
    }
    end,
}

humanFaction = {
    command_queue_index = function() return 10; end,
    name = function()
        return "wh2_main_def_naggarond";
    end,
    culture = function()
        return "wh2_main_def_dark_elves";
    end,
    subculture = function()
        return "wh_main_sc_brt_bretonnia";
    end,
    is_dead = function() return false; end,
    character_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function(self, index)
                return testCharacter;
            end,
            is_null_interface = function() return false; end,
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function(self, index)
                return cm:get_region(index);
            end,
            is_null_interface = function() return false; end,
        };
    end,
    home_region = function ()
        return {
            name = function()
                return "";
            end,
            is_null_interface = function()
                return false;
            end,
        }
    end,
    faction_leader = function() return testCharacter; end,
    is_quest_battle_faction = function() return false; end,
    is_null_interface = function() return false; end,
    is_human = function() return true; end,
    has_effect_bundle = function() return true; end,
    is_horde = function() return false; end,
    can_be_horde = function() return false; end,
    factions_of_same_culture = function() return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testFaction;
            end,
        };
    end,
    at_war_with = function() return false; end,
    factions_non_aggression_pact_with = function() return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testFaction;
            end,
        };
    end,
    factions_trading_with = function() return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testFaction;
            end,
        }
    end,
    diplomatic_standing_with = function() return 10; end,
    diplomatic_attitude_towards = function() return 15; end,
    military_allies_with = function() return true; end,
    defensive_allies_with = function() return true; end,
    get_climate_suitability = function() return "suitability_good"; end,
    is_allowed_to_capture_territory = function() return true; end,
    treasury = function() return 2000; end,
    has_pooled_resource = function() return true; end,
    pooled_resource = function() return testPooledResource; end,
    imperium_level = function() return 1; end,
}

testPooledResource = {
    value = function() return 1; end,
    factors = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return pooledResourceFactor;
            end,
            is_null_interface = function() return false; end,
        };
    end,
};

pooledResourceFactor = {
    key = function() return "mc_grn_waaagh"; end,
    value = function() return "1"; end,
}

testFaction = {
    command_queue_index = function() return 10; end,
    name = function()
        return "wh2_main_lzd_last_defenders";
    end,
    culture = function()
        return "wh2_main_lzd_lizardmen";
    end,
    subculture = function()
        return "wh_main_sc_brt_bretonnia";
    end,
    is_dead = function() return false; end,
    character_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testCharacter;
            end,
            is_null_interface = function() return false; end,
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 1;
            end,
            item_at = function(self, index)
                return cm:get_region(index);
            end,
            is_null_interface = function() return false; end,
        };
    end,
    home_region = function ()
        return {
            name = function()
                return "";
            end,
            is_null_interface = function()
                return false;
            end,
        }
    end,
    faction_leader = function() return testCharacter; end,
    is_quest_battle_faction = function() return false; end,
    is_null_interface = function() return false; end,
    is_human = function() return false; end,
    has_effect_bundle = function() return true; end,
    is_horde = function() return false; end,
    can_be_horde = function() return false; end,
    factions_of_same_culture = function() return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testFaction;
            end,
        };
    end,
    at_war_with = function() return false; end,
    factions_non_aggression_pact_with = function() return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testFaction;
            end,
        };
    end,
    factions_trading_with = function() return {
            num_items = function()
                return 1;
            end,
            item_at = function()
                return testFaction;
            end,
        }
    end,
    diplomatic_standing_with = function() return 10; end,
    diplomatic_attitude_towards = function() return 15; end,
    military_allies_with = function() return true; end,
    defensive_allies_with = function() return true; end,
    get_climate_suitability = function() return "suitability_good"; end,
    is_allowed_to_capture_territory = function() return true; end,
    treasury = function() return 2000; end,
    imperium_level = function() return 1; end,
}

testFaction2 = {
    name = function()
        return "wh2_dlc11_cst_rogue_grey_point_scuttlers";
    end,
    subculture = function()
        return "wh_main_sc_nor_norsca";
    end,
    is_dead = function() return false; end,
    character_list = function()
        return {
            num_items = function()
                return 0;
            end,
            is_null_interface = function() return false; end,
        };
    end,
    region_list = function()
        return {
            num_items = function()
                return 0;
            end,
            is_null_interface = function() return false; end,
        };
    end,
    home_region = function ()
        return {
            name = function()
                return "";
            end,
            is_null_interface = function()
                return false;
            end,
        }
    end,
    faction_leader = function() return testCharacter; end,
    is_quest_battle_faction = function() return false; end,
    is_null_interface = function() return false; end,
    is_human = function() return false; end,
    has_effect_bundle = function() return true; end,
    command_queue_index = function() return 10; end,
    imperium_level = function() return 1; end,
}

test_unit = {
    unit_key = function() return "wh2_main_hef_inf_archers_1"; end,
    force_commander = function() return testCharacter; end,
    faction = function() return testFaction; end,
    percentage_proportion_of_full_strength = function() return 80; end,
}

effect = {
    get_localised_string = function()
        return "Murdredesa";
    end,
}

-- This can be modified in the testing driver
-- so we can simulate turns changing easily
local turn_number = 1;

-- Mock functions
mock_listeners = {
    listeners = {},
    trigger_listener = function(self, mockListenerObject)
        local listener = self.listeners[mockListenerObject.Key];
        if listener and listener.Condition(mockListenerObject.Context) then
            listener.Callback(mockListenerObject.Context);
        end
    end,
}

-- Mock save structures
mockSaveData = {

}

-- slot (building) data
slot_1 = {
    has_building = function() return true; end,
    building = function() return {
        name = function() return "wh_msl_barracks_1"; end,
    }
    end,
}

slot_2 = {
    has_building = function() return true; end,
    building = function() return {
        name = function() return "wh_main_grn_military_1"; end,
    }
    end,
}

testRegion = {
    cqi = function() return 123; end,
    province_name = function() return "wh2_main_coast_of_araby"; end,
    faction_province_growth = function() return 3; end,
    religion_proportion = function() return 0; end,
    public_order = function() return -99; end,
    owning_faction = function() return testFaction; end,
    name = function() return "wh_main_couronne_et_languille_couronne"; end,
    is_province_capital = function() return false; end,
    is_abandoned = function() return false; end,
    command_queue_index = function() return 10; end,
    adjacent_region_list = function()
        return {
            item_at = function(self, i)
                if i == 0 then
                    return get_cm():get_region();
                elseif i == 1 then
                    return get_cm():get_region();
                elseif i == 2 then
                    return get_cm():get_region();
                elseif i == 3 then
                    return get_cm():get_region();
                else
                    return nil;
                end
            end,
            num_items = function()
                return 3;
            end,
            is_null_interface = function() return false; end,
        }
    end,
    is_null_interface = function() return false; end,
    garrison_residence = function() return {
        army = function() return {
            strength = function() return 50; end,
        } end ,
    } end,
    settlement = function() return {
        is_null_interface = function() return false; end,
        get_climate = function() return "suitability_good"; end,
        primary_slot = function() return {
            is_null_interface = function() return false; end,
            has_building = function() return true; end,
            building = function() return {
                is_null_interface = function() return false; end,
                name = function() return
                    "main_settlement";
                end,
                chain = function() return "wh2_main_def_murder"; end,
                superchain = function()
                    return "wh2_main_sch_infrastructure1_farm";
                end,
                building_level = function()
                    return 2;
                end,
            };
        end
        };
        end,
        port_slot = function() return {
            is_null_interface = function() return false; end,
            has_building = function() return true; end,
            building = function() return {
                is_null_interface = function() return false; end,
                name = function() return
                    "port";
                end,
                chain = function() return "wh2_main_def_sorcery"; end,
                superchain = function()
                    return "wh2_main_sch_infrastructure1_farm";
                end,
                building_level = function()
                    return 2;
                end,
                };
            end
            };
        end,
        is_port = function()
            return true;
        end,
    };
    end,
    slot_list = function() return {
        num_items = function () return 2; end,
        item_at = function(index)
            if index == 1 then
                return slot_1;
            else
                return slot_2;
            end
        end
    };
    end,
    town_wealth_growth = function() return 100; end,
    building_exists = function() return false; end,
};

function get_cm()
    return   {
        is_new_game = function() return true; end,
        create_agent = function()
            return;
        end,
        get_human_factions = function()
            return {humanFaction:name()};
        end,
        disable_event_feed_events = function() end,
        turn_number = function() return turn_number; end,
        get_local_faction = function() return humanFaction; end,
        model = function ()
            return {
                military_force_for_command_queue_index = function() return testMilitaryForce; end,
                turn_number = function() return turn_number; end,
                world = function()
                    return {
                        faction_by_key = function ()
                            return humanFaction;
                        end,
                        faction_list = function ()
                            return {
                                item_at = function(self, i)
                                    if i == 0 then
                                        return testFaction;
                                    elseif i == 1 then
                                        return humanFaction;
                                    elseif i == 2 then
                                        return testFaction2;
                                    elseif i == 3 then
                                        return testFaction2
                                    else
                                        return nil;
                                    end
                                end,
                                num_items = function()
                                    return 3;
                                end,
                            }
                        end
                    }
                end
            }
        end,
        first_tick_callbacks = {},
        add_saving_game_callback = function() end,
        add_loading_game_callback = function() end,
        spawn_character_to_pool = function() end,
        callback = function(self, callbackFunction, delay) callbackFunction() end,
        transfer_region_to_faction = function() end,
        get_faction = function() return testFaction; end,
        lift_all_shroud = function() end,
        kill_all_armies_for_faction = function() end,
        get_region = function()
            return testRegion;
        end,
        set_character_immortality = function() end,
        get_campaign_name = function() return "main_warhammer"; end,
        apply_effect_bundle_to_characters_force = function() end,
        kill_character = function() end,
        trigger_incident = function() end,
        trigger_dilemma = function() end,
        trigger_mission = function() end,
        create_force_with_general = function(self, factionKey, forceString, regionKey, spawnX, spawnY, generalType, agentSubTypeKey, clanNameKey, dummyName1, foreNameKey, dummyName2, umm, callbackFunction)
            callbackFunction(123);
        end,
        create_force_with_existing_general = function(self, cqi, factionKey, forceString, regionKey, spawnX, spawnY, callbackFunction)
            callbackFunction(123);
        end,
        force_add_trait = function() end,
        force_remove_trait = function() end,
        get_character_by_cqi = function() return testCharacter; end,
        char_is_mobile_general_with_army = function() return true; end,
        restrict_units_for_faction = function() end,
        set_saved_value = function(self, saveKey, data)
            mockSaveData[saveKey] = data;
        end,
        get_saved_value = function(self, saveKey, data)
            if mockSaveData[saveKey] == nil then
                return nil;
            end
            return mockSaveData[saveKey];
        end,
        save_named_value = function(self, saveKey, data, context)
            mockSaveData[saveKey] = data;
        end,
        load_named_value = function(self, saveKey, datastructure, context)
            if mockSaveData[saveKey] == nil then
                return nil;
            end
            return mockSaveData[saveKey];
        end,
        remove_effect_bundle = function() end,
        apply_effect_bundle = function() end,
        char_is_agent = function() return false end,
        steal_user_input = function() end,
        disable_rebellions_worldwide = function() end,
        find_valid_spawn_location_for_character_from_settlement = function() return 1, 1; end,
        force_diplomacy = function() end,
        apply_effect_bundle_to_force = function() end,
        force_declare_war = function() end,
        enable_movement_for_character = function() end,
        disable_movement_for_character = function() end,
        cai_enable_movement_for_character = function() end,
        cai_disable_movement_for_character = function() end,
        add_unit_model_overrides = function() end,
        force_character_force_into_stance = function() end,
        attack_region = function() end,
        char_lookup_str = function() end,
        suppress_all_event_feed_messages = function() end,
        grant_unit_to_character = function() end,
        show_message_event = function() end,
        show_message_event_located = function() end,
        trigger_incident_with_targets = function() end,
        force_add_and_equip_ancillary = function() end,
        force_add_ancillary = function() end,
        add_agent_experience = function() end,
        apply_effect_bundle_to_region = function() end,
        remove_effect_bundle_from_region = function() end,
        create_new_custom_effect_bundle = function()
            return {
                set_duration = function() end,
                add_effect = function() end,
            };
        end,
        apply_custom_effect_bundle_to_region = function() end,
        apply_custom_effect_bundle_to_faction = function() end,
        get_difficulty = function() return "hard"; end,
        add_first_tick_callback = function() end,
        appoint_character_to_most_expensive_force = function() end,
        change_localised_faction_name = function() end,
        set_region_abandoned = function() end,
        create_force = function() end,
        char_is_general_with_army = function() return true; end,
        force_make_vassal = function() return {}; end,
        add_event_restricted_building_record_for_faction = function() return; end,
        region_slot_instantly_dismantle_building = function() return; end,
        whose_turn_is_it = function() return humanFaction:name(); end,
        add_building_to_settlement = function() end,
        faction_add_pooled_resource = function() end,
        random_number = function(self, limit, start)
            return math.random(start, limit);
        end,
    };
end

cm = get_cm();
mock_max_unit_ui_component = {
    Id = function() return "wh2_dlc10_hef_inf_shadow_walkers_0_recruitable" end,
    ChildCount = function() return 1; end,
    Find = function() return mock_unit_ui_component; end,
    SetVisible = function() end,
    MoveTo = function() end,
    SetStateText = function() end,
    SetInteractive = function() end,
    Visible = function() return true; end,
    Position = function() return 0, 1 end,
    Bounds = function() return 0, 1 end,
    Width = function() return 1; end,
    Resize = function() return; end,
    SetCanResizeWidth = function() return; end,
    SimulateMouseOn = function() return; end,
    GetStateText = function() return "/unit/wh_main_vmp_inf_zombie]]"; end,
    --GetStateText = function() return "Unlocks recruitment of:"; end,
    SetCanResizeHeight = function() end;
    SetCanResizeWidth = function() end;
    Address = function() end,
    Adopt = function() end,
    SetImagePath = function() end,
    SetTooltipText = function() end,
}

mock_unit_ui_component = {
    Id = function() return "wh_main_vmp_inf_zombie_mercenary" end,
    --Id = function() return "building_info_recruitment_effects" end,
    ChildCount = function() return 1; end,
    Find = function() return mock_max_unit_ui_component; end,
    SetVisible = function() end,
    MoveTo = function() end,
    SetStateText = function() end,
    SetInteractive = function() end,
    Visible = function() return true; end,
    Position = function() return 0, 1 end,
    Bounds = function() return 0, 1 end,
    Width = function() return 1; end,
    Resize = function() return; end,
    SetCanResizeWidth = function() return; end,
    SimulateMouseOn = function() return; end,
    GetStateText = function() return "/unit/wh_main_vmp_inf_zombie]]"; end,
    SetCanResizeHeight = function() end;
    SetCanResizeWidth = function() end;
    Address = function() end,
    Adopt = function() end,
    SetImagePath = function() end,
    SetTooltipText = function() end,
}

mock_unit_ui_list_component = {
    Id = function() return "mock_list" end,
    ChildCount = function() return 1; end,
    Find = function() return mock_unit_ui_component; end,
    SetVisible = function() end,
    MoveTo = function() end,
    SetStateText = function() end,
    SetInteractive = function() end,
    Visible = function() return true; end,
    Position = function() return 0, 1 end,
    Bounds = function() return 0, 1 end,
    Width = function() return 1; end,
    Resize = function() return; end,
    SetCanResizeWidth = function() return; end,
    SimulateMouseOn = function() return; end,
    GetStateText = function() return "/unit/wh_main_vmp_inf_zombie]]"; end,
    --GetStateText = function() return "Unlocks recruitment of:"; end,
    SetCanResizeHeight = function() end;
    SetCanResizeWidth = function() end;
    Address = function() end,
    Adopt = function() end,
    SetImagePath = function() end,
    SetTooltipText = function() end,
}

find_uicomponent = function()
    return mock_unit_ui_list_component;
end



UIComponent = function(mock_ui_find) return mock_ui_find; end

core = {
    trigger_event = function(self, listenerEvent)
        for listenerKey, listenerData in pairs(mock_listeners.listeners) do
            if listenerData.Event == listenerEvent then
                local tempObject = {
                    Key = listenerKey,
                };
                mock_listeners:trigger_listener(tempObject);
            end
        end
    end,
    remove_listener = function() end,
    add_listener = function (self, key, eventKey, condition, callback)
        mock_listeners.listeners[key] = {
            Event = eventKey,
            Condition = condition,
            Callback = callback,
        }
    end,
    get_ui_root = function() end,
    get_screen_resolution = function() return 0, 1 end;
    is_mod_loaded = function() return true; end,
    get_or_create_component = function()
        return mock_unit_ui_list_component;
    end
}

random_army_manager = {
    new_force = function() end,
    remove_force = function() end,
    add_mandatory_unit = function() end,
    add_unit = function() end,
    generate_force = function() return ""; end,
}

invasion_manager = {
    new_invasion = function()
        return {
            set_target = function() end,
            apply_effect = function() end,
            add_character_experience = function() end,
            start_invasion = function() end,
            assign_general = function() end,
            create_general = function() end,
        }
    end,
    get_invasion = function() return {
        release = function() return end,
        create_general = function() end,
    };
    end,
}
out = function(text)
  print(text);
end

_G.IsIDE = true;
require 'script/campaign/mod/zzz_mighty_campaigns_dynamic_ai_restrictions'

math.randomseed(os.time())

zzz_mighty_campaigns_dynamic_ai_restrictions();

local DAIR_UpdateGeneralLimits = {
    Key = "DAIR_UpdateGeneralLimits",
    Context = {
        faction = function()
            return testFaction;
        end,
    },
};
mock_listeners:trigger_listener(DAIR_UpdateGeneralLimits);


local DAIR_UpdateConfederationOptionsBase = {
    Key = "DAIR_UpdateConfederationOptions",
    Context = {
        faction = function()
            return humanFaction;
        end,
    },
};
mock_listeners:trigger_listener(DAIR_UpdateConfederationOptionsBase);

humanFaction.imperium_level = function() return 4; end;
local DAIR_UpdateConfederationOptionsMedium = {
    Key = "DAIR_UpdateConfederationOptions",
    Context = {
        faction = function()
            return humanFaction;
        end,
    },
};
mock_listeners:trigger_listener(DAIR_UpdateConfederationOptionsMedium);

humanFaction.imperium_level = function() return 9; end;
local DAIR_UpdateConfederationOptionsMax = {
    Key = "DAIR_UpdateConfederationOptions",
    Context = {
        faction = function()
            return humanFaction;
        end,
    },
};
mock_listeners:trigger_listener(DAIR_UpdateConfederationOptionsMax);