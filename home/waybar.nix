{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 10;
        modules-left = ["custom/nixos" "group/hardware"];
        modules-center = ["hyprland/workspaces"];
        modules-right = ["clock" "battery" "network" "custom/power"];

        "custom/nixos" = {
          format = "       ";
          tooltip = false;
          on-click = "firefox -new-window https://search.nixos.org/packages";
        };

        "custom/power" = {
          format = "";
          on-click = "wlogout";
          tooltip = false;
        };

        "network" = {
          format = "{ifname}";
          format-wifi = "   {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "";
          tooltip-format = "{ifname}";
          tooltip-format-wifi = "   {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "  {ifname} ({ipaddr}/{cidr})";
          tooltip-format-disconnected = "Disconnected";
          on-click = "nm-connection-editor";
        };

        bluetooth = {
          format = " {status}";
          format-off = " {status}";
          format-disabled = "";
          format-connected = " ({num_connections})";
          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          on-click = "blueman-manager";
        };

        "hyprland/workspaces" = {
          active-only = false;
          disable-scroll = true;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
            empty = "";
            persistent = "";
            special = "";
            urgent = "";
          };
          persistent-workspaces = {
            "*" = 3;
          };
        };

        clock = {
          interval = 60;
          format = "  {=%H=%M}";
          timezone = "Europe/Rome";
          tooltip = false;
        };

        cpu = {
          interval = 60;
          format = "{usage}%  ";
          on-click = "hyprctl dispatch exec [float\\; size 1000 600\\; center\\(1\\)] kitty btop";
        };

        memory = {
          interval = 60;
          format = "{}%  ";
          on-click = "hyprctl dispatch exec [float\\; size 1000 600\\; center\\(1\\)] kitty btop";
        };

        disk = {
          interval = 60;
          format = "{percentage_used}%  ";
          on-click = "hyprctl dispatch exec [float\\; size 1000 600\\; center\\(1\\)] kitty btop";
        };

        "custom/system" = {
          format = "";
          tooltip = false;
          on-click = "hyprctl dispatch exec [float\\; size 1000 600\\; center\\(1\\)] kitty btop";
        };

        "group/hardware" = {
          orientation = "inherit";
          modules = ["custom/system" "cpu" "memory" "disk" "bluetooth" "pulseaudio"];
          drawer = {
            transition-duration = 300;
            transition-left-to-right = false;
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" " " " "];
          };
        };

        battery = {
          states = {
            warning = 30;
            critical = 20;
          };
          format = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };
      };
    };
  };
}
