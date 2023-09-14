local M = {}
local Menu = require("nui.menu")

M.commands = {
	serverInfo = function()
		require("plenary.curl").request({
			url = vim.g.fivem_opts.server .. "/misc/serverInfo?password=" .. vim.g.fivem_opts.password,
			method = "get",
			compressed = false,
			callback = vim.schedule_wrap(function(data)
				local body = vim.json.decode(data.body)

				Menu({
					position = "50%",
					size = {
						width = 50,
						height = 10,
					},
					border = {
						style = "single",
						text = {
							top = body.servername,
							top_align = "center",
						},
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:Normal",
					},
				}, {
					lines = {
						Menu.separator("Framework: " .. body.framework, {
							char = "",
							text_align = "right",
						}),
						Menu.separator("SQL Script: " .. body.sql, {
							char = "",
							text_align = "right",
						}),
						Menu.separator("Game build: " .. body.gameBuild, {
							char = "",
							text_align = "right",
						}),
						Menu.separator("Onesync: " .. body.onesync, {
							char = "",
							text_align = "right",
						}),
						Menu.separator("Players: " .. body.playerCount .. "/" .. body.maxPlayerCount, {
							char = "",
							text_align = "right",
						}),
					},
					max_width = 20,
					keymap = {
						focus_next = { "j", "<Down>", "<Tab>" },
						focus_prev = { "k", "<Up>", "<S-Tab>" },
						close = { "<Esc>", "<C-c>" },
						submit = { "<CR>", "<Space>" },
					},
				}):mount()
			end),
		})
	end,
}

return M
