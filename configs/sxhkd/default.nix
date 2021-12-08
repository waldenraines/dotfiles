let
  pkgs = import <nixpkgs> { };

  winhide = pkgs.writeShellScriptBin "winhide"
    (builtins.readFile ./winhide.sh);
in
{
  keybindings = {
    # Reload sxhkd
    "super + Escape" = "pkill -USR1 -x sxhkd";

    # Get a shell or launch some other terminal based program
    "super + Return" = "alacritty";
    "super + t" = "alacritty -e gotop";
    "super + Home" = "alacritty -e lf ~";
    "super + a" = ''
      alacritty -e calcurse \
        -C ${builtins.toString ../calcurse} \
        -D $SYNCDIR/share/calcurse
    '';

    # Open the web browser 
    "super + w" = "qutebrowser";

    # Launch the program runner and the file opener
    "super + space" = "dmenu-run";
    "super + o" = "dmenu-open";

    # Open wifi, bluetooth and shutdown menus
    "alt + shift + b" = "dmenu-bluetooth";
    "alt + shift + w" = "dmenu-wifi";
    "alt + shift + p" = "dmenu-powermenu";
    "alt + shift + a" = "dmenu-pulseaudio";

    # lockscreen
    "alt + shift + x" = "betterlockscreen -l dim";

    # Toggle fullscreen
    "super + {f,d,g}" = "bspc node -t {~fullscreen,tiled,fullscreen}";

    # Toggle window gaps, borders and paddings
    "super + i" = "toggle-gaps";

    # Toggle float
    "super + b" = "bspc node -t ~floating";

    # Focus windows
    "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";

    # Swap windows
    "super + ctrl + {h,j,k,l}" = "bspc node -s {west,south,north,east}";

    # Warp windows
    "super + shift + {Up,Down,Left,Right}" = "bspc node -n {north,south,west,east}";

    # Kill windows
    "super + q" = "bspc node -k";

    # Rotate trees
    "super + {_,shift + }r" = "bspc node @/ -R {90,-90}";

    # Make windows larger
    "super + alt + {Left,Down,Up,Right}" = 
      "bspc node -z {left -25 0,bottom 0 25,top 0 -25,right 25 0}";

    # Make windows smaller
    "super + ctrl + {Left,Down,Up,Right}" = 
      "bspc node -z {right -25 0,top 0 25,bottom 0 -25,left 25 0}";

    # Balance and mirror desktops
    "super + alt + {b,y,x}" = "bspc node @/ {-B,-F vertical,-F horizontal}";

    # Focus or send window to the given desktop
    "super + shift + {Left,Right}" = "bspc desktop -f {prev,next}";

    # Focus or send window to the given desktop
    "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";

    # tdrop dropdown scratchpad
    "super + minus" =
      "tdrop -ma -w -4 alacritty";

    # hide/unhide window
    "super + shift + i" = "${winhide}/bin/winhide";

    # Control audio volume
    "XF86Audio{LowerVolume,RaiseVolume,Mute}" =
      "dmenu-pulseaudio --volume {lower,raise,toggle}";

    # Screenshot either the whole screen or a portion of it and send a
    # notification.
    "super + ctrl + {3,4}" = "flameshot {full, gui} -p ~/screenshots";
  };
}
