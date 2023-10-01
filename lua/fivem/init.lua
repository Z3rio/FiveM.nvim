local M = {}

---@class Opts
---@field debug boolean
---@field password nil | string
---@field server nil | string
vim.g.fivem_opts = vim.g.fivem_opts or {
	debug = false,
	password = nil,
	server = nil,
}

---@param msg string
function M.debugLog(msg)
	if vim.g.fivem_opts.debug == true then
		print("FiveM [DEBUG] - " .. msg)
	end
end

---@return string
function M.getDataPath()
	return vim.fn.stdpath("data") .. "/FiveM.nvim.json"
end

---@param silent? boolean
function M.healthCheck(silent)
	if vim.g.fivem_opts ~= nil and vim.g.fivem_opts.server ~= nil and vim.g.fivem_opts.password ~= nil then
		local retVal = require("fivem.curl").request({
			url = vim.g.fivem_opts.server .. "/misc/healthCheck?password=" .. vim.g.fivem_opts.password,
			method = "get",
			compressed = false,
		})

		if retVal.exit ~= 0 then
			if silent ~= true then
				require("notify")("Your configuration is invalid, or the server is not running", "error", {
					title = "FiveM.nvim",
				})
			end

			return false
		else
			local body = vim.json.decode(retVal.body)

			if silent ~= true then
				if body.err == nil then
					require("notify")("Your configuration is valid", "success", {
						title = "FiveM.nvim",
					})
				else
					require("notify")("Your configuration is invalid, or the server is not running", "error", {
						title = "FiveM.nvim",
					})
				end
			end

			return body.err == nil
		end
	else
		return false
	end
end

---@return boolean
function M.loadData()
	local f = io.open(M.getDataPath(), "rb")
	if f == nil then
		return false
	end

	local content = f:read("*a")
	f:close()

	vim.g.fivem_opts = vim.tbl_deep_extend("force", vim.g.fivem_opts, vim.json.decode(content))

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
	vim.g.fivem_opts = vim.tbl_deep_extend("force", vim.g.fivem_opts, opts)
	M.LoadOptions()

	require("fivem.commands").init()

	M.debugLog("Finished setup")
end

---@return boolean
function M.validSettings()
	return vim.g.fivem_opts.server ~= nil and vim.g.fivem_opts.password ~= nil
end

function M.initialize()
	vim.ui.input({
		prompt = "API IP & Port",
		default = "http://localhost:6969",
	}, function(serverIp)
		if serverIp ~= nil then
			vim.ui.input({
				prompt = "Your Password",
				default = "",
			}, function(password)
				if password ~= nil then
					local f, err = io.open(M.getDataPath(), "w")

					if f then
						f:write(vim.json.encode({
							password = password,
							server = serverIp,
						}))
						f:close()
					else
						print("ERROR WHEN OPENING FILE: " .. err)
					end

					require("notify")(
						"You have now finalized the setup!\n" .. "You can re run this at any time with :FiveM setup",
						"success",
						{
							title = "FiveM.nvim",
						}
					)
				else
					require("notify")(
						"You cancelled the setup of FiveM.nvim\n" .. "To re run this setup, use :FiveM setup",
						"error",
						{
							title = "FiveM.nvim",
						}
					)
				end
			end)
		else
			require("notify")(
				"You cancelled the setup of FiveM.nvim\n" .. "To re run this setup, use :FiveM setup",
				"error",
				{
					title = "FiveM.nvim",
				}
			)
		end
	end)
end

return M
