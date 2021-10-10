local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
	error("This plugin requires telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)")
end


local utils = require('telescope.utils')
local defaulter = utils.make_default_callable
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values

local Job = require'plenary.job'
local M = {}
local linode_cmd = ""

function split(pString, pPattern)
	local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pPattern
	local last_end = 1
	local s, e, cap = pString:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(Table,cap)
		end
		last_end = e+1
		s, e, cap = pString:find(fpat, last_end)
	end
	if last_end <= #pString then
		cap = pString:sub(last_end)
		table.insert(Table, cap)
	end
	return Table
end

function M.linode_ssh(opts)
	local linode_commands = {
		linode_cli = {
			'linode-cli',
		},
	}

	if not vim.fn.executable(linode_cmd) then
		error("You don't have "..linode_cmd.."! Install it first.")
		return
		end

	if not linode_commands[linode_cmd] then
		error(linode_cmd.." is not supported!")
		return
	end

	local sourced_file = require('plenary.debug_utils').sourced_filepath()
	M.base_directory = vim.fn.fnamemodify(sourced_file, ":h:h:h:h")
	opts = opts or {}
	local popup_opts={}
	opts.get_preview_window=function ()
		return popup_opts.preview
	end

	local results = {}
	Job:new({
		command = 'linode-cli',
		args = {'linodes', 'list', '--text', '--format', 'label,region,ipv4', '--no-headers'},
		on_stdout = function(_, data)
			table.insert(results, data)
		end,
	}):sync()

	local picker=pickers.new(opts, {
		prompt_title = kubeconfig,
		finder = finders.new_table({
			results = results,
			opts = opts,
		}),
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(pbfr, map)
			map("i", "<CR>", function()
				local choice = action_state.get_selected_entry(pbfr)
				local ip_addr = split(choice.value, "\t")
				vim.cmd('! tmux neww ssh root@' .. ip_addr[3])
			end)
			return true
		end,
	})

	local line_count = vim.o.lines - vim.o.cmdheight
	if vim.o.laststatus ~= 0 then
		line_count = line_count - 1
	end
	popup_opts = picker:get_window_options(vim.o.columns, line_count)
	picker:find()
end

return require('telescope').register_extension {
	setup = function(ext_config)
		linode_cmd = ext_config.linode_cmd or "linode_cli"
	end,
	exports = {
		linode_ssh = M.linode_ssh,
	},
}

