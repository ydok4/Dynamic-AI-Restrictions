DynamicAIRestrictions = {
    HumanFactions = {};
    Resources = {

    },
    LoadedLichemaster = false,
    MinimumRequiredImperiumForRival = 2;
    CachedData = {
        CulturesToAlignments = {},
        FactionKey = "",
        LordCap = 2,
    },
    -- Contains a reference to the Chaos Invasion Object
    CI_DATA = {},
};

function DynamicAIRestrictions:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function DynamicAIRestrictions:Initialise(core, CI_DATA, enableLogging)
    self.Logger = Logger:new({});
    self.Logger:Initialise("MightyCampaigns-DynamicAIRestrictions.txt", enableLogging);
    require 'script/_lib/pooldata/AlignmentPoolData'
    self.Resources = GetAlignmentPoolData();
    self.Logger:Log_Start();
    self:SetHumanFactions();
    self:SetupListeners(core);
    self.CI_DATA = CI_DATA;
    if self.CI_DATA ~= nil
    and (self.CI_DATA.CI_INVASION_STAGE == 2
    or self.CI_DATA.CI_INVASION_STAGE == 3) then
        self.Logger:Log("Applying Chaos Invasion bonus for Kislev");
    end
    if cm:is_new_game() then
        self.Logger:Log("Initialising new game options...");
        self:SetupNewGameOptions();
    end
end

function DynamicAIRestrictions:SetHumanFactions()
    local allHumanFactions = cm:get_human_factions();
    if allHumanFactions == nil then
        return nil;
    end
    for key, humanFactionKey in pairs(allHumanFactions) do
        self.Logger:Log("Found human faction: "..humanFactionKey);
        local faction = cm:model():world():faction_by_key(humanFactionKey);
        self.HumanFactions[humanFactionKey] = faction;
    end
end

function DynamicAIRestrictions:SetupNewGameOptions()
    self:SetupDiplomacyRestrictions();
    -- Set bonus armies
    cm:set_saved_value("mid_bonus_alignment_armies_enabled", false);
    cm:set_saved_value("late_bonus_alignment_armies_enabled", false);
    cm:set_saved_value("bonus_alignment_armies", 0);
    -- Set minimum imperium level for rivals
    cm:set_saved_value("last_rival_imperium_level", self.MinimumRequiredImperiumForRival);
    -- Set unrestrict order confederations
    cm:set_saved_value("unrestrict_order_federations", false);
    -- Setup Dark Elf/High Elf diplomacy
    self.Logger:Log("Finished new game options.");
end

