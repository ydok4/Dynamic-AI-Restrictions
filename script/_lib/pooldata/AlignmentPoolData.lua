function GetAlignmentPoolData()
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
        -- relaxed over time when the player reaches appropriate imperium levels
        Rivals = {
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
        BonusArmies = {
            -- Subcultures
            wh_main_sc_grn_greenskins = 1,
            wh_main_sc_grn_savage_orcs = 1,
            wh_main_sc_vmp_vampire_counts = 1,
            wh_main_sc_emp_empire = -1,
            wh_main_sc_brt_bretonnia = -1,
            wh_main_sc_ksl_kislev = -1,
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
            -- Matches default - Testing purposes
            wh2_dlc13_emp_the_huntmarshals_expedition = -1,
            -- Difficult start amongst enemies
            wh2_main_hef_order_of_loremasters = 0,
            -- If one high elf faction should be more a threat, its this one
            wh2_main_hef_eataine = -1,
            -- Has a difficult start
            wh2_dlc15_hef_imrik = 0,
            -- Starts with multiple armies, so not as big a penalty
            wh2_main_hef_yvresse = -1,
            -- Major lizardmen factions should be more of a threat
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
            -- Grimgor needs some help
            wh_main_grn_greenskins = 2,
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
            -- Vortex
            wh2_main_vor_griffon_gate = true,
            wh2_main_vor_eagle_gate = true,
            wh2_main_vor_unicorn_gate = true,
            wh2_main_vor_phoenix_gate = true,
        },
    };
end