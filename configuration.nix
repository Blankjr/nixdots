# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
      ./video
      ./systempackages.nix
      ./ownPkgs
    ];
  
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # enable flakes & add binary Caches for AwesomeWM Git etc. 
  nix = {
		autoOptimiseStore = true;
		package = pkgs.nixFlakes; #enables flakes
		extraOptions = ''
   			experimental-features = nix-command flakes 
		'';
		settings = { #cachix 👍
			substituters = [
				"https://cache.nixos.org?priority=10"
				"https://fortuneteller2k.cachix.org"
			];
			trusted-public-keys = [
				"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
				"fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
			];
		};
	};


  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  console.useXkbConfig = true;
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
    xkbOptions = "caps:escape";

    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager = {
    #gdm.enable = true;
    sddm = {
      enable = true;
      theme = "sugar-dark";
    };
    defaultSession = "none+awesome";
    };
    #defaultSession = "none+awesome";
    #windowManager.awesome = {
    #enable = true;
    #};
  };
  environment.shells = with pkgs; [ zsh ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.christian = {
    isNormalUser = true;
    description = "Christian ";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
    #  firefox
    #  thunderbird
    ];
  };
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # Awesomewm.git included in Overlay 
  nixpkgs.overlays = [
		(builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
		#(import (builtins.fetchTarball {
		#	url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
		#}))
 	];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox-devedition-bin
  ## development
    neovim
    git
    kitty
    stow
    gh
    lazygit
    zoxide
    fzf
  ## system utilities
    btop
    unzip
    speedcrunch
    tealdeer
    exa
    bat
    du-dust
    duf
    xarchiver
  ## awesome wm
    copyq
    brightnessctl
    playerctl
    pamixer
    pcmanfm

  ## neovim dependencies
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.tailwindcss
    stylua
    nodePackages.prettier_d_slim
    nodePackages.prettier
  ## tutorials
    nodePackages.live-server
  ## LF File Manager
    lf
    trash-cli
  ## Daily use
    mpv
    nsxiv
    zathura
    glow
    thunderbird-bin
    keepassxc
  ## University
    teams
  ## themes
  #libsForQt5.qt5.qtgraphicaleffects
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  home-manager.users.christian = { pkgs, ...}: {
      #xresources.extraConfig = import ./video/theming/xresources.nix { inherit theme; };
      gtk = {
              enable = true;
              font = {
                      name = "Lato";
                      size = 12;
              };
              iconTheme = {
                      name = "Papirus-Dark";
                      package = pkgs.papirus-icon-theme;
              };
              cursorTheme = {
                      name = "Phinger Cursors (light)";
                      package = pkgs.phinger-cursors;
                      size = 24;
              };
              theme = {
                      name = "Materia-dark";
                      package = pkgs.materia-theme;
              };
            };

    home.packages = with pkgs;[ htop tmux ];
    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        la = "ls -A";
        update = "sudo nixos-rebuild switch";
        nvimconfig = "sudo -E -s nvim ~/.nixdots/configuration.nix";
        gg = "lazygit";
        v = "nvim";
        cd1 = "cd ..";
        cd2 = "cd ../../";
        cd3 = "cd ../../..";
        cd4 = "cd ../../../..";
        cd5 = "cd ../../../../..";
        c = "clear";
        # zoxide
        #cd="z";
        #zz= "z -";
        # tealdeer
        fman = "tldr";
        # utilities
        du="dust";
        df="duf";
        # media
        # i="nsxiv $1 /dev/null &> /dev/null &; disown";
        # p="zathura $1 < /dev/null &> /dev/null &; disown";
        i="nsxiv";
        p="zathura";
        
      };
      history = {
        size = 10000;
        #path = "${config.xdg.dataHome}/zsh/history";
      };
      zplug = {
        enable = false;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
        ];
      };
    };
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };
    # gtk.iconTheme.package = pkgs.papirus-icon-theme;
    # gtk.iconTheme.name = "Papirus-Dark";
    # gtk.theme.package = pkgs.materia-theme;
    # gtk.theme.name = "Materia-dark-compact";
  };

}