function DynamicAIRestrictions:SetupListeners(core)
    core:add_listener(
        "DAIR_UpdateGeneralLimits",
        "FactionTurnStart",
        function(context)
            local faction = context:faction();
            return not faction:is_dead()
            and self:IsExcludedFaction(faction) == false;
        end,
        function(context)
            local faction = context:faction();
            local factionKey = faction:name();
            self.Logger:Log("Doing limits for faction: "..faction:name());
            self:ApplyArmyLimits(faction);
            local unrestrictOrderFederations = cm:get_saved_value("unrestrict_order_federations");
            -- If the player has reached a high enough imperium level
            if unrestrictOrderFederations == true then
                -- If this is a high elf faction, remove the dark elf diplomacy restriction,
                -- The effect bundle check should ensure this only happens once
                if self.Resources.HighElfFactions[factionKey] ~= nil
                and faction:has_effect_bundle("ird_restored_diplomacy") == false then
                    local playersAlignment = self:GetPlayersAlignment();
                    -- If the player isn't the same alignment as Order
                    -- This ensures the High Elves stay kinda passive
                    -- It is possible for minor factions to declare war on dark elves
                    -- if they are in a military alliance with teclis, tyrion or Alith Anar
                    if playersAlignment["ForcesOfOrder"] ~= nil then
                        self.Logger:Log("Removing HEF AI war declaration restriction for faction: "..factionKey);
                        self:SetupHighElfDiplomacyRestrictions(true, factionKey);
                        cm:apply_effect_bundle("ird_restored_diplomacy", factionKey, 0);
                        core:remove_listener("DAI_RegionTurnStart");
                        self.Logger:Log_Finished();
                    end
                end
            end

            self.Logger:Log_Finished();
        end,
        true
    );

    local campaignName = cm:get_campaign_name();
    core:add_listener(
        "DAIR_UpdateConfederationOptions",
        "FactionTurnEnd",
        function(context)
            local faction = context:faction();
            local factionName = faction:name();
            return self.HumanFactions[factionName] ~= nil;
        end,
        function(context)
            self.Logger:Log_Start();
            local faction = context:faction();
            local factionKey = faction:name();
            local playerImperiumLevel = faction:imperium_level();
            self.Logger:Log("Player imperium: "..playerImperiumLevel);
            -- Update bonus AI armies
            local midAlignmentBonusEnabled = cm:get_saved_value("mid_bonus_alignment_armies_enabled");
            local lateAlignmentBonusEnabled = cm:get_saved_value("late_bonus_alignment_armies_enabled");
            if midAlignmentBonusEnabled == false
            and playerImperiumLevel > 2 then
                cm:set_saved_value("bonus_alignment_armies", 1);
                cm:set_saved_value("mid_bonus_alignment_armies_enabled", true);
            elseif lateAlignmentBonusEnabled == false
            and playerImperiumLevel > 4 then
                cm:set_saved_value("bonus_alignment_armies", 2);
                cm:set_saved_value("late_bonus_alignment_armies_enabled", true);
            end
            -- Check if player meets the imperium level to enable confederations again
            local unrestrictOrderFederations = cm:get_saved_value("unrestrict_order_federations");
            if playerImperiumLevel > 5 then
                if unrestrictOrderFederations == false then
                    local playersAlignment = self:GetPlayersAlignment();
                    if playersAlignment["ForcesOfOrder"] ~= nil then
                        self.Logger:Log("Unrestricting order forces confederations...");
                        for index, cultureKey in pairs(self.Resources.Alignments["ForcesOfOrder"]) do
                            self:UnRestrictConfederationsForCulture(cultureKey);
                        end
                        cm:set_saved_value("unrestrict_order_federations", true);
                    end
                end
            elseif unrestrictOrderFederations == false then
                self:SetupDiplomacyRestrictions();
                -- Update confederation options for rivals
                local rivalData = self.Resources.Rivals[factionKey];
                if rivalData ~= nil then
                    if rivalData.Factions ~= nil then
                        self.Logger:Log("Checking for new rivals...");
                        local minimumImperiumForRival = self.MinimumRequiredImperiumForRival;
                        if rivalData.MinimumImperium ~= nil then
                            minimumImperiumForRival = rivalData.MinimumImperium;
                        end
                        for index, rivalFactionKey in pairs(rivalData.Factions) do
                            if playerImperiumLevel > minimumImperiumForRival + (index - 1) then
                                self.Logger:Log("Player meets requirement for rival: "..rivalFactionKey);
                                local rivalFaction = cm:get_faction(rivalFactionKey);
                                self:UnRestrictConfederationsForFaction(rivalFaction);
                                self:ApplyRivalFactionEffects(rivalFaction);
                            end
                        end
                    end
                end
            end

            self.Logger:Log_Finished();
        end,
        true
    );
    -- We need to override this vanilla listener
    core:remove_listener("confederation_expired");
    core:add_listener(
		"confederation_expired",
		"ScriptEventConfederationExpired",
		true,
		function(context)
			local faction_name = context.string;
			local faction = cm:get_faction(faction_name);
			local subculture = faction:subculture();

			out("Unrestricting confederation between [faction:" .. faction_name .. "] and [subculture: " .. subculture .. "]");
			cm:force_diplomacy("faction:" .. faction_name, "subculture:" .. subculture, "form confederation", true, true, false);

			---hack fix to stop this re-enabling confederation when it needs to stay disabled
			---please let's make this more robust!
			if subculture == "wh2_main_sc_hef_high_elves" then
				local grom_faction = cm:get_faction("wh2_dlc15_grn_broken_axe")
				if grom_faction ~= false and grom_faction:is_human() then
					cm:force_diplomacy("subculture:wh2_main_sc_hef_high_elves","faction:wh2_main_hef_yvresse","form confederation", false, true, false);
				end
            end
            --DynamicAIRestrictions BEGIN
            local unrestrictOrderFederations = cm:get_saved_value("unrestrict_order_federations");
            -- If we've already unrestricted order factions, then there isn't
            -- any point resetting restrictions
            if unrestrictOrderFederations == false then
                self:SetupDiplomacyRestrictions();
            end
            --DynamicAIRestrictions END
		end,
		true
    );
    -- Remove greenskin confederation listeners and change it so it only works for the player in the early game
    -- Confederation makes the Greenskin AI more susceptible to being wiped (especially in the Badlands)
    local greenskin = "wh_main_sc_grn_greenskins";
    core:remove_listener("character_completed_battle_greenskin_confederation_dilemma");
	core:add_listener(
		"character_completed_battle_greenskin_confederation_dilemma",
		"CharacterCompletedBattle",
		true,
        function(context)
            -- We use this as the trigger to re-enable confederations for the AI
            local mid_bonus_alignment_armies enabled = cm:get_saved_value("mid_bonus_alignment_armies_enabled");
            local character = context:character();
            if character:won_battle() == true and character:faction():subculture() == greenskin and not character:faction():name():find("rebel") 
            and not character:faction():name():find("invasion") and not character:faction():name():find("waaagh") and character:faction():is_quest_battle_faction() == false then
                local enemies = cm:pending_battle_cache_get_enemies_of_char(character);
                local enemy_count = #enemies;
                if context:pending_battle():night_battle() == true or context:pending_battle():ambush_battle() == true then
                    enemy_count = 1;
                end

                local character_cqi = character:command_queue_index();
                local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(1);
                local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
                if character_cqi == attacker_cqi or character_cqi == defender_cqi then
                    for i = 1, enemy_count do
                        local enemy = enemies[i];
                        if enemy ~= nil and enemy:is_null_interface() == false and enemy:is_faction_leader() == true and enemy:faction():subculture() == greenskin and enemy:faction():is_quest_battle_faction() == false then
                            if enemy:has_military_force() == true and enemy:military_force():is_armed_citizenry() == false then
                                if character:faction():is_human() == true and enemy:faction():is_human() == false and enemy:faction():is_dead() == false then
                                    -- Trigger dilemma to offer confederation
                                    local GREENSKIN_CONFEDERATION_PLAYER = character:faction():name();
                                    local GREENSKIN_CONFEDERATION_DILEMMA = "wh2_main_grn_confederate_";
                                    cm:trigger_dilemma(GREENSKIN_CONFEDERATION_PLAYER, GREENSKIN_CONFEDERATION_DILEMMA..enemy:faction():name());
                                -- Condition is changed so it only fires for the AI if the player has reached an appropriate imperium level
                                elseif mid_bonus_alignment_armies == true and not character:faction():name():find("rebel") and character:faction():is_human() == false and enemy:faction():is_human() == false then
                                    out.design("###### Modified greenskin CONFEDERATION");
                                    -- AI confederation
                                    cm:force_confederation(character:faction():name(), enemy:faction():name());
                                    out.design("###### AI GREENSKIN CONFEDERATION");
                                    out.design("Faction: "..character:faction():name().." is confederating "..enemy:faction():name());
                                end
                            end
                        end
                    end
                end
            end
		end,
		true
	);

    core:add_listener(
        "DAI_RegionTurnStart",
        "RegionTurnStart",
        function(context)
            local region = context:region();
            local regionName = region:name();
            return not region:is_null_interface()
            and not region:is_abandoned()
            and self.Resources.UlthuanRegions[campaignName][regionName] == true;
        end,
        function(context)
            local region = context:region();
            local regionName = region:name();
            local owningFaction = region:owning_faction();
            if owningFaction:subculture() == "wh2_main_sc_def_dark_elves"
            and owningFaction:has_effect_bundle("ird_restored_diplomacy") == false then
                self.Logger:Log("Checking Ulthuan region: "..regionName);
                local factionKey = owningFaction:name();
                self.Logger:Log("Allowing Elven war against: "..factionKey);
                self:SetupHighElfDiplomacyRestrictions(true, factionKey);
                cm:apply_effect_bundle("ird_restored_diplomacy", factionKey, 0);
                self.Logger:Log("Finished high elf diplomacy change");
                self.Logger:Log_Finished();
            end
        end,
        true
    );
    if core:is_mod_loaded("liche_init") then
        self.LoadedLichemaster = true;
    end
