--- Module used to interact with toml files that specify
-- a configuration for slnvim.
-- @module slnvim.config
--

local toml = require("toml")

local build_config = {
	name = nil,
	cmd = nil
}

function build_config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

local config = {
	title = nil,
	solution = nil,
	build_configs = {},
	projects = {},
	startup_configs = {}
}

function config:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function config:load(path)
	toml_str = fs.read_all(path)
	print(toml_str)
end


return config

