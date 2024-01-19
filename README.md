<h1 align="center">Focus.nvim</h1>

A small plugin to provide a focus/writer/non clutter/zen mode in vim.

## Intent

The intent of this plugin is to provide focus mode that fits my needs.

It doesn't modify the editor config for the window, nor uses floating windows.
Basically it just create a new tab with only the current buffer displayed.

It also solves a problem I had with other plugins, I couldn't delete or leave
my "focused" buffer without messing with the plugin state.
So with this plugin, even if I close, delete or change manually my current buffer,
the plugin will still be able to put the buffer I want in focus mode without errors.

## Installation

Using `lazy` you can add this to your plugin spec table:

```lua
{
    "SamuelLorrain/focus.nvim",
    config = true
}
```

Or, to disable default keymap

```lua
{
    "SamuelLorrain/focus.nvim",
    config = function()
        require('focus').setup({
            default_key_binding = false
        })
    end
}
```

## Usage

To toggle focus mode, just type

```vim
:ToggleFocusMode
```

or use the default keymap

```vim
<leader>z
```

## Inspirations

- [True-zen.nvim](https://github.com/pocco81/true-zen.nvim)
- [zen-mode.nvim](https://github.com/folke/zen-mode.nvim)
- [Zazen.nvim](https://github.com/Manas140/Zazen.nvim)
