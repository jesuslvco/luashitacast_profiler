local inventoryManager = AshitaCore:GetMemoryManager():GetInventory();
local resourceManager = AshitaCore:GetResourceManager();
local encoding = require('encoding');

common_curita = T{}
common_curita.party = T{}

common_curita.cureTimers = {}      -- [targetName][cureName] = os.time() del último casteo
common_curita.healingDone = {}     -- [targetName] = total de HP curado

common_curita.damageTaken = {}         -- [targetName] = daño acumulado en el minuto actual
common_curita.lastHP = {}              -- [targetName] = último HP registrado
common_curita.damageStartTime = {}     -- [targetName] = timestamp de inicio del minuto


common_curita.HealThreshold = 20 -- Porcentaje de vida faltante para considerar apto para cura

local cureSpellIds = {
    ['Cure'] = 2,
    ['Cure II'] = 3,
    ['Cure III'] = 4,
    ['Cure IV'] = 5,
    ['Cure V'] = 6,
}

local regenSpellIds = {
    ['Regen'] = 108,
    ['Regen II'] = 110,
    ['Regen III'] = 111,
}

local regenAmounts = {
    ['Regen'] = 125,      -- 15 HP/tick * 25 ticks = 375 HP
    ['Regen II'] = 320,   -- 20 HP/tick * 25 ticks = 500 HP
    ['Regen III'] = 450,  -- 25 HP/tick * 25 ticks = 625 HP
}

local regenCosts = {
    ['Regen'] = 15,
    ['Regen II'] = 36,
    ['Regen III'] = 64,
}


common_curita.process_handler = function(profile, sets)
    local player = gData.GetPlayer();
    local party = gData.GetParty();

    if not player or not party then
        return;
    end

    -- Verifica si el jugador tiene MP suficiente para curar
    if (player.MP < 10 and player.Status ~= "Resting") then
        AshitaCore:GetChatManager():QueueCommand(1, '/heal');
    end

    -- Verifica si hay miembros del grupo que necesiten cura
    local partyMembers = common_curita.GetPartyMembers()
    if #partyMembers == 0 then
        print("No hay miembros del grupo para curar.");
        return;
    end

    -- Llama a la función de curación
    if(player.Status == "Idle") then
        common_curita.castCure(partyMembers, sets);
    end
    
end

common_curita.castCure = function(target, cure)
    local player = gData.GetPlayer();
    local party = gData.GetParty();

    common_curita.UpdateDamageTaken();

        local cures = {
            ['Cure'] = 40,
            ['Cure II'] = 144,
            ['Cure III'] = 230,
            ['Cure IV'] = 477,
            ['Cure V'] = 600,
        }

        local curesCost = {
            ['Cure'] = 8,
            ['Cure II'] = 24,
            ['Cure III'] = 46,
            ['Cure IV'] = 88,
            ['Cure V'] = 135,
        }

        local castCure = {}

        local partyMembers = common_curita.GetPartyMembers()
        local target = nil
        local maxMissingPercent = 0
        local maxMissingHP = 0

        -- Encuentra al miembro con mayor porcentaje de HP faltante dentro de rango y que supere el umbral
        for _, member in ipairs(partyMembers) do
            if member.HPP > 0 and member.Distance <= 20 then
                local missingPercent = 100 - member.HPP
                local missingHP = member.MaxHP - member.HP

                if missingPercent >= (common_curita.HealThreshold) then
                    if missingPercent > maxMissingPercent then
                        maxMissingPercent = missingPercent
                        maxMissingHP = missingHP
                        target = member
                    end
                end
            end
        end

        if target and maxMissingHP > 0 then
            -- Determina el mejor nivel de cura para llevar al objetivo cerca del 90% de vida, evitando sobrecura y considerando el MP disponible
            local selectedCure = nil
            local minOverheal = nil
            local hpToHeal = math.floor(target.MaxHP * 0.9) - target.HP
            if hpToHeal < 0 then hpToHeal = 0 end

            for cureName, cureAmount in pairs(cures) do
                local mpCost = curesCost[cureName] or 0
                if common_curita.CanCastCureSpell(cureName) and cureAmount >= hpToHeal and player.MP >= mpCost then
                    local overheal = cureAmount - hpToHeal
                    if not selectedCure or overheal < minOverheal then
                        selectedCure = cureName
                        minOverheal = overheal
                    end
                end
            end
            -- Si ninguna cura aprendida cubre el HP necesario, usa la más alta que conozca y que tenga MP suficiente
            if not selectedCure then
                local highestCure = nil
                for cureName, _ in pairs(cures) do
                    local mpCost = curesCost[cureName] or 0
                    if cureName ~= nil and common_curita.HasCureSpell(cureName) and player.MP >= mpCost then
                        highestCure = cureName
                    end
                end
                selectedCure = highestCure or 'Cure'
            end

            castCure.Target = target.Name
            castCure.Cure = selectedCure
            castCure.MissingHP = maxMissingHP
            castCure.MissingPercent = maxMissingPercent
            castCure.Distance = target.Distance

            --castear la cura con commando
            local command = string.format('/ma "%s" %s', castCure.Cure, castCure.Target)
            AshitaCore:GetChatManager():QueueCommand(1, command);

            -- Actualiza el timer del hechizo para ese objetivo
            if not common_curita.cureTimers[castCure.Target] then
                common_curita.cureTimers[castCure.Target] = {}
            end
            common_curita.cureTimers[castCure.Target][castCure.Cure] = os.time()

            -- Suma el healing estimado realizado a ese objetivo
            common_curita.healingDone[castCure.Target] = (common_curita.healingDone[castCure.Target] or 0) + (cures[castCure.Cure] or 0)

        elseif (target and maxMissingHP <= 0) then
           
        end
