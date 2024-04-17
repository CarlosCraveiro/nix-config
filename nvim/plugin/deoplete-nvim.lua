-- Check if deoplete is available
local status_ok, deoplete = pcall(require, "deoplete")
if not status_ok then
  return
end

vim.g['deoplete#enable_at_startup'] = 1  -- Enable deoplete at startup
