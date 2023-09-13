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

	resources = function()
		local valid = init.validSettings()
		if valid == true then
			require("plenary.curl").request({
				url = vim.g.fivem_opts.server .. "/resources/list?password=" .. vim.g.fivem_opts.password,
				method = "get",
				compressed = false,
				callback = vim.schedule_wrap(function(data)
					print(vim.json.encode(data))
				end),
			})
		else
			require("notify")(
				"You have either not set up the password/api settings correctly, or your server is not running.\n"
					.. "To set up your settings, use :FiveM setup",
				"error",
				{
					title = "FiveM.nvim",
				}
			)
		end
	end,
}

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
