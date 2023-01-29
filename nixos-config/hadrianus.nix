{ pkgs, ... }:
{
  networking.hostName = "hadrianus";

  nix.package = pkgs.nixVersions.stable;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  programs.zsh.enable = true;
  programs.nix-index.enable = true;

  time.timeZone = "Europe/Helsinki";

  # Recreate /run/current-system symlink after boot
  services.activate-system.enable = true;
  services.lorri.enable = true;
  services.nix-daemon.enable = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

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
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "f-f/homebrew-virt-manager"
    ];
    brews = [
      "magic-wormhole"
      "libvirt"
      "virt-manager"
      "virt-viewer"
    ];
    casks = [
      "ableton-live-suite"
      "audacity"
      "caffeine"
      "calibre"
      "crossover"
      "discord"
      "dropbox"
      "firefox"
      "fl-studio"
      "google-chrome"
      "iina"
      "inkscape"
      "keepassxc"
      "kitty"
      "krita"
      "little-snitch"
      "loopback"
      "mailspring"
      "microsoft-outlook"
      "native-access"
      "obsidian"
      "plugdata"
      "rectangle"
      "secretive"
      "skype"
      "slack"
      "splice"
      "spotify"
      "stats"
      "steam"
      "telegram"
      "vcv-rack"
      "visual-studio-code"
      "vlc"
      "zoom"
    ];
    masApps = {
      # Xcode = 497799835;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.fabrizio = { pkgs, ... }: {
      home.stateVersion = "22.05";

      home.packages = with pkgs; [
        arp-scan
        awscli2
        bat
        clang
        coreutils
        curl
        diff-so-fancy
        fd
        (ffmpeg-full.override {game-music-emu = null;})
        fzf
        git-lfs
        git-filter-repo
        gnumake
        gnupg
        iftop
        jc
        jq
        lorri
        m-cli
        nmap
        nodejs
        python3
        ripgrep
        rsync
        silver-searcher
        terminal-notifier
        tokei
        tldr
        wget
        youtube-dl
      ];

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
