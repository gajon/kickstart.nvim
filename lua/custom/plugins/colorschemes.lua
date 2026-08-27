-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command under that to load whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

do -- Gruvbox Material
  vim.pack.add { 'https://github.com/sainnhe/gruvbox-material' }

  vim.g.gruvbox_material_enable_italic = true
  -- The background contrast used in this color scheme.
  -- Available values: 'hard', 'medium'(default), 'soft'
  vim.g.gruvbox_material_background = 'hard'
  -- The foreground color palette used in this color scheme.
  -- Available values: 'material' (default), 'mix', 'original'
  vim.g.gruvbox_material_foreground = 'material'

  -- An alternative gruvbox is 'ellisonleao/gruvbox.nvim'
end

do -- NeoSolarized
  vim.pack.add { 'https://github.com/overcache/NeoSolarized' }

  -- Default value is "normal", Setting this option to "high" or "low" does use the
  -- same Solarized palette but simply shifts some values up or down in order to
  -- expand or compress the tonal range displayed.
  vim.g.neosolarized_contrast = "normal"

  -- Special characters such as trailing whitespace, tabs, newlines, when displayed
  -- using ":set list" can be set to one of three levels depending on your needs.
  -- Default value is "normal". Provide "high" and "low" options.
  vim.g.neosolarized_visibility = "normal"

  -- I make vertSplitBar a transparent background color. If you like the origin
  -- solarized vertSplitBar style more, set this value to 0.
  vim.g.neosolarized_vertSplitBgTrans = 1

  -- If you wish to enable/disable NeoSolarized from displaying bold, underlined
  -- or italicized" typefaces, simply assign 1 or 0 to the appropriate variable.
  -- Default values:
  vim.g.neosolarized_bold = 1
  vim.g.neosolarized_underline = 1
  vim.g.neosolarized_italic = 1

  -- Used to enable/disable "bold as bright" in Neovim terminal. If colors of bold
  -- text output by commands like `ls` aren't what you expect, you might want to
  -- try disabling this option. Default value:
  vim.g.neosolarized_termBoldAsBright = 1
end

do -- PaperColor
  vim.pack.add { 'https://github.com/NLKNguyen/papercolor-theme' }
  -- let g:PaperColor_Theme_Options = {
  -- \   'theme': {
  -- \     'default': {
  -- \       'transparent_background': 1
  -- \     }
  -- \   }
  -- \ }

  -- Currently available theme options
  --
  -- option                   | value                                          | default
  -- ------                   | ------                                         | -------
  -- `transparent_background` | 1: use terminal background                     | 0: use theme background
  -- `allow_bold`             | 1: use bold for certain text, 0: not at all    | decided by the theme
  -- `allow_italic`           | 1: use italics for certain text, 0: not at all | decided by the theme
  -- `override`               | dictionary of color key-value                  |
end

do -- tokyonight
  vim.pack.add { 'https://github.com/folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = true }, -- Enable italics in comments
    },
  }
  -- Like many other themes, this one has different styles, and you could load
  -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  -- 'tokyonight-moon'
end

-- gruvbox-material
-- NeoSolarized
-- PaperColor
-- tokyonight-day
-- tokyonight-moon
-- tokyonight-night
-- tokyonight-storm
vim.opt.background = 'dark'
vim.cmd.colorscheme 'tokyonight-moon'
