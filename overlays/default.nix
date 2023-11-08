# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs {pkgs = final;};

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    polybar = prev.polybar.overrideAttrs (old: {
      src = prev.fetchFromGitHub {
        rev = "v3.7.0";
	hash = "sha256-ccFAHyhDuOVuMjytqQCaRiecRwgdDJbNSuszAKfCMnE=";
	owner = "polybar";
	repo = "polybar";
	fetchSubmodules = true;
      };
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}

