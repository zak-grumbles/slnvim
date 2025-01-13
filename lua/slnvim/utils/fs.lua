local U = {}

function U.is_windows()
	return package.config:sub(1,1) == '\\'
end

function U.read_all(file)
	local f = io.open(file, "rb")
	local content = f:read("*all")
	f:close()
	return content
end

function U.read_lines(file)
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

function U.get_files_in_directory(dir)
	local cmd = nil
	if U.is_windows() then
		cmd = "dir \"" .. dir .. "\" /b /a-d"
	else
		cmd = "find . -maxdepth 1 -not -type d"
	end

	local output = io.popen(cmd)

	local files = {}
	for file in output:lines() do
		table.insert(files, file)
	end
	return files
end

--- Utility method for finding files in a given directory whose names match a given pattern.
-- @param dir string: Directory to search in. 
-- @param pattern string: lua pattern string
-- @return table array containing matching files. Will be empty array if no matches found.
function U.find_file(dir, pattern)
	cmd = nil
	if U.is_windows() then
		cmd = "dir \"" .. dir .. "\" /b /a-d | findstr " .. pattern
	else
		cmd = "find . -maxdepth 1 -type f -name \"" .. pattern .. "\""
	end

	output = io.popen(cmd)

	files = {}
	for file in output:lines() do
		table.insert(files, file)
	end
	return files
end

function U.find_sln(dir)
	cmd = nil
	if U.is_windows() then
		cmd = "dir \"" .. dir .. "\" /b /a-d | findstr .sln$"
	else
		cmd = "find . -maxdepth 1 -type f -name \"*.sln\""
	end

	output = io.popen(cmd)

	files = {}
	for file in output:lines() do
		table.insert(files, file)
	end
	return files
end

return U