end

function common_curita.UpdateDamageTaken()
    local partyMembers = common_curita.GetPartyMembers()
    local now = os.time()
    for _, member in ipairs(partyMembers) do
        local name = member.Name
        local currentHP = member.HP

        -- Inicializa si es la primera vez
        if not common_curita.lastHP[name] then
            common_curita.lastHP[name] = currentHP
            common_curita.damageTaken[name] = 0
            common_curita.damageStartTime[name] = now
        end

        -- Si bajó el HP, suma el daño
        if currentHP < common_curita.lastHP[name] then
            local dmg = common_curita.lastHP[name] - currentHP
            common_curita.damageTaken[name] = (common_curita.damageTaken[name] or 0) + dmg
        end

        common_curita.lastHP[name] = currentHP

        -- Si pasó un minuto, puedes mostrar el DPM y reiniciar
        if now - (common_curita.damageStartTime[name] or now) >= 60 then
            -- Si el DPM es alto, casteamos Regen
            common_curita.castBestRegen();

            local dpm = common_curita.damageTaken[name] or 0
            print(string.format("[DPM] %s: %d daño/minuto", name, dpm))
            common_curita.damageTaken[name] = 0
            common_curita.damageStartTime[name] = now
        end
    end
end

function common_curita.GetPartyMembers()
    local members = {}
    local pEntity = AshitaCore:GetMemoryManager():GetEntity()
    local pParty = AshitaCore:GetMemoryManager():GetParty()
    for i = 0, 5 do
        if pParty:GetMemberIsActive(i) == 1 then
            local member = {}
            local myIndex = pParty:GetMemberTargetIndex(i)
            member.HP = pParty:GetMemberHP(i)
            member.HPP = pParty:GetMemberHPPercent(i)
            member.MP = pParty:GetMemberMP(i)
            member.MPP = pParty:GetMemberMPPercent(i)
            member.Name = pParty:GetMemberName(i)
            member.Status = gData.ResolveString(gData.Constants.EntityStatus, pEntity:GetStatus(myIndex))
            member.Distance = math.sqrt(pEntity:GetDistance(myIndex))
            -- Estimar MaxHP si HPP > 0
            if member.HPP > 0 then
                member.MaxHP = math.floor(member.HP / (member.HPP / 100))
            else
                member.MaxHP = 0
            end
            table.insert(members, member)
        end
    end
    return members
end

