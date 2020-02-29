# vim-checktestdata

This plugin provides contextual syntax highlighting for [DOMjudge checktestdata](https://www.domjudge.org/checktestdata) format specifications in Vim.
By default, checktestdata specifications are assumed to have the file extension `.ctd`.

# Installation

`vim-checktestdata` should be installed via your preferred package manager as follows:

| Package manager | `.vimrc` command |
|:----------------|:-----------------|
| [vim-plug](https://github.com/junegunn/vim-plug) | `Plug 'Andrew-William-Smith/vim-checktestdata'` |
| [vim-pathogen](https://github.com/tpope/vim-pathogen) | `git clone https://github.com/Andrew-William-Smith/vim-checktestdata.git ~/.vim/bundle/vim-checktestdata` |
| [Vundle.vim](https://github.com/VundleVim/Vundle.vim) | `Plugin 'Andrew-William-Smith/vim-checktestdata'` |
| [neobundle.vim](https://github.com/Shougo/neobundle.vim) | `NeoBundle 'Andrew-William-Smith/vim-checktestdata'` |

# Features
## Contextual syntax highlighting

`vim-checktestdata` provides full contextual syntax highlighting for checktestdata specifications, meaning that only valid tokens will be highlighted.
Tokens that are invalid at a position will not be assigned the proper colour, indicating a likely syntax error.

![](https://raw.githubusercontent.com/Andrew-William-Smith/vim-checktestdata/master/screenshots/syntax-correct.png)

## Block error checking

This plugin also provides limited error checking for block delimiters, highlighting errant closing parentheses and `END` statements for easy visibility.

![](https://raw.githubusercontent.com/Andrew-William-Smith/vim-checktestdata/master/screenshots/syntax-errors.png)
