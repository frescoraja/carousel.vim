# FrescoRaja Themes for [Vim](http://www.vim.org)

A vim/neovim plugin wrapper that allows users to dynamically control several of Vim's visual elements and behavior:
cursor, textwidth and cursorcolumn, font, background, and colorscheme.

---

## Table of Contents

1. [Installation](#installation)
2. [Loading Custom Themes](#loading-customized-themes)
3. [Theme/Colorscheme Switching](#themescolorschemes-switching)
4. [Background Toggling](#toggle-background-color-and-transparency)
5. [Colorcolumn Toggling](#toggle-colorcolumntextwidth)
6. [Colorize/Italicize](#colorizeitalicize)
7. [Get Syntax Highlighting](#get-syntax-highlighting)
8. [Cursor Shapes](#custom-cursor-shapes)
9. [Reset Functions](#reset-functions)
10. [Default Key Mappings](#default-key-mappings)
11. [Dependencies](#dependencies)

---

### Loading Customized Themes

Use `CustomizeTheme` to load specific theme of choice. Themes are a complementary colorscheme/vim-airline theme
combination, along with some highlighting tweaks I felt were beneficial or made theming more consistent. For example,
when a new theme is loaded, the background colors used by [ALE](https://github.com/w0rp/ale) are set to complement the
theme's existing background colors. See [dependencies](#dependencies) at the bottom for integrated plugins.

Use `<Plug>CustomizeTheme` to bring up autocompletion menu with available themes to load.

```viml
" define custom mapping:
nmap <F1> <Plug>CustomizeTheme

" Load a specific theme:
nmap <F12> :CustomizeTheme blayu<CR>
```

### Themes/Colorschemes Switching

Use `<Plug>NextTheme` to cycle forwards through available customized themes.

Use `<Plug>PrevTheme` to cycle backwards through available customized themes.

Use `<Plug>NextColorscheme` to cycle forwards through all available colorschemes.

Use `<Plug>PrevColorscheme` to cycle backwards through all available colorschemes.

### Toggle Background Color and Transparency

Use `<Plug>ToggleDark` to toggle Vim `background` option value between *dark* and *light*

Use `<Plug>ToggleBackground` to toggle background color between the colorscheme's defined background and the
background color you have defined for your terminal. (sets `guibg/ctermbg` to *none*, making Vim background transparent)
Works in both gui mode and cterm mode.

### Toggle ColorColumn/Textwidth

Use `<Plug>SetTextwidth` or `SetTextwidth <num>` to set &textwidth value

Use `<Plug>ToggleColumn` or `SetTextwidth!` to toggle the cursorcolumn

As an example, the following mapping would enable you to type `tw=90` + <kbd>Enter</kbd> in normal mode to change the
textwidth to 90.  (It will also move the colorcolumn to 90)

```viml
" Set textwidth
nmap tw= <Plug>SetTextwidth
```

### Colorize/Italicize

***Note*** Your terminal may not support displaying italicized fonts by default. See instructions
[here](https://apple.stackexchange.com/questions/266333/how-to-show-italic-in-vim-in-iterm2) for enabling italics in
iTerm2 and Mac default Terminal. You may also have to add the following lines to your `.vimrc`:

```viml
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"

" OR
set t_ZH=^[[3m
set t_ZR=^[[23m

" OR have plugin enable italics
let g:custom_italics_enabled=1
```

> the `^[` above is an escape sequence you can generate in insert mode by pressing <kbd>CTRL+V</kbd> then <kbd>ESC</kbd>

Use `<Plug>Italicize` or `:Italicize!` to toggle italics mode for Comments and some other predefined syntax groups like
HTML attribute args. You can italicize specific syntax groups by appending them as a comma-separated list to the
command:

`:Italicize! String,Comment`

Use `<Plug>Colorize` or `:ColorizeSyntaxGroup` to apply a color to the syntax group of your choice.

For example, the following mapping would enable you to make the `ColorColumn` syntax group red by typing

<kbd>F1</kbd> *ColorColumn red* <kbd>Enter</kbd>

```viml
nmap <F1> <Plug>Colorize
```

when `termguicolor` is enabled, you can specify hex code colors ie `#FF0000` (the `#` is optional when typing command)

You can toggle italics for any syntax group you'd like. Just use the `Italicize!` method followed by the syntax
group you want to toggle italics for. You can specify multiple groups separated by a comma. You can make a mapping if
you like to italicize specific groups frequently, or perhaps set an autocmd to do it for specific filetypes:

```viml
" Shift+F1 to toggle italics for comments, html attributes, WildMenu
nmap <S-F1> <Plug>Italicize
" Shift+F2 to toggle italics for String, Statement, Identifier
nmap <S-F2> :Italicize! String,Statement,Identifier<CR>

" Automatically italicize keywords when opening javascript files
autocmd FileType javascript* Italicize! Identifier
```

### Get Syntax Highlighting

`<Plug>GetSyntax` This is useful for customizing themes and defining your own syntax highlighting colors. Will print
a statement in command line showing all the highlighting groups that apply to the word under the cursor, ie

`<current word> => vimStatement, Statement`

### Custom Cursor Shapes

Set `g:custom_cursors_enabled` to apply the following cursors:

- block in normal mode - ( `█` )
- vertical line in insert mode (appears between characters so it's easier to see precisely where characters will be
    inserted) - ( `▎` )
- underline in replace mode ( `_` )

```viml
" enable custom cursors
let g:custom_cursors_enabled=1
```

### Reset functions

Use `<Plug>DefaultTheme` to reset custom theme to the default defined in `g:custom_themes_name`

Use `<Plug>Refreshtheme` to reload current custom theme

**Note** if you add a new colorscheme while vim is loaded, or if for some reason the list of available
themes/colorschemes is empty, you can refresh the cache:

Use `<Plug>ReloadColorschemes` to reload all available colorschemes (or type `:ReloadColorschemes`)

Use `<Plug>ReloadThemes` to reload all customized themes (or type `:ReloadThemes`)

---

## Installation

I use and highly recommend [vim-plug](https://github.com/junegunn/vim-plug), in which case you would add something like
this to your `.vimrc`:

```viml
call plug#begin('/your-plugin-path')

Plug 'frescoraja/frescoraja-vim-themes'

call plug#end()
```

Then, just type `:PlugInstall` from within Vim, or `vim -c PlugInstall` from the command line.

Alternatively, this repo can be cloned to a your plugin manager's defined location (like for
[pathogen](https://github.com/tpope/vim-pathogen))

```shell
git clone https://github.com/frescoraja/frescoraja-vim-themes ~/.vim/bundle
```

To initialize theming functionality, set a global trigger in vimrc:

```viml
let g:custom_themes_enabled=1

" set a default theme to load on startup:
let g:custom_themes_name='default'

" set a random theme to load on startup:
let g:custom_themes_name='random'

" allow default key mappings
let g:custom_themes_mappings_enabled=1
```

Or, you can just call the initializer directly if you don't want any theming applied by default, but want the plugin
functions available:

```viml
" this line would go after plugins loaded, ie after `call plug#end()` if using vim-plug
call frescoraja#init()
```

## Default Key Mappings

If `g:custom_themes_mappings_enabled` is set to `1`, the following keyboard shortcuts will work automatically (if they
are not already mapped in your `.vimrc` or by other plugins loaded before this one. Vim will emit a warning if this
plugin tries to override any existing key mappings, and any mappings defined after plugin is loaded will override
mappings defined by plugin):

<kbd>F5</kbd> to select a custom theme from menu

<kbd>Shift</kbd> + <kbd>F5</kbd> to select a random custom theme

<kbd>F7</kbd> to cycle backwards through customized theme list

<kbd>F9</kbd> to cycle forwards through customized theme list

<kbd>Shift+F7</kbd> to cycle backwards through colorschemes

<kbd>Shift+F9</kbd> to cycle forwards through colorschemes

## Dependencies

This is the current list of plugins/colorschemes that frescoraja-vim-themes supports (They are not required)

### Plugins

- [Vim-Airline](https://github.com/bling/vim-airline) / [Vim-Airline-Themes](https://github.com/vim-airline/vim-airline-themes)
- [Vim Better Whitespace](https://github.com/ntpeters/vim-better-whitespace)
- [CoC](https://github.com/neoclide/coc.nvim)
- [Ale](https://github.com/w0rp/ale)

### Colorschemes

- [afterglow](https://github.com/danilo-augusto/vim-afterglow)
- [allomancer](https://github.com/Nequo/vim-allomancer)
- [ayu](https://github.com/ayu-theme/ayu-vim)
- [blayu](https://github.com/tjammer/blayu)
- [ceudah](https://github.com/emhaye/ceudah.vim)
- [chito](https://github.com/Jimeno0/vim-chito)
- [colorsbox](https://github.com/mkarmona/colorsbox)
- [deep-space](https://github.com/tyrannicaltoucan/vim-deep-space)
- [default](https://github.com/vim/vim/blob/master/runtime/colors/default.vim)
- [deus](https://github.com/ajmwagar/vim-deus)
- [distill](https://github.com/deathlyfrantic/vim-distill)
- [edar/elit](https://github.com/DrXVII/vim_colors)
- [gotham](https://github.com/whatyouhide/vim-gotham)
- [gruvbox](https://github.com/morhetz/gruvbox)
- [hybrid-material](https://github.com/kristijanhusak/vim-hybrid-material)
- [iceberg](https://github.com/cocopon/iceberg.vim)
- [kafka/dark](https://github.com/Konstruktionist/vim)
- [kuroi](https://github.com/aonemd/kuroi.vim)
- [mango](https://github.com/goatslacker/mango.vim)
- [material-monokai](http://github.com/skielbasa/vim-material-monokai)
- [material-theme](https://github.com/jdkanani/vim-material-theme)
- [material](https://github.com/jscappini/material.vim)
- [maui](https://github.com/zsoltf/vim-maui)
- [maui-airline](https://github.com/zsoltf/vim-maui-airline)
- [molokai](https://github.com/tomasr/molokai)
- [neodark](https://github.com/KeitaNakamura/neodark.vim)
- [oceanic-next](https://github.com/mhartington/oceanic-next)
- [onedark](https://github.com/joshdick/onedark.vim)
- [onedarkafterglow](https://github.com/MrGuiMan/onedark-afterglow.vim)
- [pink-moon](https://github.com/sts10/vim-pink-moon)
- [quantum](https://github.com/tyrannicaltoucan/vim-quantum)
- [seabird](https://github.com/nightsense/seabird)
- [spring-night](https://github.com/rhysd/vim-color-spring-night)
- [srcery](https://github.com/srcery-colors/srcery-vim)
- [tender](https://github.com/jacoborus/tender.vim)
- [thaumaturge](https://github.com/baines/vim-colorscheme-thaumaturge)
- [tokyo-metro](https://github.com/koirand/tokyo-metro.vim)
- [Tomorrow-Night](https://github.com/Ardakilic/vim-tomorrow-night-theme)
- [one](https://github.com/rakr/vim-one)
- [two-firewatch](https://github.com/rakr/vim-two-firewatch)
- [yowish](https://github.com/KabbAmine/yowish.vim)
- [vim-material](https://github.com/hzchirs/vim-material)
- The following colorschemes from [vim-colorschemes](https://github.com/flazz/vim-colorschemes)
  - jellybeans
  - busybee
  - flatcolor
  - znake

My appreciation goes to all the maintainers of above plugins/themes for their attention to aesthetics and detail.

---
