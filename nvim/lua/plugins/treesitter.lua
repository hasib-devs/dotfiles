-- Treesitter for better syntax highlighting and navigation
return {


    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "javascript",
                "typescript",
                "tsx",
                "json",
                "yaml",
                "html",
                "css",
                "scss",
                "go",
                "rust",
                "php",
                "bash",
                "markdown",
                "dockerfile",
                "sql",
                "gitignore",
                "comment",
                "regex",
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },

        })
    end,
}
