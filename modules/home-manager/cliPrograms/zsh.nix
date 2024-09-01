{ lib, config, ... }:
let
  cfg = config.profiles.home;
in
{

  options = {
    profiles.home.zsh.enable = lib.mkEnableOption "Enables zsh customization";
  };

  config = lib.mkIf cfg.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "half-life";
        plugins = [
          "git"
          "tmux"
          "sudo"
        ];
      };
      envExtra = lib.mkIf cfg.tmux.enable ''
        if [ -x "$(command -v tmux)" ] && [ -n "''${DISPLAY}" ] && [ -z "''${TMUX}" ]; then
          exec tmux new-session -A -s ''${USER} >/dev/null 2>&1
        fi
      '';
    };
  };
}
