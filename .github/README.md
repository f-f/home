# home

Versioning `$HOME`. Contains nix configs, dotfiles, scripts.

Config for NixOS only.

## Fresh install, wat do

1. Clone this repo in the home folder: `git clone https://github.com/f-f/home.git ~`
1. Fetch everything: `cd ~ && git submodule update --init --recursive --remote`
1. Add the fzf module:
    ```bash
    mkdir -p .zprezto/contrib && cd $_
    git clone https://github.com/gpanders/fzf-prezto.git fzf
    cd fzf
    git submodule update --init
    ```
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

# Install brew and nix
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
curl -L https://nixos.org/nix/install | sh

# Set hostname
export NEW_HOSTNAME=foo
sudo scutil --set HostName $NEW_HOSTNAME
sudo scutil --set LocalHostName $NEW_HOSTNAME
sudo scutil --set ComputerName $NEW_HOSTNAME

# At this point, edit nixos-config/flake.nix to add the new machine

# Then:
nixos-switch

# Note: it will complain at first that the nix command requires experimental features, so that will require executing the script by hand adding the right flags, but after that it's all fine
```

Useful reads:
- https://xyno.space/post/nix-darwin-introduction
- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://github.com/srstrong/nix-env
- https://daiderd.com/nix-darwin/manual/index.html


TODO: refactor readme. With the flakes it's not quite the right approach
Reference this link: https://colinramsay.co.uk/2021/10/19/migrating-a-nixos-install-to-flakes.html
