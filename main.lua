


-- dependencias
local utils = require ("utils")
local player = require ("player.player")
local playerActions = require ("player.actions")
local colossos = require ("colossos.colossos")
local colossosActions = require ("colossos.actions")


-- UTF 8
utils.enableUtf8()

-- header
utils.printHeader()

-- obter definição do jogador
print(string.format(" A vida do jogador é %d/%d", player.health, player.maxHealth))

-- obter definição do monstro
local boss = colossos
local bossActions = colossosActions
-- apresentar o monstro 
utils.printCreature(boss)

playerActions.build()
bossActions.build()


-- começar o loop de batalha
while true do

-- mostrar ações do jogador
print()
print(string.format("Qual será a proxima ação de %s?", player.name))
    local valuePlayerActions = playerActions.getValidActions(player, boss)
    for i, actions in pairs(valuePlayerActions) do
        print(string.format("%d. %s", i, actions.description))
    end
    local chosenIndex = utils.ask()
    local chosenAction = valuePlayerActions[chosenIndex]
    local isActionValid = chosenAction ~= nil

    -- simular o turno do jogador 
    if isActionValid then
        chosenAction.execute(player, boss)
    else
        print(string.format("Sua escolha é invalida. %s perdeu a vez!", player.name))
    end


    if boss.health <= 0 then
        break
    end

    print()
    local validBossActions = bossActions.getValidActions(player, boss)
    local bossAction = validBossActions[math.random(#validBossActions)]
    bossAction.execute(player, boss)

    if player.health <= 0 then
        break
    end
end

--processar condicoes de vitoria e derrota
if player.health <= 0 then
    print()
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    print()
    print("😥😣")
    print(string.format("%s não foi capaz de vencer %s.", player.name, boss.name))
    print("Quem sabe da proxima vez bravo guerreiro..")
    print()
elseif boss.health <= 0 then
    print()
    print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    print()
    print("😍😎😋😊")
    print(string.format("%s Venceu o desafio contra %s.", player.name, boss.name))
    print("Parabéns guerreiro!")
    print()
end