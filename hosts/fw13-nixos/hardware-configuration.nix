# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = with config.boot.kernelPackages; [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "uas"
    "sd_mod"
  ];
  boot.initrd.kernelModules = with config.boot.kernelPackages; [ "dm-snapshot" ];
  boot.kernelModules = with config.boot.kernelPackages; [ "kvm-intel" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/72f6c0f8-d526-4aea-afdf-f683d3005933";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B403-D3C7";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/b6f5b5eb-9080-4b4d-9bfe-4e0e09bb6e30"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp170s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
