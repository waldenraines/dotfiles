{ colors }:

let
  pkgs = import <nixpkgs> { config = { allowUnfree = true; }; };

  mpv-focus-prev = pkgs.writeShellScriptBin "mpv-focus-prev"
    (builtins.readFile ./scripts/mpv-focus-prev.sh);
in
{
  settings = {
    "window_gap" = 10;
    "top_padding" = 25;
    "border_width" = 2;
    "focus_follows_pointer" = true;
    "normal_border_color" = colors.border.unfocused;
    "active_border_color" = colors.border.unfocused;
    "focused_border_color" = colors.border.focused;
  };

  monitors = {
    "eDP1" = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "videos"];
  };

  rules = {
    "mpv" = {
      state = "fullscreen";
      desktop = "videos";
      follow = true;
    };

    "Zathura" = {
      state = "tiled";
    };
  };

  startupPrograms = [
    "${pkgs.fusuma}/bin/fusuma"
    "${pkgs.unclutter-xfixes}/bin/unclutter -idle 10"
    "${pkgs.xbanish}/bin/xbanish"
    "PATH=$PATH:${pkgs.xdo}/bin:${pkgs.bspwm}/bin ${mpv-focus-prev}/bin/mpv-focus-prev"
  ];

  extraConfig = ''
    # lower key rate to prevent double letters
    xset r rate 250 60

    keyctl link @u @s

    systemctl --user start pulseaudio.service
    systemctl --user restart polybar.service
  '';
}
