local inventoryManager = AshitaCore:GetMemoryManager():GetInventory();
local resourceManager = AshitaCore:GetResourceManager();

local encoding = require('encoding');
local common_functions = gFunc.LoadFile('common\\common_functions.lua');

local handle_common = T{};
-- handle_common sets
handle_common.AliasList = T{'craft','choco','fishing','helm','acc','eva','mac','th','pdt','mdt','emnity','ring_hpp75','auto','pet_range','xray'};
-- check areas for towns
handle_common.Towns = T{'Tavnazian Safehold','Al Zahbi','Aht Urhgan Whitegate','Nashmau','Southern San d\'Oria [S]','Bastok Markets [S]','Windurst Waters [S]','San d\'Oria-Jeuno Airship','Bastok-Jeuno Airship','Windurst-Jeuno Airship','Kazham-Jeuno Airship','Southern San d\'Oria','Northern San d\'Oria','Port San d\'Oria','Chateau d\'Oraguille','Bastok Mines','Bastok Markets','Port Bastok','Metalworks','Windurst Waters','Windurst Walls','Port Windurst','Windurst Woods','Heavens Tower','Ru\'Lude Gardens','Upper Jeuno','Lower Jeuno','Port Jeuno','Rabao','Selbina','Mhaura','Kazham','Norg','Mog Garden','Celennia Memorial Library','Western Adoulin','Eastern Adoulin'};
-- ws distance safety check
handle_common.DistanceWS = T{'Flaming Arrow','Piercing Arrow','Dulling Arrow','Sidewinder','Blast Arrow','Arching Arrow','Empyreal Arrow','Refulgent Arrow','Apex Arrow','Namas Arrow','Jishnu\'s Randiance','Hot Shot','Split Shot','Sniper Shot','Slug Shot','Blast Shot','Heavy Shot','Detonator','Numbing Shot','Last Stand','Coronach','Wildfire','Trueflight','Leaden Salute','Myrkr','Dagan','Moonlight','Starlight'};
-- blu magic
handle_common.BstPetAttack = T{'Foot Kick','Whirl Claws','Big Scissors','Tail Blow','Blockhead','Sensilla Blades','Tegmina Buffet','Lamb Chop','Sheep Charge','Pentapeck','Recoil Dive','Frogkick','Queasyshroom','Numbshroom','Shakeshroom','Nimble Snap','Cyclotail','Somersault','Tickling Tendrils','Sweeping Gouge','Grapple','Double Claw','Spinning Top','Suction','Tortoise Stomp','Power Attack','Rhino Attack','Razor Fang','Claw Cyclone','Crossthrash','Scythe Tail','Ripper Fang','Chomp Rush','Pecking Flurry','Sickle Slash','Mandibular Bite','Wing Slap','Beak Lunge','Head Butt','Wild Oats','Needle Shot','Disembowel','Extirpating Salvo','Mega Scissors','Back Heel','Hoof Volley','Fluid Toss','Fluid Spread'};
handle_common.BstPetMagicAttack = T{'Gloom Spray','Fireball','Acid Spray','Molting Plumage','Cursed Sphere','Nectarous Deluge','Charged Whisker','Nepenthic Plunge'};
handle_common.BstPetMagicAccuracy = T{'Toxic Spit','Acid Spray','Leaf Dagger','Venom Spray','Venom','Dark Spore','Sandblast','Dust Cloud','Stink Bomb','Slug Family','Intimidate','Gloeosuccus','Spider Web','Filamented Hold','Choke Breath','Blaster','Snow Cloud','Roar','Palsy Pollen','Spore','Brain Crush','Choke Breath','Silence Gas','Chaotic Eye','Sheep Song','Soporific','Predatory Glare','Sudden Lunge','Numbing Noise','Jettatura','Bubble Shower','Spoil','Scream','Noisome Powder','Acid Mist','Rhinowrecker','Swooping Frenzy','Venom Shower','Corrosive Ooze','Spiral Spin','Infrasonics','Hi-Freq Field','Purulent Ooze','Foul Waters','Sandpit','Infected Leech','Pestilent Plume'};
handle_common.SmnSkill = T{'Shining Ruby','Glittering Ruby','Crimson Howl','Inferno Howl','Frost Armor','Crystal Blessing','Aerial Armor','Hastega II','Fleet Wind','Hastega','Earthen Ward','Earthen Armor','Rolling Thunder','Lightning Armor','Soothing Current','Ecliptic Growl','Heavenward Howl','Ecliptic Howl','Noctoshield','Dream Shroud','Altana\'s Favor','Reraise','Reraise II','Reraise III','Raise','Raise II','Raise III','Wind\'s Blessing'};
handle_common.SmnMagical = T{'Searing Light','Meteorite','Holy Mist','Inferno','Fire II','Fire IV','Meteor Strike','Conflag Strike','Diamond Dust','Blizzard II','Blizzard IV','Heavenly Strike','Aerial Blast','Aero II','Aero IV','Wind Blade','Earthen Fury','Stone II','Stone IV','Geocrush','Judgement Bolt','Thunder II','Thunder IV','Thunderstorm','Thunderspark','Tidal Wave','Water II','Water IV','Grand Fall','Howling Moon','Lunar Bay','Ruinous Omen','Somnolence','Nether Blast','Night Terror','Level ? Holy'};
handle_common.SmnHealing = T{'Healing Ruby','Healing Ruby II','Whispering Wind','Spring Water'};
handle_common.SmnHybrid = T{'Flaming Crush','Burning Strike'};
handle_common.SmnEnfeebling = T{'Diamond Storm','Sleepga','Shock Squall','Slowga','Tidal Roar','Pavor Nocturnus','Ultimate Terror','Nightmare','Mewing Lullaby','Eerie Eye'};
handle_common.BluMagPhys = T{'Foot Kick','Sprout Smack','Wild Oats','Power Attack','Queasyshroom','Battle Dance','Feather Storm','Helldive','Bludgeon','Claw Cyclone','Screwdriver','Grand Slam','Smite of Rage','Pinecone Bomb','Jet Stream','Uppercut','Terror Touch','Mandibular Bite','Sickle Slash','Dimensional Death','Spiral Spin','Death Scissors','Seedspray','Body Slam','Hydro Shot','Frenetic Rip','Spinal Cleave','Hysteric Barrage','Asuran Claws','Cannonball','Disseverment','Ram Charge','Vertical Cleave','Final Sting','Goblin Rush','Vanity Dive','Whirl of Rage','Benthic Typhoon','Quad. Continuum','Empty Thrash','Delta Thrust','Heavy Strike','Quadrastrike','Tourbillion','Amorphic Spikes','Barbed Crescent','Bilgestorm','Bloodrake','Glutinous Dart','Paralyzing Triad','Thrashing Assault','Sinker Drill','Sweeping Gouge','Saurian Slide'};
handle_common.BluMagDebuff = T{'Filamented Hold','Cimicine Discharge','Demoralizing Roar','Venom Shell','Light of Penance','Sandspray','Auroral Drape','Frightful Roar','Enervation','Infrasonics','Lowing','CMain Wave','Awful Eye','Voracious Trunk','Sheep Song','Soporific','Yawn','Dream Flower','Chaotic Eye','Sound Blast','Blank Gaze','Stinking Gas','Geist Wall','Feather Tickle','Reaving Wind','Mortal Ray','Absolute Terror','Blistering Roar','Cruel Joke'};
handle_common.BluMagStun = T{'Head Butt','Frypan','Tail Slap','Sub-zero Smash','Sudden Lunge'};
handle_common.BluMagBuff = T{'Cocoon','Refueling','Feather Barrier','Memento Mori','Zephyr Mantle','Warm-Up','Amplification','Triumphant Roar','Saline Coat','Reactor Cool','Plasma Charge','Regeneration','Animating Wail','Battery Charge','Winds of Promy.','Barrier Tusk','Orcish Counterstance','Pyric Bulwark','Nat. Meditation','Restoral','Erratic Flutter','Carcharian Verve','Harden Shell','Mighty Guard'};
handle_common.BluMagSkill = T{'Metallic Body','Diamondhide','Magic Barrier','Occultation','Atra. Libations'};
handle_common.BluMagDiffus = T{'Erratic Flutter','Carcharian Verve','Harden Shell','Mighty Guard'};
handle_common.BluMagCure = T{'Pollen','Healing Breeze','Wild Carrot','Magic Fruit','Plenilune Embrace'};
handle_common.BluMagEnmity = T{'Actinic Burst','Exuviation','Fantod','Jettatura','Temporal Shift'};
handle_common.BluMagTH = T{'Actinic Burst','Dream Flower','Subduction'};
handle_common.Elements = T{'Thunder', 'Blizzard', 'Fire', 'Stone', 'Aero', 'Water', 'Light', 'Dark'};
handle_common.HelixSpells = T{'Ionohelix', 'Cryohelix', 'Pyrohelix', 'Geohelix', 'Anemohelix', 'Hydrohelix', 'Luminohelix', 'Noctohelix'};
handle_common.StormSpells = T{'Thunderstorm', 'Hailstorm', 'Firestorm', 'Sandstorm', 'Windstorm', 'Rainstorm', 'Aurorastorm', 'Voidstorm'};
handle_common.NinNukes = T{'Katon: Ichi', 'Katon: Ni', 'Katon: San', 'Hyoton: Ichi', 'Hyoton: Ni', 'Hyoton: San', 'Huton: Ichi', 'Huton: Ni', 'Huton: San', 'Doton: Ichi', 'Doton: Ni', 'Doton: San', 'Raiton: Ichi', 'Raiton: Ni', 'Raiton: San', 'Suiton: Ichi', 'Suiton: Ni', 'Suiton: San'};
handle_common.Rolls = T{{'Fighter\'s Roll',5,9}, {'Monk\'s Roll',3,7}, {'Healer\'s Roll',3,7}, {'Corsair\'s Roll',5,9}, {'Ninja Roll',4,8},{'Hunter\'s Roll',4,8}, {'Chaos Roll',4,8}, {'Magus\'s Roll',2,6}, {'Drachen Roll',4,8}, {'Choral Roll',2,6},{'Beast Roll',4,8}, {'Samurai Roll',2,6}, {'Evoker\'s Roll',5,9}, {'Rogue\'s Roll',5,9}, {'Warlock\'s Roll',4,8},
	{'Puppet Roll',3,7}, {'Gallant\'s Roll',3,7}, {'Wizard\'s Roll',5,9}, {'Dancer\'s Roll',3,7}, {'Scholar\'s Roll',2,6},{'Naturalist\'s Roll',3,7}, {'Runeist\'s Roll',4,8}, {'Bolter\'s Roll',3,9}, {'Caster\'s Roll',2,7}, {'Courser\'s Roll',3,9},{'Blitzer\'s Roll',4,9}, {'Tactician\'s Roll',5,8}, {'Allies\' Roll',3,10}, {'Miser\'s Roll',5,7},
	{'Companion\'s Roll',2,10},{'Avenger\'s Roll',4,8},}; -- {name,lucky,unlucky}

