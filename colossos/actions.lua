local utils = require "utils"

local actions = {}

actions.list = {}

-- cria uma lista de acções que é armazenada internamente

function actions.build()
    -- Reset list
    actions.list = {}

    -- atacar 
    local boddyAttack = {
        description = "Atacar com o corpo.",
        requirement = nil,

        execute = function (playerData, creatureData)
            -- 1 Definir chance de sucesso
            local sucessChance = creatureData.speed == 0 and 1 or creatureData.speed / playerData.speed
            local sucess = math.random() <= sucessChance

            -- 2 Calcular dano
            local rawDamage = creatureData.attack - math.random() * playerData.defense
            -- local rawDamage = 4 - math.random() * 6
            local damage = math.max(1, math.ceil(rawDamage))


            -- 3 Apresentar resultado como print
            if sucess then
                print(string.format(" %s atacou %s e deu pontos de dano.", creatureData.name, playerData.name, damage))

                -- 4 Aplicar o dano em caso de sucesso
                playerData.health = playerData.health - damage
                local healthRate = math.floor((playerData.health / playerData.maxHealth) * 10)
                print(string.format ("%s: %s", playerData.name, utils.getProgressBar(healthRate)))
            else
                print(string.format(" %s tentou atacar mas errou.", creatureData.name))
            end
        end
    }

        -- ataque sonar 
        local sonarAttack = {
            description = "Ataque Sonar",
            requirement = nil,

            execute = function (playerData, creatureData)
                
                local rawDamage = creatureData.attack - math.random() * playerData.defense
                local damage = math.max(1, math.ceil(rawDamage * 0.3))

                    playerData.health = playerData.health - damage

                    print(string.format("%s usou um sonar e deu %d pontos de dano.", creatureData.name, damage))
                    local healthRate = math.floor((playerData.health / playerData.maxHealth) * 10)
                    print(string.format ("%s: %s", playerData.name, utils.getProgressBar(healthRate)))

                end
        }

         -- aguardar 
         local waitingAction = {
            description = "aguardar",
            requirement = nil,

            execute = function (playerData, creatureData)   

                    print(string.format(" %s decidiu aguardar, e não fez nada nesse turno.", creatureData.name))
                end
        }
    -- usar poção de vida
     local regenPotion = {
        description = "Tomar uma poção de regeneração.",
        requirement = function(playerData, creatureData)
            return playerData.potions >= 1
        end,
        execute = function (playerData, creatureData)
            -- tirar poção do inventario
            playerData.potions = playerData.potions - 1
            
            -- recuperar vida 
            local regenPoints = 5 
            playerData.health = math.min(playerData.maxHealth, playerData.health + regenPoints)
            print("Você usou uma poção e recuperou alguns pontos de vida.")
        end
    }
       -- Populate list
    actions.list[#actions.list + 1] = boddyAttack
    actions.list[#actions.list + 1] = sonarAttack
    actions.list[#actions.list + 1] = waitingAction
end


--[[Retorna uma lista de ações válidas
---@param playerData table Definição do jogador
---@param creatureData table Definição da criatura
---@return table 
]]
function actions.getValidActions(playerData, creatureData)
    local validActions = {}
    for _, action in pairs(actions.list) do
        local requirement = action.requirement
        local isValid = requirement == nil or requirement(playerData, creatureData)
        if isValid then
            validActions[#validActions+1] = action
        end
    end
    return validActions
end

return actions