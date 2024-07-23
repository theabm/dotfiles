{
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = "no";
      font_size = 15;
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      background_opacity 0.7
    '';
    shellIntegration.enableFishIntegration = true;
  };
}
