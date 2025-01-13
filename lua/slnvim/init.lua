--- Plugin that provides better functionality for working with
-- visual studio solutions.

vim.g.slnvim_auto_init = true
vim.g.slnvim_auto_create_toml = false
vim.g.slnvim_initialized = false

fs = require("slnvim.utils.fs")
ui = require("slnvim.utils.ui")

local sln = require("slnvim.sln")
local solution = nil

local config = require("slnvim.config")
local conf = nil

local term_popup = require("slnvim.utils.term_popup")

-- All nui examples show capitalized names, so breaking convention here.
local Split = require("nui.split")
local Popup = require("nui.popup")
local Event = require('nui.utils.autocmd').event

--- Ask the user to select a project file
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

--- Build the given project
--@param proj string: Path to selected .csproj
function build_proj(proj)
	if proj == nil then return end

	cmds = {}
	table.insert(cmds, { "MSBuild", proj.path, "-p:Configuration=Debug" })

	term_popup:run_all(cmds)
end

---  Builds the entire .sln
function build_all()
	if sln == nil then return end

	cmds = {}
	table.insert(cmds, { "MSBuild", sln.sln_path, "-p:Configuration=Debug" })

	term_popup:run_all(cmds)
end

function run()
	if conf == nil then return end
	print(vim.inspect(conf))

	local opts = {}
	for _,start_conf in pairs(conf.startup_configs) do
		table.insert(opts, start_conf.name)
	end
	ui.select(opts, "Select Run Config",
	function() print("NONE") end,
	function(item)
		selected = conf.startup_configs[item.index]
	end)
end

function load_slnvim_toml()
	local toml_confs = fs.find_file(vim.fn.getcwd(), ".slnvim.toml")
	if #toml_confs > 0 then
		conf = config.from_file()
		return conf ~= nil
	end
	return false
end

--- Prompt the user to select a sln file
--@param sln_opts [string]: Array of solution files found in root directory
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


function ask_for_init(sln_opts)
	ui.select({"Yes", "No" }, 
	"Initialize SLN Project?",
	function()
	end,
	function(item)
		if item.index == 1 then
			sln_selection(sln_opts)
		end
	end)
end

--- Search the current directory for solution files
function init_slnvim()
	local toml_loaded = load_slnvim_toml()

	if toml_loaded == true then
		solution = sln.from_file(conf.sln_path)
	else
		local sln_opts = fs.find_sln(vim.fn.getcwd())
		if sln_opts ~= nil then
			ask_for_init(sln_opts)
		end
	end
end


local M = {} -- module

function M.setup(opts)
	opts = opts or {}

	if vim.g.slnvim_auto_init == true then
		init_slnvim()
	end

	local slnvim_group = vim.api.nvim_create_augroup("slnvim", { clear = true })
	vim.api.nvim_create_user_command('SLNInit', init_slnvim, { nargs = 0 })
	vim.api.nvim_create_user_command('SLNBuild', select_proj, { nargs = 0 })
	vim.api.nvim_create_user_command('SLNLoad', function()
		conf = config.from_file(".slnvim.toml")
	end, { nargs = 0 })
	vim.api.nvim_create_user_command('SLNRun', run, { nargs = 0 })
	vim.api.nvim_create_user_command('SLNBuildAll', build_all, { nargs = 0 })
end

return M
