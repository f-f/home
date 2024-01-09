{ pkgs, hostname, ... }:
let
  brewPkgs = [
    "autoconf"
    "automake"
    "czkawka"
    "glib"
    "pkg-config"
    "fileicon"
    "gnu-tar"
    "magic-wormhole"
    "libvirt"
    "libusb"
    "macchanger"
    "openocd"
    "virt-manager"
    "virt-viewer"
    "youtube-dl"
  ];
  brewCasks = [
    "ableton-live-suite"
    "arduino"
    "audacity"
    "bartender"
    "bluesnooze"
    "caffeine"
    "calibre"
    "ckan"
    "discord"
    "dropbox"
    "firefox"
    "fl-studio"
    "google-chrome"
    "inkscape"
    "keepassxc"
    "kicad"
    "kitty"
    "krita"
    "launchcontrol"
    "little-snitch"
    "loopback"
    "lunar"
    "native-access"
    "obsidian"
    "plugdata"
    "rectangle"
    "secretive"
    "shifty"
    "skype"
    "slack"
    "sonos"
    "splice"
    "spotify"
    "stats"
    "steam"
    "syncthing"
    "teensy"
    "telegram"
    "vcv-rack"
    "visual-studio-code"
    "vlc"
    "wireshark"
    "xournal-plus-plus"
    "zoom"
  ];
  nixPkgs = with pkgs; [
    arp-scan
    awscli2
    bat
    clang
    coreutils
    curl
    diff-so-fancy
    fd
    (ffmpeg-full.override { withGme = false; })
    fq
    fzf
    git-lfs
    git-filter-repo
    gnumake
    gnupg
    graphviz
    iftop
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

  nix.package = pkgs.nixVersions.stable;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  programs.zsh.enable = true;
  programs.nix-index.enable = true;

  time.timeZone = "Europe/Helsinki";

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
  # services.lorri.enable = true;
  services.nix-daemon.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  launchd =
    let
      runEvery = StartInterval: {
        inherit StartInterval;
        Nice = 5;
        LowPriorityIO = true;
        AbandonProcessGroup = true;
      };
      runCommand = command: {
        inherit command;
        serviceConfig.RunAtLoad = true;
        serviceConfig.KeepAlive = true;
      }; in {

    user.agents = {
      obsidianBackup = {
        script = ''
          source ${secrets}
          /Users/fabrizio/bin/zk-backup
        '';
        serviceConfig = (runEvery 86400) // { RunAtLoad = true; UserName = "fabrizio"; StandardOutPath = "/Users/fabrizio/backstdout.log"; StandardErrorPath = "/Users/fabrizio/backstderr.log"; };
      };
      cleanDownloads = {
        script = "/Users/fabrizio/bin/cleanup-downloads";
        serviceConfig = (runEvery 86400) // { RunAtLoad = true; };
      };
    };
  };

  homebrew = {
    enable = true;
    global.brewfile = true;
    brewPrefix = "/opt/homebrew/bin";
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "f-f/homebrew-virt-manager"
      "acrogenesis/macchanger"
      "wader/tap"
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
    users.fabrizio = { pkgs, ... }: {
      home.stateVersion = "22.05";
      home.homeDirectory = pkgs.lib.mkForce "/Users/fabrizio";
      home.packages = nixPkgs;

      # https://github.com/nix-community/home-manager/issues/423
      home.sessionVariables = {
        PAGER = "less -R";
        TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
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

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    fira-code
    font-awesome
    inconsolata
    nerdfonts
    recursive
    roboto
    roboto-mono
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