end

function DynamicAIRestrictions:ApplyArmyLimits(faction)
    if faction:subculture() ~= "wh_dlc03_sc_bst_beastmen"
    and faction:subculture() ~= "wh_main_sc_chs_chaos"
    and faction:subculture() ~= "wh2_dlc09_sc_tmb_tomb_kings"
    and faction:name() ~= "wh2_dlc13_lzd_spirits_of_the_jungle" then
        self:CreateCachedData(faction);
        local factionKey = faction:name();
        self.Logger:Log("Applying army limits for faction: "..factionKey.." number of armies is: "..(self.CachedData.LordCap + 1));
        local customEffectBundle = cm:create_new_custom_effect_bundle("wh_main_effect_dair_dummy_army_cap");
        local useUnlimited = false;
        -- When using Lichemaster and we are updating Kemmler's faction, they should have unlimited armies
        -- cause they are capped anyway
        if self.LoadedLichemaster == true
        and faction:name() == "wh2_dlc11_vmp_the_barrow_legion" then
            useUnlimited = true;
        end
        if useUnlimited == true
        or faction:is_human() == true then
            self.Logger:Log("Using unlimited army cap");
            customEffectBundle:add_effect("wh2_dlc09_effect_increase_army_capacity", "faction_to_faction_own_unseen", 9999);
        else
            customEffectBundle:add_effect("wh2_dlc09_effect_increase_army_capacity", "faction_to_faction_own_unseen", self.CachedData.LordCap);
        end
        customEffectBundle:set_duration(0);
        cm:apply_custom_effect_bundle_to_faction(customEffectBundle, faction);
        self.Logger:Log_Finished();
    end
