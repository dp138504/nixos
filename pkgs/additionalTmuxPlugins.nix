{ pkgs, lib, ... }:
let
  pythonInputs = (
    pkgs.python312.withPackages (
      p: with p; [
        libtmux
        pip
      ]
    )
  );
in
{
  tmux-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-window-name";
    version = "28bbe2a";
    src = pkgs.fetchFromGitHub {
      owner = "ofirgall";
      repo = "tmux-window-name";
      rev = "28bbe2a117bf728087fc41f6c9892b45bae01c90";
      hash = "sha256-miUPJeT7N1K8K+Gry46wO7iYsWtIzEC6kJWvW9syrI0=";
    };
    nativeBuildInputs = [ pkgs.makeWrapper ];
    rtpFilePath = "tmux_window_name.tmux";
    postInstall = ''
      # NIX_BIN_PATH="${builtins.getEnv "HOME"}/.nix-profile/bin"
      NIX_BIN_PATH="/nix/store"
      # Update USR_BIN_REMOVER with .nix-profile PATH
      sed -i "s|^USR_BIN_REMOVER.*|USR_BIN_REMOVER = (r\'^$NIX_BIN_PATH/(?:.*/)(.*)\', r\'\\\g<1>\')|" $target/scripts/rename_session_windows.py

      # Update substitute_sets with .nix-profile PATHs
      sed -i "s|^\ssubstitute_sets: List.*|    substitute_sets: List[Tuple] = field(default_factory=lambda: [(\'/$NIX_BIN_PATH/(.+) --.*\', r\'\\\g<1>\'), (r\'.+ipython([32])\', r\'ipython\\\g<2>\'), USR_BIN_REMOVER, (r\'(bash) (.+)/(.+[ $])(.+)\', r\'\\\g<3>\\\g<4>\')])|" $target/scripts/rename_session_windows.py

      # Update dir_programs with .nix-profile PATH for applications
      sed -i "s|^\sdir_programs: List.*|    dir_programs: List[str] = field(default_factory=lambda: [["$NIX_BIN_PATH/vim", "$NIX_BIN_PATH/vi", "$NIX_BIN_PATH/git", "$NIX_BIN_PATH/nvim"]])|" $target/scripts/rename_session_windows.py

      for f in tmux_window_name.tmux scripts/rename_session_windows.py; do
        wrapProgram $target/$f \
          --prefix PATH : ${lib.makeBinPath [ pythonInputs ]}
      done
    '';
  };
}
