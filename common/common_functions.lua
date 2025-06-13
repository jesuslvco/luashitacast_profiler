local inventoryManager = AshitaCore:GetMemoryManager():GetInventory();
local resourceManager = AshitaCore:GetResourceManager();
local encoding = require('encoding');
local common_curita = gFunc.LoadFile('common\\common_curita.lua');

local petsByLvl = {
    [23] = 'Herbal Broth',
    [28] = 'Meat Broth',
    [33] = 'Carrion Broth',
    [38] = 'Tree Sap',
    [43] = 'S. Herbal Broth',
};

local hqPetsByLvl = {
    [38] = 'Antica Broth',
    [43] = 'Blood Broth',
};

local petsSkills = {
    ["SheepFamiliar"] = 'Lamb Chop',
    ["LizardFamiliar"] = 'Brain Crush',
    ["TigerFamiliar"] = 'Razor Fang',
    ["BeetleFamiliar"] = 'Power Attack',
    ["LullabyMelodia"] = 'Lamb Chop',
    ["MiteFamiliar"] = 'Double Claw',
    ["AntlionFamiliar"] = 'Mandibular Bite',
};
--weapons 
--local weapons =



local common_functions = T{};

-- Function to automatically handle DPS for specific jobs
function common_functions.auto()
    local player = gData.GetPlayer();
    local level = player.MainJobSync;
    local zone = gData.GetEnvironment();
    --check for gear
    local equip = gData.GetEquipment();

    if (equip.Main ~= nil) then

        local mageJobs = T{'WHM', 'RDM', 'BRD', 'SMN', 'BLM', 'SCH'}
        local isMele = not mageJobs:contains(player.MainJob)

        if(isMele) then
            common_functions.engage()
        end



        -- Check for PDT
            if(player.MainJob == 'SAM') then

                local hasso = gData.GetBuffCount('Hasso');
                local hassoRecast = common_functions.CheckAbilityRecast('Hasso');
                local thirdeye = gData.GetBuffCount('Third Eye');
                local thirdeyeRecast = common_functions.CheckAbilityRecast('Third Eye');
                local seigan = gData.GetBuffCount('Seigan');
                local seiganRecast = common_functions.CheckAbilityRecast('Seigan');
                local seigan = gData.GetBuffCount('Meditate');
                local meditateRecast = common_functions.CheckAbilityRecast('Meditate');
                local konzenIttai = gData.GetBuffCount('Konzen Ittai');
                local konzenIttaiRecast = common_functions.CheckAbilityRecast('Konzen Ittai');
                
                if (player.Status == 'Engaged') then
                    
                    if (meditateRecast <= 0) and (player.TP < 1000) and (level >=30) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja meditate <me>');
                    end
    
                    if(player.HPP > 30) then
                        if (hasso <= 0) and (hassoRecast <= 0) and (level >=25) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ja hasso <me>');
                        end
                    else
                        --seigan
                        if (seigan <= 0) and (seiganRecast <= 0) and (level >=35) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ja seigan <me>');
                        end

                        --third eye
                        if (thirdeye <= 0) and (thirdeyeRecast <= 0) and (level >=15) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ja "third eye" <me>');
                        end
                    end
                    
                    if(player.TP <= 999) then
                        gFunc.CancelAction();
                        return;
                    else
                        -- Weapon Skills
                        
                        if(level == 75) and (equip.Main.Name:contains('Amanomurakumo')) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "tachi:kaiten" <t>');
                        else
                            if (level >= 70 ) and (level <= 75)  then
                                AshitaCore:GetChatManager():QueueCommand(-1, '/ws "tachi: kasha" <t>');
                            end
                        end
                        
                        if(level >= 65) and (level < 70 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "tachi: gekko" <t>');
                        end
                        if(level >= 60) and (level < 65 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "tachi: yukikaze" <t>');
                        end
                        if(level >= 49) and (level < 60 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "tachi: jimpu" <t>');
                        end
                        if(level >= 1) and (level < 49 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "tachi: empi" <t>');
                        end
                    end
                end
            end
            if(player.MainJob == 'BST') then

                 
                -- Ready
                local recastReady = common_functions.CheckAbilityRecast('Ready');
                local recastCallBeast = common_functions.CheckAbilityRecast('Call Beast');
                local bestialLoyalty = common_functions.CheckAbilityRecast('Bestial Loyalty');
                

                local pet = gData.GetPet();
                
                if (player.Status == 'Engaged') then
                    if(bestialLoyalty ~= nil and recastCallBeast ~=nil) then
                        if (pet == nil and level >=23 and (bestialLoyalty <= 0 or recastCallBeast <= 0)) then
                            local petItem =  common_functions.GetAvailablePetItem(level);
                            local hqPetItem =  common_functions.GetAvailableHQPetItem(level);

                            if (bestialLoyalty <= 0 and hqPetItem ~= nil) then
                                AshitaCore:GetChatManager():QueueCommand(-1, '/equip ammo "' .. hqPetItem..'"');
                                AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Bestial Loyalty" <me>');
                            elseif(petItem ~= nil) and (recastCallBeast <= 0) then
                                AshitaCore:GetChatManager():QueueCommand(-1, '/equip ammo "' .. petItem..'"');
                                AshitaCore:GetChatManager():QueueCommand(-1, '/ja "call beast" <me>');                                
                            end
                        end
                    end

                    -- Check for ammo slot
                   --[[ 
                   local slot = gData.GetEquipment('Ammo');
                    if(slot ~= nil and slot.Ammo ~= nil) then
                        --print('Ammo Slot: ' .. slot.Ammo.Name);
                    else
                        if(common_functions.HasItem('Wooden Arrow'))then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/equip ammo "Wooden Arrow"');
                            --print('You have Wooden arrow in your inventory');
                        end
                    end
                    ]]
                    
                    if(pet ~= nil and pet.Status ~= 'Engaged') then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "fight" <t>');
                    end

                    if(pet ~= nil) then

                        local petSkill = petsSkills[pet.Name];
                            -- Call Beast
                        if(petSkill ~= nil) then
                            -- Check if the pet skill is ready to use
                            local recastSkill = common_functions.CheckAbilityRecast(petSkill);
    
                            if(pet.Status == 'Engaged' and recastSkill <= 0) then
                                    AshitaCore:GetChatManager():QueueCommand(-1, '/pet "' .. petSkill .. '" <me>');
                            end
                        end

                    end
                    
                    if(player.TP <= 999) then
                        gFunc.CancelAction();
                        return;
                    else
                        if(level >= 55) and (level <= 75 ) then
                           AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Rampage" <t>');
                        end
                        if(level >= 1) and (level < 55 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Raging axe" <t>');
                        end
                    end
                    
                end
            end

            if(player.MainJob == 'WAR') then

                -- Call Beast
                local warcry = common_functions.CheckAbilityRecast('Warcry');
                -- Ready
                local aggressor = common_functions.CheckAbilityRecast('Aggressor');

                if (player.Status == 'Engaged') then
                    -- warcry
                    if(warcry <= 0 and level >= 35) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja warcry <me>');
                    end
                    --aggressor
                    if(aggressor <= 0 and level >= 45) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja aggressor <me>');
                    end
                    
                    if(player.TP <= 999) then
                        gFunc.CancelAction();
                        return;
                    else
                        if(level >= 60) and (level <= 75 ) then
                           AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Raging rush" <t>');
                        end
                        if(level >= 24) and (level <= 59 ) then
                           AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Sturmwind" <t>');
                        end
                        if(level > 14) and (level < 24 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Iron Tempest" <t>');
                        end
                        if(level >= 1) and (level <= 14 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Shield Break" <t>');
                        end
                    end
                    
                end
            end
            if(player.MainJob == 'MNK') then

                local boost = common_functions.CheckAbilityRecast('Boost');
                local focus = common_functions.CheckAbilityRecast('Focus');
                local chakra = common_functions.CheckAbilityRecast('Chakra');
                local footwork = common_functions.CheckAbilityRecast('Footwork');


                if (player.Status == 'Engaged') then

                    if(boost <= 0 and level >= 5) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja boost <me>');
                    end

                    if(focus <= 0 and level >= 25) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja focus <me>');
                    end

                    if(chakra <= 0 and level >= 35 and player.HPP < 70) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja chakra <me>');
                    end

                    if(footwork <= 0 and level >= 65 and player.TP > 800 and player.TP < 1000) then
                        --AshitaCore:GetChatManager():QueueCommand(-1, '/ja footwork <me>');
                    end

                    if(player.TP <= 999) then
                        gFunc.CancelAction();
                        return;
                    else
                        if(level > 42) and (level <= 75 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Raging Fists" <t>');
                        end
                        if(level >= 1) and (level <= 42 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Combo" <t>');
                        end
                    end
                    
                end
            end

            -- DRG
            if(player.MainJob == 'DRG') then

                local jump = common_functions.CheckAbilityRecast('Jump');
                local hjump = common_functions.CheckAbilityRecast('High jump');
                local sjump = common_functions.CheckAbilityRecast('Super Jump');
                local slink = common_functions.CheckAbilityRecast('Spirit Link');

                


                if (player.Status == 'Engaged') then

                    if(jump <= 0 and level >= 10 and player.TP < 1000) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja jump <t>');
                    end

                    if(hjump <= 0 and level >= 35 and player.TP < 1000) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "High Jump" <t>');
                    end

                    if(sjump <= 0 and level >= 50 and player.HPP < 15) then
                        AshitaCore:GetChatManager():QueueCommand(-1, '/ja "Super Jump" <t>');
                    end


                    if(player.TP <= 999) then
                        gFunc.CancelAction();
                        return;
                    else
                        if(level > 64) and (level <= 75 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Wheeling Thrust" <t>');
                        end
                        if(level > 49) and (level <= 64 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Penta Thrust" <t>');
                        end
                        if(level >= 1) and (level <= 49 ) then
                            AshitaCore:GetChatManager():QueueCommand(-1, '/ws "Double Thrust" <t>');
                        end
                    end
                    
                end
            end

    end

    if (player.MainJob == 'WHM' or player.MainJob == 'SCH' or player.MainJob == 'RDM') then
        common_curita.process_handler(profile, sets);
    end



    if(player.SubJobSync > 0) then
        local DrainSamba = gData.GetBuffCount('Drain Samba');
        if(player.SubJobSync > 5 and player.subJob == 'DNC' and player.TP > 200 and DrainSamba <= 0) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/ja drain samba <me>');
        end
    end

    
    
end

-- Function to get the available pet item based on player's level
-- Returns the item name if available, or nil if no suitable item is found
function common_functions.GetAvailablePetItem(playerLevel)
    local selectedItem = nil
    local selectedLevel = 0
    for lvl, item in pairs(petsByLvl) do
        if lvl <= playerLevel and lvl > selectedLevel then
            if common_functions.HasItem(item) then
                selectedItem = item
                selectedLevel = lvl
            end
        end
    end
    return selectedItem
end
function common_functions.GetAvailableHQPetItem(playerLevel)
    local selectedItem = nil
    local selectedLevel = 0
    for lvl, item in pairs(hqPetsByLvl) do
        if lvl <= playerLevel and lvl > selectedLevel then
            if common_functions.HasItem(item) then
                selectedItem = item
                selectedLevel = lvl
            end
        end
    end
    return selectedItem
end

-- Function to check if an item exists in the player's inventory
-- Returns true if the item is found, false otherwise
function common_functions.HasItem(itemName)
    for _,container in ipairs(gSettings.EquipBags) do
        local available = gData.GetContainerAvailable(container)
        if available then
            local max = gData.GetContainerMax(container)
            for index = 1, max do
                local containerItem = inventoryManager:GetContainerItem(container, index)
                if containerItem and containerItem.Count > 0 and containerItem.Id > 0 then
                    local resource = resourceManager:GetItemById(containerItem.Id)
                    local resourceName = encoding:ShiftJIS_To_UTF8(resource.Name[1])
                    if not japanese then
                        resourceName = string.lower(resourceName)
                        itemName = string.lower(itemName)
                    end
                    if resourceName == itemName then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- Function to check the recast time of an ability by its name
-- Returns the recast time in seconds, or 0 if the ability is not found
function common_functions.CheckAbilityRecast(check)
	local RecastTime = 0;

	for x = 0, 31 do
		local id = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimerId(x);
		local timer = AshitaCore:GetMemoryManager():GetRecast():GetAbilityTimer(x);

		if ((id ~= 0 or x == 0) and timer > 0) then
			local ability = AshitaCore:GetResourceManager():GetAbilityByTimerId(id);
			if ability == nil then return end
			if (ability.Name[1] == check) and (ability.Name[1] ~= 'Unknown') then
				RecastTime = timer;
			end
		end
	end

	return RecastTime;
end

common_functions.engageProcess = false;
function common_functions.engage()
    local player = gData.GetPlayer();
    local subLeader = common_curita.getMemberByIndex(1);
    local me = common_curita.getMemberByIndex(0);
    
        
        --for k, v in pairs(target) do
         --   print(k, v)
        --end
    
        
    local now = os.time()
    if (player.Status == 'Idle' or (player.Status == 'Resting' and player.HPP > 50)) then
        if(subLeader ~= nil) then
            if (subLeader.Distance < 15 and subLeader.Status == 'Engaged' and common_functions.engageProcess == false) then
                common_functions.engageProcess = true;

                -- Ejecutar una función después de 4 segundos
                ashita.tasks.once(4, function()
                    common_functions.engageProcess = false;
                    print('5 segundos')
                    -- Aquí va tu función o código a ejecutar
                end)

                ashita.tasks.once(3, function()
                    AshitaCore:GetChatManager():QueueCommand(2000, '/attack <t>');
                end)
                
                if(player.Status == 'Resting')then
                    AshitaCore:GetChatManager():QueueCommand(-1, '/heal');
                end

                AshitaCore:GetChatManager():QueueCommand(100, '/assist ' .. subLeader.Name);
                AshitaCore:GetChatManager():QueueCommand(1000, '/follow <t>');

            end
        end
    end
    if(subLeader ~= nil) then
        --[[
            if (player.IsMoving) and (me.Target == nil) and (subLeader.Distance > 12) then
                AshitaCore:GetChatManager():QueueCommand(-1, '/heal');
                AshitaCore:GetChatManager():QueueCommand(1000, '/heal');
            end
            ]]
    end
    
end

return common_functions