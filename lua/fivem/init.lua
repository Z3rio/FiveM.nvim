local M = {}

---@class Opts
---@field debug boolean
M.opts = {
	debug = false,
}

---@param msg string
function M.debugLog(msg)
	if M.opts.debug == true then
		print("SPOTIFY [DEBUG] - " .. msg)
	end
end

---@param opts Opts
function M.setup(opts)
	M.opts = vim.tbl_deep_extend("force", M.opts, opts)

	M.debugLog("Finished setup")
end

return M
