--- Module used to interact with toml files that specify
-- a configuration for slnvim.
-- @module slnvim.config
--

local toml = require("toml")

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
	startup_configs = {}
}

function config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function config:from_toml(toml_str)
end

return config

