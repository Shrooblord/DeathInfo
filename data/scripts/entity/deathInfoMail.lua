--DeathInfo (c) Shrooblord, 2019
--  Binds the functionality to a Ship or Station's onDestroyed() callback so the player gets sent a Mail when one of their Ships or Stations is destroyed, detailing the events of their death.

package.path = package.path .. ";data/scripts/lib/?.lua"
include("utility")
include("stringutility")
include("faction")
include("callable")
include("sMFormat")
include("sMStringUtility")

-- Don't remove or alter the following comment, it tells the game the namespace this script lives in. If you remove it, the script will break.
-- namespace DeathInfo
DeathInfo = {}

local mailText = ""
local mailHeader = ""
local mailSender = ""

function DeathInfo.restore(values)
    mailText = values.mailText or ""
    mailHeader = values.mailHeader or ""
    mailSender = values.mailSender or ""
end

-- this function gets called on creation of the entity the script is attached to, on client and server
function DeathInfo.initialize()
    if onServer() then
        local e = Entity()
        e:registerCallback("onDestroyed" , "onDestroyed")
    end

    if onClient() then
        invokeServerFunction("setTranslatedMailText",
                             "Concerning Your Destroyed Property"%_t,
                             DeathInfo.generateDeathInfoMailText(),
                             "S.R.I. /* Abbreviation for Ship Registration Intergalactical; must match with the email signature */"%_t)
    end
end

function DeathInfo.setTranslatedMailText(header, text, sender)
    mailHeader = header
    mailText = text
    mailSender = sender
end
callable(DeathInfo, "setTranslatedMailText")

-- if ship is destroyed this function is called
function DeathInfo.onDestroyed(index, lastDamageInflictor)
    local faction = Faction()
    if not faction then return end
    local e = Entity()

    local x, y = Sector():getCoordinates()
    deathLocation = padCoords(x, y)     -- returns the coords formatted to "([-]xxx:[-]yyy)" notation

    if faction then
        local destroyerText = ""
        local destroyer = Entity(lastDamageInflictor)

        local destroyerTitle = destroyer.title
        if destroyerTitle then
            destroyerTitle = destroyerTitle.." "
        end

        local destroyerName = destroyer.name
        if not destroyerName then
            if not destroyerTitle then
                destroyerName = "Unknown vessel"
            else
                destroyerName = "unknown vessel"
            end
        end
        
        local destroyerFactionName = Faction(destroyer.factionIndex).name
        if destroyerFactionName then
            if not stringStartsWith(destroyerFactionName, "The ") then
                destroyerFactionName = "the "..destroyerFactionName
            end
        else
            destroyerFactionName = "an unknown"
        end

        destroyerFactionName = destroyerFactionName.." faction"

        destroyerText = destroyerTitle..destroyerName.." of "..destroyerFactionName

        local mail = Mail()
        mail.header = mailHeader
        mail.text = mailText % {destroyer = destroyerText, location = deathLocation}
        mail.sender = mailSender
        
        if faction.isPlayer then
            local p = Player(faction.index)
            p:addMail(mail)
        end

        if faction.isAlliance then
            local alliance = Alliance(faction.index)
            local members = {alliance:getMembers()}

            for _, member in pairs(members) do
                Player(member):addMail(mail)
            end
        end
    end
end

-- following are mail texts sent to the player
function DeathInfo.generateDeathInfoMailText()
    local entity = Entity()
    local receiver = Faction()
    if not receiver then return end

    --${destroyer} and ${location} will be filled out at a later time, when onDestroyed() is called
    local deathInfoMail = [[Dear ${player},

We received notice of the destruction of your craft '${craft}'. Very unfortunate!

From the Black Box data, we were able to recover the location of its demise, and the culprit behind the attack.
This information follows:

Location: ${location}
Destroyed by: ${destroyer}

The contract for your craft '${craft}' is now fulfilled. We hope we can be of future service to you.

Best wishes,
Ship Registration Intergalactical
]]%_t

    return deathInfoMail % {player = receiver.name, craft = entity.name}
end

function DeathInfo.sendInfo(faction, msg, ...)
    if faction.isPlayer then
        local player = Player(faction.index)
        player:sendChatMessage("S.R.I./* Abbreviation for Ship Registration Intergalactical; must match with the email signature */"%_t, 3, msg, ...)
    end
end
