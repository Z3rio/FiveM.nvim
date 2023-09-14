local M = {}
local init = require("fivem.init")

---@class Command
---@field func function
---@field opts? Object

---@type Object<string, Command>
M.commands = {
	setup = function()
		init.initialize()
	end,

	init = function()
		init.initialize()
	end,
}

M.commands = vim.tbl_deep_extend("force", M.commands, require("fivem.cmds").commands)

function M.init()
	vim.api.nvim_create_user_command("FiveM", function(opts)
		if M.commands[opts.args] then
			M.commands[opts.args]()
		end
	end, {
		bar = true,
		bang = true,
		nargs = "?",
		desc = "FiveM",
		complete = function(_, line)
			line = string.sub(string.lower(line), 7)

			local results = {}

			for i in pairs(M.commands) do
				if #line == 0 or string.find(i, line) then
					table.insert(results, i)
				end
			end

			return results
		end,
	})
end

return M
