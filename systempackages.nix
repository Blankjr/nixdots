{ config, lib, pkgs, ... }:

with pkgs;
let
  	my-python-packages = python-packages: with python-packages; [
    		pandas
                requests
                python-lsp-server

    	];
	python-with-my-packages = python39.withPackages my-python-packages;
in
{
	nixpkgs.config.allowUnfree = true;
	nixpkgs.overlays = [
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
		#(import (builtins.fetchTarball {
		#	url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
		#}))
 	];
	environment.systemPackages = with pkgs; [
	## developement
		python-with-my-packages

	];



	
}


