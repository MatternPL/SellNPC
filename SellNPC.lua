local npcLocation = vector3(0.0, 0.0, 0.0)  -- Lokasjonen av NPC, x, y, z.
local npcModel = ""  -- Modellen av NPCen
local npcName = "Material Forhandler"  -- Navnet av NPCen
local sellPrices = {  -- Priser for hvert item.
    ["Polymer"] = 50,
    ["Stål"] = 50,
    ["Kobber"] = 50,
    ["Stoff"] = 50
}

-- Opprette NPC 
local sellNPC = CreatePed(4, npcModel, npcLocation.x, npcLocation.y, npcLocation.z, 0.0, true, true)
SetEntityAsMissionEntity(sellNPC, true, true)
SetBlockingOfNonTemporaryEvents(sellNPC, true)
SetPedCombatAttributes(sellNPC, 46, true)
SetPedFleeAttributes(sellNPC, 0, 0)

-- Setter NPC navn
SetPedNameDebug(sellNPC, npcName)

-- Marker for NPC
local marker = CreateMarker(1, npcLocation - vector3(0.0, 0.0, 1.0), vector3(0.0, 0.0, 0.0), vector3(0.0, 0.0, 0.0), 1.0, 0, 0, 0, 0, 0, 0)

-- Gir varsling til spiller i nærheten
Citizen.CreateThread(function()
    while true do
        Wait(0)

        if IsPlayerInRangeOfMarker(marker) then
            DisplayHelpText("Trykk E for å selge")
        end

        if IsControlJustReleased(0, 38) and IsPlayerInRangeOfMarker(marker) then  -- E knapp
            -- Åpner selger menyen for spilleren.
            local inventory = GetPlayerInventory()
            local sellMenu = {}
            for item, price in pairs(sellPrices) do
                if inventory[item] then
                    table.insert(sellMenu, {
                        item = item,
                        price = price,
                        count = inventory[item]
                    })
                end
            end
            if #sellMenu > 0 then
                -- Viser selg menyen for spiller.
                local sellMenuString = "Selg gjenstander:\n"
                for _, item in pairs(sellMenu) do
                    sellMenuString = sellMenuString .. string.format("%s: %d x %d$\n", item.item, item.count