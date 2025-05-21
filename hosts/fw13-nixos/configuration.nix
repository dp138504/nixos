# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  # System-level profiles. Implemented as NixOS modules.
  profiles = {
    virtualization = {
      enable = true; # Enables virtualization technologies: docker & qemu/kvm
      addToGroup = [ "dap" ];
    };
    common.enable = true; # Sets common system settings: nix tweaks, i18n, etc.
    bootloader = {
      enable = true; # Bootloader defaults.
      graphical = true; # Enable plymouth graphical boot process.
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
  };

#  sops = {
#    defaultSopsFile = ../../secrets/personal/secrets.yaml;
#    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
#    gnupg.home = "../../.git/gnupg";
#    secrets = {
#      "intermediate_ca.pem" = {  };
#      "root_ca.pem" = {  };
#    };
#  };

  # Bootloader extras.
  boot = {
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      windows."win11" = {
        title = "Windows 11";
        sortKey = "o_windows";
        efiDeviceHandle = "HD0b";
      };
      extraEntries = {
        "kali.conf" = ''
          title Kali Linux
          efi /efi/edk2-uefi-shell/shell.efi
          options -nointerrupt -nomap -noversion HD1e0b:\EFI\kali\grubx64.efi
          sort-key o_kali
        '';
      };
    };
    kernelParams = [
      "usbcore.autosuspend=300" # Suspend USB devices after 5 minutes (default is 2 seconds)
    ];
  };

  networking.hostName = "fw13-nixos"; # Define your hostname.

  services.resolved.enable = true;

