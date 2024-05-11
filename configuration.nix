{ config, lib, pkgs, agenix, nix-colors, ... }:
let
        system = "x86_64-linux";
in
{
    #nixpkgs.config.allowUnfree = true;
  imports =
    [ # Include the results of the hardware scan. 
      	./hardware-configuration.nix
        nix-colors.homeManagerModules.default

	    #home-manager.nixosModules.default 
    ];

	nix.settings.experimental-features = ["nix-command" "flakes"];

    # Use the systemd-boot EFI boot loader.
  	# boot.loader.systemd-boot.enable = true;
  	# boot.loader.systemd-boot.configurationLimit = 5;
  	# boot.loader.efi.canTouchEfiVariables = true;
    
    colorScheme = {
    slug = "adamsmasher";
    name = "AdamSmasher";
    author = "Carlos Craveiro (https://github.com/CarlosCraveiro)";
    palette = {
      base00 = "#01000E";
      base01 = "#071923";
      base02 = "#192A24";
      base03 = "#595495";
      base04 = "#A0C7E5";
      base05 = "#FC3636";
      base06 = "#17263B";
      base07 = "#FC3636"; # Left unset
      base08 = "#49EF8C";
      base09 = "#D1F640";
      base0A = "#7BA9EF";
      base0B = "#509999";
      base0C = "#64D6BE";
      base0D = "#C2D1CC";
      base0E = "#FBD9AB";
      base0F = "#912626";
    };
  };  	
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


#networking.nameservers = ["1.1.1.1" "9.9.9.9"];
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
	
    services = {
        
        displayManager = {
			defaultSession = "none+i3";
			#lightdm.enable = true;
			autoLogin.enable = true;
			autoLogin.user = "coveiro";
		};
        
        xserver = {
		    enable = true;
	        #extraConfig = ''
            #Section "Device"
            #    Identifier "Intel Graphics"
            #    Driver "Intel"
            #EndSection
            #'';
            monitorSection = ''
                
            '';

    	    xkb.layout = "br,us,jp";
		    xkb.variant = ",alt-intl,kana";
		    xkb.options = "grp:win_space_toggle";

		    desktopManager = {
			    xterm.enable = false;
		    };

		displayManager = {
	#		defaultSession = "none+i3";
			lightdm.enable = true;
	#		autoLogin.enable = true;
	#		autoLogin.user = "coveiro";
		};
		
		    windowManager.i3 = {
			    enable = true;	
			    extraPackages = with pkgs ;[
				    dmenu
				    i3status
                    i3lock-fancy-rapid
			    ];
		    };
	    };
    };
   
   programs.xss-lock = {
        enable = true;
        extraOptions = [
            "--transfer-sleep-lock"
        ]; # 5 pixel
        lockerCommand = "${pkgs.i3lock-fancy-rapid}/bin/i3lock-fancy-rapid 5 pixel -k --inside-color=#${config.colorScheme.palette.base00} --ring-color=#${config.colorScheme.palette.base0C} --insidever-color=#${config.colorScheme.palette.base00} --ringver-color=#${config.colorScheme.palette.base0A} --insidewrong-color=#${config.colorScheme.palette.base00} --ringwrong-color=#${config.colorScheme.palette.base05} --keyhl-color=#${config.colorScheme.palette.base08} --bshl-color=#${config.colorScheme.palette.base0F} --verif-color=#${config.colorScheme.palette.base04} --wrong-color=#${config.colorScheme.palette.base04} --modif-color=#${config.colorScheme.palette.base04} --layout-color=#${config.colorScheme.palette.base0C} --time-color=#${config.colorScheme.palette.base0C} --date-color=#${config.colorScheme.palette.base0C} --greeter-color=#${config.colorScheme.palette.base0C}";
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
    simulide
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
    bat
    just
    tomato-c
    texliveFull
    statix
    alejandra
    retroarchFull
    tree
    cowsay
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
  services.openssh = {
    enable = true;
    settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
    };
  };

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
