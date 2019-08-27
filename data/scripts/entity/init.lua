--DeathInfo (c) Shrooblord, 2019
--  Attaches DeathInfo to all Ship and Station Entities if they are not owned by an AI Faction.

if onServer() then

package.path = package.path .. ";data/scripts/lib/?.lua"
include("faction")

local e = Entity()

if (e.isShip) or (e.isStation) then
    if e.isDrone or e.isFighter then return end  --we really don't want this mail to be sent for Mining Drones or Fighters.
    
    local faction = Faction()

    if valid(faction) and not faction.isAIFaction then
        e:addScriptOnce("deathInfoMail")
    end
end

end