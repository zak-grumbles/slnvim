local Menu = require("nui.menu")

local M = {}

function M.select(opts, title, fn_close, fn_select)
	local menu_opts = {}

	for i in ipairs(opts) do
		table.insert(menu_opts, Menu.item(opts[i], { index = i }))
	end

	local menu = Menu({
		position = "50%",
		size = {
			width = 50,
			height = 10,
		},
		border = {
			style = "single",
			text = {
				top = title,
				top_align = "center"
			}
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal"
		},
	}, {
		lines = menu_opts,
		max_width = 50,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" }
		},
		on_close = fn_close,
		on_submit = fn_select
	})

	menu:mount()
end

return M
