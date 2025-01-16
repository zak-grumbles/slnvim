--- Module used to interact with toml files that specify
-- a configuration for slnvim.
-- @module slnvim.config
--

local fs = require("slnvim.utils.fs")

local toml = require("deps.toml")

local startup_config = {
	name = nil,
	projects = {},
	pre_run_tasks = {}
}

function startup_config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local config = {
	title = nil,
	sln_path = nil,
	startup_configs = {},
	tasks = {},
	projects = {}
}

function config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function config.from_file(path)
	local toml_str = fs.read_all(path)
	print(vim.inspect(toml_str))

	local toml_conf = toml.parse(toml_str)
	local conf = config:new(toml_conf)
	return conf
end

function config.from_sln(sln)
	local c = config:new()

	c.name = sln.title
	c.sln_path = sln.sln_path
	c.projects = sln.projects

	return c
end

function config:save(dir)
	local toml_str = toml.encode(self)
	fs.write_to_file(dir, '.slnvim.toml', toml_str)
end

return config

