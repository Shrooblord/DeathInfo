
meta =
{
    id = "DeathInfo", --ws id "1847804341"
    name = "DeathInfo",
    title = "Death Info",
    description = "Sends a Mail to the owner of a destroyed Ship or Station containing the details of their death.",
    authors = {"Shrooblord"},


    version = "1.1.3",
    dependencies = {
        {id = "1847767864", min = "1.1"},  -- Shrooblord Mothership
        {id = "Avorion", min = "0.26", max = "0.32.*"}
    },

    serverSideOnly = false,
    clientSideOnly = false,
    saveGameAltering = true,
    contact = "avorion@shrooblord.com",
}
