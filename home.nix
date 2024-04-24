{pkgs, inputs, lib, nix-colors, agenix, config, ...}:
{
    imports = [
        nix-colors.homeManagerModules.default
    ];
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
        
        home.packages = [ pkgs.atool pkgs.httpie ];
		
		services.dunst = {
			enable = true;
			iconTheme.name = "Adawaita";
			iconTheme.package = pkgs.gnome.adwaita-icon-theme;
			iconTheme.size = "96x96";
            settings = {
                global = {
                    mouse_middle_click = "context,close_current";
                };
            };
		};
		
		services.picom = {
			enable = true;
            settings = {
                corner-radius = 10;
            };
            opacityRules = [
                "85:class_g *= 'kitty'"
            ];
		};
        
        programs.sioyek = {
            enable = true;
            config = {
                "custom_background_color" = "#01000E"; #base00 hex
                "custom_text_color" = "#C2D1CC";#base0D hex

                "page_separator_color" = "#01000E";#base00 hex
                "search_highlight_color" = "#7BA9EF";#base0A hex
                "status_bar_color" = "#01000E";#base00 hex
                "status_bar_text_color" = "#C2D1CC";#base0D hex
                "ui_text_color" = "#C2D1CC";#base0D hex
                "ui_selected_text_color" = "#C2D1CC";#base0D hex
                "ui_background_color" = "#071923";#base01 hex
                "ui_selected_background_color" = "#595495";#base03 hex
                "background_color" = "#01000E";#base00 hex
                "visual_mark_color" = "0.3490196 0.3294118 0.5843137 0.2";# base03-dec-r base03-dec-g base03-dec-b
                "text_highlight_color" = "#595495";# base03 hex
                "link_highlight_color" = "#64D6BE";# base0C hex
                "synctex_highlight_color" = "#49EF8C";# base08 hex
                };
                bindings = {
                    "toggle_custom_color" = "<C-r>";
                };
            };
        age.secrets.nusp.file = builtins.toPath /home/coveiro/.config/nixos/secrets/nusp.age;
		programs.zsh = {
			enable = true;
            #autosuggestion.enable = true;
			initExtra = "eval \"$(direnv hook zsh)\"\n eval \"$(ssh-agent -s)\" >> /dev/null";
			shellAliases = let
                rawnusp = builtins.readFile config.age.secrets.nusp.path;
                nusp = builtins.replaceStrings ["\n" " "] ["" ""] rawnusp; 
            in{
				enmh_right = "xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1";
				enmh_left = "xrandr --output eDP-1 --auto --output HDMI-1 --auto --left-of eDP-1";
				matlab = "nix run gitlab:doronbehar/nix-matlab";
				zshell = "nix-shell --run zsh";
				vpnusp = "sudo openconnect --protocol=anyconnect --user=${nusp} --passwd-on-stdin --server=vpn.semfio.usp.br";
				sysconf = "nvim /home/coveiro/.config/nixos/configuration.nix";
				nixconf = "nvim /home/coveiro/.config/nixos/flake.nix";
				homeconf = "nvim /home/coveiro/.config/nixos/home.nix";
				ll = "ls -l";
				update = "sudo nixos-rebuild switch --flake '/home/coveiro/.config/nixos#roxanne'";
				cls = "clear";
				kssh = "kitty +kitten ssh";
			};
			
			oh-my-zsh = {
				enable = true;
				plugins = ["git"];
				theme = "xiong-chiamiov-plus";
			};
		};

		programs.kitty = {
			enable = true;
			settings = {
				enable_audio_bell = false;	
				confirm_os_window_close = 0;
			};	
		};
        
        programs.ranger = {
            enable = true;
        };
        
        programs.git = {
            enable = true;
            userName  = "CarlosCraveiro";
            userEmail = "carlos.craveiro@usp.br";
        };

		programs.neovim = 
        let
            toLua = str: "lua << EOF\n${str}\nEOF\n";
            toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
        in
        {
  			enable = true;	
			extraLuaConfig = ''
                ${builtins.readFile ./nvim/options.lua}
                ${builtins.readFile ./nvim/keymaps.lua}
                ${builtins.readFile ./nvim/colorscheme.lua} -- In future convert it in to package
            '';
			
			plugins = with pkgs.vimPlugins; [
				{
                    plugin = ale;
                    config = toLuaFile ./nvim/plugin/ale.lua;
                }
                {
                    plugin = deoplete-nvim;
                    config = toLuaFile ./nvim/plugin/deoplete-nvim.lua;
                }
                {
                    plugin = project-nvim;
                    config = toLuaFile ./nvim/plugin/project-nvim.lua;
                }
                {
                    plugin = vimtex;
                    config = toLuaFile ./nvim/plugin/vimtex.lua;
                }
				vim-floaterm
				nvim-notify
				vim-move
				vim-airline
				vim-airline-themes
                vim-just
                {
                    plugin = vim-fugitive;
                    #config = toLuaFile ./nvim/plugin/vim-pencil.lua;
                }
                {
                    plugin = vim-pencil;
                    config = toLuaFile ./nvim/plugin/vim-pencil.lua;
                }
                {
                    plugin = vim-markdown;
                    config = toLuaFile ./nvim/plugin/vim-markdown.lua;
                }
                {
                    plugin = neogit;
                    config = toLuaFile ./nvim/plugin/neogit.lua; 
                }

                {
                    plugin = neo-tree-nvim;
                    config = toLuaFile ./nvim/plugin/neo-tree.lua; 
                }
                {
                    plugin = nvim-cmp;
                    config = toLuaFile ./nvim/plugin/cmp.lua; 
                }
                {
                    plugin = vimtex;
                    config = toLuaFile ./nvim/plugin/vimtex.lua;
                }
                {
                    plugin = alpha-nvim;
                    config = toLuaFile ./nvim/plugin/alpha.lua;
                }
                {
                    plugin = telescope-nvim;
                    config = toLuaFile ./nvim/plugin/telescope.lua;
                }
                {
                    plugin = which-key-nvim;
                    config = toLuaFile ./nvim/plugin/whichkey.lua;
                }	
			];
		};	
		
		xsession = {
			enable = true;
			initExtra = "feh Downloads/lovedeathandrobots.jpg --bg-fill; wpctl set-mute @DEFAULT_AUDIO_SINK@ 1; numlockx on";
			windowManager.i3 = {
    				enable = true;
				extraConfig = "
				default_border pixel 0
				";
				config = {
					window.hideEdgeBorders = "both";
					modifier = "Mod4";
					terminal = "kitty";

					gaps = {
						inner = 6;
						outer = 12;
                        smartBorders = "on";
                        smartGaps = true;

					};
					keybindings = lib.mkOptionDefault {
			#"XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status";
			#"XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status";
  			#"XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status";
			
			"XF86AudioRaiseVolume" = "exec --no-startup-id ~/Scripts/locochoco-volume raise && $refresh_i3status";
			"XF86AudioLowerVolume" = "exec --no-startup-id ~/Scripts/locochoco-volume lower && $refresh_i3status";
			"XF86AudioMute"        = "exec --no-startup-id ~/Scripts/locochoco-volume mute && $refresh_i3status";
					
			"XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status";
			"XF86MonBrightnessUp" = "exec --no-startup-id light -A 10 && dunstify -i /run/current-system/sw/share/icons/Adwaita/96x96/status/display-brightness-symbolic.symbolic.png -t 1500 -h int:value:$(light | cut -d. -f1) -h string:synchronous:brightness \"Brightness $(light | cut -d. -f1)%\" -r 1000";
			"XF86MonBrightnessDown" = "exec --no-startup-id light -U 10 && dunstify -i /run/current-system/sw/share/icons/Adwaita/96x96/status/display-brightness-symbolic.symbolic.png -t 1500 -h int:value:$(light | cut -d. -f1) -h string:synchronous:brightness \"Brightness $(light | cut -d. -f1)%\" -r 1000";	
			"Print" = "exec --no-startup-id import ~/Images/Screenshots/Screenshot-$(date +\"%Y-%m-%d_%H-%M-%S\").png"; 

            # xclip -sel clip -t image/png ~/Images/Screenshots/Screenshot-$(date +\"%Y-%m-%d_%H-%M-%S\").png"; -- alternativa para passar p clipboard

					};	
				};
			};
		};		
  		home.stateVersion = "23.11";
}
