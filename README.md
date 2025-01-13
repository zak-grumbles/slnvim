# SLNVIM

Neovim plugin that adds some commands for working in visual studio projects

This is a work in progress and may not yet be stable or fully functional.

## Dependencies
- [nui](https://github.com/MunifTanjim/nui.nvim) for UI

## Installation
I highly recommend using a package manager. 

### Plug
`Plug 'zak-grumbles/slnvim'`

## Usage

_Commands marked with a `*` should be assumed to be unstable or not functional_

| Command        | Description                                         |
| -------------- | --------------------------------------------------- |
| `:SLNInit`     | Prompts the user to select a solution file to load. |
| `:SLNBuild`    | Prompts the user to select a project to build.      |
| `:SLNLoad`*    | Loads the `.slnvim.toml` fild if found.             |
| `:SLNRun`*     | **TODO**                                                |
| `:SLNBuildAll` | Builds the entire solution.                         |
