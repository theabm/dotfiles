# Stow 

Stow is a useful utility for configuring things I prefer to configure without nixos.

I always forget the commands so I decided to document what I do.

As an example, lets take doom emacs. Doom expects configuration files to be found in `~/.config/doom`, 
so in my dotfiles, I create a `dotfiles/stow/doom` directory which will reflect this hierarchy 
and contain all the configuration files. In other words, it will look like this:

```
          Same structure I want in `~` (the target directory)
          -----------------------
          |                     |
          |                     |
stow/doom/.config/doom/config.el
stow/doom/.config/doom/init.el
stow/doom/.config/doom/packages.el
```
Then, from `stow/` I run `stow -vRt ~ doom`. This will create symlinks in the target directory (in 
this case, I specified my home directory `~`) that reflect the same file structure contained in `doom` .

The `-v` is for verbose, the `-R` is to clean up old symlinks, and `-t` is to set the target.

In the end, the output is something like:

```
LINK: .config/doom/config.el => ../../dotfiles/stow/doom/.config/doom/config.el
LINK: .config/doom/init.el => ../../dotfiles/stow/doom/.config/doom/init.el
LINK: .config/doom/packages.el => ../../dotfiles/stow/doom/.config/doom/packages.el
```


