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
		end
	)
end

local M = {} -- module

function M.setup(opts)
	opts = opts or {}

	vim.keymap.set("n", "<Leader>k", function()
		found_slns = fs.find_sln(vim.fn.getcwd())
		if next(found_slns) ~= nil then
			sln_selection(found_slns)
		end
	end)
end


return M
