The intention is not to have things work magically, but pragmatically. I liked the topical approach of [holman/ditfiles](https://github.com/holman/dotfiles) but didn't like it was shell specific (ie file.zsh) and the .symlink convention. I wanted to have support for multiple shells. I also liked the simplicity of [wking/dotfiles-framework](https://github.com/wking/dotfiles-framework), but it requires bash, and I would have preferred plain Bourne Shell support. Expect the code here to be borrowed or heavily influenced with these tools.

Please note that this script does not execute any of the files contained in this repository. You can also symlink dotfiles within the <home> directory to other files in this repository. This will cause the files in your home directory (`~`) to be symlinked to the target of the symlink.

*TODO:* installation notes. submodule or keep on it's own



