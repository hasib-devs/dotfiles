-- Enhanced jump_to navigation
return {
    "ggandor/leap.nvim",
    config = function()
        require("leap").add_default_mappings()
    end,
}
