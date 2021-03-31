{ config, lib, pkgs, ... }:
let
  unstable = import <nixos-unstable> { };

  font = "roboto-mono";
  theme = "onedark";

  fonts-dir = ./fonts + "/${font}";
  themes-dir = ../../themes + "/${theme}";

  sync-dir = config.home.homeDirectory + "/Sync";
  secrets-dir = sync-dir + "/secrets";
  screenshots-dir = sync-dir + "/screenshots";
  scripts-dir = ./scripts;
  qutebrowser-userscripts-dir = ./scripts/qutebrowser;

  alacrittyConfig = lib.attrsets.recursiveUpdate
    (import ../../defaults/alacritty {
      font = import (fonts-dir + /alacritty.nix);
      colors = import (themes-dir + /alacritty.nix);
    })
    (import ./alacritty.nix {
      inherit pkgs;
    });

  batConfig = import ../../defaults/bat;

  bspwmConfig = (import ../../defaults/bspwm {
    colors = import (themes-dir + /bspwm.nix);
  });

  direnvConfig = import ../../defaults/direnv;

  dunstConfig = (import ../../defaults/dunst {
    font = import (fonts-dir + /dunst.nix);
    colors = import (themes-dir + /dunst.nix);
  });

  fdConfig = {
    ignores =
      (import ../../defaults/fd).ignores
      ++ (import ./fd.nix).ignores;
  };

  firefoxConfig = (import ../../defaults/firefox {
    font = import (fonts-dir + /firefox.nix);
    colors = import (themes-dir + /firefox.nix);
  });

  fishConfig = lib.attrsets.recursiveUpdate
    (import ../../defaults/fish {
      colors = import (themes-dir + /fish.nix);
    })
    (import ./fish.nix);

  fzfConfig = (import ../../defaults/fzf {
    colors = import (themes-dir + /fzf.nix);
  });

  gitConfig = lib.attrsets.recursiveUpdate
    (import ../../defaults/git)
    (import ./git.nix);

  lfConfig = lib.attrsets.recursiveUpdate
    (import ../../defaults/lf { })
    (import ./lf.nix { });

  picomConfig = import ../../defaults/picom;

  polybarConfig = (import ../../defaults/polybar {
    font = import (fonts-dir + /polybar.nix);
    colors = import (themes-dir + /polybar.nix);
    scripts-dir = scripts-dir;
  });

  qutebrowserConfig = (import ../../defaults/qutebrowser {
    font = import (fonts-dir + /qutebrowser.nix);
    colors = import (themes-dir + /qutebrowser.nix);
    userscripts-dir = qutebrowser-userscripts-dir;
  });

  rofiConfig = (import ../../defaults/rofi {
    font = import (fonts-dir + /rofi.nix);
    colors = import (themes-dir + /rofi.nix);
  });

  starshipConfig = import ../../defaults/starship;

  sxhkdConfig = (import ../../defaults/sxhkd {
    secrets-dir = secrets-dir;
    screenshots-dir = screenshots-dir;
    scripts-dir = scripts-dir;
  });

  sshConfig = import ../../defaults/ssh;

  tridactylConfig = (import ../../defaults/tridactyl {
    font = import (fonts-dir + /tridactyl.nix);
    colors = import (themes-dir + /tridactyl.nix);
  });

  vividConfig = (import ../../defaults/vivid {
    colors = import (themes-dir + /vivid.nix);
  });

  zathuraConfig = (import ../../defaults/zathura {
    font = import (fonts-dir + /zathura.nix);
    colors = import (themes-dir + /zathura.nix);
  });
