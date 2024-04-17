-- Enable filetype plugins
vim.cmd [[filetype plugin on]]

-- Create an autocommand group for Pencil
local pencil_group = vim.api.nvim_create_augroup('pencil', { clear = true })

-- Autocommand for Markdown file types
vim.api.nvim_create_autocmd('FileType', {
    group = pencil_group,
    pattern = {'markdown', 'mkd', 'text'},
    callback = function()
        vim.fn['pencil#init']()
        vim.wo.spell = true  -- Enable spell checking
    end,
})
