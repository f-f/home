# macOS install

- Install [Homebrew](http://brew.sh/)
- [Change your hostname](https://apple.stackexchange.com/questions/66611/how-to-change-computer-name-so-terminal-displays-it-in-mac-os-x-mountain-lion)
- `brew install git gnupg`
- generate a new ssh key for each hostname: `ssh-keygen -t rsa -b 4096 -C "$USER@$(hostname)" -f ~/.ssh/github`
- `ssh-add .ssh/github` and insert passphrase
- `git clone git@github.com:f-f/dotfiles.git`
- most likely also `visudo` and input `fabrizio ALL=(ALL) NOPASSWD: ALL`
- `cd macOS && ./boostrap`


