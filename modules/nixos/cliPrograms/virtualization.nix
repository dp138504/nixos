{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.virtualization;
  users = config.profiles.virtualization.addToGroup;
in
{
  options = {
    profiles.virtualization = {
      enable = lib.mkEnableOption "Enable virtualization technologies.";
      docker = lib.mkOption {
        type = lib.types.bool;
        description = "Enable rootless docker";
        default = true;
      };
      qemu_kvm = lib.mkOption {
        type = lib.types.bool;
        description = "Enable qemu/kvm virtualization";
        default = true;
      };
      addToGroup = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of users to add to the libvirtd group.";
        default = [];
      };
    };
  };

  config = lib.mkIf config.profiles.virtualization.enable {
    virtualisation.docker.rootless = lib.mkIf (cfg.docker) {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [ "1.1.1.1" ];
      };
    };

    virtualisation = {
      libvirtd = lib.mkIf (cfg.qemu_kvm) {
        enable = true;
        qemu = {
          runAsRoot = true;
        };
      };
      spiceUSBRedirection.enable = lib.mkIf (cfg.qemu_kvm) true;
    };

    users.groups.libvirtd.members = lib.mkIf (cfg.qemu_kvm) users;

    programs.virt-manager.enable = lib.mkIf (cfg.qemu_kvm) true;
  };
}
