--
-- sln.lua
--
-- Contains methods for parsing and interacting with SLN files
--

require("slnvim.utils.strings")

local M = {
	sln_path = nil,
	format_version = nil
}

function M:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function M:load(path)
	self.sln_path = path
	self:parse_sln()
end

function M:parse_file_version(line)
	print(line)
	if not line:startswith("Microsoft Visual Studio Solution File") then
		return nil
	end
	_, _, value = line:find("(%d+%.%d)")
	print(value)
end

function M:parse_sln()
	print(self.sln_path)
	local lines = fs.read_lines(self.sln_path)
	print(vim.inspect(lines))
end


return M 
