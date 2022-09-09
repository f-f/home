# home

Versioning `$HOME`. Contains nix configs, dotfiles, scripts.

Config for NixOS only.

## Fresh install, wat do

1. Clone this repo in the home folder: `git clone https://github.com/f-f/home.git ~`
1. Fetch everything: `cd ~ && git submodule update --init --recursive --remote`
1. Write down the config for the new machine, start from the example: `cd ~/nixos-config && cp local-example.nix $(hostname).nix`, and integrate with what's in `/etc/nixos/configuration.nix`
1. Import it as a local configuration: `echo "import ./$(hostname).nix" > local.nix`
1. `mv /etc/nixos/hardware-configuration.nix ~`
1. Add channels:
 ```
 sudo nix-channel --add http://nixos.org/channels/nixos-21.05 nixos
 sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
 sudo nix-channel --update
 ```

Then: `nixos-switch`

Next:
1. Make a new ssh key for github: `ssh-keygen -t ed25519 -C "$USER+github@$(hostname)" -f github`, add it as deploy key here
2. Replace this repo remote from http to git: `git remote set-url origin git@github.com:f-f/home.git`

### On macOS

It's a little harder to bootstrap Nix on macOS, but it can be done. After cloning the stuff:
```bash
# In case of M1
softwareupdate --install-rosetta

# Install brew, nix, darwin-nix, and flakes
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
curl -L https://nixos.org/nix/install | sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
nix-env -iA nixpkgs.nixFlakes

# Update /etc/nix/nix.conf and add:
# experimental-features = nix-command flakes 

# From ~/dev/nix-env (where the root flake.nix exists)
nixos-switch
```

Useful reads:
- https://xyno.space/post/nix-darwin-introduction
- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://github.com/srstrong/nix-env
- https://daiderd.com/nix-darwin/manual/index.html
