local M = {}
local init = require("fivem.init")

M.commands = {
	setup = function()
		init.initialize()
	end,

	init = function()
		init.initialize()
	end,

	healthCheck = function()
		init.healthCheck(false)
	end,
}

M.commands = vim.tbl_deep_extend("force", M.commands, require("fivem.cmds").commands)

function M.init()
	init.healthCheck(false)

	vim.api.nvim_create_user_command("FiveM", function(opts)
		if M.commands[opts.args] then
			init.healthCheck(true, function(resp)
				if resp == true then
					M.commands[opts.args]()
				end
			end)
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
