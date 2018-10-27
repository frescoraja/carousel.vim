**This is currently a work-in-progress**

# FrescoRaja Themes for [Vim](http://www.vim.org)

> A vim plugin wrapper for conveniently customizing vim theming.
> **Note:** This is for my own personal use, if you want to try it go ahead but at your own risk..


## Installation

I use [vim-plug](https://github.com/junegunn/vim-plug), in which case you would add something like this to your 
`.vimrc`:

```viml
call plug#begin(/your-plugin-path)

Plug 'frescoraja/frescoraja-vim-themes'

call plug#end()
```

Alternatively this repo can be cloned to a different plugin manager's location:

```shell
git clone https://github.com/frescoraja/frescoraja-vim-themes ~/.vim/bundle
```

## Usage

To enable plugin functionality, set a global trigger in vimrc or call the initializer function directly:


```viml

call frescoraja#init()

" OR

let g:custom_theme_enabled=1

" to set a default theme to load on startup:
let g:custom_theme_name='blayu'

```
#### Mapping
If <Nul> (Control + Space) hasn't been mapped, it gets mapped to call CustomizeTheme which will list the available 
themes to load. It can be triggered by a custom mapping, ie:
```viml
nmap <Leader>T <Plug>(customize_theme)
```

 
## Dependencies

> This is my current rotation of favorite themes, 

* #### VimAirline / VimAirline Themes

    - [vim-airline](https://github.com/bling/vim-airline)
    - [vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)

* #### ColorSchemes

    - [gruvbox](https://github.com/morhetz/gruvbox)
    - [oceanic-next](https://github.com/mhartington/oceanic-next)
    - [onedark](https://github.com/joshdick/onedark.vim)
    - [maui](https://github.com/zsoltf/vim-maui)
    - [kafka/dark](https://github.com/Konstruktionist/vim)
    - [distill](https://github.com/deathlyfrantic/vim-distill)
    - [base](https://github.com/bounceme/base.vim)
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
    - The following colorschemes from [vim-colorschemes](https://github.com/flazz/vim-colorschemes)
        - CandyPaper
        - jellybeans
        - herokudoc-gvim
        - busybee
        - flatcolor
        - iceberg
        - znake
        - orange-moon/pink-moon/yellow-moon

My appreciation goes to all the maintainers of above plugins/themes for their attention to aesthetics and detail.

---

[frescoraja-vim-themes](https://github.com/frescoraja/frescoraja-vim-themes)
