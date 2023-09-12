local M = {}

---@class Opts
---@field debug boolean
---@field rcon nil | string
---@field server nil | string
M.opts = {
	debug = false,
	rcon = nil,
	server = nil,
}

---@param msg string
function M.debugLog(msg)
	if M.opts.debug == true then
		print("FiveM [DEBUG] - " .. msg)
	end
end

---@return string
function M.getDataPath()
	return vim.fn.expand("%:h:h:h") .. "/data.json"
end

---@return boolean
function M.loadData()
	local f = io.open(M.getDataPath(), "rb")
	if f == nil then
		return false
	end

	local content = f:read("*a")
	f:close()

	M.opts = vim.tbl_deep_extend("force", M.opts, vim.json.decode(content))

	return true
end

function M.LoadOptions()
	local exists = M.loadData()

	if exists == false then
		M.debugLog("Options did not exist, initializing")
		M.initialize()
	else
		M.debugLog("Successfully loaded options")
	end
end

---@param opts Opts
function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts)
	M.LoadOptions()

	M.debugLog("Finished setup")
end

function M.initialize()
	vim.ui.input({
		prompt = "Server IP & Port",
		default = "http://localhost:30120",
	}, function(serverIp)
		if serverIp ~= nil then
			vim.ui.input({
				prompt = "Your Rcon Key",
				default = "",
			}, function(rconKey)
				if rconKey ~= nil then
					local f, err = io.open(M.getDataPath(), "w")

					if f then
						f:write(vim.json.encode({
							rcon = rconKey,
							server = serverIp,
						}))
						f:close()
					else
						print("ERROR WHEN OPENING FILE: " .. err)
					end

					require("notify")(
						"You have now finalized the setup!\n" .. "You can re run this at any time with :FiveMSetup",
						"success",
						{
							title = "FiveM.nvim",
						}
					)
				else
					require("notify")(
						"You cancelled the setup of FiveM.nvim\n" .. "To re run this setup, use :FiveMSetup",
						"error",
						{
							title = "FiveM.nvim",
						}
					)
				end
			end)
		else
			require("notify")(
				"You cancelled the setup of FiveM.nvim\n" .. "To re run this setup, use :FiveMSetup",
				"error",
				{
					title = "FiveM.nvim",
				}
			)
		end
	end)
end

return M
