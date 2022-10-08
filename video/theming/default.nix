{ config, pkgs, ... }:
let
	gtkconfig = ''
	 [Settings]
	 gtk-icon-theme-name=Papirus
	 gtk-theme-name=Orchis-green-dark
	 gtk-cursor-theme-size=16
	'';
in {
	services.xserver = {
		# enable = true;
		# layout = "de";
		libinput = {
			enable = true;
		};
		displayManager = {
			sddm = {
				enable = true;
				theme = "sugar-dark";
			};
		};
	};

	environment.systemPackages = with pkgs; [
		papirus-maia-icon-theme
		phinger-cursors
		orchis-theme
		libsForQt5.qtstyleplugins
		libsForQt5.qt5.qtgraphicaleffects
	];
	environment.etc = {
		"xdg/gtk-3.0/settings.ini" = {
			text = "${gtkconfig}";
			mode = "444";
		};
	};
}


