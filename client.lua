local isKnockedOut = false
local xKeyHash = 0x8CC9CD42 -- Hash for 'X' key

RegisterNetEvent("ragdoll:resetWalk")

local function IsUsingKeyboard(padIndex)
    return Citizen.InvokeNative(0xA571D46727E2B718, padIndex)
end

local function toggleRagdoll(ped)
    isKnockedOut = not isKnockedOut

    if isKnockedOut then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true, 0, false, false) -- Prevent weapon being dropped
        ClearPedTasksImmediately(ped)
        TaskKnockedOut(ped, -1, true)
    else
        TaskKnockedOut(ped, 0, false)
        TriggerServerEvent("ragdoll:resetWalk")
    end
end

AddEventHandler("ragdoll:resetWalk", function(playerServerId)
    SetPedConfigFlag(GetPlayerPed(GetPlayerFromServerId(playerServerId)), 336, false) -- Removes injured walk style
end)

Citizen.CreateThread(function()
    TriggerEvent("chat:addSuggestion", "/ragdoll", "Toggle ragdoll mode")

    while true do
        if IsUsingKeyboard(0) and IsControlJustPressed(0, xKeyHash) then
            toggleRagdoll(PlayerPedId())
        end

        Citizen.Wait(0)
    end
end)
