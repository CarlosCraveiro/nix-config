{ config, lib, pkgs, agenix, ... }:
let
        system = "x86_64-linux";
in
{
    #nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan. 
      	./hardware-configuration.nix
	    #home-manager.nixosModules.default 
    ];

	nix.settings.experimental-features = ["nix-command" "flakes"];

    # Use the systemd-boot EFI boot loader.
  	# boot.loader.systemd-boot.enable = true;
  	# boot.loader.systemd-boot.configurationLimit = 5;
  	# boot.loader.efi.canTouchEfiVariables = true;
  	
    boot.loader.grub.enable = true;
    boot.loader.grub.configurationLimit = 5;
    boot.loader.grub.copyKernels           = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.efiSupport            = true;
    boot.loader.grub.fsIdentifier          = "label";
    boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
        pname = "yorha-grub-themes";
        version = "3.1";
        src = pkgs.fetchFromGitHub {
            owner = "CarlosCraveiro";
            repo = "yorha-grub-theme";
            rev = "v1.0";
            hash = "sha256-XVzYDwJM7Q9DvdF4ZOqayjiYpasUeMhAWWcXtnhJ0WQ=";
        };
        installPhase = "cp -r ./yorha-1920x1080 $out";
    };
    boot.loader.grub.useOSProber = true;
    boot.loader.grub.devices               = [ "nodev" ];
    boot.loader.grub.extraEntries = ''
    menuentry "Reboot" {
      reboot
    }
    menuentry "Poweroff" {
      halt
    }
  '';

  networking.hostName = "roxanne"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
#age.secretsDir = ./secrets;
#age.secrets.eduruim.file =  builtins.toPath /home/coveiro/.config/nixos/secrets/eduruim.age;
age.secrets.casa_dollars5g.file = builtins.toPath /home/coveiro/.config/nixos/secrets/casa_dollars5g.age;
age.secrets.nusp.file = builtins.toPath /home/coveiro/.config/nixos/secrets/nusp.age;
age.secrets.susp.file = builtins.toPath /home/coveiro/.config/nixos/secrets/susp.age;
age.secrets.celular_dollars.file = builtins.toPath /home/coveiro/.config/nixos/secrets/celular_dollars.age;
age.secrets.casa_bia.file = builtins.toPath /home/coveiro/.config/nixos/secrets/casa_bia.age;
age.secrets.casa_fael5g.file = builtins.toPath /home/coveiro/.config/nixos/secrets/casa_fael5g.age;
age.secrets.vonbraunsanca.file = builtins.toPath /home/coveiro/.config/nixos/secrets/vonbraunsanca.age;
age.secrets.casa_jade5g.file = builtins.toPath /home/coveiro/.config/nixos/secrets/casa_jade5g.age;
age.secrets.casa_fortal.file = builtins.toPath /home/coveiro/.config/nixos/secrets/casa_fortal.age;
age.secrets.casa_talma.file = builtins.toPath /home/coveiro/.config/nixos/secrets/casa_talma.age;
age.secrets.jade_rioclaro.file = builtins.toPath /home/coveiro/.config/nixos/secrets/jade_rioclaro.age;


