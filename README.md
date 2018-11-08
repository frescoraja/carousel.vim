# FrescoRaja Themes for [Vim](http://www.vim.org)

*work-in-progress*

A vim plugin wrapper that allows users to dynamically control several of Vim's visual elements and behavior: cursor,
textwidth and cursorcolumn, font, background, and colorscheme.

> **Note:** This is for my own educational use, if you want to try it go ahead but at your own risk.. It is my first
> time attempting to create a Vim plugin and I take no responsibility for any consequences of its use on your system.

## Functionality

### Loading Customized Themes

Use `CustomizeTheme` to load specific theme of choice. Themes are a complementary colorscheme/vim-airline theme
combination, along with some highlighting tweaks I felt were beneficial or made theming more consistent. For example,
when a new theme is loaded, the background colors used by [GitGutter](https://github.com/airblade/vim-gitgutter) and
[ALE](https://github.com/w0rp/ale) are set to complement the theme's existing background colors. See
[dependencies](#dependencies) at the bottom for integrated plugins.

Use `<Plug>(customize_theme)` to bring up autocompletion menu with available themes to load.

<kbd>Ctrl</kbd>+<kbd>Space</kbd> is built into the plugin to call `<Plug>(customize_theme)` (if it hasn't already been
defined)

```viml
" define custom mapping:
nmap <F1> <Plug>(customize_theme)

" Load a specific theme:
nmap <F12> :CustomizeTheme blayu<CR>
```

### Cycle Custom Themes (..or all the available colorschemes)

Use `<Plug>(cycle_custom_themes_next)` to cycle forwards through available customized themes.

Use `<Plug>(cycle_custom_thems_prev)` to cycle backwards through available customized themes.

Use `<Plug>(cycle_colorschemes_next)` to cycle forwards through all available colorschemes.

Use `<Plug>(cycle_colorschemes_prev)` to cycle backwards through all available colorschemes.

The following mappings are built into the plugin (if they were not already defined)

<kbd>F7</kbd> to cycle backwards through customized theme list

<kbd>F9</kbd> to cycle forwards through customized theme list

<kbd>Shift+F7</kbd> to cycle backwards through colorschemes

<kbd>Shift+F9</kbd> to cycle forwards through colorschemes

**Note** if you add a new colorscheme while vim is loaded, or if for some reason the list of available
themes/colorschemes is empty, you can refresh the cache.

Use `<Plug>(refresh_colorschemes)` to reload all available colorschemes (or type `:RefreshColorschemes`)

Use `<Plug>(refresh_custom_themes)` to reload all customized themes (or type `:RefreshCustomThemes`)

### Toggle Background Color and Transparency

Use `<Plug>(toggle_dark)` to toggle Vim `background` option value between *dark* and *light*

Use `<Plug>(toggle_background)` to toggle background color between the colorscheme's defined background and the
background color you have defined for your terminal. (sets `guibg/ctermbg` to *none*, making Vim background transparent)
Works in both gui mode and cterm mode.

### Toggle ColorColumn / Textwidth

Use `<Plug>(set_textwidth)` to set &textwidth value

Use `<Plug>(toggle_column)` to toggle the display of a highlighted cursorcolumn at `&textwidth` value

As an example, the following mapping would enable you to type ***tw=90<Enter>*** in normal mode to change the textwidth
to 90.  (It will also automatically move the colorcolumn to 90 as well)

```viml
" Set textwidth
nmap tw= <Plug>(set_textwidth)
```

### Colorize/Italicize Comments, Colorize ColorColumn

Use `<Plug>(italicize)` to toggle italics mode for Comments and some other predefined syntax groups like HTML attribute
args.

Use `<Plug>(set_comments_color)` to colorize Comments.

Use `<Plug>(set_column_color)` to colorize ColumnColor.

For example, the following mapping would enable you to type ***<Leader>cwhite<Enter>*** to change comments to white in
cterm or
gui mode. (If providing a hex color value like #fafafa, surround with quotes when typing command and , ie
<Leader>c'#fafafa'<Enter> - the '#' is optional)

```viml
nmap <Leader>c <Plug>(set_comments_color)
```

You can toggle italics for any syntax group you'd like. Just use the `Italicize!` method followed by the syntax
group you want to toggle italics for. You can specify multiple groups separated by a comma. You can make a mapping if
you like to italicize specific groups frequently, or perhaps set and autocmd to do it for specific filetypes:

```viml
" Shift+F1 to toggle italics for comments, html attributes, WildMenu
nmap <S-F1> <Plug>(italicize)
" Shift+F2 to toggle italics for String, Statement, Identifier
nmap <S-F2> :Italicize! String,Statement,Identifier<CR>

" Automatically italicize keywords when opening javascript files
autocmd FileType javascript* Italicize! Identifier
```

### Get Syntax Highlighting group for term under cursor

`<Plug>(get_syntax)` This is useful for customizing themes and defining my own syntax highlighting colors. Will print
a statement in command line showing the highlight group name of the word under the cursor and which highlight group it
might be linked with, ie `vimCommand => Statement`

### Custom cursor shapes

Use ***g:custom_cursors_enabled*** to set the following cursors:

  - block in normal mode
  - vertical line in insert mode (appears between characters so it's easier to see precisely where characters will be 
      inserted
  - underline in replace mode

```viml
" enable custom cursors
let g:custom_cursors_enabled=1
```

### Reset functions

Use the following globals to define custom default colors used by theme:
  - `g:default_comments_color_c` -> define comment color in cterm mode (0-255), defaults to 59 (grey)
  - `g:default_comments_color_g` -> define comment color in gui mode (hex RGB), defaults to #658494 (blue-grey)
  - `g:default_column_color_c` -> define column color in cterm mode, defaults to 236 (dark grey)
  - `g:default_column_color_g` -> define column color in gui mode, defaults to #2a2a2a (dark grey)
  - `g:default_textwidth` -> define textwidth, defaults to &texwidth
  - `g:default_airline_theme` -> define airline theme, default to g:airline_theme
  - `g:custom_themes_name` -> define custom theme to use, defaults to 'default'

Use `<Plug>(reset_theme)` to reset custom theme to default

Use `<Plug>(refresh_theme)` to reapply current custom theme

Use `<Plug>(reset_texwidth)` to reset textwidth to default

Use `<Plug>(reset_comments_color)` to reset comments color to default

Use `<Plug>(reset_column_color)` to reset columncolor to default

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

To enable plugin functionality, set a global trigger in vimrc:

```viml
let g:custom_themes_enabled=1

" set a default theme to load on startup:
let g:custom_themes_name='blayu'
```

Or, you can just call the initializer directly if you don't want any theming applied by default, but want the plugin
functions available:

```viml
" this line would go after plugins loaded, ie after `call plug#end()` if using vim-plug
call frescoraja#init()
```

## Dependencies

This is the current list of plugins that frescoraja-vim-themes integrates. They are not required.

### Plugins

* #### [Vim-Airline](https://github.com/bling/vim-airline) / [Vim-Airline-Themes](https://github.com/vim-airline/vim-airline-themes)

* #### [Vim Better Whitespace](https://github.com/ntpeters/vim-better-whitespace)

* #### [GitGutter](https://github.com/airblade/vim-gitgutter)

* #### Colorschemes
    - [ayu](https://github.com/ayu-theme/ayu-vim)
    - [gruvbox](https://github.com/morhetz/gruvbox)
    - [oceanic-next](https://github.com/mhartington/oceanic-next)
    - [onedark](https://github.com/joshdick/onedark.vim)
    - [maui](https://github.com/zsoltf/vim-maui)
    - [kafka/dark](https://github.com/Konstruktionist/vim)
    - [distill](https://github.com/deathlyfrantic/vim-distill)
    - [vim-material](https://github.com/hzchirs/vim-material)
    - [material](https://github.com/jscappini/material.vim)
    - [hybrid-material](https://github.com/kristijanhusak/vim-hybrid-material)
    - [neodark](https://github.com/KeitaNakamura/neodark.vim)
    - [quantum](https://github.com/tyrannicaltoucan/vim-quantum)
    - [molokai](https://github.com/tomasr/molokai)
    - [dracula](https://github.com/dracula/vim)
    - [blayu](https://github.com/tjammer/blayu)
    - [edar/elit](https://github.com/DrXVII/vim_colors)
    - [thaumaturge](https://github.com/baines/vim-colorscheme-thaumaturge)
    - [deus](https://github.com/ajmwagar/vim-deus)
    - [spring-night](https://github.com/rhysd/vim-color-spring-night)
    - [afterglow](https://github.com/danilo-augusto/vim-afterglow)
    - [gotham](https://github.com/whatyouhide/vim-gotham)
    - [material-theme](https://github.com/jdkanani/vim-material-theme)
    - [ceudah](https://github.com/emhaye/ceudah.vim)
    - [srcery](https://github.com/srcery-colors/srcery-vim)
    - [colorsbox](https://github.com/mkarmona/colorsbox)
    - [material-monokai](http://github.com/skielbasa/vim-material-monokai)
    - [tender](https://github.com/jacoborus/tender.vim)
    - [iceberg](https://github.com/cocopon/iceberg.vim)
    - [pink-moon](https://github.com/sts10/vim-pink-moon)
    - The following colorschemes from [vim-colorschemes](https://github.com/flazz/vim-colorschemes)
        - jellybeans
        - herokudoc-gvim
        - busybee
        - flatcolor
        - znake

My appreciation goes to all the maintainers of above plugins/themes for their attention to aesthetics and detail.

---
