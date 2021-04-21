function GetAlignmentPoolData()
    -- Updated for Rakarth
    return {
        -- Alignments determine confederation options
        -- at game start and army limits as the game
        -- progresses
        Alignments = {
            ForcesOfOrder = {
                -- Empire includes TEB and Kislev
                "wh_main_emp_empire",
                "wh_main_brt_bretonnia",
                "wh2_main_hef_high_elves",
                "wh2_main_lzd_lizardmen",
                "wh_main_dwf_dwarfs",
            },
            ForcesOfChaos = {
                -- Chaos includes Norsca
                "wh_main_chs_chaos",
                "wh_dlc03_bst_beastmen",
            },
            ForcesOfDestruction = {
                "wh_main_vmp_vampire_counts",
                "wh_main_grn_greenskins",
                "wh2_main_skv_skaven",
                "wh2_dlc11_cst_vampire_coast",
                "wh2_main_def_dark_elves",
            },
            Unaligned = {
                "wh2_dlc09_tmb_tomb_kings",
                "wh_dlc05_wef_wood_elves",
            },
        },
        -- Certain factions have rivals  which may have confederation options
        -- relaxed over time when the player reaches appropriate imperium levels.
        -- Additionally, Vampire Counts will get 100% upkeep reduction for zombies + skeles and additional recruitment slots
        Rivals = {
            -- Bretonnia
            wh_main_brt_bretonnia = {
                Factions = { "wh_main_vmp_mousillon", "wh2_dlc11_vmp_the_barrow_legion", },
                MinimumImperium = 1,
            },
            wh_main_brt_carcassonne = {
                Factions = { "wh_main_vmp_mousillon", "wh2_dlc11_vmp_the_barrow_legion", },
                MinimumImperium = 1,
            },
            wh_main_brt_bordeleaux = {
                Factions = { "wh_main_vmp_mousillon", "wh2_dlc11_vmp_the_barrow_legion", },
                MinimumImperium = 1,
            },
            -- Dark Elves
            wh2_main_def_naggarond = {
                Factions = { "wh2_main_hef_eataine", "wh2_main_hef_avelorn", },
            },
            wh2_main_def_cult_of_pleasure = {
                Factions = { "wh2_main_hef_eataine", "wh2_main_hef_avelorn", "wh2_main_lzd_hexoatl", },
            },
            wh2_main_def_har_ganeth = {
                Factions = { "wh2_main_hef_avelorn", "wh2_main_hef_eataine", },
            },
            wh2_dlc11_def_the_blessed_dread = {
                Factions = { "wh2_main_lzd_itza", "wh2_main_lzd_hexoatl", },
            },
            -- Empire = {
            wh_main_emp_empire = {
                Factions = { "wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", },
                MinimumImperium = 1,
            },
            wh2_dlc13_emp_golden_order = {
                Factions = { "wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", },
                MinimumImperium = 1,
            },
            -- Skaven
            wh2_main_skv_clan_mors = {
                Factions = { "wh2_main_lzd_last_defenders", },
            },
            wh2_main_skv_clan_pestilens = {
                Factions = { "wh2_main_lzd_itza", "wh2_main_lzd_hexoatl", },
            },
            -- Vampire coast
            wh2_dlc11_cst_vampire_coast = {
                Culture = { "wh2_main_lzd_lizardmen", },
            },
            -- Vampire Counts
            wh_main_vmp_vampire_counts = {
                Factions = { "wh_main_emp_empire", "wh2_dlc13_emp_golden_order", },
            },
            wh_main_vmp_schwartzhafen = {
                Factions = { "wh_main_emp_empire", "wh2_dlc13_emp_golden_order", },
            },
            wh_main_vmp_mousillon = {
                Factions = { "wh_main_brt_bretonnia", "wh_main_emp_empire", },
            },
            wh2_dlc11_vmp_the_barrow_legion = {
                Factions = { "wh_main_brt_bretonnia", "wh_main_emp_empire", },
            },
        },
        -- These are effect bonuses that will be applied if the rival faction matches this subculture
        RivalEffects = {
            wh_main_sc_vmp_vampire_counts = {
                wh2_dlc11_effect_tech_no_upkeep_cost_zombies = {
                    Scope = "faction_to_faction_own_unseen",
                    Value = -100,
                },
                wh2_dlc11_effect_tech_no_upkeep_cost_skeletons = {
                    Scope = "faction_to_faction_own_unseen",
                    Value = -100,
                },
                wh_main_effect_unit_recruitment_points = {
                    Scope = "faction_to_faction_own_unseen",
                    Value = 2,
                },
            },
        },
        -- Only some order factions receive alignment bonuses
        -- because there are usually more order factions hanging around
        OrderAlignmentBonusFactions = {
            wh_main_emp_empire = true,
            wh_main_brt_bretonnia = true,
            wh_main_ksl_kislev = true,
            wh2_main_hef_eataine = true,
            wh2_main_hef_order_of_loremasters = true,
            wh_main_dwf_dwarfs = true,
            wh2_main_lzd_hexoatl = true,
        },
        BonusArmies = {
            -- Subcultures
            wh_main_sc_grn_greenskins = 1,
            wh_main_sc_grn_savage_orcs = 1,
            wh_main_sc_vmp_vampire_counts = 1,
            wh_main_sc_emp_empire = -1,
            wh_main_sc_ksl_kislev = -1,
            wh_main_sc_teb_teb = -1,
            wh_main_sc_brt_bretonnia = -1,
            wh2_main_sc_skv_skaven = 2,
            wh_main_sc_dwf_dwarfs = -1,
            wh2_main_sc_hef_high_elves = -2,
            wh2_main_sc_lzd_lizardmen = -1,
            wh_main_sc_nor_norsca = 1,
            -- Order aligned major Factions
            wh_main_emp_empire = 0,
            wh2_dlc13_emp_golden_order = 0,
            wh_main_brt_bretonnia = 0,
            wh_main_brt_carcassonne = 0,
            wh2_dlc14_brt_chevaliers_de_lyonesse = 0,
            wh_main_ksl_kislev = 0,
            -- With the Moot excluded from giving army bonuses
            -- Vlad needs an extra bonus since he only starts with a minor settlement
            -- It also lets him recruit Isabella at the same time
            --wh_main_vmp_schwartzhafen = 2,
            -- ER Kislev only factions, helps chaos not
            -- have as strong a wall, especially with the main Kislev faction nearby
            -- which get alignment bonuses.
            wh_main_ksl_praag = -2,
            wh_main_vmp_tri = -1,
            -- These Dwarfs actually need some help
            wh_main_dwf_karak_kadrin = 0,
            -- Matches default - Testing purposes
            wh2_dlc13_emp_the_huntmarshals_expedition = -1,
            -- If one high elf faction should be more a threat, its this one
            wh2_main_hef_eataine = -1,
            -- Drycha takes a little too much territory
            wh2_dlc16_wef_drycha = -1,
            -- Difficult start amongst enemies
            wh2_main_hef_order_of_loremasters = -1,
            -- Has a difficult start and can use a boost
            wh2_dlc15_hef_imrik = -1,
            -- Major Lustrian Lizardmen factions should be more of a threat
            -- Mazdamundi especially needs some help
            wh2_main_lzd_hexoatl = 0,
            wh2_main_lzd_itza = 0,
            wh2_dlc12_lzd_cult_of_sotek = 0,
            -- Except defenders, they get rolling too easily
            wh2_main_lzd_last_defenders = -1,
            -- Can overperform sometimes
            wh2_dlc14_grn_red_cloud = 0,
            -- High elf campaigns are more interesting if the Dark Elves are stronger
            wh2_main_def_naggarond = 1,
            wh2_main_def_scourge_of_khaine = 1,
            -- Helps Morathi out
            wh2_main_def_cult_of_pleasure = 1,
            wh2_main_def_ssildra_tor = -1,
            -- Helps the Naggarond AI out
            wh2_dlc16_grn_naggaroth_orcs = 0,
            wh2_main_skv_clan_septik = 1,
            -- These two tend to overperform in the Badlands
            wh_main_dwf_dwarfs = -2, -- They still beat Grimgor!
            wh_main_dwf_karak_azul = -2,
            -- Major Greenskin factions need some help
            wh_main_grn_greenskins = 2,
            wh_main_grn_crooked_moon = 2,
            wh2_dlc15_grn_broken_axe = 2,
            -- Minor greenskins can over perform now
            wh_main_grn_scabby_eye = 1, -- Testing
            wh2_dlc15_grn_skull_crag = 1, -- Testing
            wh_main_grn_teef_snatchaz = 0,
            -- Mixu Unlocker specific
            wh2_main_wef_wychwethyl = -1,
        },
        -- Factions starting with single regions
        -- get too big of an advantage. Eg Elyrion
        RegionsToIgnore = {
            -- ME
            wh2_main_griffon_gate = true,
            wh2_main_eagle_gate = true,
            wh2_main_unicorn_gate = true,
            wh2_main_phoenix_gate = true,
            wh2_main_fort_helmgart = true,
            wh2_main_fort_soll = true,
            wh2_main_fort_bergbres = true,
            wh_main_stirland_the_moot = true,
            -- Vortex
            wh2_main_vor_griffon_gate = true,
            wh2_main_vor_eagle_gate = true,
            wh2_main_vor_unicorn_gate = true,
            wh2_main_vor_phoenix_gate = true,
        },
        -- Dark Elf/High Elf war declartion functionality
        HighElfFactions = {
            "wh2_main_hef_order_of_loremasters",
            "wh2_main_hef_eataine",
            "wh2_main_hef_chrace",
            "wh2_main_hef_avelorn",
            "wh2_main_hef_nagarythe",
            "wh2_main_hef_yvresse",
            "wh2_main_hef_tiranoc",
            "wh2_main_hef_saphery",
            "wh2_main_hef_fortress_of_dawn",
            "wh2_main_hef_citadel_of_dusk",
            "wh2_main_hef_ellyrion",
            "wh2_main_hef_cothique",
            "wh2_main_hef_caledor",
            "wh2_dlc15_hef_imrik",
        },
        UlthuanRegions = {
            ["main_warhammer"] = {
                -- Outer
                ["wh2_main_caledor_vauls_anvil"] = true,
                ["wh2_main_caledor_tor_sethai"] = true,
                ["wh2_main_tiranoc_whitepeak"] = true,
                ["wh2_main_tiranoc_tor_anroc"] = true,
                ["wh2_main_nagarythe_tor_dranil"] = true,
                ["wh2_main_nagarythe_tor_anlec"] = true,
                ["wh2_main_nagarythe_shrine_of_khaine"] = true,
                ["wh2_main_chrace_tor_achare"] = true,
                ["wh2_main_chrace_elisia"] = true,
                ["wh2_main_cothique_mistnar"] = true,
                ["wh2_main_cothique_tor_koruali"] = true,
                ["wh2_main_yvresse_tor_yvresse"] = true,
                ["wh2_main_yvresse_elessaeli"] = true,
                ["wh2_main_yvresse_tralinia"] = true,
                ["wh2_main_yvresse_shrine_of_loec"] = true,
                -- Inner
                ["wh2_main_eataine_lothern"] = true,
                ["wh2_main_eataine_tower_of_lysean"] = true,
                ["wh2_main_ellyrion_tor_elyr"] = true,
                ["wh2_main_eagle_gate"] = true,
                ["wh2_main_ellyrion_whitefire_tor"] = true,
                ["wh2_main_griffon_gate"] = true,
                ["wh2_main_avelorn_evershale"] = true,
                ["wh2_main_unicorn_gate"] = true,
                ["wh2_main_phoenix_gate"] = true,
                ["wh2_main_avelorn_tor_saroir"] = true,
                ["wh2_main_avelorn_gaean_vale"] = true,
                ["wh2_main_saphery_tor_finu"] = true,
                ["wh2_main_saphery_tower_of_hoeth"] = true,
                ["wh2_main_saphery_port_elistor"] = true,
                ["wh2_main_eataine_angerrial"] = true,
                ["wh2_main_eataine_shrine_of_asuryan"] = true,
            },
            ["wh2_main_great_vortex"] = {
                -- Outer
                ["wh2_main_vor_straits_of_lothern_glittering_tower"] = true,
                ["wh2_main_vor_caledor_vauls_anvil"] = true,
                ["wh2_main_vor_caledor_caledors_repose"] = true,
                ["wh2_main_vor_caledor_tor_sethai"] = true,
                ["wh2_main_vor_tiranoc_whitepeak"] = true,
                ["wh2_main_vor_tiranoc_tor_anroc"] = true,
                ["wh2_main_vor_tiranoc_the_high_vale"] = true,
                ["wh2_main_vor_tiranoc_salvation_isle"] = true,
                ["wh2_main_vor_nagarythe_tor_dranil"] = true,
                ["wh2_main_vor_nagarythe_tor_anlec"] = true,
                ["wh2_main_vor_nagarythe_shrine_of_khaine"] = true,
                ["wh2_main_vor_chrace_tor_gard"] = true,
                ["wh2_main_vor_chrace_tor_achare"] = true,
                ["wh2_main_vor_chrace_elisia"] = true,
                ["wh2_main_vor_cothique_tor_koruali"] = true,
                ["wh2_main_vor_cothique_mistnar"] = true,
                ["wh2_main_vor_northern_yvresse_sardenath"] = true,
                ["wh2_main_vor_northern_yvresse_tor_yvresse"] = true,
                ["wh2_main_vor_northern_yvresse_tralinia"] = true,
                ["wh2_main_vor_southern_yvresse_elessaeli"] = true,
                ["wh2_main_vor_southern_yvresse_shrine_of_loec"] = true,
                ["wh2_main_vor_southern_yvresse_cairn_thel"] = true,
                -- Inner
                ["wh2_main_vor_straits_of_lothern_lothern"] = true,
                ["wh2_main_vor_straits_of_lothern_tower_of_lysean"] = true,
                ["wh2_main_vor_ellyrion_the_arc_span"] = true,
                ["wh2_main_vor_eagle_gate"] = true,
                ["wh2_main_vor_ellyrion_tor_elyr"] = true,
                ["wh2_main_vor_griffon_gate"] = true,
                ["wh2_main_vor_ellyrion_reavers_mark"] = true,
                ["wh2_main_vor_unicorn_gate"] = true,
                ["wh2_main_vor_avelorn_evershale"] = true,
                ["wh2_main_vor_phoenix_gate"] = true,
                ["wh2_main_vor_avelorn_tor_saroir"] = true,
                ["wh2_main_vor_avelorn_gaean_vale"] = true,
                ["wh2_main_vor_saphery_tor_finu"] = true,
                ["wh2_main_vor_saphery_shadow_peak"] = true,
                ["wh2_main_vor_saphery_tower_of_hoeth"] = true,
                ["wh2_main_vor_saphery_port_elistor"] = true,
                ["wh2_main_vor_eataine_angerrial"] = true,
                ["wh2_main_vor_eataine_shrine_of_asuryan"] = true,
            },
        },
    };
end