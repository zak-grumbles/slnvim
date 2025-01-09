--- A module for working with .sln file data
-- @module slnvim.sln

require("slnvim.utils.strings")
project = require("slnvim.project")

--- Find the line in the given array that indicates the start of sln data.
-- This is necessary as the file may include a byte order mark that gets placed
-- at the start of the array.
-- @param lines [string]: Array of lines assumed to be from a .sln file.
-- @return int or nil: Line index of the start of sln data.
function get_starting_line_index(lines)
	for i,line in ipairs(lines) do
		if line:starts_with("Microsoft Visual Studio Solution File") then
			return i
		end
		if i > 2 then break end
	end
	return nil
end

local M = {
	sln_path = nil,
	format_version = nil,
	visual_studio_version = nil,
	min_visual_studio_version = nil,
	projects = {}
}

--- Constructor for sln object
-- @return sln object
function M:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

--- Loads the .sln file at the given path
-- @param path string: Path to .sln file
function M:load(path)
	self.sln_path = path
	self:parse_sln()
end

--- Parse the line containing information on the file format version.
-- @param line string: Line of text containing format version information.
function M:parse_file_version(line)
	_, _, self.format_version = line:find("(%d+%.%d+)")
end

function M:parse_vs_version(line)
	_, _, self.visual_studio_version = line:find("(%d+%.%d+%.%d+%.%d+)")
end

function M:parse_minimum_vs_version(line)
	_, _, self.min_visual_studio_version = line:find("(%d+%.%d+%.%d+%.%d+)")
end

function M:parse_project(line)
	local new_proj = project:new()
	new_proj:from_line(line)

	table.insert(self.projects, new_proj)
end

--- Parse the sln found at self.sln_path
function M:parse_sln()
	local lines = fs.read_lines(self.sln_path)
	local i = get_starting_line_index(lines)

	self:parse_file_version(lines[i])
	i = i + 1

	for k = i,#lines do
		if lines[k]:starts_with('VisualStudioVersion') then
			self:parse_vs_version(lines[k])
		elseif lines[k]:starts_with('MinimumVisualStudioVersion') then
			self:parse_minimum_vs_version(lines[k])
		elseif lines[k]:starts_with('Project') then
			self:parse_project(lines[k])
		elseif lines[k]:starts_with('Global') then
		end
	end
end

return M 
