# dotfiles

My dotfiles, scripts and keys. Use at your own risk!

Config for Ubuntu 16. Should run with no issues on Debian and Ubuntu 14 - untested though. In case you do please get in touch :)

## Fast install

Requirements: `sudo apt install gnupg git`

1. Get the GPG key, put in `keypair.gpg`
2. `gpg --allow-secret-key-import --import keypair.gpg`
3. `rm keypair.gpg`
4. `git clone https://github.com/ff-/dotfiles.git`
5. `cd dotfiles && ./bootstrap`

## Inspiration

- https://github.com/mathiasbynens/dotfiles
- https://github.com/webpro/dotfiles
- https://github.com/thypon/dotconfig
- https://github.com/skeeto/dotfiles
- https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.188hq56fb
