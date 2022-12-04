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
                gensim
                tqdm
    	];
	python-with-my-packages = python39.withPackages my-python-packages;
 #  	rasa-python-packages = python-packages: with python-packages; [
 #                rasa
 #    	];
	# python-with-rasa = python38.withPackages rasa-python-packages;
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
		# python-with-rasa
                micromamba
                unstable.insomnia
                ## java
                # jdk11
        ## daily use
                unstable.discord
                flameshot
        ## eduroam
        #openssl
        #cacert
        ## entertainment
        unstable.ani-cli
        unstable.ffmpeg
        unstable.axel
        ## jupyter notebooks
        vscodium-fhs
	];



	
}


