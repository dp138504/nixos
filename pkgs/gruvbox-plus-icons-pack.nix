{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
  lib ? pkgs.lib,
  stdenvNoCC ? pkgs.stdenvNoCC,
  gtk3,
  breeze-icons,
  gnome-icon-theme,
  hicolor-icon-theme
}:

stdenvNoCC.mkDerivation rec {
  pname = "gruvbox-plus-icon-pack";
  version = "4.0";
  meta = with lib; {
    description = "GruvboxPlus is an icon pack for Linux (KDE, XFCE, Gnome) based on and inspired by: Suru++, OneDark, Gruvbox icon pack, GruvboxMateria, and original Breeze Dark from KDE. GruvboxPlus is using color scheme from Gruvbox, both dark and light color palette. Icons were created with the thought of dark backgrounds, so it's recommended to use dark themes.";
    homepage = "https://github.com/SylEleuth/gruvbox-plus-icon-pack";
    maintainers = [ "Dylan A. Pitts" ];
    licenses = licenses.gpl3;
    platforms = platforms.linux;
  };

  src = pkgs.fetchFromGitHub {
    owner = "SylEleuth";
    repo = "gruvbox-plus-icon-pack";
    rev = "v4.0";
    sha256 = "sha256-KefCHHFtuh2wAGBq6hZr9DpuJ0W99ueh8i1K3tohgG8=";
  };

  nativeBuildInputs = [ gtk3 ];

  propagatedBuildInputs = [ breeze-icons gnome-icon-theme hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share/icons/Gruvbox-Plus-Dark
    rm README.md
    cp -r * $out/share/icons/Gruvbox-Plus-Dark
    for e in information warning; do
      for i in 16 24 32 48; do
        ln -s $out/share/icons/Gruvbox-Plus-Dark/emblems/$i/emblem-$e.svg $out/share/icons/Gruvbox-Plus-Dark/emblems/$i/dialog-$e.svg
      done
    done
  '';

  dontDropIconThemeCache = true;
}
