{ pkgs, ... }:
{
	environment.systemPackages = [
		(pkgs.callPackage ./sddm-sugar-dark.nix {})
	];
}

