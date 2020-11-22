local MAX_NUM_SAVE_TABLE_KEYS = 200;

local cm = nil;
local context = nil;

function MC_InitialiseSaveHelpers(cmObject, contextObject)
    out("EnR: Initialising save helpers");
    cm = cmObject;
    context = contextObject;
end

function MC_NC_SaveHistory(mc)
    out("MC_NC: Saving past narratives");
    local nc_past_narratives_header = {};

    local numberOfPastNarratives = 0;
    local tableCount = 1;
    local nthTable = {};

    for narrativeScopeKey, narrativeScope in pairs(mc.NarrativeController.PastNarratives) do
        for factionOrProvinceOrNarrativeKey, pastNarratives in pairs(narrativeScope) do
            if narrativeScopeKey == "Faction"
            or narrativeScopeKey == "Province" then
                for index, narrativeData in pairs(pastNarratives) do
                    nthTable[narrativeScopeKey.."/"..factionOrProvinceOrNarrativeKey.."/"..narrativeData.NarrativeKey.."/"..narrativeData.TurnNumber] = {
                        narrativeData.NarrativeKey,
                        narrativeData.TurnNumber,
                    };
                    numberOfPastNarratives = numberOfPastNarratives + 1;
                end
                if numberOfPastNarratives % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                    out("EnR: Saving table number "..(tableCount + 1));
                    cm:save_named_value("nc_past_narratives_"..tableCount, nthTable, context);
                    tableCount = tableCount + 1;
                    nthTable = {};
                end
            else
                nthTable[narrativeScopeKey.."/"..pastNarratives.NarrativeKey.."/"..pastNarratives.TurnNumber] = {
                    pastNarratives.NarrativeKey,
                    pastNarratives.TurnNumber,
                };
                numberOfPastNarratives = numberOfPastNarratives + 1;
                if numberOfPastNarratives % MAX_NUM_SAVE_TABLE_KEYS == 0 then
                    out("EnR: Saving table number "..(tableCount + 1));
                    cm:save_named_value("nc_past_narratives_"..tableCount, nthTable, context);
                    tableCount = tableCount + 1;
                    nthTable = {};
                end
            end
        end
    end
    -- Saving the remaining active PREs
    cm:save_named_value("nc_past_narratives_"..tableCount, nthTable, context);
    out("EnR: Saving "..numberOfPastNarratives.." past narratives");

    nc_past_narratives_header["TotalPastNarratives"] = numberOfPastNarratives;
    cm:save_named_value("nc_past_narratives_header", nc_past_narratives_header, context);
end