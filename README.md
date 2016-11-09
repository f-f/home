# dotfiles

This repository versions my personal dotfiles. Use at your own risk!

Config for Ubuntu 16.04 Xenial.

## Fast install

Requirements: `sudo apt install gnupg git`

1. Get the GPG key in some way, put in `keypair.gpg`
2. `gpg --allow-secret-key-import --import keypair.gpg`
3. `rm keypair.gpg`
4. Generate a new ssh key for each hostname: `ssh-keygen -t rsa -b 4096 -C "$USER@$(hostname)"`
5. `git clone git@github.com:ff-/dotfiles.git`
6. Most likely you'd like to do `visudo` and input `ff_ ALL=(ALL) NOPASSWD: ALL`
7. `cd dotfiles && ./bootstrap`
8. Logout and login again!

## Inspiration

[Some](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.188hq56fb)
[links](https://github.com/mathiasbynens/dotfiles)
[and](https://github.com/webpro/dotfiles)
[repos](https://github.com/thypon/dotconfig)
[that](https://github.com/skeeto/dotfiles)
I found useful and inspiring.
