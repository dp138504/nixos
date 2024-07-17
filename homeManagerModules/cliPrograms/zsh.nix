{  lib, config, pkgs, ...}:
{

  options = {
    zsh.enable = lib.mkEnableOption "Enables zsh customization";
  };
  
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "half-life";
        plugins = [ "git" "tmux" "sudo" ];
      };
      envExtra = lib.mkIf config.tmux.enable ''
        if [ -x "$(command -v tmux)" ] && [ -n "''${DISPLAY}" ] && [ -z "''${TMUX}" ]; then
          exec tmux new-session -A -s ''${USER} >/dev/null 2>&1
        fi
      '';
    };
  };
}
