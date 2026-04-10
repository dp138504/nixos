{ lib, config, pkgs, ... }:
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
        theme = "half-life-mod";
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
      initContent = 
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          export ZSH_CUSTOM="${config.home.homeDirectory}/.oh-my-zsh/custom"
        '';
        zshConfig = lib.mkOrder 1000 ''
          tmux-window-name() {
            (${pkgs.additionalTmuxPlugins.tmux-window-name}/share/tmux-plugins/tmux-window-name/scripts/rename_session_windows.py &)
          }

           add-zsh-hook chpwd tmux-window-name
        '';
      in lib.mkIf cfg.tmux.enable (lib.mkMerge [ zshConfigEarlyInit zshConfig ]);

    };
    home.file.".oh-my-zsh/custom/themes/half-life-mod.zsh-theme".source = ./half-life-mod.zsh-theme;
  };
}
