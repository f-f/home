# dotfiles

My dotfiles, scripts and keys. Use at your own risk!

Config for Ubuntu 16.04 Xenial.

## Fast install

Requirements: `sudo apt install gnupg git`

1. Get the GPG key, put in `keypair.gpg`
2. `gpg --allow-secret-key-import --import keypair.gpg`
3. `rm keypair.gpg`
4. `git clone https://github.com/ff-/dotfiles.git`
5. Most likely you'd like to do `visudo` and input `ff_ ALL=(ALL) NOPASSWD: ALL`
6. `cd dotfiles && ./bootstrap`

## Inspiration

[Some](https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.188hq56fb)
[links](https://github.com/mathiasbynens/dotfiles)
[and](https://github.com/webpro/dotfiles)
[repos](https://github.com/thypon/dotconfig)
[that](https://github.com/skeeto/dotfiles)
I found useful and inspiring.
