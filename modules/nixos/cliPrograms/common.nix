{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.profiles.common;
in
{
  options = {
    profiles.common = {
      enable = lib.mkEnableOption "Enable common settings such as localization and nix settings";
    };
  };

  config = lib.mkIf cfg.enable {

    # Nix language tweaks
    nix = {
      # This will add each flake input as a registry
      # To make nix3 commands consistent with your flake
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

      # This will additionally add your inputs to the system's legacy channels
      # Making legacy nix commands consistent as well, awesome!
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Deduplicate and optimize nix store
        auto-optimise-store = true;
      };
    };

    # Internationalization/localization settings
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    # East-coast TZ
    time.timeZone = "America/New_York";

    # Allow /etc/hosts to be writable for on-the-fly edits
    environment.etc.hosts.mode = "0644";

  };
}
