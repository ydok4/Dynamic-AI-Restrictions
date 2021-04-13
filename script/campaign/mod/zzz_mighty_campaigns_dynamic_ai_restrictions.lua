DAIR = {};
_G.DAIR = DAIR;

-- Helpers
require 'script/_lib/core/helpers/MC_DataHelpers';
require 'script/_lib/core/helpers/MC_LoadHelpers';
require 'script/_lib/core/helpers/MC_SaveHelpers';
-- Models
require 'script/_lib/core/model/DynamicAIRestrictions';
require 'script/_lib/core/model/Logger';

function zzz_mighty_campaigns_dynamic_ai_restrictions()
    local enableLogging = true;
    out("DAIR: Main mod function");
    DAIR = DynamicAIRestrictions:new({});
    DAIR:Initialise(core, CI_DATA, enableLogging);
    DAIR.Logger:Log("Initialised");
    DAIR.Logger:Log_Finished();
    _G.MC_CS = DAIR;
    out("DAIR: Finished setup");
end