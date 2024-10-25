{ config, pkgs, ... }:

let secrets = "/home/fabrizio/nixos-config/secrets.sh";
    zfsNotifyCmd = pkgs.writeShellScript "zfsNotify.sh" ''
  INPUT=$(</dev/stdin)
  echo "$INPUT" | grep "errors: No known data errors"
  ZFS_ERR=$?
  source ${secrets};
  curl -fsS -m 10 --retry 5 --data-raw "$INPUT" https://hc-ping.com/$ZFS_TOKEN/$ZFS_ERR
  '';
    mkFolder = { path, devices, ...}:
      {
        path = path;
        devices = devices;
        ignorePerms = false;
        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "15552000"; # 180 days in seconds
          };
        };
      };
in
{

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "mpt3sas" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Boot config
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.memtest86.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This is for sensors to work
  boot.kernelModules = [ "kvm-intel" "coretemp" "it87" "nct6775"];

  # Activate the serial
  boot.kernelParams = ["console=tty0" "console=ttyS0,115200"];

  # ZFS stuff
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs = {
    extraPools = [ "tank" ];
  };
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  fileSystems."/" =
    { device = "system/local/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "system/local/nix";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "system/safe/home";
      fsType = "zfs";
    };

  fileSystems."/persist" =
    { device = "system/safe/persist";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4E99-BB54";
      fsType = "vfat";
    };

  # ZFS config
  services.zfs = {
    autoSnapshot = {
      enable = true;
      monthly = 1; # keep only one monthly instead of 12
    };
    autoScrub = {
      enable = true;
      # Run on the first Monday of the month
      # Use `systemd-analyze calendar $INTERVAL` to validate correctness
      interval = "Mon *-*-1..7 06:00:00";
    };
    trim = {
      enable = true;
      interval = "Fri *-*-* 11:11:11";
    };
    zed.settings = {
      ZED_EMAIL_ADDR = [ "root" ];
      ZED_EMAIL_PROG = zfsNotifyCmd.outPath;
      ZED_NOTIFY_VERBOSE = true;
      ZED_SCRUB_AFTER_RESILVER = true;
    };
  };

  # ECC monitoring
  hardware.rasdaemon.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    dataDir = "/tank/sync/Sync";
    openDefaultPorts = true;
    configDir = "/tank/sync/.config/syncthing";
    user = "fabrizio";
    group = "users";
    guiAddress = "0.0.0.0:8384";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      gui = {
        # See https://github.com/NixOS/nixpkgs/issues/85336#issuecomment-1922030843
        # It does not matter anyways because this is all on local network
        user = "fabrizio";
        password = "$2y$19$TEI/A4mw2DpcQtZ04it3/.V6rTb.bBX43arPHzVbungEDdzXqYK.6";
      };
      devices = {
        "claudius" = { id = "YLAYFCC-SN3FHCY-QJ3JO5J-7NCE6S4-K727LOJ-QPBKXPU-DMHBI7U-Q4RIHAL"; };
        "tiberius" = { id = "YXJJ7SB-DG7A2XC-LPOSC62-ENSPSRM-GKIC5KH-E4U3GNB-JXQCHTI-CNIMVQW"; };
        "trajan" = { id = "MRHFQWO-VFGGALI-2E5RX2B-L6GDEDD-Z6MEJ2C-PQIVSFZ-TNKPZRD-JQDYVAB"; };
        "aurelius" = { id = "2SDXURU-ZHJBJ3K-LNS5BP7-6X766CA-V7BBDTV-QYFRDR7-6PDRSKC-GIIT6AC"; };
      };
      folders = {
        "Sync" = mkFolder {
          path = "/tank/sync/Sync";
          devices = [ "claudius" "tiberius" "aurelius" ];
        };
        "shared" = mkFolder {
          path = "/tank/sync/shared";
          devices = [ "claudius" "tiberius" "aurelius" ];
        };
        "DJ" = mkFolder {
          path = "/tank/sync/DJ";
          devices = [ "claudius" "trajan" "tiberius" "aurelius" ];
        };
        "ebooks" = mkFolder {
          path = "/tank/sync/ebooks";
          devices = [ "claudius" "tiberius" "aurelius" ];
        };
        "archive" = mkFolder {
          path = "/tank/sync/archive";
          devices = [ "claudius" "tiberius" ];
        };
      };
    };
  };

  services.tailscale.enable = true;

  
  # Virtualisation
  security.polkit.enable = true;

  # Networking
  networking.hostName = "claudius";  
  networking.hostId = "454f37c2";
  networking.enableIPv6 = false;
  networking.defaultGateway = {
    address = "192.168.178.1";
    interface = "enp7s0";
    metric = 10;
  };
  networking.dhcpcd.extraConfig =
  ''
    interface enp9s0f0
    metric 300

    interface enp9s0f1
    metric 290

    interface enp7s0
    metric 200
  '';
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];
  networking.resolvconf.dnsExtensionMechanism = false;
  # For the networking of the systemd/nixos containers
  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-*"];
    externalInterface = "enp7s0";
    # god forbid
    enableIPv6 = false;
  };
  networking.firewall.enable = false;
  # See https://github.com/NixOS/nixpkgs/issues/161610
  networking.firewall.checkReversePath = false;
  networking.firewall.extraCommands = ''
    iptables -t nat -A POSTROUTING -o enp7s0 -j MASQUERADE
  '';

  # DynamicDNS for functional.pizza
  services.ddclient = {
    enable = true;
    configFile = "/tank/ddclient_namecheap.conf";
  };

  # FIXME: reinstate coredns. By now I forgot whatever the issue was
  # CoreDNS for accessing in local network domains that we host
  # TODO: we could have a PiHole kind of setup as well, see
  # https://wes.today/replace-pihole-with-coredns/
  services.coredns = {
    enable = false;
    config =
    ''
      . {
        # hosts /etc/coredns/blocklist.hosts {
        #   fallthrough
        # }
        # Cloudflare Forwarding
        forward . 1.1.1.1 1.0.0.1
        cache
      }

      functional.pizza {
          template IN A  {
            answer "{{ .Name }} 0 IN A 192.168.8.159"
          }
      }
    '';
  };
  # of course we need to disable some systemd shit for this to work
  services.resolved.enable = true;

  # Nginx reverse proxy
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "letsencrypt@ferrai.io";
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "functional.pizza" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://10.10.10.11:80";
          proxyWebsockets = true;
        };
      };
    };
  };


  # Sources of container knowledge:
  # - https://blog.beardhatcode.be/2020/12/Declarative-Nixos-Containers.html
  # FIXME: remove this
  containers.testContainer = {
    ephemeral = true;
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.10.10.12";
    localAddress = "10.10.10.13";
    config = { config, pkgs, ... }: {
        services.httpd.enable = true;
        services.httpd.adminAddr = "foo@example.org";
        networking.firewall.allowedTCPPorts = [ 80 ];
    };
  };

  # Containers: mastodon
  # Info:
  # - https://github.com/NixOS/nixpkgs/blob/nixos-23.05/nixos/modules/services/web-apps/mastodon.nix
  # - https://nixos.wiki/wiki/Mastodon
  # - https://github.com/NixOS/nixpkgs/blob/2846986f10a2220af6efc688e1e2799a520a386a/nixos/modules/services/web-apps/mastodon.nix
  # - https://krisztianfekete.org/self-hosting-mastodon-on-nixos-a-proof-of-concept/
  containers.mastodon = {
    privateNetwork = true;
    hostAddress = "10.10.10.10";
    localAddress = "10.10.10.11";
    ephemeral = false;
    autoStart = true;
    config = { config, pkgs, ... }: {
      system.stateVersion = "24.05";
      services.mastodon = {
        enable = true;
        localDomain = "functional.pizza";
        configureNginx = false;
        enableUnixSocket = false;
        smtp.fromAddress = "noreply@functional.pizza";
        extraConfig.SINGLE_USER_MODE = "true";
        streamingProcesses = 3;
     };
      services.nginx = {
        enable = true;
        recommendedProxySettings = true;

        virtualHosts."functional.pizza" = {
          root = "${config.services.mastodon.package}/public/";

          locations."/system/".alias = "/var/lib/mastodon/public-system/";

          locations."/" = {
            tryFiles = "$uri @proxy";
          };

          locations."@proxy" = {
            proxyPass = "http://127.0.0.1:${toString config.services.mastodon.webPort}";
            proxyWebsockets = true;
            # Hack, see here: https://blog.vyvojari.dev/mastodon-behind-a-reverse-proxy-without-ssl-https/
            extraConfig = "proxy_set_header X-Forwarded-Proto https;";
          };

          # FIXME this is deprecated in 24.05
          # locations."/api/v1/streaming/" = {
          #  proxyPass = "http://127.0.0.1:${toString config.services.mastodon.streamingPort}";
          #   proxyWebsockets = true;
          # };
        };
      };

      networking.firewall.enable = false; #allowedTCPPorts = [ 80 ];
    };
  };


  users.users.fabrizio.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILWBoYJ6BAQevcLwudr4yQCV6qdyMTrW8EYd/FZsD2/O fabrizio+claudius@tiberius"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtNeH9zrRkxq+Be1PbdyvVhUcNIVVrLijeN/ct3HnhQ4W1qq8ixFyfUEiwCSsZvR4L1L/GVZZmwmi7TRqRsOVVfV54q7QAzTKgs6+tPZLDktsvORiNoPu1uONH8Lf8Cbvpdnx6fCl+z8VU2p5+myAF4FXVY4EX2m6TCKJnwdRuZsjZh98XveUf46vXFjMqNUIW9ueipCCoDAyIqX8V3TmjWgyHZ3rIxGExnXNFYPN4Wz4UNRYI2Da1DOtFqXgFpm+nxVqk6QziRnUpgIXkBL9QBPnJEfKywy7rHpQlDX6/f2imFjkNAZq5my22KSoeYTJZyAuCrCCHgpY/ljl8kbL5ZWvPCai7DYpTVRnqhQAey7FUaafMPC/pmD6QYrb566QEYgj1MNknPMnvEPSR2xFJAiCo95Ckz9OvRCMZ1MA/wmRDOtL5dxqJWjnDtbXFt2jy4zLfrPKYKua/K5GOPHwMIMMDGGkJriWTkmi4OqZK2yPyFyfIVHJOhZhl5OtyQTsRyTDK4tPPZ3h/G8Q2YvvK6rTSO3oJbCn8yYqoPe8rAlrmeOBhB89/s9fqiczCHNt2Yj2Lax+aARF3lasA4pmbAseIO+jgYsk8xHhytTE45rLQnSYz63YuycJXJFKIgyqIQxZ1Jxj2GbzzoWeRUFxCKW9qmMcx+QP22BTIvE5HuQ== fabrizio@caesar"
  ];

  # FIXME: I guess we could deprecate duckdns
  systemd.services.duckdns= {
    enable = true;
    description = "Ping DuckDNS";
    after = [ "network.target" ];
    path = with pkgs; [ bash curl ];
    environment = {
      SECRETS_LOCATION = secrets;
    };
    serviceConfig = {
      Type = "oneshot";
      User = "fabrizio";
      Group = "fabrizio";
      ExecStart = "/home/fabrizio/bin/duckdns";
    };
  };
  systemd.timers.duckdns = {
    enable = true;
    description = "Ping DuckDNS";
    wantedBy = [ "timers.target" ];
    partOf = [ "duckdns.service" ];
    timerConfig = {
      OnBootSec = "10min";
      OnUnitActiveSec = "20min";
      Unit = "duckdns.service";
    };
  };
}
