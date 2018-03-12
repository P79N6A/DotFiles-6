# vimrc

这是我的 Vim 配置文件，为 Haskell 以及 Rust 开发进行了优化，将 `.vimrc` 和 `.ctags` 文件放在 `~` 目录下即可。

## 插件管理

本配置文件使用 [vim-plug](https://github.com/junegunn/vim-plug) 进行插件管理，需要先行安装。为了配置文件的可移植性，我将 Windows 下的配置路径也设置为了 `~/.vim`，所以 vim-plug 官网的配置不适用于本配置文件（如果是 Mac 或 Linux 则依然适用）。如果是在 Windows 下使用本配置文件，需要在 Powershell 中输入如下命令：

```powershell
md ~\.vim\autoload
$uri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
(New-Object Net.WebClient).DownloadFile($uri, $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath("~\.vim\autoload\plug.vim"))
```

如果是在 Mac 或者 Linux 下，就可以直接按照 vim-plug 官网的命令进行配置：

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

运行上述命令后，启动 vim，在 normal 模式下按 `:`，输入 `PlugInstall` 然后回车等待插件安装完成。

注意，由于 vim-plug 依赖于 git，所以必须要能够在命令行中使用 `git` 的情况下才可以使用。

安装完插件后，还需要对一个特殊插件进行配置。配置中使用到 [vimproc](https://github.com/Shougo/vimproc.vim) 这个插件，所以需要编译，如果在 Mac 或 Linux 下，只需要支持 `make` 命令即可，vim-plug 会自动将其编译，但在 Windows 下较为麻烦，建议使用官方编译好的版本，根据 Vim 的版本在 [这里](https://github.com/Shougo/vimproc.vim/releases) 选择对应的二进制文件下载，下载后放入 `~/.vim/plugged/vimproc.vim/lib` 目录下。如果在 Mac 或 Linux 下出现编译失败的情况，需要自行进入 `~/.vim/plugged/vimproc.vim` 目录下调用 `make`。

另外，[Tagbar](https://github.com/majutsushi/tagbar) 插件依赖于 [ctags](http://ctags.sourceforge.net/)，如果没有下载需要先下载并将其目录加入 `PATH`。

## 插件相关

本配置文件带有一些插件，具体可以在配置文件的 `Plugin manager` 一项中查看。

需要注意的是，由于使用了 [neocomplete](https://github.com/Shougo/neocomplete.vim) 进行自动补全，所以必须安装支持 lua 版本的 Vim（官网下载的默认版本不支持）。所以需要到 [neocomplete](https://github.com/Shougo/neocomplete.vim) 的主页根据平台选择合适的方式进行安装。

## 额外快捷键

除了插件默认的快捷键之外，这里还添加了一些快捷键方便使用。Vim 的默认 `leader` 键 和 `localleader` 键都是 `\ `，这里将 `leader` 映射为 `,`，将 `localleader` 映射为空格以方便使用。

### 通用

| **按键**         | **功能**                   | **助记**                         |
|------------------|----------------------------|----------------------------------|
| `<leader>nt`     | 在 NerdTree 中找到当前文件 | **N**erd**T**ree                 |
| `<leader>nT`     | 仅打开 NerdTree            | **N**erd**T**ree                 |
| `<leader>tt`     | 开关 TagBar                | **T**agBar                       |
| `<leader>ut`     | 开关 Undotree              | **U**ndo**T**ree                 |
| `<Ctrl-p>`       | 激活 CtrlP                 | Ctrl**P**                        |
| `<Ctrl-k>`       | 激活 CtrlPFunky            | CtrlPFun**ky**                   |
| `<leader>b`      | 打开缓冲区列表             | open **b**uffer list             |
| `<leader>r`      | 打开最近常用文件列表       | open **r**ecent file list        |
| `<leader>a`      | 激活 EasyAlign             | Easy**A**lign                    |
| `<leader>f`      | 快速移动到指定字母         | **f**ind char                    |
| `<leader>w`      | 快速移动到指定单词         | jump to **w**ord                 |
| `<localleader>p` | 从系统剪贴板粘贴           | same as default Vim key bindings |
| `<localleader>y` | 复制到系统剪贴板           | same as default Vim key bindings |
| `<localleader>d` | 剪切到系统剪贴板           | same as default Vim key bindings |
| `<leader>ev`     | 编辑 vimrc 配置文件        | **e**dit **v**imrc               |
| `<leader>sv`     | 重新载入 vimrc 配置文件    | **s**ource **v**imrc             |

### Markdown 相关

| **按键**         | **功能**   | **助记**           |
|------------------|------------|--------------------|
| `<leader>a<bar>` | 格式化表格 | same as easy align |

### Haskell 相关

这部分需要安装 `ghc-mod`，`hlint`，`hasktags` 和 `hoogle` 才可正确运行。

| **按键**     | **功能**                                | **助记**                 |
|--------------|-----------------------------------------|--------------------------|
| `<leader>ts` | GhcMod 显示当前变量类型                 | **t**ype info **s**how   |
| `<leader>ti` | GhcMod 插入当前变量的类型               | **t**ype info **i**nsert |
| `<leader>tc` | GhcMod 清除变量类型的高亮               | **t**ype info **c**lear  |
| `<leader>sp` | GhcMod 将函数的参数展开为所有匹配的形式 | **sp**lit cases          |
| `<leader>dw` | 用 Hoogle 查找光标下的单词              | **d**ocument **w**ord    |
| `<leader>dd` | 用 Hoogle 查看光标下的单词的详细文档    | **d**etail **d**ocument  |

### Rust 相关

这部分需要安装 `racer` 以及 Rust 的文档，具体可以参考 [这篇文章](https://rust-china.org/rust-primer/latest/editors/vim.html)。

| **按键**     | **功能**         | **助记**                          |
|--------------|------------------|-----------------------------------|
| `<leader>gd` | 跳转到定义       | **g**oto **d**efinition           |
| `<leader>ds` | 水平分屏查看定义 | **d**efinition **s**plit          |
| `<leader>dv` | 垂直分屏查看定义 | **d**efinition **v**ertical split |
| `<leader>dd` | 查看详细文档     | **d**etail **d**ocument           |

## 参考

[spf13-vim](https://github.com/spf13/spf13-vim)

[haskell-vim-now](https://github.com/begriffs/haskell-vim-now)

[Rust Primer](https://rust-china.org/rust-primer/latest/editors/vim.html)
