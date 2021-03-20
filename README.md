# Carousel for [Vim](http://www.vim.org)/[NeoVim](https://neovim.io)

Carousel is a theme-switcher that allows you to easily load and cycle through your `colorschemes`

It is also provides an interface to dynamically control several of Vim's visual elements and behavior:
background, cursor, textwidth and cursorcolumn, and text styles.

---

## Table of Contents

1. [Installation](#installation)
2. [Loading Themes](#loading-themes)
3. [Theme/Colorscheme Switching](#themescolorschemes-switching)
4. [Background Toggling](#toggle-background-color-and-transparency)
5. [Colorcolumn Toggling](#toggle-colorcolumntextwidth)
6. [Colorize/Italicize](#colorizeitalicize)
7. [Get Syntax Highlighting](#get-syntax-highlighting)
8. [Cursor Shapes](#custom-cursor-shapes)
9. [Reset Functions](#reset-functions)
10. [Default Key Mappings](#default-key-mappings)
11. [Dependencies/Integrations](#integrations)

---

## Installation

For [vim-plug](https://github.com/junegunn/vim-plug) users, add the following to your `.vimrc` or `init.vim`:

```viml
Plug 'frescoraja/carousel.vim'
```

Then exit Vim and execute `vim +PlugInstall` from the command line, or restart Vim and run `:PlugInstall`.

***To enable theming functionality, the following global variable must be set:***

```viml
let g:carousel_enabled = 1
```

To set a default theme to load on startup:

```viml
let g:carousel_theme_name='default'
```

For example, to set [`apprentice`](https://github.com/romainl/Apprentice) theme to load on startup in `diff` mode, with
`random` theme otherwise:

```viml
if &diff
    let g:carousel_theme_name='apprentice'
else
    let g:carousel_theme_name='random'
endif
```

To use [default key mappings](#default-key-mappings):

```viml
let g:carousel_mappings_enabled=1
```

## Plugin Commands Usage

### Loading Themes

Use `Carousel` to load specific theme of choice. Themes are a complementary colorscheme/vim-airline theme
combination, along with some highlighting tweaks I felt were beneficial or made theming more consistent. For example,
when a new theme is loaded, the background colors used by [ALE](https://github.com/w0rp/ale) are set to complement the
theme's existing background colors. See [dependencies](#dependencies) at the bottom for integrated plugins.

Use `<Plug>Carousel` to bring up autocompletion menu with available themes to load.

```viml
" define custom mapping:
nmap <F1> <Plug>Carousel

" Load a specific theme:
nmap <F12> :Carousel blayu<CR>
```

### Themes/Colorschemes Switching

Use `<Plug>CarouselNext` to cycle forwards through theme carousel.

Use `<Plug>CarouselPrev` to cycle backwards through theme carousel.

Use `<Plug>ColorschemeNext` to cycle forwards through colorschemes.

Use `<Plug>ColorschemePrev` to cycle backwards through colorschemes.

### Toggle Background Color and Transparency

Use `<Plug>ToggleDark` to toggle Vim `background` option value between *dark* and *light*

Use `<Plug>ToggleBackground` to toggle background color between the colorscheme's defined background and the
background color you have defined for your terminal. (sets `guibg/ctermbg` to *None*, making Vim background transparent)
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
let g:carousel_italics_enabled=1
```

> the `^[` above is an escape sequence you can generate in insert mode by pressing <kbd>CTRL</kbd> + <kbd>V</kbd> then
> <kbd>ESC</kbd>

Use `<Plug>ToggleItalics` to toggle italics mode for Comments and some other predefined syntax groups like
HTML attribute args. You can italicize specific syntax groups by appending them as a comma-separated list to the
`<Plug>Italicize` or `:Italicize` command:

`:Italicize String,Comment`

Use `<Plug>Colorize` or `:ColorizeSyntaxGroup` to apply a color to the syntax group of your choice.

For example, the following mapping would enable you to make the `ColorColumn` syntax group red by typing <kbd>F1</kbd>:

```viml
nmap <F1> <Plug>Colorize ColorColumn red<CR>
```

when `termguicolor` is enabled, you can specify hex code colors ie `#FF0000` (the `#` is optional when typing command)

You can toggle italics for any syntax group you'd like. Just use the `Italicize!` method followed by the highlight
group you want to toggle italics for. You can specify multiple groups separated by a comma. You can make a mapping if
you like to italicize specific groups frequently, or perhaps set an autocmd to do it for specific filetypes:

```viml
" Shift+F1 to toggle italics for comments, html attributes, WildMenu
nmap <S-F1> <Plug>ToggleItalics
" Shift+F2 to toggle italics for String, Statement, Identifier
nmap <S-F2> <Plug>Italicize String,Statement,Identifier<CR>

" Automatically italicize Identifier keywords when opening javascript files
autocmd FileType javascript* Italicize! Identifier
```

### Get Syntax Highlighting

`<Plug>GetSyntax` This is useful for customizing themes and defining your own syntax highlighting colors. Will print
a statement in command line showing all the highlighting groups that apply to the word under the cursor, ie

`<current word> => vimStatement, Statement`

### Custom Cursor Shapes

Set `g:carousel_cursors_enabled` to apply the following cursors:

- block in normal mode - ( `█` )
- vertical line in insert mode (appears between characters so it's easier to see precisely where characters will be
    inserted) - ( `▎` )
- underline in replace mode ( `_` )

```viml
" enable custom cursors
let g:custom_cursors_enabled=1
```

### Reset functions

Use `<Plug>CarouseDefault` to reset custom theme to the default defined in `g:carousel_theme_name`

Use `<Plug>CarouseRefresh` to reload current custom theme

**Note** if you add a new colorscheme while vim is loaded, or if for some reason the list of available
themes/colorschemes is empty, you can refresh the cache:

Use `<Plug>ColorschemesReload` to reload all available colorschemes (or type `:ColorschemesReload`)

Use `<Plug>CarouselReload` to reload all carousel themes (or type `:CarouselReload`)

---

## Default Key Mappings

If `g:carousel_mappings_enabled` is set to `1`, the following keyboard shortcuts will work automatically (if they
are not already mapped in your `.vimrc` or by other plugins loaded before this one. Vim will emit a warning if this
plugin tries to override any existing key mappings, and any mappings defined after plugin is loaded will override
mappings defined by this plugin):

<kbd>F5</kbd> to select a custom theme from menu/floating window using [`clap`](#plugins) provider

<kbd>Shift</kbd> + <kbd>F5</kbd> to select a random carousel theme

<kbd>F7</kbd> to cycle backwards through carousel themes

<kbd>F9</kbd> to cycle forwards through carousel themes

<kbd>Shift</kbd> + <kbd>F7</kbd> to cycle backwards through colorschemes

<kbd>Shift</kbd> + <kbd>F9</kbd> to cycle forwards through colorschemes

## Integrations

Here is a list of plugins and colorschemes that `carousel.vim` supports (They are not required)

### Plugins

- [Ale](https://github.com/w0rp/ale)
  - ALE Warning, Error, and Info message highlights are customized
  - (can be disabled by adding `let g:carousel_ale_highlights = 0` to `vimrc`
- [CoC](https://github.com/neoclide/coc.nvim)
  - CoC Warning, Error, Info message as well as GitGutter highlights are customized
  - (can be disabled by adding `let g:carousel_coc_highlights = 0` to `vimrc`
- [Vim-Airline](https://github.com/bling/vim-airline) / [Vim-Airline-Themes](https://github.com/vim-airline/vim-airline-themes)
  - Vim-Airline automatically selects airline_theme based on colorscheme, this plugin makes some customizations
  - (can be disabled by adding `let g:carousel_airline_highlights = 0` to `vimrc`
- [Vim Better Whitespace](https://github.com/ntpeters/vim-better-whitespace)
  - Vim-Better-Whitespace ExtraWhitespace highlight is underlined in red
  - (can be disabled by adding `let g:carousel_extra_whitespace_highlights = 0` to `vimrc`
- [Vim Clap](https://github.com/liuchengxu/vim-clap)
  - Vim Clap integration enabled by default if installed, defining a `g:clap_provider_themes` provider which will list
    all carousel themes in a floating window via command `:Clap themes`
  - <kbd>F5</kbd> will be mapped to `:Clap themes` command when `g:carousel_mappings_enabled=1`
  - (can be disabled by adding `let g:carousel_clap_provider_enabled = 0` to `vimrc`

### Colorschemes

- [afterglow](https://github.com/danilo-augusto/vim-afterglow)
- [allomancer](https://github.com/Nequo/vim-allomancer)
- [apprentice](https://github.com/romainl/Apprentice)
- [ayu](https://github.com/ayu-theme/ayu-vim)
- [blayu](https://github.com/tjammer/blayu)
- [candid](https://github.com/flrnprz/candid.vim)
- [ceudah](https://github.com/emhaye/ceudah.vim)
- [challenger_deep](https://github.com/challenger-deep-theme/vim)
- [chito](https://github.com/Jimeno0/vim-chito)
- [colorsbox](https://github.com/mkarmona/colorsbox)
- [deep-space](https://github.com/tyrannicaltoucan/vim-deep-space)
- [default](https://github.com/vim/vim/blob/master/runtime/colors/default.vim)
- [deus](https://github.com/ajmwagar/vim-deus)
- [distill](https://github.com/deathlyfrantic/vim-distill)
- [edar/elit](https://github.com/DrXVII/vim_colors)
- [edge](https://github.com/sainnhe/edge)
- [everforest](https://github.com/sainnhe/everforest)
- [gotham](https://github.com/whatyouhide/vim-gotham)
- [gruvbox](https://github.com/morhetz/gruvbox)
- [gruvbox8](https://github.com/lifepillar/vim-gruvbox8)
- [gruvbox-material](https://github.com/sainnhe/gruvbox-material)
- [gummybears](https://github.com/vim-scripts/GummyBears)
- [hybrid-material](https://github.com/kristijanhusak/vim-hybrid-material)
- [iceberg](https://github.com/cocopon/iceberg.vim)
- [jellybeans](https://github.com/nanotech/jellybeans.vim)
- [kafka/dark](https://github.com/Konstruktionist/vim)
- [kuroi](https://github.com/aonemd/kuroi.vim)
- [mango](https://github.com/goatslacker/mango.vim)
- [material-monokai](http://github.com/skielbasa/vim-material-monokai)
- [material-theme](https://github.com/jdkanani/vim-material-theme)
- [material](https://github.com/jscappini/material.vim)
- [maui](https://github.com/zsoltf/vim-maui)
- [maui-airline](https://github.com/zsoltf/vim-maui-airline)
- [miramare](https://github.com/franbach/miramare)
- [molokai](https://github.com/tomasr/molokai)
- [neodark](https://github.com/KeitaNakamura/neodark.vim)
- [nightowl](https://github.com/haishanh/night-owl.vim)
- [nord](https://github.com/arcticicestudio/nord-vim)
- [oceanic-next](https://github.com/mhartington/oceanic-next)
- [onedark](https://github.com/joshdick/onedark.vim)
- [onedarkafterglow](https://github.com/MrGuiMan/onedark-afterglow.vim)
- [plastic](https://github.com/flrnprz/plastic.vim)
- [pink-moon](https://github.com/sts10/vim-pink-moon)
- [quantum](https://github.com/tyrannicaltoucan/vim-quantum)
- [seabird](https://github.com/nightsense/seabird)
- [sonokai](https://github.com/sainnhe/sonokai)
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
  - busybee
  - flatcolor
  - znake

My appreciation goes to all the maintainers of above plugins/themes for their attention to aesthetics and detail.

---
