local myname, ns = ...

ns.points = {
    --[[ structure:
    [mapFile] = { -- "_terrain1" etc will be stripped from attempts to fetch this
        [coord] = {
            label=[string], -- label: text that'll be the label, optional
            item=[id], -- itemid
            quest=[id], -- will be checked, for whether character already has it
            achievement=[id], -- will be shown in the tooltip
            junk=[bool], -- doesn't count for achievement
            npc=[id], -- related npc id, used to display names in tooltip
            note=[string], -- some text which might be helpful
        },
    },
    --]]
    ["Azsuna"] = {
        [54003300] = { label="Nar'thalas academy crystal", },
        [37003200] = { label="Nor'danil wellspring north crystal", },
        [50002000] = { label="Azurewing repose cave crystal ", },
        [61003000] = { label="In a cave crystal", },
        [47006200] = { label="Oceanus cove crystal", },
        [42000800] = { label="Lost Orchard crystal", },
        [34003500] = { label="Nor'danil wellspring south crystal", },
        [47003300] = { label="Azurewing repose south crystal", },
        [53002800] = { label="Liothien crystal", },
        [59003800] = { label="Hatecoil warcamp crystal", },
        [67003300] = { label="Felblaze Ingress east crystal", },
        [60005300] = { label="The Ruined sanctum west crystal", },
    },
}
