{
  programs.nixvim.plugins = {
    hardtime = {
      enable = true;
      allowDifferentKey = true;
      maxCount = 1;
      extraOptions = {
        hardtime_motion_with_count_resets = 1;
      };
    };
  };
}
