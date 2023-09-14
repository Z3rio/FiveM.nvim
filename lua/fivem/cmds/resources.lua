local M = {}
local Menu = require("nui.menu")
local init = require("fivem.init")

local statePriority = {
	"started",
	"starting",
	"stopping",
	"stopped",
}

M.commands = {
	resources = function()
		local valid = init.validSettings()
		if valid == true then
			require("plenary.curl").request({
				url = vim.g.fivem_opts.server .. "/resources/list?password=" .. vim.g.fivem_opts.password,
				method = "get",
				compressed = false,
				callback = vim.schedule_wrap(function(data)
					local resp = vim.json.decode(data.body)
					if resp.err then
						error(resp.err)
					else
						local items = {}

						for i, v in pairs(resp.list) do
							if items[v.status] == nil then
								items[v.status] = {}
							end

							table.insert(items[v.status], i)
						end

						for i in pairs(items) do
							table.sort(items[i], function(a, b)
								return a:lower() < b:lower()
							end)
						end

						local sortedItems = {}
						for i = 1, #statePriority do
							if items[statePriority[i]] ~= nil then
								for i2 in pairs(items[statePriority[i]]) do
									table.insert(sortedItems, items[statePriority[i]][i2])
								end

								items[statePriority[i]] = nil
							end
						end

						for i in pairs(items) do
							for i2 in pairs(items[i]) do
								table.insert(sortedItems, i2)
							end
						end

						vim.ui.select(sortedItems, {
							prompt = "Select Resource to view",
							format_item = function(item)
								return "[" .. resp.list[item].status .. "] - " .. item
							end,
						}, function(chosenResource)
							Menu({
								position = "50%",
								size = {
									width = 35,
									height = 10,
								},
								border = {
									style = "single",
									text = {
										top = chosenResource,
										top_align = "center",
									},
								},
								win_options = {
									winhighlight = "Normal:Normal,FloatBorder:Normal",
								},
							}, {
								lines = {
									Menu.separator("Current status: " .. resp.list[chosenResource].status, {
										char = "",
										text_align = "right",
									}),
									Menu.separator("Version: " .. resp.list[chosenResource].version, {
										char = "",
										text_align = "right",
									}),
									Menu.separator("", {
										char = "-",
										text_align = "right",
									}),
									Menu.item("Restart"),
									Menu.item("Stop"),
									Menu.item("Start"),
								},
								max_width = 20,
								keymap = {
									focus_next = { "j", "<Down>", "<Tab>" },
									focus_prev = { "k", "<Up>", "<S-Tab>" },
									close = { "<Esc>", "<C-c>" },
									submit = { "<CR>", "<Space>" },
								},
								on_submit = function(item)
									require("plenary.curl").request({
										url = vim.g.fivem_opts.server
											.. "/resources/"
											.. chosenResource
											.. "/"
											.. string.lower(item.text)
											.. "?password="
											.. vim.g.fivem_opts.password,
										method = "post",
										compressed = false,
									})
								end,
							}):mount()
						end)
					end
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

return M
