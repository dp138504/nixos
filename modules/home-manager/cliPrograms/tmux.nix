{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.profiles.home.tmux;
in
{

  options = {
    profiles.home.tmux.enable = lib.mkEnableOption "Enables tmux";
  };

  config = lib.mkIf cfg.enable {
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
        {
          plugin = tmuxPlugins.gruvbox;
          extraConfig = "set -g @tmux-gruvbox 'dark'";
        }
        {
          plugin = additionalTmuxPlugins.tmux-window-name; # defined in pkgs
          extraConfig = ''
            # tmux-window-name
            # set -g @tmux_window_name_log_level "'DEBUG'"
            # set -g @tmux_window_name_substitute_sets "[('/home/${config.home.username}/.nix-profile/bin/(.+) --.*', r'\\g<1>')]"
            set -g @tmux_window_name_dir_programs "['nvim', 'vim', 'vi', 'git', '${pkgs.nvim-pkg}/bin/nvim']"
            set -g @tmux_window_name_show_program_args "False"
            set -g @tmux_window_name_use_tilde "True"
          '';
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

        set-environment -g TMUX_WINDOW_NAME_PATH '${pkgs.additionalTmuxPlugins.tmux-window-name}/share/tmux-plugins'
      '';
    };
  };
}
