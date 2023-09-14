local M = {}

M.commands = {}

M.commands = vim.tbl_deep_extend("force", M.commands, require("fivem.cmds.resources").commands)

return M
