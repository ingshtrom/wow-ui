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
    ["TanaanJungle"] = {
        [26143160] = { quest=39157, label="Felsworn Sentry", },
        [15744444] = { quest=39168, label="Bleakclaw", },
        [75453736] = { quest=39173, label="Defiled Earth", },
        [57733734] = { quest=39165, label="Direflame", },
        [54072983] = { quest=39167, label="Dark Gazer", },
        [48073302] = { quest=39172, label="Skrillix (Cave)", },
        [48373547] = { quest=39171, label="Netherfist", },
        [31373806] = { quest=39162, label="Cursed Spirit", },
        [42237179] = { quest=39166, label="Mirecroak", },
        [25047621] = { quest=39161, label="Chaos Pup", },
        [44034572] = { quest=39169, label="Vile Blood", },
        [43378444] = { quest=39164, label="Tainted Mudclaw", },
        [53016521] = { quest=39160, label="Corrupted Thundertail", },
        [55908076] = { quest=39163, label="Felfly", },
        [47335278] = { quest=39170, label="Dreadwalker", },
    },
}
