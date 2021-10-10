# Telescope-kubectl.nvim

Edit k8s objects, view pod logs, etc...

## Install

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
			linode_cmd = "linode-cli",
			extra_args = ""
		}
	},
}
```

```
nnoremap <leader>k <cmd>lua require('telescope').load_extension('linode_commands').ssh_linode()<cr>
```