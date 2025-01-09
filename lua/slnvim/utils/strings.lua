
string.starts_with = function(self, str)
	return self:find('^' .. str) ~= nil
end
