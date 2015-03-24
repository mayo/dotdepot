# dotdepot

The intention is not to have things work magically, but pragmatically. I liked the topical approach of [holman/dotfiles](https://github.com/holman/dotfiles) but didn't like it was shell specific (.e. zsh) and the .symlink convention. I also liked the simplicity of [wking/dotfiles-framework](https://github.com/wking/dotfiles-framework), but it requires bash, and I would have preferred plain Bourne Shell support. (Plus, I kept running into errors) Expect the code here to be borrowed or heavily influenced with these tools.

Please note that this script does not execute any of the files contained in the source directory. The files in your home directory will be symlinked to files in the source directory.

## TODO

- installation notes (standalone or submodule in dotfiles)
- bootstrapping
- unlink files no longer in repo? (or detect removal, offer to keep old copy?)
- backup option when overwriting/removing directories
- diff/patch
- unlink home dir

