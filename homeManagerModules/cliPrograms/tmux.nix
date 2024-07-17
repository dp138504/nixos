{
  lib,
  config,
  pkgs,
  ...
}:
{

  options = {
    tmux.enable = lib.mkEnableOption "Enables tmux";
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      historyLimit = 100000;
      prefix = "C-a";
      baseIndex = 1;
      clock24 = true;
      mouse = true;
      newSession = true;
      keyMode = "vi";
      plugins = with pkgs; [
        tmuxPlugins.gruvbox
        {
          plugin = tmuxPlugins.gruvbox;
          extraConfig = "set -g @tmux-gruvbox 'dark'";
        }
      ];

      extraConfig = ''
        unbind '"'
        unbind '%'
        bind "|" split-window -hc "#{pane_current_path}"
        bind "\\" split-window -hc "#{pane_current_path}"
        bind "-" split-window -vc "#{pane_current_path}"
        bind "_" split-window -vc "#{pane_current_path}"
        bind C command-prompt -p "Session Name:" "new-session -A -s '%%'"
        bind X confirm kill-session

        set-option -g allow-rename off
        set-option -g detach-on-destroy off
        set -g renumber-windows on
      '';
    };
  };
}