networking.nameservers = ["1.1.1.1" "9.9.9.9"];
networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = {
      eduroam =
      let
        rawnusp = builtins.readFile config.age.secrets.nusp.path;
        nusp = builtins.replaceStrings ["\n" " "] ["" ""] rawnusp; 
        rawsusp = builtins.readFile config.age.secrets.susp.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" " "] rawsusp;
      in
      {
        auth = ''
		proto=RSN
		key_mgmt=WPA-EAP
		pairwise=CCMP
		auth_alg=OPEN
		eap=PEAP
		identity="${nusp}@usp.br"
		password="${passwd}"
		phase2="auth=MSCHAPV2"
        '';
      };
      DOLLARS_5GHz =
      let
        raw = builtins.readFile config.age.secrets.casa_dollars5g.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
      	auth = ''
		    psk="${passwd}"
	    '';
      }; 
      VBC_PISO_2_B =
      let
      	raw = builtins.readFile config.age.secrets.vonbraunsanca.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
      Jade5G =
      let
      	raw = builtins.readFile config.age.secrets.casa_jade5g.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
      DOLARS_NET =
      let
      	raw = builtins.readFile config.age.secrets.celular_dollars.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
      Apto_201_5G =
      let
      	raw = builtins.readFile config.age.secrets.casa_fael5g.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
      "Laplace.net" =
      let
      	raw = builtins.readFile config.age.secrets.casa_bia.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    CLARO_2GF01F5B =
      let
      	raw = builtins.readFile config.age.secrets.casa_fortal.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    CLARO_5GF01F5B =
      let
      	raw = builtins.readFile config.age.secrets.casa_fortal.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    "TC NETWORK 5G_xt" =
      let
      	raw = builtins.readFile config.age.secrets.casa_talma.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    "TC NETWORK_xt" =
      let
      	raw = builtins.readFile config.age.secrets.casa_talma.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    CLARO_erados5g =
      let
      	raw = builtins.readFile config.age.secrets.jade_rioclaro.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    "Era dos Extremos" =
      let
      	raw = builtins.readFile config.age.secrets.jade_rioclaro.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    claroeradosextremos =
      let
      	raw = builtins.readFile config.age.secrets.jade_rioclaro.path;
        passwd = builtins.replaceStrings ["\n" " "] ["" ""] raw;
      in
      {
	auth = ''
		psk="${passwd}"
	'';
      };
    };
};

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";


	programs.zsh.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

	environment.pathsToLink = [ "/libexec" ]; 
	environment.variables.EDITOR = "nvim";
  # Enable the X11 windowing system.
	services.xserver = {
		enable = true;
		
    	xkb.layout = "br,us,jp";
		xkb.variant = ",alt-intl,kana";
		xkb.options = "grp:win_space_toggle";

		desktopManager = {
			xterm.enable = false;
		};

		displayManager = {
			defaultSession = "none+i3";
			lightdm.enable = true;
			autoLogin.enable = true;
			autoLogin.user = "coveiro";
		};
		
		windowManager.i3 = {
			enable = true;	
			extraPackages = with pkgs ;[
				dmenu
				i3status
				i3lock
			];
		};
	};
    
  ###############################
  ## Input Method Editor (IME) ##
  ###############################

  # This enables "fcitx" as your IME.  This is an easy-to-use IME.  It supports many different input methods.
  #i18n.inputMethod.enabled = "fcitx5";

  # This enables "mozc" as an input method in "fcitx".  This has a relatively
  # complete dictionary.  I recommend it for Japanese input.
  #i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-gtk ];
    
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

fonts = {
    packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];
};  

  # Enable CUPS to print documents.
  # services.printing.enable = true;

	# Enable bluetooth
	hardware.bluetooth.enable = true;	
	services.blueman.enable = true;

  # Enable sound.
	#hardware.pulseaudio.enable = true;
	#hardware.pulseaudio.support32Bit = true;
    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        jack.enable = true;
    };


  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

	# Sets Zsh as a default shell for any user	
	users.defaultUserShell = pkgs.zsh;	
  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.coveiro = {
	isNormalUser = true;
	home = "/home/coveiro";
	description = "Carlos Craveiro";
     	extraGroups = [ "video" "wheel" "audio" "optical" ];
	packages = with pkgs; [
	];
   };