in
{
  imports = [
    ../../modules/programs/fd.nix
    ../../modules/programs/tridactyl.nix
    ../../modules/programs/vivid.nix
  ];

  home = {
    username = "noib3";
    homeDirectory = "/home/noib3";
    stateVersion = "21.03";

    packages = with pkgs; [
      bitwarden
      calcurse
      chafa
      colorpicker
      evemu
      evtest
      feh
      file
      fusuma
      gcc
      gotop
      graphicsmagick-imagemagick-compat
      lazygit
      libnotify
      mediainfo
      neovim-nightly
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "RobotoMono"
        ];
      })
      nixpkgs-fmt
      nodejs
      noto-fonts-emoji
      ookla-speedtest-cli
      pfetch
      pick-colour-picker
      (python39.withPackages (
        ps: with ps; [
          ipython
        ]
      ))
      sxiv
      texlive.combined.scheme-full
      ueberzug
      unzip
      vimv
      xclip
      xdotool
      yarn
    ];

    sessionVariables = {
      COLORTERM = "truecolor";
      EDITOR = "nvim";
      HISTFILE = "${config.home.homeDirectory}/.cache/bash/bash_history";
      MANPAGER = "nvim -c 'set ft=man' -";
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LESSHISTFILE = "${config.home.homeDirectory}/.cache/less/lesshst";
      LS_COLORS = "$(vivid generate current)";
    };

    file = {
      ".ssh" = {
        source = "${secrets-dir}/ssh-keys";
        recursive = true;
      };

      ".icons/default" = {
        source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
      };
    };
  };

  nixpkgs.overlays = [
    (self: super: {
      direnv = unstable.direnv;
      fish = unstable.fish;
      fzf = unstable.fzf;
      lf = unstable.lf;
      ookla-speedtest-cli = super.callPackage ./overlays/ookla-speedtest-cli.nix { };
      picom = unstable.picom;
      python39 = unstable.python39;
      qutebrowser = unstable.qutebrowser;
      starship = unstable.starship;
      # texlive.combined.scheme-full = unstable.texlive.combined.scheme-full;
      ueberzug = unstable.ueberzug;
      vimv = unstable.vimv;
    })

    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  xdg.configFile."wall.png" = {
    source = themes-dir + /wall.png;
  };

  xdg.configFile."alacritty/fuzzy-opener.yml" = {
    text = lib.replaceStrings [ "\\\\" ] [ "\\" ]
      (builtins.toJSON (import ./scripts/fuzzy-opener/alacritty.nix {
        font = import (fonts-dir + /alacritty.nix);
        colors = import (themes-dir + /alacritty.nix);
      }));
    source =
      let
        yaml = pkgs.formats.yaml { };
      in
      yaml.generate "fuzzy-opener.yml"
        (import ./scripts/fuzzy-opener/alacritty.nix {
          font = import (fonts-dir + /alacritty.nix);
          colors = import (themes-dir + /alacritty.nix);
        });
  };

  xdg.configFile."calcurse" = {
    source = ../../defaults/calcurse;
    recursive = true;
  };

  xdg.configFile."calcurse/hooks/calendar-icon.png" = {
    source = ./scripts/calcurse/calendar-icon.png;
  };

  xdg.configFile."fusuma" = {
    source = ../../defaults/fusuma;
    recursive = true;
  };

  xdg.configFile."nvim" = {
    source = ../../defaults/neovim;
    recursive = true;
  };

  xdg.configFile."nvim/init.lua" = {
    text = (import ../../defaults/neovim/default.nix {
      inherit lib;
      colors = import (themes-dir + /neovim.nix);
    });
  };

  fonts.fontconfig = {
    enable = true;
  };

  programs.home-manager = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
  } // alacrittyConfig;

  programs.bat = {
    enable = true;
  } // batConfig;

  programs.direnv = {
    enable = true;
  } // direnvConfig;

  programs.fd = {
    enable = true;
  } // fdConfig;

  programs.firefox = {
    enable = true;
  } // firefoxConfig;

  programs.fish = {
    enable = true;
  } // fishConfig;

  programs.fzf = {
    enable = true;
  } // fzfConfig;

  programs.git = {
    enable = true;
  } // gitConfig;

  programs.lf = {
    enable = true;
  } // lfConfig;

  programs.mpv = {
    enable = true;
  };

  programs.qutebrowser = {
    enable = true;
  } // qutebrowserConfig;

  programs.rofi = {
    enable = true;
  } // rofiConfig;

  programs.ssh = {
    enable = true;
  } // sshConfig;

  programs.starship = {
    enable = true;
  } // starshipConfig;

  programs.tridactyl = {
    enable = true;
  } // tridactylConfig;

  programs.vivid = {
    enable = true;
  } // vividConfig;

  programs.zathura = {
    enable = true;
  } // zathuraConfig;

  services.dunst = {
    enable = true;
  } // dunstConfig;

  services.picom = {
    enable = true;
  } // picomConfig;

  services.polybar = {
    enable = true;
  } // polybarConfig;

  services.sxhkd = {
    enable = true;
  } // sxhkdConfig;

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
    } // bspwmConfig;
  };
}
