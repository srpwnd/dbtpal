-- Filetype helpers for dbt, many of the ideas for these commands
-- are borrowed from jgillies and his vim-dbt plugin

local projects = require "dbtpal.projects"
local config = require "dbtpal.config"

vim.api.nvim_create_augroup("dbtPal", {})

if config.options.custom_dbt_syntax_enabled then
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = "dbtPal",
        pattern = { "*.sql" },
        command = "set filetype=dbt syntax=dbt",
        desc = "Enable custom dbt syntax",
    })
end

-- TODO: this should be configurable by the user
if config.options.extended_path_search then
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = "dbtPal",
        pattern = { "*.sql" },
        command = "set suffixesadd+=.sql",
        desc = "Enable gf (go to file) under cursor)",
    })
end

if config.options.extended_path_search then
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = "dbtPal",
        pattern = { "*.md", "*.yml" },
        command = "set suffixesadd+=.sql",
        desc = "Enable gf (go to file) under cursor)",
    })
end

if config.options.extended_path_search then
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = "dbtPal",
        pattern = { "*.sql", "*.yml", "*.md" },
        callback = function(ev)
            local projPath = config.options.path_to_dbt_project
            if projPath == "" then
              projPath = projects.detect_dbt_project_dir(ev.file)
            end
            if projPath then
                vim.opt.path:append(config.options.path_to_dbt_project .. "/macros/**")
                vim.opt.path:append(config.options.path_to_dbt_project .. "/models/**")
            end
        end,
        desc = "Look for files within dbt project folders",
    })
end

if config.options.protect_compiled_files then
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        group = "dbtPal",
        pattern = { "*/target/run/*.sql", "*/target/compiled/*.sql" },
        command = "set filetype=dbtCompiledSQL syntax=dbt",
        desc = "Look for files within dbt project folders",
    })
end