-- Area Buff
--Areas diferentes a Aht Urhgan Whitegate y Aldouin
handle_common.signetAreas = T{'Tavnazian Safehold','San d\'Oria-Jeuno Airship','Bastok-Jeuno Airship','Windurst-Jeuno Airship','Kazham-Jeuno Airship','Southern San d\'Oria','Northern San d\'Oria','Port San d\'Oria','Chateau d\'Oraguille','Bastok Mines','Bastok Markets','Port Bastok','Metalworks','Windurst Waters','Windurst Walls','Port Windurst','Windurst Woods','Heavens Tower','Ru\'Lude Gardens','Upper Jeuno','Lower Jeuno','Port Jeuno','Rabao','Selbina','Mhaura','Kazham','Norg','Western Altepa Desert','Eastern Altepa Desert','Qufim Island','Beaucedine Glacier','Xarcabard','Carpenters\' Landing','Bibiki Bay','Lufaise Meadows','Misareaux Coast','Phanauet Channel','Valkurm Dunes','Buburimu Peninsula','Tahrongi Canyon','Konschtat Highlands','La Theine Plateau','Jugner Forest','Batallia Downs','Rolanberry Fields','East Ronfaure','West Ronfaure','North Gustaberg','South Gustaberg','East Sarutabaruta','West Sarutabaruta','Bostaunieux Oubliette','Crawlers\' Nest','Garlaige Citadel','Ordelle\'s Caves','Gusgen Mines','Maze of Shakhrami','Korroloka Tunnel','Ranguemont Pass','Dangruf Wadi','Inner Horutoto Ruins','Outer Horutoto Ruins','Toraimarai Canal','Sea Serpent Grotto','Ifrit\'s Cauldron'};
handle_common.sanctionAreas = T{'Al Zahbi','Aht Urhgan Whitegate','Nashmau','Arrapago Reef','Aydeewa Subterrane','Bhaflau Thickets','Caedarva Mire','Halvung','Ilrusi Atoll','Leujaoam Sanctum','Mamook','Mamool Ja Training Grounds','Mount Zhayolm','Periqia','Silver Sea route to Nashmau','Silver Sea route to Al Zahbi','Talacca Cove','The Ashu Talif','Wajaom Woodlands','Zhayolm Remnants','Arrapago Remnants','Bhaflau Remnants','Nyzul Isle','Alzadaal Undersea Ruins'};
handle_common.sigilAreas = T{'Southern San d\'Oria [S]','Northern San d\'Oria [S]','East Ronfaure [S]','West Ronfaure [S]','Jugner Forest [S]','Vunkerl Inlet [S]','Batallia Downs [S]','Bastok Markets [S]','Bastok Mines [S]','North Gustaberg [S]','Grauberg [S]','Pashhow Marshlands [S]','Rolanberry Fields [S]','Windurst Waters [S]','Windurst Walls [S]','West Sarutabaruta [S]','Fort Karugo-Narugo [S]','Meriphataud Mountains [S]','Sauromugue Champaign [S]','Garlaige Citadel [S]','Beaucedine Glacier [S]','Xarcabard [S]','The Eldieme Necropolis [S]','Crawlers\' Nest [S]','Bostaunieux Oubliette [S]','Ranguemont Pass [S]','La Vaule [S]','Castle Oztroja [S]','Davoi [S]','Beadeaux [S]','Castle Zvahl Baileys [S]','Castle Zvahl Keep [S]'};



