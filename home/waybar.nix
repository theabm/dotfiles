{
  pkgs,
  lib,
  ...
}: let
  shared_config = import ./shared_config.nix;

  nixos-image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/theabm/dotfiles/main/home/nixos-icon.svg";
    sha256 = "sha256-Kl0+lC1dsnxPM+whYBxFj4adGNU+gxQiAnqKSCjaN4Q=";
  };
in {
  programs.waybar = {
    enable = true;
    settings = {
      laptopBar =
        {
          position = "top";
          output = "eDP-1";
          "hyprland/workspaces" = {
            active-only = false;
            disable-scroll = true;
            on-click = "activate";
            format = "{icon}";
            persistent_workspaces = {
              "1" = ["eDP-1"];
              "2" = ["eDP-1"];
              "3" = ["eDP-1"];
              "4" = ["eDP-1"];
              "5" = ["eDP-1"];
              "6" = ["eDP-1"];
              "7" = ["eDP-1"];
              "8" = ["eDP-1"];
              "9" = ["eDP-1"];
            };
          };
        }
        // shared_config;

      monitorBar =
        {
          position = "bottom";
          output = "DP-1";
          "hyprland/workspaces" = {
            active-only = false;
            disable-scroll = true;
            on-click = "activate";
            format = "{icon}";
            persistent_workspaces = {
              "1" = ["DP-1"];
              "2" = ["DP-1"];
              "3" = ["DP-1"];
              "4" = ["DP-1"];
              "5" = ["DP-1"];
              "6" = ["DP-1"];
              "7" = ["DP-1"];
              "8" = ["DP-1"];
              "9" = ["DP-1"];
            };
          };
        }
        // shared_config;
    };
    style = ''
      /*@import '/home/andres/.cache/wal/colors-waybar.css';*/
      * {
      	font-family: FontAwesome;
      	font-size: 100%;
      	margin: 0.2em;
      	padding: 0px;
      	border: none;
      }

      window#waybar {
        background: #1e1d24;
      	transition-property: background-color;
        	transition-duration: 0.5s;
      	opacity:0.8;
      }

      #workspaces {
      	/* background: #dee9ee; */
      	/* border-radius: 1em; */
      }

      #workspaces button{
      	transition: all 0.3s ease-in-out;
          min-width : 3em;
          color: #dee9ee;
      	/* border-radius: 1em; */
      	/*modifies shape of ball*/
      	padding: 0px 0.3em;
      	/*modifies space between circles and background*/
      	margin: 0.1em 0.3em;
      }

      #workspaces button.persistent{
          /* workspaces that are not active but have windows in it*/
          background: #718FC8;
          min-width: 3em;
          transition: all 0.3s ease-in-out;
      }

      #workspaces button.empty{
          /* workspaces that are shown in the bar but are empty*/
          background: #1e1d24;
          min-width: 3em;
          transition: all 0.3s ease-in-out;
      }

      #workspaces button.active{
      	background: purple;
      	/* make this button bigger so it stands out*/
      	min-width: 4em;
      	transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover{
      	background: purple;
      }

      #cpu {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #pulseaudio {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #battery {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 0px solid #dee9ee;
      	padding: 0em 1em;
      }

      #battery.good {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #battery.warning {
      	background: orange;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #battery.critical {
      	background: red;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #clock {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 0px solid #dee9ee;
      	padding: 0em 1em;
      }

      #memory {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #network {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 0px solid #dee9ee;
      	padding: 0em 1em;
      }

      #bluetooth {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }

      #disk {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 1px solid #dee9ee;
      	padding: 0em 1em;
      }


      #custom-power {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	padding: 0em 0.5em 0em 0em;
      	font-size: 1.2em;
      }

      #custom-nixos {
      	background-image: url('${nixos-image}');
      	background-position: right;
      	background-repeat: no-repeat;
      	background-size: contain;
      	padding: 0em;
      }

      #custom-system {
      	background: transparent;
      	color: #dee9ee;
      	/* border-radius: 1em; */
      	border: 0px solid #dee9ee;
      	padding: 0em 1em;
      }
    '';
  };
}
