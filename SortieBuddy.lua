_addon.name = 'SortieBuddy'
_addon.author = 'Meneth'
_addon.version = '1.1'
_addon.command = 'sortie'
_addon.language = 'english'

local packets = require('packets')

-- Table des Bitzers (E, F, G, H)
local bitzer_indexes = {
    ["Bitzer E"] = 837,
    ["Bitzer F"] = 838,
    ["Bitzer G"] = 839,
    ["Bitzer H"] = 840,
}

local ordered_keys = {"Bitzer E", "Bitzer F", "Bitzer G", "Bitzer H"}

local human_reading = {
    -- Secteur E
    D6 = 'NW boss', E6 = 'NE boss', D7 = 'SW boss', E7 = 'SE boss',
    D8 = 'Flans', D9 = 'Flans', E8 = 'Flans', E9 = 'Flans',
    -- Secteur G
    L11 = 'SE boss', K11 = 'SW boss', L10 = 'NE boss', K10 = 'NW boss',
    L8 = 'Vamps', L9 = 'Vamps',
    -- Secteur F
    J4 = 'NW boss', K4 = 'NE boss', J5 = 'SW boss', K5 = 'SE boss',
    H4 = 'Pixies', I4 = 'Pixies', H5 = 'Pixies', I5 = 'Pixies',
    F4 = 'NW after pixies', G4 = 'NE after pixies', F5 = 'SW after pixies', G5 = 'SE after pixies',
    L6 = 'NW door room', M6 = 'NE door room', L7 = 'SW door room', M7 = 'SE door room',
    -- Secteur H
    F11 = 'NW boss', G11 = 'NE boss', F12 = 'SW boss', G12 = 'SE boss',
    H12 = '"Flans"', I12 = '"Flans"',
    J12 = 'NW after "flans"', K12 = 'NE after "flans"', J13 = 'SW after "flans"', K13 = 'SE after "flans"',
    D10 = 'NW door room', E10 = 'NE door room', D11 = 'SW door room', E11 = 'SE door room',
}

local function get_coords(mob)
    if not mob then return '??' end
    local column = 2 + math.floor((mob.x - 40) / 80)
    local row    = 7 - math.floor((mob.y - 40) / 80)
    return (column > 0) and (row > 0) and string.char(column + 64)..row or string.format("(x: %.1f, y: %.1f)",mob.x,mob.y)
end

-- Force la mise à jour des données serveur
-- From NyzulBuddy (Uwu/Darkdoom)
function Update()
    for _, v in pairs(bitzer_indexes) do
        packets.inject(packets.new('outgoing', 0x016, {["Target Index"] = v}))
    end
end

function actual_send_to_party()
    local wait_time = 0
    local found = false

    for _, name in ipairs(ordered_keys) do
        local mob = windower.ffxi.get_mob_by_index(bitzer_indexes[name])

        if mob and mob.name == 'Diaphanous Bitzer' and mob.x ~= 0 then
            local location = get_coords(mob)
            local hint = human_reading[location] or location
            
            wait_time = wait_time + 2
            windower.send_command(string.format("wait %s; input /p %s : %s", wait_time, name, hint))
            found = true
        end
    end
    if not found then windower.send_command('input /p no bitzer found yet...') end
end

function send_to_party()
    Update()
    windower.add_to_chat(200, 'SortieBuddy: Report is being generated...')
    windower.send_command('input /p Trying to find Bitzers; wait 3; sortie internal_send')
end

function actual_send_to_self()
    local found = false

    for _, name in ipairs(ordered_keys) do
        local mob = windower.ffxi.get_mob_by_index(bitzer_indexes[name])

        if mob and mob.name == 'Diaphanous Bitzer' and mob.x ~= 0 then
            local location = get_coords(mob)
            local hint = human_reading[location] or location
            
            windower.add_to_chat(8,string.format("%s : %s", name, hint))
            found = true
        end
    end
    if not found then windower.add_to_chat(8,'No bitzer found yet...') end
end

function send_to_self()
    Update()
    windower.add_to_chat(200, 'SortieBuddy: Report is being generated...')
    windower.send_command('wait 3; sortie internal_send_self')
end

function sortie_command(command, ...)
    local cmd = command and command:lower() or 'help'

    if cmd == 'send' or cmd == 'report' then
        send_to_party()
    elseif cmd == 'silent' then
        send_to_self()
    elseif cmd == 'internal_send' then
        actual_send_to_party()
    elseif cmd == 'internal_send_self' then
        actual_send_to_self()
    else
        windower.add_to_chat(200, 'SortieBuddy: //sortie send | report | silent')
    end
end

windower.register_event('addon command', sortie_command)