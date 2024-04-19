{  pkgs, ...}:
{
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
      tmuxPlugins.gruvbox {
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

      set-option -g allow-rename off
      set -g renumber-windows on
    '';
  };
}
