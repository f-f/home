# macOS install

- Install [Homebrew](http://brew.sh/)
- `brew install git gnupg`
- generate a new ssh key for each hostname: `ssh-keygen -t rsa -b 4096 -C "$USER@$(hostname)"`
- `git clone git@github.com:ff-/dotfiles.git`
- most likely also `visudo` and input `fabrizio ALL=(ALL) NOPASSWD: ALL`
- `cd macOS && ./boostrap`


