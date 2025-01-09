local Popup = require("nui.popup")
local Event = require("nui.utils.autocmd").event

local term_popup = {
	popup = nil
}

function term_popup:run_all(cmds)
	self.popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = "rounded"
		},
		position = "50%",
		size = {
			width = "80%",
			height = "60%"
		},
	})

	self.popup:mount()

	self.popup:on(Event.BufLeave, function()
		self.popup:unmount()
	end)

	for i,cmd in ipairs(cmds) do
		vim.system(cmd, { 
			text = true,
			stdout = function(err, data)
				vim.schedule(function()
					if data ~= nil then
						data = data:gsub("[\n\r]", " ")
						vim.api.nvim_buf_set_lines(self.popup.bufnr, -1, -1, false, { data })
					end
					if err ~= nil then
						err = err:gsub("[\n\r]", " ")
						vim.api.nvim_buf_set_lines(self.popup.bufnr, -1, -1, false, { err })
					end
				end)
			end,
			stderr = function(err, data)
				print(err)
			end
		}, function() print("DONE") end)
	end

end

return term_popup
