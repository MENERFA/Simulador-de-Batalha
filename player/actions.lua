local utils = require "utils"

local actions = {}

actions.list = {}

-- cria uma lista de acções que é armazenada internamente

function actions.build()
    -- Reset list
    actions.list = {}

    --atacar com a espada
    local swordAttack = {
        description = "Atacar com espada.",
        requirement = nil,

        execute = function (playerData, creatureData)
            -- 1 Definir chance de sucesso
            local sucessChance = creatureData.speed == 0 and 1 or playerData.speed / creatureData.speed
            local sucess = math.random() <= sucessChance

            -- 2 Calcular dano
            local rawDamage = playerData.attack - math.random() * creatureData.defense
        -- local rawDamage = 4 - math.random() * 6
            local damage = math.max(1, math.ceil(rawDamage))


            -- 3 Apresentar resultado como print
            if sucess then
                print(string.format("%s atacou a criatura e deu %d pontos de dano.", playerData.name, damage))

                -- 4 Aplicar o dano em caso de sucesso
                creatureData.health = creatureData.health - damage
                local healthRate = math.floor((creatureData.health / creatureData.maxHealth) * 10)
                print(string.format ("%s: %s", creatureData.name, utils.getProgressBar(healthRate)))
            else
                print(string.format ("Violet tentou atacar, mas esqueceu a espada na mochila.", playerData.name))
            end
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
            local regenPoints = 10
            playerData.health = math.min(playerData.maxHealth, playerData.health + regenPoints)
            print(string.format ("Violet usou uma poção e recuperou alguns pontos de vida.", playerData.name))
        end
    }
       -- Populate list
    actions.list[#actions.list + 1] = swordAttack
 -- actions.list[0 + 1] = swordAttack
 -- actions.list[1] = swordAttack

    actions.list[#actions.list + 1] = regenPotion
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