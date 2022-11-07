{ config, lib, pkgs, ... }:

with pkgs;
let
  	my-python-packages = python-packages: with python-packages; [
    		pandas
                requests
                python-lsp-server
                jupyter
                ipython
                ipykernel
                nltk
                spacy
                scikit-learn
                numpy
                pytorchWithoutCuda
    	];
	python-with-my-packages = python39.withPackages my-python-packages;
        unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
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
        ## daily use
                unstable.discord
                flameshot
        ## eduroam
        #openssl
        #cacert
        ## entertainment
        ani-cli
        ## jupyter notebooks
        vscodium-fhs
	];



	
}


