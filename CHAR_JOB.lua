local profile = {};

handle_common = gFunc.LoadFile('common\\handle_common.lua');

local sets = {
    --common sets
        town = { },resting = {},idle = {Head = 'Sprout beret',Body = 'Chocobo Shirt',ring1 = 'Chocobo Charm',ring2 = 'Warp Ring'},
        movement = {Body = 'Kupo Suit'},
        -- use /th
        th = {},
        -- use /emnity
        enmity = {},

    --common magic
        precast = {},cure = {},enhancing = {},
    --common ranged
        preshot = {},midshot = {},
    --common combat    
        tp_default = {},ws_default = {},ws_acc = {},
    -- During Fights
            --use /eva
        eva = {},tp_eva = {},
            --use /acc
        acc = {},tp_acc = {},
    
    --Helm and other sets #######################
        -- use /craft
        craft = {},
        -- use /choco
        choco = {},
        -- use /fishing
        fishing = {},
        -- use /helm
        helm = {},
    -- SETS BY LVL ########################################
        tp_level_1 = {},ws_level_1 = {},
        tp_level_10 = {},ws_level_10 = {},
        tp_level_20 = {},ws_level_20 = {},
        tp_level_30 = {},ws_level_30 = {},
        tp_level_40 = {},ws_level_40 = {},
        tp_level_50 = {},ws_level_50 = {},
        tp_level_60 = {},ws_level_60 = {},
        tp_level_70 = {},ws_level_70 = {},
    -- ---------------------------------------------------

};
profile.Sets = sets;

profile.Packer = {
    {Name = 'Red Curry Bun', Quantity = 'all'},
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 1');

    handle_common.Initialize(sets);

end

profile.OnUnload = function()
    handle_common.Unload();
end

profile.HandleCommand = function(args)
    handle_common.SetCommands(args);
end

profile.HandleDefault = function()
    handle_common.CheckDefault(sets);
	
end

profile.HandleAbility = function()
    local ability = gData.GetAction();
    handle_common.HandleAbility(sets);
end

profile.HandleItem = function()
    handle_common.HandleItem(sets);
    local item = gData.GetAction();
    --[[
	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(
        gcinclude.sets.Holy_Water)
    end*/
    --]]
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    handle_common.HandlePrecast(sets)
end

profile.HandleMidcast = function()
    handle_common.HandleMidcast(sets)
    local spell = gData.GetAction();
end

profile.HandlePreshot = function()
    handle_common.HandlePreshot(sets);
end

profile.HandleMidshot = function()
    handle_common.HandleMidshot(sets);
end

profile.HandleWeaponskill = function()
    handle_common.HandleWeaponskill(sets);
    
    local canWS = handle_common.CheckWsBailout();
    if (canWS == false) then 
        gFunc.CancelAction() 
        return;
    else
        
        local ws = gData.GetAction();
        
    end
end

return profile;
