--- Module used to interact with toml files that specify
-- a configuration for slnvim.
-- @module slnvim.config
--

local fs = require("slnvim.utils.fs")

local toml = require("deps.tinytoml")
local conf = nil

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
	print(path)
	local parsed = toml.parse(path)

	conf = config.new(parsed)
	return conf
end

return config

