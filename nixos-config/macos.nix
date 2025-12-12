{ pkgs, hostname, ... }:
let
  brewPkgs = [
    "autoconf"
    "automake"
    "bcrypt"
    "czkawka"
    "glib"
    "pkg-config"
    "fileicon"
    "gnu-tar"
    "magic-wormhole"
    "libvirt"
    "libusb"
    "macchanger"
    "nicotine-plus"
    "openocd"
    "pandoc"
    "pinentry-mac"
    "qmk/qmk/qmk"
    "virt-manager"
    "virt-viewer"
    "yt-dlp"
  ];
  brewCasks = [
    "affinity"
    "aldente"
    "arduino"
    "audacity"
    "balenaetcher"
    "basictex"
    "bluesnooze"
    "caffeine"
    "calibre"
    "cardinal"
    "ckan-app"
    "claude"
    "crossover"
    "discord"
    "dropbox"
    "easyeda"
    "firefox"
    "fl-studio"
    "gimp"
    "google-chrome"
    "inkscape"
    "imhex"
    "jordanbaird-ice"
    "keepassxc"
    "kicad"
    "kitty"
    "krita"
    "launchcontrol"
    "little-snitch"
    "loopback"
    "lunar"
    "media-converter"
    "native-access"
    "obs"
    "obsidian"
    "orbstack"
    "plugdata"
    "porting-kit"
    "protonvpn"
    "raspberry-pi-imager"
    "rectangle"
    "shifty"
    "slack"
    "sonos"
    "splice"
    "spotify"
    "stats"
    "steam"
    "syncthing-app"
    "tailscale-app"
    "teensy"
    "telegram"
    "todoist-app"
    "visual-studio-code"
    "vlc"
    "wireshark-app"
    "xld"
    "xournal++"
    "zoom"
  ];
  nixPkgs = with pkgs; [
    arp-scan
    bat
    clang
    coreutils
    curl
    diff-so-fancy
    diffoscope
    fd
    fq
    fzf
    github-cli
    git-lfs
    git-filter-repo
    gnumake
    gnupg
    graphviz
    iftop
    iodine
    jc
    jq
    m-cli
    mosquitto
    nmap
    nodejs
    python3
    ripgrep
    rsync
    silver-searcher
    terminal-notifier
    tokei
    tldr
    tree
    wget
    yq
  ];
  secrets = "/Users/fabrizio/nixos-config/secrets.sh";
in

{
  networking.hostName = hostname;

  nix.package = pkgs.nixVersions.latest;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  nix.gc.automatic = true;

  nix.settings = {
    trusted-users = [ "@admin" ];
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://cache.iog.io"
    ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
  };

  ids.uids.nixbld = 350;
  ids.gids.nixbld = 30000;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  programs.zsh.enable = true;
  programs.nix-index.enable = true;

  time.timeZone = "Europe/Helsinki";

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  launchd =
    let
      defaultServiceConfig = scriptName: {
        RunAtLoad = true;
        StandardOutPath = "/tmp/launchd_${scriptName}_stdout.log";
        StandardErrorPath = "/tmp/launchd_${scriptName}_stderr.log";
      };

      defaultDaemonConfig = scriptName: (defaultServiceConfig scriptName) // { KeepAlive = true; };

      runEvery = StartInterval: scriptName: (defaultServiceConfig scriptName) // {
        inherit StartInterval;
        Nice = 5;
        LowPriorityIO = true;
        AbandonProcessGroup = true;
      };

      runBinScript = cadenceSeconds: binScriptName: {
        script = ''
          source ${secrets}
          /Users/fabrizio/bin/${binScriptName}
        '';
        serviceConfig = runEvery cadenceSeconds binScriptName;
      };

      runScriptDaily = runBinScript 86400;
      runScriptHourly = runBinScript 3600;

      # Things that are run only on the desktop, such as Ollama for code completion,
      # and various iCloud -> Syncthing backups
      tiberiusScripts = if hostname == "tiberius" then
        {
          obsidianBackup = runScriptDaily "obsidian-backup";
          keepassBackup = runScriptHourly "keepass-backup";
          # ollama-serve = {
          #   environment = { OLLAMA_HOST = "0.0.0.0:11434"; };
          #   command = "${pkgs.ollama}/bin/ollama serve";
          #   serviceConfig = defaultDaemonConfig "ollama";
          # };
        } else {};

    in {
      user.agents = {
        cleanupDownloads = runScriptDaily "cleanup-downloads";
      } // tiberiusScripts;
    };

  homebrew = {
    enable = true;
    global.brewfile = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      autoUpdate = true;
      upgrade = false;
      cleanup = "zap";
    };
    taps = [
      "f-f/homebrew-virt-manager"
      "acrogenesis/macchanger"
      "wader/tap"
      "qmk/qmk"
    ];
    brews = brewPkgs;
    casks = brewCasks;
    masApps = {
      # Xcode = 497799835;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.fabrizio = { pkgs, ... }: {
      home.stateVersion = "22.05";
      home.homeDirectory = pkgs.lib.mkForce "/Users/fabrizio";
      home.packages = nixPkgs;

      # https://github.com/nix-community/home-manager/issues/423
      home.sessionVariables =
        let
          kitty = pkgs.kitty.overrideAttrs (oldAttrs: {
            # https://github.com/NixOS/nixpkgs/issues/388020
            doInstallCheck = false;
          });
        in
        {
          PAGER = "less -R";
          TERMINFO_DIRS = "${kitty.terminfo.outPath}/share/terminfo";
        };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = "${pkgs.fd}/bin/fd --type d";
        defaultCommand = "${pkgs.fd}/bin/fd --type file --hidden --exclude .git";
        fileWidgetCommand = "${pkgs.fd}/bin/fd --type file --hidden --exclude .git";
        fileWidgetOptions = [ "--preview '${pkgs.bat}/bin/bat --style=numbers --color=always {}'" ];
      };

      programs.htop = {
        enable = true;
        settings.show_program_path = true;
      };
    };
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      minimize-to-application = true;
    };

    screencapture.location = "/tmp";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };

    NSGlobalDomain._HIHideMenuBar = false;
    NSGlobalDomain.NSWindowResizeTime = 0.1;

  };

  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    google-fonts
    inconsolata
    recursive
    roboto
    roboto-mono
  ] ++ (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts));

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.stateVersion = 5;
  system.primaryUser = "fabrizio";
}