function common_curita.castBestRegen()
    local player = gData.GetPlayer()
    local partyMembers = common_curita.GetPartyMembers()

    local maxDpm = 0
    local targetMember = nil

    -- Justo antes de tu loop de Regens en castBestRegen
    for regenName, spellId in pairs(regenSpellIds) do
        local hasSpell = AshitaCore:GetMemoryManager():GetPlayer():HasSpell(spellId)
        print(string.format("[DEBUG] Spell: %s, ID: %s, hasSpell: %s", regenName, tostring(spellId), tostring(hasSpell)))
    end

    print("[Regen] Buscando miembro con mayor DPM...")
    for _, member in ipairs(partyMembers) do
        local dpm = common_curita.damageTaken[member.Name] or 0
        print(string.format("[Regen] %s: DPM=%d", member.Name, dpm))
        if dpm > maxDpm then
            maxDpm = dpm
            targetMember = member
        end
    end

    if targetMember then
        print(string.format("[Regen] Mayor DPM: %s (%d)", targetMember.Name, maxDpm))
    else
        print("[Regen] No se encontró miembro para Regen.")
    end

    if targetMember and maxDpm > 200 then
        local bestRegen = nil
        local bestAmount = 0
        for regenName, healAmount in pairs(regenAmounts) do
            local mpCost = regenCosts[regenName] or 0
            local canCast = common_curita.CanCastRegenSpell(regenName)
            print(string.format("[Regen] Intentando %s: heal=%d, mpCost=%d, canCast=%s, mp=%d", regenName, healAmount, mpCost, tostring(canCast), player.MP))
            if canCast and player.MP >= mpCost then
                if healAmount > bestAmount then
                    bestRegen = regenName
                    bestAmount = healAmount
                end
            end
        end
        if bestRegen then
            local command = string.format('/ma "%s" %s', bestRegen, targetMember.Name)
            print(string.format("[Regen] Casteando %s en %s (DPM: %d)", bestRegen, targetMember.Name, maxDpm))
            AshitaCore:GetChatManager():QueueCommand(1, command)
        else
            print("[Regen] No hay ningún Regen disponible para castear.")
        end
    else
        print("[Regen] Ningún miembro supera el umbral de DPM para Regen.")
    end
end

function common_curita.CanCastRegenSpell(spellName)
    local spellId = regenSpellIds[spellName]
    if not spellId then
        print('[CanCastRegenSpell] No se encontró el ID para el spell Regen:', spellName)
        return false
    end
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    local recast = AshitaCore:GetMemoryManager():GetRecast():GetSpellTimer(spellId)
    local hasSpell = player:HasSpell(spellId)
    print(string.format("[CanCastRegenSpell] %s (ID: %s): hasSpell=%s, recast=%s", spellName, tostring(spellId), tostring(hasSpell), tostring(recast)))
    if not hasSpell then
        print(string.format("[CanCastRegenSpell] El jugador NO tiene aprendido %s (ID: %s)", spellName, tostring(spellId)))
    end
    if recast ~= 0 then
        print(string.format("[CanCastRegenSpell] %s (ID: %s) está en recast (%s)", spellName, tostring(spellId), tostring(recast)))
    end
    return hasSpell and recast == 0
end

function common_curita.CanCastCureSpell(spellName)
    local spellId = cureSpellIds[spellName]
    if not spellId then
        print('No se encontró el ID para el hechizo:', spellName)
        return false
    end
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    local recast = AshitaCore:GetMemoryManager():GetRecast():GetSpellTimer(spellId)
    local hasSpell = player:HasSpell(spellId)
    --print(string.format("Chequeando %s (ID: %s): hasSpell=%s, recast=%s", spellName, tostring(spellId), tostring(hasSpell), tostring(recast)))
    return hasSpell and recast == 0
end

function common_curita.HasCureSpell(spellName)
    local spellId = cureSpellIds[spellName]
    if not spellId then
        print('No se encontró el ID para el hechizo:', spellName)
        return false
    end
    local player = AshitaCore:GetMemoryManager():GetPlayer()
    local hasSpell = player:HasSpell(spellId)
    return hasSpell
end

return common_curita;