{ colors }:

{
  settings = {
    "border_width" = 2;
    "window_gap" = 25;
    "normal_border_color" = colors.normal_border;
    "active_border_color" = colors.active_border;
    "focused_border_color" = colors.focused_border;
  };

  monitors = {
    "focused" = [ "1" "2" "3" "4" "5" ];
  };

  rules = {
    "Zathura" = {
      state = "tiled";
    };
  };
}
