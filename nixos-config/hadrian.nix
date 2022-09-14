{ pkgs, ... }:
{
  networking.hostName = "hadrian";

  nix.package = pkgs.nixFlakes;
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
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-drivers"
    ];
    casks = [
      "caffeine"
      "secretive"
      "little-snitch"
      "spotify"
      "dropbox"
      "firefox"
      "google-chrome"
      "visual-studio-code"
      "discord"
      "keepassxc"
      "kitty"
      "microsoft-outlook"
      "mailspring"
      "telegram"
      "iina"
      "obsidian"
      "native-access"
      "splice"
      "vcv-rack"
      # "amethyst"
      # "ableton-live-suite"
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
        jq
        lorri
        m-cli
        nmap
        python3
        ripgrep
        rsync
        silver-searcher
        terminal-notifier
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