handle_common.ws = T{
    'Chant du Cygne','Savage Blade','Expiacion','Requiescat',
    'Aeolian Edge','Evisceration','Last Stand','Rudra\'s Storm','Pyrrhic Kleos',
    'Wildfire','Leaden Salute',
    'Victory Smite','Shijin Spiral',
    'Blade: Hi','Blade: Metsu','Blade: Shun','Blade: Teki',
    'Chant du Cygne','Atonement',
    'True Flight',
    'Dimidiation','Resolution','Shockwave',
    'Tachi: Jinpu','Tachi: Ageha','Stardiver',
    'Cataclysm','Mykyr',
    'Impulse Drive'
    };
    


handle_common.settings = {
	--[[
	You can also set any of these on a per job basis in the job file in the OnLoad function. See my COR job file to see how this is done
	but as an example you can just put 'handle_common.settings.RefreshGearMPP = 50;' in your job files OnLoad function to modify for that job only
	]]
	Messages = false; --set to true if you want chat log messages to appear on any /gc command used such as DT, TH, or KITE gear toggles, certain messages will always appear
	AutoGear = true; --set to false if you dont want DT/Regen/Refresh/PetDT gear to come on automatically at the defined %'s here
	WScheck = true; --set to false if you dont want to use the WSdistance safety check
	WSdistance = 4.3; --default max distance (yalms) to allow non-ranged WS to go off at if the above WScheck is true
	RegenGearHPP = 60; -- set HPP to have your idle regen set to come on
	RefreshGearMPP = 70; -- set MPP to have your idle refresh set to come on
	DTGearHPP = 40; -- set HPP to have your DT set to come on
	PetDTGearHPP = 50; -- set pet HPP to have your PetDT set to come on
	MoonshadeTP = 2250; -- this is the TP amount you want to equip EAR2 with moonshade earring when you have less than this amount, set to 0 if you dont want to use at all
	Tele_Ring = 'Dim. Ring (Dem)'; -- put your tele ring in here
};

--custom sets

function handle_common.SetTownGear()
	local zone = gData.GetEnvironment();
	if (zone.Area ~= nil) and (handle_common.Towns:contains(zone.Area)) then handle_common.useSet('town') end
end


-- Aliases

function handle_common.SetAlias()
	for _, v in ipairs(handle_common.AliasList) do
		AshitaCore:GetChatManager():QueueCommand(-1, '/alias /' .. v .. ' /lac fwd ' .. v);
	end
    
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F5 /acc');
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F6 /eva');
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F7 /th');
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F8 /ring_hpp75');

    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F9 /pdt');
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F10 /mdt');

    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F12 /xray');
    

    AshitaCore:GetChatManager():QueueCommand(20000, '/bind list');

end

function handle_common.ClearAlias()
	for _, v in ipairs(handle_common.AliasList) do
		AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /' .. v);
	end
    
    AshitaCore:GetChatManager():QueueCommand(-1, '/unbind all');

end

function handle_common.setAliasValues()
    for _, aliasName in ipairs(handle_common.AliasList) do
        handle_common[aliasName] = false;
    end
end