end

function DynamicAIRestrictions:CreateCachedData(faction)
    local campaignName = cm:get_campaign_name();
    local factionKey = faction:name();
    local subcultureKey = faction:subculture();
    local baseArmyCap = -1; -- By default the game ensures the minimum cap is 1
    local numberOfLocalRegions = 0;
    local minimumArmyAmount = 0;
    local overallLordCap = baseArmyCap;
    -- Climate bonus armies
    local regionList = faction:region_list();
    for i = 0, regionList:num_items() - 1 do
        local region = regionList:item_at(i);
        local regionKey = region:name();
        local settlement = region:settlement();
        local climateKey = settlement:get_climate();
        local isSuitableClimate = faction:get_climate_suitability(climateKey);
        if isSuitableClimate == "suitability_good"
        and not self.Resources.RegionsToIgnore[regionKey] then
            if region:is_province_capital() == true then
                self.Logger:Log("Region: "..region:name().." is suitable.");
                overallLordCap = overallLordCap + 1;
                -- If the faction is a hef faction
                -- and this is an ulthuan region that isn't Tor Anlec
                -- then we increase the number of 'local' regions
                if subcultureKey == "wh2_main_sc_hef_high_elves"
                and self.Resources.UlthuanRegions[campaignName][regionKey] == true
                and regionKey ~= "wh2_main_nagarythe_tor_anlec"
                and regionKey ~= "wh2_main_vor_nagarythe_tor_anlec" then
                    numberOfLocalRegions = numberOfLocalRegions + 1;
                    -- Then we increase the minimum army amount
                    -- If they have more than 1, we increase their minimum army amount
                    if numberOfLocalRegions > 1 then
                        self.Logger:Log("Hef faction has additional Ulthuan region: "..region:name());
                        minimumArmyAmount = minimumArmyAmount + 1;
                    end
                end
            end
        end
    end
    self.Logger:Log("Region/Climate bonus is: "..overallLordCap);
    -- Faction bonus armies
    local factionBonusArmies = self:GetFactionBonusArmies(faction);
    self.Logger:Log("Faction bonus is: "..factionBonusArmies);
    overallLordCap = overallLordCap + factionBonusArmies;
    -- Apply Chaos Invasion bonus because Kislev will lose territory really fast
    if factionKey == "wh_main_ksl_kislev"
    and self.CI_DATA ~= nil
    and (self.CI_DATA.CI_INVASION_STAGE == 2
    or self.CI_DATA.CI_INVASION_STAGE == 3) then
        self.Logger:Log("Applying Chaos Invasion bonus for Kislev");
        overallLordCap = overallLordCap + 1;
    end
    -- Enforce minimum
    -- Lokhir needs a boost in Mortal Empires
    if factionKey == "wh2_dlc11_def_the_blessed_dread"
    and overallLordCap < 1
    and cm:get_campaign_name() == "main_warhammer" then
        overallLordCap = 1;
    elseif overallLordCap < minimumArmyAmount then
        overallLordCap = minimumArmyAmount;
    end
    self.Logger:Log("Adjusted cap with minimum: "..overallLordCap);
    -- Alignment bonus armies
    local playersAlignment = self:GetPlayersAlignment();
    local factionAlignment = self:GetFactionAlignment(faction);
    if playersAlignment[factionAlignment] == nil
    and (self.Resources.OrderAlignmentBonusFactions[factionKey] == true
    or factionAlignment ~= "ForcesOfOrder") then
        local bonusAlignmentArmies = cm:get_saved_value("bonus_alignment_armies");
        self.Logger:Log("Adding alignment bonus ("..bonusAlignmentArmies..") to faction: "..factionKey);
        overallLordCap = overallLordCap + bonusAlignmentArmies;
    end

    -- We only apply this bonus if the player is an order faction
    if playersAlignment["ForcesOfOrder"] ~= nil
    and factionAlignment ~= "ForcesOfOrder" then
        for factionKey, humanFaction in pairs(self.HumanFactions) do
            if faction:at_war_with(humanFaction) == true then
                self.Logger:Log("Adding +1 bonus because faction is at war with human order faction");
                overallLordCap = overallLordCap + 1;
                break;
            end
        end
    end

    self.Logger:Log("Army limit: "..overallLordCap);
    self.CachedData.FactionKey = factionKey;
    self.CachedData.LordCap = overallLordCap;
