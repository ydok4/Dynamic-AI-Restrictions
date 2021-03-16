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
};

function DynamicAIRestrictions:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function DynamicAIRestrictions:Initialise(core, enableLogging)
    self.Logger = Logger:new({});
    self.Logger:Initialise("MightyCampaigns-DynamicAIRestrictions.txt", enableLogging);
    require 'script/_lib/pooldata/AlignmentPoolData'
    self.Resources = GetAlignmentPoolData();
    self:SetHumanFactions();
    self:SetupListeners(core);
    self.Logger:Log_Start();
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
            self.Logger:Log("Doing limits for faction: "..faction:name());
            self:ApplyArmyLimits(faction);
            self.Logger:Log_Finished();
        end,
        true
    );

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
            if playerImperiumLevel > 6 then
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
                        for index, rivalFactionKey in pairs(rivalData.Factions) do
                            if playerImperiumLevel > self.MinimumRequiredImperiumForRival + (index - 1) then
                                self.Logger:Log("Player meets requirement for rival: "..rivalFactionKey);
                                local rivalFaction = cm:get_faction(rivalFactionKey);
                                self:UnRestrictConfederationsForFaction(rivalFaction);
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
            self:SetupDiplomacyRestrictions();
            --DynamicAIRestrictions END
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
        self.Logger:Log("Applying army limits for faction: "..factionKey);
        local customEffectBundle = cm:create_new_custom_effect_bundle("wh_main_effect_dair_dummy_army_cap");
        local useUnlimited = false;
        self.Logger:Log("Created effect bundle");
        -- When using Lichemaster and we are updating Kemmler's faction, they should have unlimited armies
        -- cause they are capped anyway
        if self.LoadedLichemaster == true
        and faction:name() == "wh2_dlc11_vmp_the_barrow_legion" then
            useUnlimited = true;
        end
        if useUnlimited == true
        or faction:is_human() == true then
            self.Logger:Log("Use unlimited");
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
    local factionKey = faction:name();
    local subcultureKey = faction:subculture();
    local overallLordCap = 0;
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
            end
        end
    end
    self.Logger:Log("Finished checking climates...");
    local factionBonusArmies = self:GetFactionBonusArmies(faction);
    overallLordCap = overallLordCap + factionBonusArmies;
    if factionKey == "wh2_dlc11_def_the_blessed_dread"
    and overallLordCap < 1
    and cm:get_campaign_name() == "main_warhammer" then
        overallLordCap = 1;
    elseif overallLordCap < 0 then
        overallLordCap = 0;
    end

    local playersAlignment = self:GetPlayersAlignment();
    local factionAlignment = self:GetFactionAlignment(faction);
    if playersAlignment[factionAlignment] == nil then
        local bonusAlignmentArmies = cm:get_saved_value("bonus_alignment_armies");
        overallLordCap = overallLordCap + bonusAlignmentArmies;
    end
    self.Logger:Log("Finished checking alignment bonuses");
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
        for humanFactionKey, humanFaction in pairs(self.HumanFactions) do
            -- As per vanilla, tomb kings and vampire coast can't confederate
            if humanFaction:culture() ~= "wh2_dlc09_tmb_tomb_kings"
            and humanFaction:culture() ~= "wh2_dlc11_cst_vampire_coast" then
                cm:callback(function()
                    self:UnRestrictConfederationsForFaction(humanFaction);
                end, 0.2);
            end
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