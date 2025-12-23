local jumpCount = 0
local lastJumpTime = 0
local isRagdoll = false
local wasJumping = false

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()

        local jumping = IsPedJumping(ped)

        if not isRagdoll and jumping and not wasJumping then
            local currentTime = GetGameTimer()

            jumpCount = (currentTime - lastJumpTime < Config.resetTime)
                and (jumpCount + 1) or 1

            lastJumpTime = currentTime

            if jumpCount >= Config.maxJumps then
                SetPedToRagdoll(
                    ped,
                    Config.ragdollDuration,
                    Config.ragdollDuration,
                    0,
                    false,
                    false,
                    false
                )

                print("Arrête de spam les sauts !") -- si tu veux remplace par une notification
                jumpCount = 0
                isRagdoll = true

                Citizen.SetTimeout(Config.ragdollDuration + 300, function()
                    isRagdoll = false
                end)
            end
        end


        if GetGameTimer() - lastJumpTime > Config.resetTime then
            jumpCount = 0
        end

        wasJumping = jumping


        Citizen.Wait(50)
    end
end)
