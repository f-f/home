# home

Versioning `$HOME`. Contains nix configs, dotfiles, scripts.

Config for NixOS only.

## Fresh install, wat do

1. Clone this repo in the home folder: `git clone https://github.com/f-f/home.git ~`
2. Fetch everything: `cd ~ && git submodule update --init --recursive --remote`
2. Symlink `~/nixos-config` to `/etc/nixos/versioned`: `sudo ln -sv ~/nixos-config /etc/nixos/versioned`
3. Write down the config for the new machine, start from the example: `cd ~/nixos-config && cp local-example.nix $(hostname).nix`
4. Import it as a local configuration: `echo "import ./$(hostname).nix" > local.nix`
5. Symlink the main config: `sudo ln -sv /etc/nixos/versioned/configuration.nix /etc/nixos/configuration.nix`
6. Add channels:
 ```
 sudo nix-channel --add http://nixos.org/channels/nixos-19.03 nixos
 sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
 sudo nix-channel --update
 ```

Then: `nixos-rebuild switch`

Next:
1. Make a new ssh key for github: `ssh-keygen -t rsa -b 4096 -C "$USER@$(hostname)" -f github`, add it as deploy key here
2. Replace this repo remote from http to git: `git remote set-url origin git@github.com:f-f/dotfiles.git`
