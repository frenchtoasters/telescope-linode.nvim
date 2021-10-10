# Telescope-kubectl.nvim

## Requirements

* tmux
* neovim v0.5.1

## Install

* Configure cli tool:
```
linode-cli configure
```

* Update init.vim
```
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'frenchtoasters/telescope-linode.nvim'
```

## Setup

```
require('telescope').load_extension('linode_commands')
```

### Configuraiton

```
require'telescope'.seutp {
	...
	extensions = {
		linode_commands = {
			linode_cmd = "linode-cli"
		}
	},
}
```

```
nnoremap <leader>k <cmd>lua require('telescope').load_extension('linode_commands').ssh_linode()<cr>
```
