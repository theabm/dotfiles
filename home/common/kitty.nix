{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = "no";
      font_size = 15;
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      background_opacity 0.8
      include colors-kitty.conf
    '';
    shellIntegration.enableFishIntegration = true;
  };
}