#	home-manager.users.coveiro = { config, pkgs, lib, ... }: {
#  		home.packages = [ pkgs.atool pkgs.httpie ];
#		
#		services.dunst = {
#			enable = true;
#			iconTheme.name = "Adawaita";
#			iconTheme.package = pkgs.gnome.adwaita-icon-theme;
#			iconTheme.size = "96x96";
#            settings = {
#                global = {
#                    mouse_middle_click = "context,close_current";
#                };
#            };
#		};
#		
#		services.picom = {
#			enable = true;
#            settings = {
#                corner-radius = 10;
#            };
#            opacityRules = [
#                "85:class_g *= 'kitty'"
#            ];
#		};
#        
#        programs.sioyek = {
#            enable = true;
#            config = {
#                "custom_background_color" = "#01000E"; #base00 hex
#                "custom_text_color" = "#C2D1CC";#base0D hex
#
#                "page_separator_color" = "#01000E";#base00 hex
#                "search_highlight_color" = "#7BA9EF";#base0A hex
#                "status_bar_color" = "#01000E";#base00 hex
#                "status_bar_text_color" = "#C2D1CC";#base0D hex
#                "ui_text_color" = "#C2D1CC";#base0D hex
#                "ui_selected_text_color" = "#C2D1CC";#base0D hex
#                "ui_background_color" = "#071923";#base01 hex
#                "ui_selected_background_color" = "#595495";#base03 hex
#                "background_color" = "#01000E";#base00 hex
#                "visual_mark_color" = "0.3490196 0.3294118 0.5843137 0.2";# base03-dec-r base03-dec-g base03-dec-b
#                "text_highlight_color" = "#595495";# base03 hex
#                "link_highlight_color" = "#64D6BE";# base0C hex
#                "synctex_highlight_color" = "#49EF8C";# base08 hex
#                };
#                bindings = {
#                    "toggle_custom_color" = "<C-r>";
#                };
#            };
#
#		programs.zsh = {
#			enable = true;
#			initExtra = "eval \"$(direnv hook zsh)\"\n eval \"$(ssh-agent -s)\" >> /dev/null";
#			shellAliases = {
#				enmh_right = "xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1";
#				enmh_left = "xrandr --output eDP-1 --auto --output HDMI-1 --auto --left-of eDP-1";
#				matlab = "nix run gitlab:doronbehar/nix-matlab";
#				zshell = "nix-shell --run zsh";
#				vpnusp = "sudo openconnect --protocol=anyconnect --user=12547187 --passwd-on-stdin --server=vpn.semfio.usp.br";
#				nixconf = "nvim /home/coveiro/.config/nixos/configuration.nix";
#				ll = "ls -l";
#				update = "sudo nixos-rebuild switch --flake '/home/coveiro/.config/nixos#roxanne'";
#				cls = "clear";
#				kssh = "kitty +kitten ssh";
#				tomato-c = "nix run github:gabrielzschmitz/Tomato.C";
#			};
#			
#			oh-my-zsh = {
#				enable = true;
#				plugins = ["git"];
#				theme = "xiong-chiamiov-plus";
#			};
#		};
#
#		programs.kitty = {
#			enable = true;
#			settings = {
#				enable_audio_bell = false;	
#				confirm_os_window_close = 0;
#			};	
#		};
#        
#        programs.ranger = {
#            enable = true;
#        };
#        
#        programs.git = {
#            enable = true;
#            userName  = "CarlosCraveiro";
#            userEmail = "carlos.craveiro@usp.br";
#        };
#
#		programs.neovim = 
#        let
#            toLua = str: "lua << EOF\n${str}\nEOF\n";
#            toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
#        in
#        {
#  			enable = true;	
#			extraLuaConfig = ''
#                ${builtins.readFile ./nvim/options.lua}
#                ${builtins.readFile ./nvim/keymaps.lua}
#                ${builtins.readFile ./nvim/colorscheme.lua} -- In future convert it in to package
#            '';
#			
#			plugins = with pkgs.vimPlugins; [
#				ale
#                {
#                    plugin = deoplete-nvim;
#                    config = toLuaFile ./nvim/plugin/deoplete-nvim.lua;
#                }
#				vim-floaterm
#				nvim-notify
#				vim-move
#				vim-airline
#				vim-airline-themes
#                {
#                    plugin = vim-fugitive;
#                    #config = toLuaFile ./nvim/plugin/vim-pencil.lua;
#                }
#                {
#                    plugin = vim-pencil;
#                    config = toLuaFile ./nvim/plugin/vim-pencil.lua;
#                }
#                {
#                    plugin = vim-markdown;
#                    config = toLuaFile ./nvim/plugin/vim-markdown.lua;
#                }
#                {
#                    plugin = neogit;
#                    config = toLuaFile ./nvim/plugin/neogit.lua; 
#                }
#
#                {
#                    plugin = neo-tree-nvim;
#                    config = toLuaFile ./nvim/plugin/neo-tree.lua; 
#                }
#                {
#                    plugin = nvim-cmp;
#                    config = toLuaFile ./nvim/plugin/cmp.lua; 
#                }
#                {
#                    plugin = vimtex;
#                    config = toLuaFile ./nvim/plugin/vimtex.lua;
#                }
#                {
#                    plugin = alpha-nvim;
#                    config = toLuaFile ./nvim/plugin/alpha.lua;
#                }
#                {
#                    plugin = telescope-nvim;
#                    config = toLuaFile ./nvim/plugin/telescope.lua;
#                }
#                {
#                    plugin = which-key-nvim;
#                    config = toLuaFile ./nvim/plugin/whichkey.lua;
#                }	
#			];
#		};	
#		
#		xsession = {
#			enable = true;
#			initExtra = "feh Downloads/lovedeathandrobots.jpg --bg-fill; wpctl set-mute @DEFAULT_AUDIO_SINK@ 1; numlockx on";
#			windowManager.i3 = {
#    				enable = true;
#				extraConfig = "
#				default_border pixel 0
#				";
#				config = {
#					window.hideEdgeBorders = "both";
#					modifier = "Mod4";
#					terminal = "kitty";
#
#					gaps = {
#						inner = 6;
#						outer = 12;
#                        smartBorders = "on";
#                        smartGaps = true;
#
#					};
#					keybindings = lib.mkOptionDefault {
#			#"XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status";
#			#"XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status";
#  			#"XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
#			
#			"XF86AudioRaiseVolume" = "exec --no-startup-id ~/Scripts/locochoco-volume raise && $refresh_i3status";
#			"XF86AudioLowerVolume" = "exec --no-startup-id ~/Scripts/locochoco-volume lower && $refresh_i3status";
#			"XF86AudioMute"        = "exec --no-startup-id ~/Scripts/locochoco-volume mute && $refresh_i3status";
#					
#			"XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
#			"XF86MonBrightnessUp" = "exec --no-startup-id light -A 10 && dunstify -i /run/current-system/sw/share/icons/Adwaita/96x96/status/display-brightness-symbolic.symbolic.png -t 1500 -h int:value:$(light | cut -d. -f1) -h string:synchronous:brightness \"Brightness $(light | cut -d. -f1)%\" -r 1000";
#			"XF86MonBrightnessDown" = "exec --no-startup-id light -U 10 && dunstify -i /run/current-system/sw/share/icons/Adwaita/96x96/status/display-brightness-symbolic.symbolic.png -t 1500 -h int:value:$(light | cut -d. -f1) -h string:synchronous:brightness \"Brightness $(light | cut -d. -f1)%\" -r 1000";	
#			"Print" = "exec --no-startup-id import ~/Images/Screenshots/Screenshot-$(date +\"%Y-%m-%d_%H-%M-%S\").png"; 
#
#            # xclip -sel clip -t image/png ~/Images/Screenshots/Screenshot-$(date +\"%Y-%m-%d_%H-%M-%S\").png"; -- alternativa para passar p clipboard
#
#					};	
#				};
#			};
#		};		
#  		home.stateVersion = "23.11";
#	};	
    
    xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
        config = {
            common.default = ["gtk"];
        };
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
   environment.systemPackages = with pkgs; [
    translate-shell
    newsflash
    stremio
    xdg-desktop-portal
    brave
    xdragon
	imagemagick
	okular
	zotero
	vim
	wget
	zsh
	kitty
	git
	neofetch
	btop
	feh
	zathura
	comma
	maim
	xclip
	verilator
	yosys
	ghdl
	rlwrap
	tcl
	tcllib
	links2
    distrobox
    qemu
	libnotify
	anki
	telegram-desktop
	openconnect
	anydesk
	direnv
	tldr
    agenix.packages.x86_64-linux.default
    (pkgs.sdcc.override { withGputils = true; })
    simulide # from minepkgs
    gputils
    podman
    kicad
    zip
    unzip
    onlyoffice-bin
    freecad
    mpv
    numlockx
    man-pages
    man-pages-posix
    inkscape
    uwufetch
    bat
  ];	

	programs.light.enable = true;
        
	#virtualisation.docker.enable = true;

        virtualisation.podman = {
            enable = true;
            dockerCompat = true;
    };



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

  # Man Pages
  documentation.dev.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

