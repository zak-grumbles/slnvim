fs = require("slnvim.utils.fs")
ui = require("slnvim.utils.ui")

local sln = require("slnvim.sln")
local solution = nil

local term_popup = require("slnvim.utils.term_popup")

-- All nui examples show capitalized names, so breaking convention here.
local Split = require("nui.split")
local Popup = require("nui.popup")
local Event = require('nui.utils.autocmd').event

function sln_selection(sln_opts)
	ui.select(sln_opts, "Select Solution",
	function() 
		print("No solution selected")
	end,
	function(item)
		solution = sln:new()
		solution:load(item.text)
	end)
end

function init_slnvim()
	found_slns = fs.find_sln(vim.fn.getcwd())
	if next(found_slns) ~= nil then
		sln_selection(found_slns)
	end
end

function select_proj()
	if solution ~= nil then
		proj_opts = {}
		for i,p in ipairs(solution.projects) do
			table.insert(proj_opts, p.name)
		end
		ui.select(proj_opts, "Select Project",
		function()
			print("No project selected")
		end,
		function(item)
			selected = solution.projects[item.index]
			build_proj(selected)
		end)
	end
end

function build_proj(proj)
	if proj == nil then return end

	cmds = {}
	table.insert(cmds, { "dotnet", "build" })

	term_popup:run_all(cmds)
end

local M = {} -- module

function M.setup(opts)
	opts = opts or {}

	local slnvim_group = vim.api.nvim_create_augroup("slnvim", { clear = true })

	vim.api.nvim_create_user_command('SLNInit', init_slnvim, { nargs = 0 })
	vim.api.nvim_create_user_command('SLNBuild', select_proj, { nargs = 0 })
end


return M
