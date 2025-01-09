fs = require("slnvim.utils.fs")
ui = require("slnvim.utils.ui")

sln = require("slnvim.sln")

Menu = require("nui.menu")

function sln_selection(sln_opts)
	ui.select(sln_opts, "Select Solution",
	function() 
		print("No solution selected")
	end,
	function(item)
		local solution = sln:new()
		solution:load(item.text)
	end)
end

function init_slnvim()
	found_slns = fs.find_sln(vim.fn.getcwd())
	if next(found_slns) ~= nil then
		sln_selection(found_slns)
	end
end

local M = {} -- module

function M.setup(opts)
	opts = opts or {}

	local slnvim_group = vim.api.nvim_create_augroup("slnvim", { clear = true })

	vim.api.nvim_create_user_command('SLNInit', init_slnvim, { nargs = 0 })
end


return M
