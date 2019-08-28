
meta =
{
    id = "DeathInfo",
    name = "DeathInfo",
    title = "Death Info",
    description = "Sends a mail to the owner of a destroyed Ship or Station containing the details of their death.",

    authors = {"Shrooblord"},
    version = "1.0",

    dependencies = {
        {id = "Avorion", min = "0.26"},
        {id = "1847767864", min = "1.0.0"},             --ShrooblordMothership (library mod)
    },

    serverSideOnly = false,
    clientSideOnly = false,
    saveGameAltering = true,

    contact = "avorion@shrooblord.com",
}
