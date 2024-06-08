{
  pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
  stdenv,
  lib,
  fetchurl, 
  unzip
}:

stdenv.mkDerivation rec {
  version = "2.4.3";
  pname = "acrotex";
  name = "${pname}-${version}";
  outputs = ["out" "tex"];
  tlType = "run";

  src = fetchurl {
    url = "https://mirrors.ctan.org/macros/latex/contrib/acrotex.zip";
    sha256 = "sha256-QENWO4xLwVUm4MTJzKWFZD9Be/6wvhvcxxLVcuvolN8=";
  };

  buildInputs = [ unzip pkgs.texliveBasic];

  # Multiple files problem
  unpackPhase = ''
    runHook preUnpack

    unzip $src
    cd acrotex

    runHook postUnpack
  ''; 

  buildPhase = ''
    runHook preBuild

    latex *.ins

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $tex/tex/latex/acrotex
    cp -va *.{cls,def,clo,sty} $tex/tex/latex/acrotex
    mkdir -p $out/doc/latex/acrotex
    cp -va doc/* $out/doc/latex/acrotex

    runHook postInstall
  '';

  meta = {
    branch = "3";
    platforms = lib.platforms.unix;
  };
}