function handle_common.SetCommands(args)
	if not handle_common.AliasList:contains(args[1]) then return end

	local player = gData.GetPlayer();

    aliasName = args[1]
    handle_common[aliasName] = not handle_common[aliasName];
    print(aliasName .. ' is now set to ' .. tostring(handle_common[aliasName]));


    if (aliasName == 'craft') then
        if (handle_common.craft == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable main');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable sub');
        else
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable main');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable sub');
        end
    end
    if (aliasName == 'fishing') then
        if (handle_common.fishing == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable ammo');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable range');
        else
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable ammo');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable range');
        end
    end
    if (aliasName == 'xray') then
        if (handle_common.xray == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/fillmode 2');
        else
            AshitaCore:GetChatManager():QueueCommand(-1, '/fillmode 3');
        end
    end

end

function handle_common.Unload()
	handle_common.ClearAlias();
end

function handle_common.Initialize(sets)
	handle_common.SetAlias:once(2);
    handle_common.setAliasValues()
    handle_common.sets = sets;
end
--Hangle items
function handle_common.HandleItem(sets)
    local item = gData.GetAction();
    local player = gData.GetPlayer();
    
    if (string.contains(item.Name, 'Rice Ball') and player.MainJob == 'SAM') then
        handle_common.useSet('set_rice_ball');
    end

end


--Precast
function handle_common.HandlePrecast(sets)
    local spell = gData.GetAction();

    local val = gData.GetBuffCount('Valiance');
    local vall = gData.GetBuffCount('Vallation');

    local player = gData.GetPlayer();
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    local mw = gData.GetBuffCount('Manawell');
    local MainJob = player.MainJob;
    
    handle_common.useSet('precast');

    --General
    if (spell.Skill == 'Enhancing Magic') then
        handle_common.useSet('precast_enhancing');
    elseif (spell.Skill == 'Healing Magic') then
        handle_common.useSet('precast_healing');
    end

    --Manejo del Sorcerer's Ring
    if (handle_common.ring_hpp75 == true and (player.MainJob == 'BLM' or player.MainJob == 'BRD')) then
        if(player.HPP > 75) then
            handle_common.useSet('hpp_reduction_75');
        end
    end

    if string.contains(spell.Name, 'Stoneskin') then
        handle_common.useSet('stoneskin_precast');
    end 

    --Handle BLU
    if string.contains(spell.Skill, 'Blue Magic') then
        handle_common.useSet('blu_precast');
    end
    --BRD
    if (spell.Skill == 'Singing') then
        handle_common.useSet('song_precast');
    end
    --RUN
    if (val >= 1) or (vall >= 1) then
        handle_common.useSet('run_precast_vallation_valiance');
    end

end
--Midcast
function handle_common.HandleMidcast(sets)
    local spell = gData.GetAction();
    
    if (spell.Skill == 'Enhancing Magic') then
        handle_common.useSet('enhancing');
    elseif (spell.Skill == 'Healing Magic') then
        handle_common.useSet('cure');
    end

    --Handle BLU
    handle_common.blu_midcast();
    --hable Mage
    handle_common.mage_midcast();
    
end

function handle_common.HandlePreshot(sets)
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    
    handle_common.useSet('preshot');

    --COR RNG
    if (player.MainJob == 'COR' or player.MainJob == 'RNG') then
        local flurryI = gData.GetBuffCount(265);
        local flurryII = gData.GetBuffCount(581);
        if flurryII > 0 then
            handle_common.useSet('preshot_flurryII');
        elseif flurryI > 0 then
            handle_common.useSet('preshot_flurryI');
        end
    end
    
    
    
end

function handle_common.HandleMidshot(sets)
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();

    local double = gData.GetBuffCount('Double Shot');
    local barrage = gData.GetBuffCount('Barrage');

    local triple = gData.GetBuffCount('Triple Shot');

    handle_common.useSet('midshot');
    
    
    if triple > 0 then
        handle_common.useSet('triple_shot');
    end
    
    if double > 0 then
        handle_common.useSet('double_shot');
    end

    if (handle_common.acc == true) then
        handle_common.useSet('midshot_acc');
    end

    if barrage > 0 then--ensure acc as base if barrage up
        handle_common.useSet('midshot_acc');
        handle_common.useSet('barrage');
    end
    

    
end

--Sets
function handle_common.CheckDefault(sets)
    local player = gData.GetPlayer();
    local game = gData.GetEnvironment();

    local sa = gData.GetBuffCount('Sneak Attack');
    local ta = gData.GetBuffCount('Trick Attack');

    --MNK
    local impetus = gData.GetBuffCount('Impetus');
    local footwork = gData.GetBuffCount('Footwork');
    --NIN
    local yonin = gData.GetBuffCount('Yonin');
    local innin = gData.GetBuffCount('Innin');
    local migawari = gData.GetBuffCount('Migawari');
    --PLD
    local cover = gData.GetBuffCount('Cover');
    --SAM
    local hasso = gData.GetBuffCount('Hasso');
    local thirdeye = gData.GetBuffCount('Third Eye');
    local seigan = gData.GetBuffCount('Seigan');
    
	handle_common.SetTownGear();
    --handle_common.auto();
    --handle_common.AreaBuff();

    --Control de auto
    if(handle_common.auto == true) then
        common_functions.auto();
    end

    --Pets Check ----------------------------------------
    local pet = gData.GetPet();
    local OD = gData.GetBuffCount('Overdrive');

	local petAction = gData.GetPetAction();
    if (pet ~= nil) and (petAction ~= nil) then
        handle_common.HandlePetAction(petAction);
    end
    if(pet ~= nil and pet.Status == 'Engaged' and player.Status ~= 'Engaged') then
        handle_common.useSet('pet_only_tp');
    end
    --PUP
    if(player.MainJob == 'PUP') then
        if (pet ~= nil) and (pet.TP > 950) and (pet.Status == 'Engaged') then 
            if (handle_common.pet_range == true) then
                handle_common.useSet('pet_ws_range');
            else
                handle_common.useSet('pet_ws');
            end
        end
        if OD > 0 then
            handle_common.useSet('pup_overdrive');
        end
    end
    --SMN
    
    if (pet ~= nil) and (pet.Name == 'Carbuncle') then
        handle_common.useSet('smn_carbuncle');
    end
    -- ---------------------------------------------------

    if (handle_common.choco == true) then handle_common.useSet('choco') end
    if (handle_common.eva == true) then handle_common.useSet('eva') end
    if (handle_common.acc == true) then handle_common.useSet('acc') end
    
    --Not engaged, Not Moving   
    if (player.Status ~= 'Engaged') and (player.IsMoving ~= true) then
        if (handle_common.craft == true) then handle_common.useSet('craft') end
        if (handle_common.fishing == true) then handle_common.useSet('fishing') end
        if (handle_common.helm == true) then handle_common.useSet('helm') end
    end

    --Allways
    if (cover >= 1) then
		handle_common.useSet('pld_fealty'); -- same set as fealty
	end


    --RESTING STANCE
    if (player.Status == 'Resting') then
        
        handle_common.useSet('resting');
        
    --NOT Engage Stance
    elseif (player.Status ~= 'Engaged') then
        --Movement detection
        if(player.IsMoving == true) then

            handle_common.useSet('movement');

            if(player.MainJob == 'NIN') then
                if (game.Time < 6.00) or (game.Time > 18.00) then
		            handle_common.useSet('nin_movement_night');
                end
            end

        else
            handle_common.useSet('idle');
        end
    elseif(player.Status == 'Engaged') then
    --Engage Stance
        
        --tp default
        local hasSet = handle_common.tp_levels();
        if (hasSet == false) then
            handle_common.useSet('tp_default');
        end

        -- acc and eva
        if (handle_common.acc == true) then handle_common.useSet('tp_acc') end
        if (handle_common.eva == true) then handle_common.useSet('tp_eva') end
        -- th
        if (handle_common.th == true) then handle_common.useSet('th') end
        --MNK
        if (impetus >= 1) then handle_common.useSet('mnk_impetus') end
        if (footwork >= 1) then handle_common.useSet('mnk_footwork') end
        --NIN
        if (yonin > 0) then handle_common.useSet('nin_yonin')
        elseif (innin > 0) then handle_common.useSet('nin_innin') end
        --SAM
        if (hasso >= 1) then handle_common.useSet('sam_hasso') end
        if (thirdeye >= 1) and (seigan >= 1) then 
            handle_common.useSet('sam_thirdeye');
        elseif (seigan >= 1) then
            handle_common.useSet('sam_seigan');
        end


    end

    -- NOT RESTING
    if (player.Status ~= 'Resting') then

        -- Emnity
        if (handle_common.emnity == true) then
            handle_common.useSet('enmity');
        end
        -- PDT
        if (handle_common.pdt == true) then
            handle_common.useSet('pdt');
        end
        -- MDT
        if (handle_common.mdt == true) then
            handle_common.useSet('mdt');
        end
        
    end

    -- THF
    if (sa == 1) and (ta == 1) then
        handle_common.useSet('thf_sata');
    elseif (sa == 1) then
        handle_common.useSet('thf_sa');
    elseif (ta == 1) then
        handle_common.useSet('thf_ta');
    end
	
end
-- Abilities
function handle_common.HandleAbility(sets)
    local player = gData.GetPlayer();
    local ability = gData.GetAction();
    local target = gData.GetActionTarget();
    local ac = gData.GetBuffCount('Astral Conduit');

    --WAR
        if string.match(ability.Name, 'Provoke') then handle_common.useSet('enmity') end
        if ability.Name == 'Tomahawk' then handle_common.useSet('set_tomahawk');
        elseif ability.Name == 'Berserk' then handle_common.useSet('set_berserk');
        elseif ability.Name == 'Aggressor' then handle_common.useSet('set_aggressor');
        elseif ability.Name == 'Warcry' then handle_common.useSet('set_warcry');
        elseif ability.Name == 'Defender' then handle_common.useSet('set_defender');
        elseif ability.Name == 'Blood Rage' then handle_common.useSet('set_blood_rage');end;

    -- Handle BST
        if string.match(ability.Name, 'Call Beast') or string.match(ability.Name, 'Bestial Loyalty') then
            handle_common.useSet('call_pet');
        elseif string.match(ability.Name, 'Reward') then
            handle_common.useSet('bst_reward');
        elseif string.match(ability.Type, 'Killer Instinct') then
            handle_common.useSet('bst_killer');
        elseif string.match(ability.Type, 'Spur') then
            handle_common.useSet('bst_spur');
        elseif string.match(ability.Type, 'Ready') then
            handle_common.useSet('bst_ready');
        end

    -- DNC
        if string.contains(ability.Name, 'Climactic') then
           handle_common.useSet('dnc_climactic');
        elseif string.contains(ability.Name, 'Waltz') then
           handle_common.useSet('dnc_waltz') 
        end

    -- Handle DRG
        if (string.contains(ability.Name, 'Jump')) then
            handle_common.useSet('drg_jump'); 
        end
    -- DRK
        if(player.MainJob == 'DRK') then
            if string.match(ability.Name, 'Blood Weapon') then
                handle_common.useSet('blood_weapon');
            end
        end
    -- MNK
        if(player.MainJob == 'MNK') then
            if string.match(ability.Name, 'Focus') then handle_common.useSet('mnk_focus');
            elseif string.match(ability.Name, 'Dodge') then handle_common.useSet('mnk_dodge');
            elseif string.match(ability.Name, 'Hundred Fists') then handle_common.useSet('mnk_hundred_fists');
            elseif string.match(ability.Name, 'Chakra') then handle_common.useSet('mnk_chakra');
            elseif string.match(ability.Name, 'Footwork') then handle_common.useSet('mnk_footwork');
            elseif string.match(ability.Name, 'Counterstance') or string.match(ability.Name, 'Mantra') then handle_common.useSet('mnk_counterstance');
            elseif string.contains(ability.Name, 'Formless Strikes') then handle_common.useSet('mnk_formless_strikes') end
        end
    -- NIN
        if string.match(ability.Name, 'Mijin Gakure') then handle_common.useSet('nin_mijin_gakure') end
    --PLD
        if string.match(ability.Name, 'Shield Bash') or string.match(ability.Name, 'Chivalry') then handle_common.useSet('shield_bash'); end
        if(player.MainJob == 'PLD') then
            handle_common.useSet('emnity');
            if string.match(ability.Name, 'Cover') then handle_common.useSet('pld_cover');
            elseif string.match(ability.Name, 'Fealty') then handle_common.useSet('pld_fealty');
            elseif string.match(ability.Name, 'Sentinel') then handle_common.useSet('pld_sentinel');
            --invincible
            elseif string.match(ability.Name, 'Invincible') then handle_common.useSet('pld_invincible');    
            elseif string.match(ability.Name, 'Rampart') then handle_common.useSet('pld_rampart');
            end
        end
    --RDM
        if(player.MainJob == 'RDM') then
            if string.match(ability.Name, 'Convert') then handle_common.useSet('rdm_convert');
            elseif string.match(ability.Name, 'Chainspell') then handle_common.useSet('rdm_chainspell');end
        end
    --RNG
        if(player.MainJob == 'RNG') then
            if string.match(ability.Name, 'Scavenge') then handle_common.useSet('rng_scavenge');
            elseif string.match(ability.Name, 'Sharpshot') then handle_common.useSet('rng_sharpshot') end
        end
    --RUN
        if(player.MainJob == 'RUN') then
            handle_common.useSet('emnity');
            if string.match(ability.Name, 'Swipe') or string.match(ability.Name, 'Lunge') then
                handle_common.useSet('swipe_lunge');
            elseif string.match(ability.Name, 'Vallation') or string.match(ability.Name, 'Valiance') then
                handle_common.useSet('run_vallation_valiance');
            elseif string.contains(ability.Name, 'Pulse') then
                handle_common.useSet('run_pulse');
            elseif string.contains(ability.Name, 'Swordplay') then
                handle_common.useSet('run_swordplay');
            elseif string.contains(ability.Name, 'Sforzo') then
                handle_common.useSet('run_sforzo');
            elseif string.match(ability.Name, 'Battuta') then
                handle_common.useSet('run_battuta');
            end
        end
    --SAM
        if(player.MainJob == 'SAM') then
            if string.match(ability.Name, 'Meditate') then handle_common.useSet('sam_meditate');
            elseif string.match(ability.Name, 'Third Eye') then handle_common.useSet('sam_thirdeye');end
        end
    --SMN
        if(player.MainJob == 'SMN') then
            if ac == 0 then 
                if (ability.Name ~= 'Release') and (ability.Name ~= 'Avatar\'s Favor') and (ability.Name ~= 'Assault') and (ability.Name ~= 'Retreat') and (ability.Name ~= 'Apogee') then
                handle_common.useSet('smn_blood_pact');
                    if (ability.Name == 'Elemental Siphon') then
                        handle_common.useSet('smn_siphon');
                    end
                end
            end
    --THF
        if string.match(ability.Name, 'Flee') then
		    handle_common.useSet('thf_flee');
	    elseif string.match(ability.Name, 'Steal') then
            handle_common.useSet('thf_steal');
        elseif string.match(ability.Name, 'Despoil') then
            handle_common.useSet('thf_despoil');
        elseif string.match(ability.Name, 'Mug') then
            handle_common.useSet('thf_mug');
        end


    end

end

-- Weapon Skills
function handle_common.HandleWeaponskill(sets)
    local canWS = handle_common.CheckWsBailout();
    
    local ws = gData.GetAction();
    local sa = gData.GetBuffCount('Sneak Attack');
    local ta = gData.GetBuffCount('Trick Attack');
    
    if (canWS == false) then 
        gFunc.CancelAction() 
        return;
    else
        

        handle_common.ws_levels();
        handle_common.useSet('ws_default');

        if(handle_common.acc == true) then
            handle_common.useSet('ws_acc');
        end

        --Main WS Handler
        if (handle_common.ws:contains(ws.Name)) then
            local ws_name_clean = string.gsub(ws.Name, "'", "")      -- elimina comillas simples
            ws_name_clean = string.gsub(ws_name_clean, " ", "_")     -- reemplaza espacios por _
            ws_name_clean = string.gsub(ws_name_clean, ":", "")     -- elimina dos puntos
            ws_name_clean = string.lower(ws_name_clean)              -- todo en minúsculas
            handle_common.useSet('ws_' .. ws_name_clean);
        end

        --THF buffs
        if (sa == 1) and (ta == 1) then
            handle_common.useSet('ws_sata');
        elseif (sa == 1) then
            handle_common.useSet('ws_sa');
        elseif (ta == 1) then
            handle_common.useSet('ws_ta');
        end
        -- --------------------

    end

end
-- Pet Actions
function handle_common.HandlePetAction(PetAction)
    local player = gData.GetPlayer();
    local level = player.MainJobLevel;
    local MainJob = player.MainJob;

    if(MainJob == 'BST') then
        handle_common.useSet('petReadyDefault');
    
        if (handle_common.BstPetAttack:contains(PetAction.Name)) then
            handle_common.useSet('petAttack');
        elseif (handle_common.BstPetMagicAttack:contains(PetAction.Name)) then
            handle_common.useSet('petMagicAttack');
        elseif (handle_common.BstPetMagicAccuracy:contains(PetAction.Name)) then
            handle_common.useSet('petMagicAccuracy');
        end
    
    end
    --SMN
    if(MainJob == 'SMN') then
        
        if (handle_common.SmnSkill:contains(PetAction.Name)) then
            handle_common.useSet('smn_skill');
            if PetAction.Name == 'Wind\'s Blessing' then
                handle_common.useSet('smn_wind_blessing');
            end
        elseif (handle_common.SmnMagical:contains(PetAction.Name)) then
            handle_common.useSet('smn_magical');
        elseif (handle_common.SmnHybrid:contains(PetAction.Name)) then
            handle_common.useSet('smn_hybrid');
        elseif (handle_common.SmnHealing:contains(PetAction.Name)) then
            handle_common.useSet('smn_healing');
        elseif (handle_common.SmnEnfeebling:contains(PetAction.Name)) then
            handle_common.useSet('smn_enfeebling');
        else
            handle_common.useSet('smn_physical');
        end

    end
    --PUP
    if(MainJob == 'PUP') then
        
        if (string.match(ability.Name, 'Repair')) or (string.match(ability.Name, 'Maintenance')) then
            handle_common.useSet('pup_repair');
        elseif (string.contains(ability.Name, 'Maneuver')) then
            handle_common.useSet('pup_maneuver');
        elseif (string.match(ability.Name, 'Overdrive')) then
            handle_common.useSet('pup_overdrive');
        end

    end


end

-- Handle Level paths to 75
function handle_common.tp_levels()
    local player = gData.GetPlayer();
    local level = player.MainJobLevel;
    local hasSet = false;

    if (level > 70) and (level < 75) then
        hasSet = handle_common.useSet('tp_level_70');
    elseif (level > 60) and (level <= 70) then
        hasSet = handle_common.useSet('tp_level_60');
    elseif (level > 50) and (level <= 60) then
        hasSet = handle_common.useSet('tp_level_50');
    elseif (level > 40) and (level <= 50) then
        hasSet = handle_common.useSet('tp_level_40');
    elseif (level > 30) and (level <= 40) then
        hasSet = handle_common.useSet('tp_level_30');
    elseif (level > 20) and (level <= 30) then
        hasSet = handle_common.useSet('tp_level_20');
    elseif (level > 10) and (level <= 20) then
        hasSet = handle_common.useSet('tp_level_10');
    elseif (level >= 1) and (level <= 10) then
        hasSet = handle_common.useSet('tp_level_1');
    end

    return hasSet;
end

-- Handle Level paths to 75 for WS
function handle_common.ws_levels()
    local player = gData.GetPlayer();
    local level = player.MainJobLevel;

    if (level > 70) and (level < 75) then
        handle_common.useSet('ws_level_70');
    elseif (level > 60) and (level <= 70) then
        handle_common.useSet('ws_level_60');
    elseif (level > 50) and (level <= 60) then
        handle_common.useSet('ws_level_50');
    elseif (level > 40) and (level <= 50) then
        handle_common.useSet('ws_level_40');
    elseif (level > 30) and (level <= 40) then
        handle_common.useSet('ws_level_30');
    elseif (level > 20) and (level <= 30) then
        handle_common.useSet('ws_level_20');
    elseif (level > 10) and (level <= 20) then
        handle_common.useSet('ws_level_10');
    elseif (level >= 1) and (level <= 10) then
        handle_common.useSet('ws_level_1');
    end
end



function handle_common.CheckWsBailout()
	local player = gData.GetPlayer();
	local ws = gData.GetAction();
	local target = gData.GetActionTarget();
	local sleep = gData.GetBuffCount('Sleep');
	local petrify = gData.GetBuffCount('Petrification');
	local stun = gData.GetBuffCount('Stun');
	local terror = gData.GetBuffCount('Terror');
	local amnesia = gData.GetBuffCount('Amnesia');
	local charm = gData.GetBuffCount('Charm');

	if handle_common.settings.WScheck and not handle_common.DistanceWS:contains(ws.Name) and (tonumber(target.Distance) > handle_common.settings.WSdistance) then
		print('Distance to mob is too far! Move closer or increase WS distance');
		print('Can change WS distance allowed by using /wsdistance ##');
		return false;
	elseif (player.TP <= 999) or (sleep+petrify+stun+terror+amnesia+charm >= 1) then
		return false;
	end
		
	return true;
end

function handle_common.CheckSpellBailout()
	local sleep = gData.GetBuffCount('Sleep');
	local petrify = gData.GetBuffCount('Petrification');
	local stun = gData.GetBuffCount('Stun');
	local terror = gData.GetBuffCount('Terror');
	local silence = gData.GetBuffCount('Silence');
	local charm = gData.GetBuffCount('Charm');

	if (sleep+petrify+stun+terror+silence+charm >= 1) then
		return false;
	else
		return true;
	end
end

function handle_common.CheckAbilityRecast(check)
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

-- DRG Casting
function handle_common.check_healing_DRG()
    local player = gData.GetPlayer();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local MainJob = player.MainJob;
    local SubJob = player.SubJob;

    if (MainJob == 'DRG') then
        if(SubJob == 'WHM') or (SubJob == 'SCH') or (SubJob == 'RDM') or (SubJob == 'BLU') or (SubJob == 'NIN')  then
            if (spell.Skill == 'Healing Magic') or (spell.Skill == 'Enhancing Magic') or (spell.Skill == 'Ninjutsu') then
                if (target.Name == player.Name) then
                    handle_common.useSet('drg_healing_breath');
                end
            end
        end
    end
end

-- BLM
function handle_common.mage_midcast()
    local player = gData.GetPlayer();
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    local mw = gData.GetBuffCount('Manawell');
    local power = gData.GetBuffCount('Ebullience') +  gData.GetBuffCount('Rapture');
    local klimaform = gData.GetBuffCount('Klimaform');

    --NIN
    local futae = gData.GetBuffCount('Futae');

    local MainJob = player.MainJob;

    handle_common.check_healing_DRG();

        --PLD case
        if(player.MainJob == 'PLD') then
            handle_common.useSet('emnity');
        end
        -- ---------------------------------------

        if (spell.Skill == 'Enhancing Magic') then
                handle_common.useSet('enhancing');
            if (target.Name == me) then
                --handle_common.useSet('self_Enhancing');
            end

            if string.match(spell.Name, 'Phalanx') then
                handle_common.useSet('phalanx');
            elseif string.match(spell.Name, 'Stoneskin') then
                handle_common.useSet('stoneskin');
            elseif string.contains(spell.Name, 'Regen') then
                handle_common.useSet('regen');
            elseif string.contains(spell.Name, 'Refresh') then
                handle_common.useSet('refresh');
                if (target.Name == me) then
                   --handle_common.useSet('self_Refresh');
                end
            end
        elseif (spell.Skill == 'Healing Magic') then
            handle_common.useSet('cure');
            if (target.Name == me) then
                --handle_common.useSet('self_Cure');
            end
        elseif (spell.Skill == 'Elemental Magic') then
            handle_common.useSet('nuke');

            if (handle_common.mac == true) then
                handle_common.useSet('nukeACC');
            end
            if (spell.Element == weather.WeatherElement and klimaform > 0) then
                handle_common.useSet('klimaform');
            end
            if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
                handle_common.useSet('weather_day_set');
            end
            if string.match(spell.Name, 'helix') then
                handle_common.useSet('helix');
            end
            if (player.MPP <= 40) and (mw == 0) then
                handle_common.useSet('mp_under_40');
            end
            if (player.MPP <= 40) and (mw == 0) then
                handle_common.useSet('mp_under_50');
            end
            if (player.HPP <= 75) and (player.MainJob == 'BLM') then
                handle_common.useSet('ring_hp75');
            end
            if (player.HPP <= 75) and (player.MainJob == 'BRD') then
                handle_common.useSet('ring_hp75');
            end
            if string.contains(spell.Name, 'ja') then
                handle_common.useSet('ja_spell');
            end
        elseif (spell.Skill == 'Enfeebling Magic') then
            if(player.MainJob == 'RDM') then
                handle_common.useSet('magic_acc');
            end
            handle_common.useSet('enfeebling');
        elseif (spell.Skill == 'Dark Magic') then
            handle_common.useSet('dark_magic');
            if (string.contains(spell.Name, 'Aspir') or string.contains(spell.Name, 'Drain')) then
                handle_common.useSet('aspir_drain');
            elseif (string.match(spell.Name, 'Dread Spikes')) then
                handle_common.useSet('dread_spikes');
            elseif (string.match(spell.Name, 'Kaustra')) then
                handle_common.useSet('kaustra');
            end
        elseif (spell.Skill == 'Divine Magic') then
            handle_common.useSet('divine_magic');
            if (string.contains(spell.Name, 'Flash')) then
                handle_common.useSet('cast_flash');
            end
        elseif (spell.Skill == 'Singing') then
            if (string.contains(spell.Name, 'Paeon')) or (string.contains(spell.Name, 'Mazurka')) then
                handle_common.useSet('paeon');
            else
                handle_common.useSet('sing_buff');
            end
            if (string.contains(spell.Name, 'Requiem')) or (string.contains(spell.Name, 'Elegy')) or (string.contains(spell.Name, 'Threnody')) or (string.contains(spell.Name, 'Finale')) or (string.contains(spell.Name, 'Lullaby')) then
                handle_common.useSet('sing_wind');
            end
            if (string.contains(spell.Name, 'Horde Lullaby')) then
                handle_common.useSet('horde_lullaby');
            elseif (string.contains(spell.Name, 'Foe Lullaby')) then
                handle_common.useSet('foe_lullaby');
            elseif (string.contains(spell.Name, 'March')) then
                handle_common.useSet('march');
            elseif (string.contains(spell.Name, 'Madrigal')) then
                handle_common.useSet('madrigal');
            elseif (string.contains(spell.Name, 'Scherzo')) then
                handle_common.useSet('scherzo');
            elseif (string.contains(spell.Name, 'Ballad')) then
                handle_common.useSet('ballad');
            end
            
        elseif (spell.Skill == 'Ninjutsu') then
            if string.contains(spell.Name, 'Utsusemi') then
                handle_common.useSet('utsusemi');
            elseif (handle_common.NinNukes:contains(spell.Name)) then
                handle_common.useSet('nuke');
                if (futae > 0) then handle_common.useSet('nin_futae') end
            else
                handle_common.useSet('nukeACC');
            end
        elseif (spell.Skill == 'Summoning Magic') then
            handle_common.useSet('smn_magic');
        end

        
end
-- BLU
function handle_common.blu_midcast()
    local player = gData.GetPlayer();
    local spell = gData.GetAction();

    local diff = gData.GetBuffCount('Diffusion');
    local ca = gData.GetBuffCount('Chain Affinity');
    local ba = gData.GetBuffCount('Burst Affinity');
    local ef = gData.GetBuffCount('Efflux');
    local spell = gData.GetAction();
    
    if (handle_common.BluMagDebuff:contains(spell.Name)) then handle_common.useSet('bluMagicAccuracy')
    elseif (handle_common.BluMagStun:contains(spell.Name)) then handle_common.useSet('bluStun');
    elseif (handle_common.BluMagBuff:contains(spell.Name)) then handle_common.useSet('bluBuff');
    elseif (handle_common.BluMagSkill:contains(spell.Name)) then handle_common.useSet('bluSkill');
    elseif (handle_common.BluMagCure:contains(spell.Name)) then handle_common.useSet('cure');
    elseif (handle_common.BluMagEnmity:contains(spell.Name)) then handle_common.useSet('enmity');
    elseif string.match(spell.Name, 'White Wind') then handle_common.useSet(sets.WhiteWind);
    elseif string.match(spell.Name, 'Evryone. Grudge') or string.match(spell.Name, 'Tenebral Crush') then handle_common.useSet('bluDark');
    end

    if (ca>=1) then handle_common.useSet('blu_ca') end
    if (ba>=1) then handle_common.useSet('blu_ba') end
    if (ef>=1) then handle_common.useSet('efflux') end
    if (diff>=1) then handle_common.useSet('blu_diffusion') end
end



function handle_common.AreaBuff()
    local player = gData.GetPlayer();
    local zone = gData.GetEnvironment();
    
    local signet = gData.GetBuffCount('Signet');
    local sigil = gData.GetBuffCount('Sigil');
    local sanction = gData.GetBuffCount('Sanction');
    
	if (zone.Area ~= nil) and (handle_common.signetAreas:contains(zone.Area)) then
        if (signet <= 0) then
            AshitaCore:GetChatManager():QueueCommand(-1, '!signet');
        end
    end
	if (zone.Area ~= nil) and (handle_common.sanctionAreas:contains(zone.Area)) then
        if (sanction <= 0) then
            AshitaCore:GetChatManager():QueueCommand(-1, '!sanction');
        end
    end
	if (zone.Area ~= nil) and (handle_common.sigilAreas:contains(zone.Area)) then
        if (sigil <= 0) then
            AshitaCore:GetChatManager():QueueCommand(-1, '!sigil');
        end
    end
    
end

function handle_common.HasItem(itemName)
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

-- Control de sets

function handle_common.useSet(setName)
    if (handle_common.sets[setName] == nil) then
        print(chat.header('GearSets'):append(chat.message('Set not found: ' .. setName)));
        return false
    else
        --detecta si no esta vacia
        if(next(handle_common.sets[setName]) ~= nil) then
            gFunc.EquipSet(setName);
            return true
        end
        return false
    end
end

return handle_common;