#  networking.hosts = {
#    "IP" = ["host1" "host2"];
#  };

  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager = {
    enable = true;
    enableStrongSwan = true;
  };

  security.pam.services.hyprlock = {};

  security.pki.certificateFiles = [
    ../../assets/dod_certificates.pem
  ];
  services.pcscd.enable = true; # Smartcard daemon
  services.udev = {
    packages = with pkgs; [
      yubikey-personalization
      platformio-core
      openocd
    ];
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="4348", ATTR{idProduct}=="7048", ATTR{power/autosuspend}="-1"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="43f2", ATTR{idProduct}=="1211", ATTR{power/autosuspend}="-1" 
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1b1c", ATTR{idProduct}=="1b7f", ATTR{power/autosuspend}="-1" 
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  services.desktopManager = {
    plasma6.enable = true;
    cosmic.enable = true;
  };

  services.udisks2.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Enable and configure the X11 windowing system.
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

#  services.greetd = {
#    enable = true;
#    settings = {
#      default_session = {
#        command = let 
#          tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
#          wayland-sessions = "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
#          xsessions = "--xsessions ${config.services.displayManager.sessionData.desktops}/share/xsessions";
#        in
#          builtins.concatStringsSep " " [
#            tuigreet
#            "--time"
#            "--remember"
#            "--remember-session"
#            wayland-sessions
#            xsessions
#          ];
#        user = "greeter";
#      };
#    };
#  };
#
#  systemd.services.greetd.serviceConfig = {
#    Type = "idle";
#    StandardInput = "tty";
#    StandardOutput = "tty";
#    StandardError = "journal"; # Without this errors will spam on screen
#    # Without these bootlogs will spam on screen
#    TTYReset = true;
#    TTYVHangup = true;
#    TTYVTDisallocate = true;
#    };

  services.displayManager = {
    defaultSession = "plasma";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
#    sddm.sugarCandyNix = {
#      enable = false;
#      settings = {
#        Background = lib.cleanSource ../../assets/background_2256x1504.jpg;
#        ScreenWidth = 2256;
#        ScreenHeight = 1504;
#        FormPosition = "left";
#        HaveFormBackground = true;
#        PartialBlur = true;
#        DateFormat = "dddd, MMMM d, yyyy";
#        ForceHideCompletePassword = true; # Do not show any password characters
#        HeaderText = "";
#        Font = "JetBrainsMono Nerd Font Mono";
#      };
#    };
  };

  environment.etc."pkcs11/modules/opensc-pkcs11".text = ''
    module: ${pkgs.opensc}/lib/opensc-pkcs11.so
  '';

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  systemd.mounts = [
    { 
      what = "172.16.1.5:/volume1/share";
      type = "nfs";
      where = "/home/dap/mnt/share";
      after = [ "network-online.service" ];
      options = "v4,user,noauto,rw,relatime,nolock";
    }
  ];
  systemd.automounts = [
    {
      name = "home-dap-mnt-share.automount";
      where = "/home/dap/mnt/share";
      wantedBy = [ "multi-user.target" ];
    }
  ];


  services.fwupd.enable = true; # Firmware updates
  services.hardware.bolt.enable = true; # Thunderbolt daemon
  services.fprintd.enable = false; # Disable fingerprint reader (Overridden in specialisation)

  services.printing = {
    enable = true; # Enable CUPS to print documents.
    drivers = [ pkgs.epson-escpr ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dap = {
    isNormalUser = true;
    description = "Dylan A Pitts";
    extraGroups = [
      "plugdev"
      "networkmanager"
      "wheel"
      "video"
      "dialout"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ home-manager ];
  };

  # $ nix search nixpkgs#wget
  environment.systemPackages = with pkgs; [
    firefox # Default system browser
    vim # Text editor
    fprintd # Fingerprint reader daemon
    powertop # Power management monitor
    git # SCM
    sops # secrets operations
    git-agecrypt
    seahorse # Gnome keyring management
    kde-gruvbox
    (pkgs.writeShellScriptBin "setup-browser-cac" ''
      NSSDB="''${HOME}/.pki/nssdb"
      mkdir -p ''${NSSDB}

      ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add p11-kit-proxy \
        -libfile ${pkgs.p11-kit}/lib/p11-kit-proxy.so
    '')
    nfs-utils
    wireguard-tools
  ];

  # Power management
  powerManagement.powertop.enable = true; # View power usage
#  services.tlp = {
#    # Laptop power saving utility
#    enable = true;
#    settings = {
#      PCIE_ASPM_ON_BAT = "powersupersave";
#      PCIE_ASPM_ON_AC = "on"; # Force PCIe (i.e. eGPU) devices to "on" when on external power
#    };
#  };

    services.logind = {
      lidSwitch = "ignore";
      lidSwitchExternalPower = "ignore";
    };

  programs.zsh.enable = true;
  programs.xfconf.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.rtl-sdr.enable = true;

  services.tailscale.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # See the following for details: https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # Must be false for sync
    powerManagement.finegrained = false; # Must be false for sync
    open = true; # Not working with false (Getting RmInitAdapter failed which could be a bios bug)
    nvidiaSettings = true; # Nvidia Xorg Settings tool
    forceFullCompositionPipeline = true; # Helps with screen tearing

    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "570.133.07";
      # this is the third one it will complain is wrong
      sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
      # unused
      sha256_aarch64 = "sha256-2l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      # this is the second one it will complain is wrong
      openSha256 = "sha256-9l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
      # this is the first one it will complain is wrong
      settingsSha256 = "sha256-XMk+FvTlGpMquM8aE8kgYK2PIEszUZD2+Zmj2OpYrzU=";
      # unused
      persistencedSha256 = "sha256-4l8N83Spj0MccA8+8R1uqiXBS0Ag4JrLPjrU3TaXHnM=";
    };

    prime = {
      sync.enable = true;
      allowExternalGpu = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:4:0:0";
    };
  };

  specialisation = {
    undocked.configuration = {
      system.nixos.tags = [ "undocked" ];
      services.xserver.videoDrivers = lib.mkForce [ "i915" ];
      services.fprintd.enable = lib.mkForce true;
      hardware.nvidia.prime.sync.enable = lib.mkForce false;
      systemd.targets.hybrid-sleep.enable = lib.mkForce true;
      services.logind.lidSwitch = lib.mkForce "suspend-then-hibernate";
      services.logind.lidSwitchExternalPower = lib.mkForce "suspend";
      services.logind.extraConfig = lib.mkForce ''
        IdleAction=hybrid-sleep
        IdleActionSec=1800s
      '';
      systemd.sleep.extraConfig = lib.mkForce ''
        HibernateMode=shutdown
        HibernateDelaySec=1800s
      '';
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.

  virtualisation.docker.extraOptions = "--iptables=False";

  networking = {
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 8802 8000 8086 22 ];
    
#    nftables.enable = true;
#    nftables.flushRuleset = true;
#    nftables.ruleset = ''
#      table inet filter {
#        chain default_input {
#          type filter hook input priority 0 
#          policy drop
#          
#          iif lo accept
#
#          ct state invalid drop
#          ct state established,related accept
#
#          icmpv6 type { 1, 2, 3, 4, 128, 129, 133, 134, 135, 136, 141, 142, 148, 149 } accept
#          icmpv6 type { 137 } ip6 hoplimit != 1 accept
#          icmpv6 type { 130, 131, 132, 143, 151, 152, 153 } ip6 saddr fe80::/64 accept
#
#          jump input
#        }
#
#        chain input {
#          tcp dport 8802 accept comment "Allow tcp/8802 for packer"
#          tcp dport 8000 accept comment "Allow tcp/8000 for testing"
#        }
#
#        chain forward {
#          type filter hook forward priority 0
#          policy drop
#        }
#
#        chain output {
#          type filter hook output priority 0
#          policy accept
#        }
#      }
#    '';
  };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  #
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