end

function DynamicAIRestrictions:IsExcludedFaction(faction)
    local factionName = faction:name();
    if factionName == "wh_main_grn_skull-takerz" then
        return false;
    end
    --self.Logger:Log("Checking faction is excluded: "..factionName);
    if factionName == "rebels" or
    faction:is_quest_battle_faction() == true or
    string.match(factionName, "waaagh") ~= nil or
    string.match(factionName, "rogue") ~= nil or
    string.match(factionName, "brayherd") ~= nil or
    string.match(factionName, "intervention") ~= nil or
    string.match(factionName, "incursion") ~= nil or
    string.match(factionName, "separatists") ~= nil or
    factionName == "wh2_dlc13_lzd_defenders_of_the_great_plan" or
    factionName == "wh_dlc03_bst_beastmen_chaos" or
    factionName == "wh2_dlc11_cst_vampire_coast_encounters"
    then
        --self.Logger:Log("Faction is excluded");
        return true;
    end
    --self.Logger:Log("Faction is not excluded");
    return false;
end

function DynamicAIRestrictions:GetFactionBonusArmies(faction)
    local factionKey = faction:name();
    local subcultureKey = faction:subculture();
    if self.Resources.BonusArmies[factionKey] ~= nil then
        return self.Resources.BonusArmies[factionKey];
    end

    if self.Resources.BonusArmies[subcultureKey] ~= nil then
        return self.Resources.BonusArmies[subcultureKey];
    end

    return 0;
end

function DynamicAIRestrictions:SetupDiplomacyRestrictions()
    local playerCultures = {};
    for humanFactionKey, humanFaction in pairs(self.HumanFactions) do
        playerCultures[humanFaction:culture()] = humanFaction;
    end

    -- Initialise starting confederation options
    for alignmentType, cultureAlignments in pairs(self.Resources.Alignments) do
        if alignmentType == "ForcesOfOrder" then
            for index, cultureKey in pairs(cultureAlignments) do
                self:RestrictConfederationsForCulture(cultureKey);
            end
        elseif alignmentType == "ForcesOfDestruction" then
            for index, cultureKey in pairs(cultureAlignments) do
                if playerCultures[cultureKey] ~= nil
                and cultureKey ~= "wh_main_grn_greenskins"
                and cultureKey ~= "wh_main_sc_vmp_vampire_counts" then
                    self:RestrictConfederationsForCulture(cultureKey);
                end
            end
        end
    end
    -- Then remove the restrictions for the player
    for humanFactionKey, humanFaction in pairs(self.HumanFactions) do
        self.Logger:Log("Human faction is: "..humanFactionKey);
        -- As per vanilla, tomb kings and vampire coast can't confederate
        if humanFaction:culture() ~= "wh2_dlc09_tmb_tomb_kings"
        and humanFaction:culture() ~= "wh2_dlc11_cst_vampire_coast" then
            cm:callback(function()
                self:UnRestrictConfederationsForFaction(humanFaction);
                self.Logger:Log_Finished();
            end, 0.2);
        end
    end
