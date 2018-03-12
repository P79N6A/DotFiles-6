# DotFiles

**Only support OSX**

Install [vim plug](https://github.com/junegunn/vim-plug)

```Bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

For [deplete-clang](https://github.com/zchee/deoplete-clang) support, neovim/python-client and clang are needed:

```Bash
pip3 install --upgrade neovim
brew install clang
```

For C++ code formatting support, clang-format is needed:

```Bash
brew install clang-format
```

