{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.virtualization;
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
    };
  };

  config = lib.mkIf config.profiles.virtualization.enable {
    virtualisation.docker.rootless = lib.mkIf (cfg.docker) {
      enable = true;
      setSocketVariable = true;
    };

    virtualisation.libvirtd = lib.mkIf (cfg.qemu_kvm) {
      enable = true;
      qemu = {
        runAsRoot = true;
        ovmf = {
          packages = [ pkgs.OVMFFull.fd ];
          enable = true;
        };
      };
    };

    programs.virt-manager.enable = lib.mkIf (cfg.qemu_kvm) true;
  };
}