end

function DynamicAIRestrictions:RestrictConfederationsForCulture(culture, exceptFaction)
    -- Restrict confederations for all culture factions
    cm:force_diplomacy("culture:"..culture, "all", "form confederation", false, false, true);
    -- Then unrestrict confederations for the faction
    if exceptFaction and exceptFaction:culture() == culture then
        --self.Logger:Log("IRD: Unrestricting diplomacy for "..tostring(exceptFaction:name()))
        cm:force_diplomacy("faction:"..exceptFaction:name(), "culture:"..culture, "form confederation", true, false);
    end
end

function DynamicAIRestrictions:UnRestrictConfederationsForCulture(culture)
    -- Unrestrict confederations for faction within culture
    self.Logger:Log("IRD: Unrestricting confderations for "..culture)
    cm:force_diplomacy("culture:"..culture, "all", "form confederation", true, true, true);
end

function DynamicAIRestrictions:UnRestrictConfederationsForFaction(exceptFaction)
    -- Unrestrict confederations for faction within culture
    self.Logger:Log("IRD: Unrestricting diplomacy for "..tostring(exceptFaction:name()))
    cm:force_diplomacy("faction:"..exceptFaction:name(), "all", "form confederation", true, true, false);
end

function DynamicAIRestrictions:ApplyRivalFactionEffects(rivalFaction)
    local rivalSubculture = rivalFaction:subculture();
    local rivalEffects = self.Resources.RivalEffects[rivalSubculture];
    if rivalEffects ~= nil then
        self.Logger:Log("Applying rival effect for subculture: "..rivalSubculture);
        local customEffectBundle = cm:create_new_custom_effect_bundle("wh_main_effect_dair_dummy_rival_effects");
        for effectKey, effectData in pairs(rivalEffects) do
            customEffectBundle:add_effect(effectKey, effectData.Scope, effectData.Value);
        end
        cm:apply_custom_effect_bundle_to_faction(customEffectBundle, rivalFaction);
    end
end

-- This should only be used for single player functions
function DynamicAIRestrictions:GetPlayersAlignment()
    self:CreateAlignmentCache();
    local alignments = {};
    for humanFactionKey, humanFaction in pairs(self.HumanFactions) do
        local playerCulture = humanFaction:culture();
        alignments[self.CachedData.CulturesToAlignments[playerCulture]] = playerCulture;
    end
    return alignments;
end

function DynamicAIRestrictions:GetFactionAlignment(faction)
    self:CreateAlignmentCache();
    return self.CachedData.CulturesToAlignments[faction:culture()];
end

function DynamicAIRestrictions:CreateAlignmentCache()
    if not next(self.CachedData.CulturesToAlignments) then
        for alignmentKey, cultureAlignments in pairs(self.Resources.Alignments) do
            for index, cultureKey in pairs(cultureAlignments) do
                self.CachedData.CulturesToAlignments[cultureKey] = alignmentKey;
            end
        end
    end
end

function DynamicAIRestrictions:SetupHighElfDiplomacyRestrictions(restriction, factionKey)
    local restrictionTarget = "culture:wh2_main_def_dark_elves";
    if factionKey ~= nil then
        restrictionTarget = "faction:"..factionKey;
    end
    -- Stop/Start minor and most major factions from declaring war on Dark Elves
    for index, factionKey in pairs(self.Resources.HighElfFactions) do
        if factionKey ~= "wh2_main_hef_order_of_loremasters"
        and factionKey ~= "wh2_main_hef_eataine"
        and factionKey ~= "wh2_main_hef_nagarythe" then
            local faction = cm:get_faction(factionKey);
            if faction
            and not faction:is_human() then
                cm:force_diplomacy("faction:" .. factionKey, restrictionTarget, "war", restriction, restriction, false);
            end
        end
    end
end