local M = {}
local init = require("fivem.init")
-- local a = require("async")

M.commands = {
	setup = {
		cb = function()
			init.initialize()
		end,
	},

	init = {
		cb = function()
			init.initialize()
		end,
	},

	healthCheck = {
		cb = function()
			init.healthCheck(false)
		end,
		ignoreHealthCheck = true,
	},
}

M.commands = vim.tbl_deep_extend("force", M.commands, require("fivem.cmds").commands)

function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function table.copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return setmetatable(u, getmetatable(t))
end

function M.init()
	init.healthCheck(false)

	vim.api.nvim_create_user_command("FiveM", function(opts)
		local splits = string.split(opts.args, " ")

		if M.commands[splits[1]] then
			local resp = init.healthCheck(true)
			if resp == true or M.commands[splits[1]].ignoreHealthCheck == true then
				local newSplits = table.copy(splits)
				table.remove(newSplits, 1)

				M.commands[splits[1]].cb(newSplits)
			end
		end
	end, {
		bar = true,
		bang = true,
		nargs = "?",
		desc = "FiveM",
		complete = function(_, line)
			line = string.sub(string.lower(line), 7)
			local splits = string.split(line, " ")

			local results = {}

			for i, v in pairs(M.commands) do
				if #line == 0 or string.find(i, splits[1]) then
					-- exact command match
					if splits[1] == i then
						-- match with custom completion
						if v.complete then
							local newSplits = table.copy(splits)
							table.remove(newSplits, 1)

							return v.complete(newSplits)
							-- match with no further completion
						else
							return {}
						end
					end

					-- non exact match
					table.insert(results, i)
				end
			end

			return results
		end,
	})
end

return M
