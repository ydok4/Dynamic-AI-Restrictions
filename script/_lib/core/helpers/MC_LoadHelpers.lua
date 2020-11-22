local MAX_NUM_SAVE_TABLE_KEYS = 200;

local cm = nil;
local context = nil;

function MC_InitialiseLoadHelpers(cmObject, contextObject)
    out("MC: Initialising load helpers");
    cm = cmObject;
    context = contextObject;
end

function MC_NC_LoadHistory(mc)
    out("MC_NC: LoadHistory");
    if cm == nil then
        out("MC_NC: Can't access CM");
        return;
    end
    local nc_past_narratives_header = cm:load_named_value("nc_past_narratives_header", {}, context);
    if nc_past_narratives_header == nil or nc_past_narratives_header["TotalPastNarratives"] == nil then
        out("MC_NC: No past narratives to load");
        return;
    else
        out("MC_NC: Loading "..nc_past_narratives_header["TotalPastNarratives"].." past Narrativess");
    end

    local serialised_save_table_past_narratives = {};
    if mc.NarrativeController == nil then
        mc.NarrativeController = {};
    end
    mc.NarrativeController.PastNarratives = {};
    local tableCount = math.ceil(nc_past_narratives_header["TotalPastNarratives"] / MAX_NUM_SAVE_TABLE_KEYS);
    for n = 1, tableCount do
        out("MC_NC: Loading table "..tostring(n));
        local nthTable = cm:load_named_value("nc_past_narratives_"..tostring(n), {}, context);
        ConcatTableWithKeys(serialised_save_table_past_narratives, nthTable);
    end

    for key, pastNarrativeData in pairs(serialised_save_table_past_narratives) do
        local narrativeScopeKey = key:match("(.-)/");
        out("MC_NC: Loading past narrative in scope: "..narrativeScopeKey);
        if mc.NarrativeController.PastNarratives[narrativeScopeKey] == nil then
            mc.NarrativeController.PastNarratives[narrativeScopeKey] = {};
        end
        if narrativeScopeKey == "Faction"
        or narrativeScopeKey == "Province" then
            local factionOrProvinceKey = key:match(narrativeScopeKey.."/(.-)/");
            if mc.NarrativeController.PastNarratives[narrativeScopeKey][factionOrProvinceKey] == nil then
                mc.NarrativeController.PastNarratives[narrativeScopeKey][factionOrProvinceKey] = {};
            end
            local narrativekey = key:match(narrativeScopeKey.."/"..factionOrProvinceKey.."/(.-)/");
            local turnNumber = key:match(narrativeScopeKey.."/"..factionOrProvinceKey.."/"..narrativekey.."/(.+)");
            local pastNarrativesForScope = mc.NarrativeController.PastNarratives[narrativeScopeKey][factionOrProvinceKey];
            pastNarrativesForScope[#pastNarrativesForScope + 1] = {
                NarrativeKey = narrativekey,
                TurnNumber = turnNumber,
            };
        -- Otherwise this is the global scope
        else
            local narrativekey = key:match(narrativeScopeKey.."/(.-)/");
            local turnNumber = key:match(narrativeScopeKey.."/"..narrativekey.."/(.+)");
            mc.NarrativeController.PastNarratives[narrativeScopeKey][narrativekey] = {
                NarrativeKey = narrativekey,
                TurnNumber = turnNumber,
            };

        end
    end
    out("MC_NC: Finished loading");
end