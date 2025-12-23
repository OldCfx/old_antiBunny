local bmxHash = GetHashKey("bmx")
local jumpCount = 0
local lastJumpTime = 0
local isRagdoll = false

Citizen.CreateThread(function()
    while true do
        local sleep = 500

        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)


        if veh == 0 then
            jumpCount = 0
            goto continue
        end


        if GetEntityModel(veh) ~= bmxHash then
            jumpCount = 0
            sleep = 250
            goto continue
        end


        sleep = 0

        if not isRagdoll then
            if IsControlJustPressed(0, Config.jumpKey) then
                local currentTime = GetGameTimer()

                jumpCount = (currentTime - lastJumpTime < Config.resetTime) and (jumpCount + 1) or 1
                lastJumpTime = currentTime

                if jumpCount >= Config.maxJumps then
                    TriggerRagdoll(ped, veh)
                    jumpCount = 0
                end
            end
        end

        if GetGameTimer() - lastJumpTime > Config.resetTime then
            jumpCount = 0
        end

        ::continue::
        Citizen.Wait(sleep)
    end
end)

function TriggerRagdoll(ped, veh)
    isRagdoll = true

    TaskLeaveVehicle(ped, veh, 4160)
    Citizen.Wait(200)

    SetPedToRagdoll(ped, Config.ragdollDuration, Config.ragdollDuration, 0, 0, 0, 0)

    print("Arrête de spam les sauts sur le BMX !") -- si tu veux remplace par une notification

    Citizen.Wait(Config.ragdollDuration + 300)
    isRagdoll = false
end
