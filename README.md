# gutenhasktags

[![Build Status](https://travis-ci.org/rob-b/gutenhasktags.png)](https://travis-ci.org/githubuser/gutenhasktags)

Simple wrapper around [hasktags](https://hackage.haskell.org/package/hasktags) to allow it to work with [vim-gutentags](https://github.com/ludovicchabant/vim-gutentags)

## Usage

Install gutenhasktags then add the following to your vimrc

    let g:gutentags_project_info = [ {'type': 'python', 'file': 'setup.py'},
                                   \ {'type': 'ruby', 'file': 'Gemfile'},
                                   \ {'type': 'haskell', 'file': 'Setup.hs'} ]
    let g:gutentags_ctags_executable_haskell = 'gutenhasktags'
