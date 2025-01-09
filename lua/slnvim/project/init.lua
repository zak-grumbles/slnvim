--- A module for working with projects in a visual studio solution
-- @module slnvim.project

local project = {
	id = nil,
	name = nil,
	path = nil
}

--- Constructor
-- @return project object
function project:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function project:from_line(line)
	_, _, self.name, self.path, self.id = line:find(
		'Project%(.*%) = "(.*)", "(.*%.csproj)", "({.*})"')
end

return project
