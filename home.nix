{ pkgs
, lib
, config
, machine
, colorscheme
, font-family
, palette
, configDir
, cloudDir
, gitDir 
, hexlib
, ...
}:

let
  inherit (pkgs.stdenv) isDarwin isLinux;

  fuzzy-ripgrep = pkgs.writeShellScriptBin "fuzzy_ripgrep"
    (builtins.readFile "${configDir}/fzf/scripts/fuzzy-ripgrep.sh");

  lf_w_image_previews = with pkgs; hiPrio (writeShellScriptBin "lf"
    (import "${configDir}/lf/launcher.sh.nix" { inherit lf; })
  );

  previewer = with pkgs; writeShellApplication {
    name = "previewer";
    runtimeInputs = [
      atool # contains `als` used for archives
      bat
      # calibre # contains `ebook-meta` used for epubs
      chafa
      ffmpegthumbnailer
      file
      inkscape # SVGs
      mediainfo # audios
      mkvtoolnix-cli # videos
      poppler_utils # contains `pdftoppm` used for PDFs
    ] ++ lib.lists.optionals isLinux [
      ueberzug
    ];
    text = (builtins.readFile "${configDir}/lf/previewer.sh");
  };

  rg-previewer = pkgs.writeShellScriptBin "rg-previewer"
    (builtins.readFile "${configDir}/ripgrep/rg-previewer.sh");
in
{
  home.packages = with pkgs; [
    ### WALDEN ###
    chromium
    joplin-desktop
    keepass
    libreoffice
    protonvpn-cli
    signal-desktop
    slack
    srm
    tdrop
    vlc
    wine
    winetricks
    ### END: WALDEN ###

    asciinema
    bottom
    delta
    dua
    fd
    file
    fuzzy-ripgrep
    helix
    imagemagick_light # Contains `convert`
    jq
    neovim-nightly
    nextcloud-client
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Inconsolata"
        "Iosevka"
        "JetBrainsMono"
        "Mononoki"
        "RobotoMono"
      ];
    })
    # ookla-speedtest
    pfetch
    previewer
    # procs
    (python310.withPackages (pp: with pp; [
      ipython
      isort
      jedi-language-server
      yapf
    ]))
    rg-previewer
    ripgrep
    rnix-lsp
    # rust-bin.nightly.latest.default
    rust-bin.stable.latest.default
    rust-analyzer
    nodePackages.svelte-language-server
    stylua
    sumneko-lua-language-server
    texlive.combined.scheme-full
    tokei
    nodePackages.typescript-language-server
    stylua
    unzip
    vimv
    zip
  ] ++ lib.lists.optionals isDarwin [
    binutils
    coreutils
    findutils
    gnused
    libtool
  ] ++ lib.lists.optionals isLinux [
    ### WALDEN ###
    betterlockscreen
    brightnessctl
    giph
    pavucontrol
    ssh-agents 
    ### END: WALDEN ###

    blueman
    brave
    calcurse
    (import "${configDir}/dmenu" {
      inherit pkgs colorscheme font-family palette hexlib;
    })
    feh
    glibc
    lf_w_image_previews
    libnotify
    noto-fonts-emoji
    obs-studio
    pick-colour-picker
    ueberzug
    wmctrl
    xclip
    xdotool
    xorg.xev
    xorg.xwininfo
    (pkgs.makeDesktopItem {
      name = "qutebrowser";
      desktopName = "qutebrowser";
      exec = "${pkgs.qutebrowser}/bin/qutebrowser";
      mimeTypes = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      icon = "qutebrowser";
    })
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    MANPAGER = "nvim +Man! -";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    COLORTERM = "truecolor";
    LS_COLORS = "$(vivid generate current)";
    LF_ICONS = (builtins.readFile "${configDir}/lf/LF_ICONS");
    HISTFILE = "${config.xdg.cacheHome}/bash/bash_history";
    LESSHISTFILE = "${config.xdg.cacheHome}/less/lesshst";
    RIPGREP_CONFIG_PATH = "${configDir}/ripgrep/ripgreprc";
    NPM_CONFIG_PREFIX = "$HOME/.npm_global_modules";
    TDTD_DATA_DIR = "${cloudDir}/tdtd";
    OSFONTDIR = lib.strings.optionalString isLinux (
      config.home.homeDirectory
      + "/.nix-profile/share/fonts/truetype/NerdFonts"
    );
  };

  home.pointerCursor = lib.mkIf isLinux {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
    size = 16;
    x11.enable = true;
    x11.defaultCursor = "left_ptr";
  };

  nix = {
    package = pkgs.nixUnstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  xdg.configFile = {
    "fd/ignore" = {
      source = "${configDir}/fd/ignore";
    };

    # Forcing an update w/ `fc-cache --really-force` may be needed on Linux.
    "fontconfig/fonts.conf" = {
      text = import "${configDir}/fontconfig/fonts.conf.nix" {
        fontFamily = font-family;
      };
    };

    "fusuma/config.yml" = lib.mkIf isLinux {
      source = "${configDir}/fusuma/config.yml";
    };

    "nvim" = {
      source = "${configDir}/neovim";
      recursive = true;
    };

    "nvim/lua/colorscheme.lua" = {
      text = import "${configDir}/neovim/lua/colorscheme.lua.nix" {
        inherit colorscheme palette;
      };
    };

    "redshift/hooks/notify-change" = {
      text = import "${configDir}/redshift/notify-change.sh.nix" {
        inherit pkgs;
      };
      executable = true;
    };
  };

  xdg.mimeApps = lib.mkIf isLinux {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      "text/html" = [ "qutebrowser.desktop" ];
      "x-scheme-handler/http" = [ "qutebrowser.desktop" ];
      "x-scheme-handler/https" = [ "qutebrowser.desktop" ];
    };
  };

  fonts.fontconfig = lib.mkIf isLinux {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
  } // (import "${configDir}/alacritty" {
    inherit font-family machine palette;
    inherit (lib.lists) optionals;
    inherit (lib.attrsets) optionalAttrs;
    inherit isDarwin isLinux;
    shell = {
      program = "${pkgs.fish}/bin/fish";
      args = [ "--interactive" ];
    };
  });

  programs.bat = {
    enable = true;
  } // (import "${configDir}/bat");

  programs.direnv = {
    enable = true;
    # };
  } // (import "${configDir}/direnv");

  programs.fish = {
    enable = true;
  } // (import "${configDir}/fish" {
    inherit pkgs colorscheme palette cloudDir gitDir;
    inherit (lib.strings) removePrefix;
  });

  # programs.firefox = lib.mkIf isDarwin
  #   {
  #     enable = true;
  #   } // (import "${configDir}/firefox" {
  #   inherit lib colorscheme font-family machine palette;
  # });

  programs.fzf = {
    enable = true;
  } // (import "${configDir}/fzf" {
    inherit colorscheme palette hexlib;
    inherit (lib) concatStringsSep;
    inherit (lib.strings) removePrefix;
  });

  programs.git = {
    enable = true;
  } // (import "${configDir}/git" { inherit colorscheme; });

  programs.gpg = {
    enable = true;
  } // (import "${configDir}/gpg/gpg.nix" {
    homedir = "${cloudDir}/share/gnupg";
  });

  programs.home-manager = {
    enable = true;
  };

  programs.lazygit = {
    enable = true;
  } // (import "${configDir}/lazygit");

  programs.lf = {
    enable = true;
  } // (import "${configDir}/lf" {
    inherit pkgs previewer;
  });

  programs.mpv = {
    enable = true;
  } // (import "${configDir}/mpv");

  programs.qutebrowser = lib.mkIf isLinux
    {
      enable = true;
    } // (import "${configDir}/qutebrowser" {
    inherit pkgs colorscheme font-family palette hexlib;
  });

  # programs.spacebar = lib.mkIf isDarwin ({
  #   enable = true;
  # } // (import "${configDir}/spacebar" {
  #   inherit colorscheme font-family palette;
  #   inherit (lib.strings) removePrefix;
  # }));

  programs.starship = {
    enable = true;
  } // (import "${configDir}/starship" { inherit (lib) concatStrings; });

  programs.vivid = {
    enable = true;
  } // (import "${configDir}/vivid" {
    inherit colorscheme palette;
    inherit (lib.strings) removePrefix;
  });

  programs.zathura = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/zathura" {
    inherit colorscheme font-family palette hexlib;
  }));

  services.dunst = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/dunst" {
    inherit colorscheme font-family palette hexlib;
    inherit (pkgs) hicolor-icon-theme;
  }));

  services.flameshot = lib.mkIf isLinux {
    enable = true;
  };

  # services.fusuma = {
  #   enable = true;
  # } // (import "${configDir}/fusuma");

  services.gpg-agent = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/gpg/gpg-agent.nix"));

  services.mpris-proxy = lib.mkIf isLinux {
    enable = true;
  };

  services.picom = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/picom"));

  services.polybar = lib.mkIf isLinux ({
    enable = true;
    package = pkgs.polybar.override {
      pulseSupport = true;
    };
  } // (import "${configDir}/polybar" {
    inherit colorscheme font-family palette hexlib;
    inherit (lib) concatStringsSep;
  }));

  services.redshift = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/redshift"));

  services.skhd = lib.mkIf isDarwin ({
    enable = true;
  } // (import "${configDir}/skhd" {
    inherit pkgs;
  }));

  services.sxhkd = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/sxhkd" {
    inherit configDir cloudDir;
    inherit (pkgs) writeShellScriptBin;
    inherit (pkgs.writers) writePython3Bin;
  }));

  services.udiskie = lib.mkIf isLinux ({
    enable = true;
  } // (import "${configDir}/udiskie"));

  services.yabai = lib.mkIf isDarwin ({
    enable = true;
  } // (import "${configDir}/yabai"));

  systemd.user.startServices = true;

  xsession = lib.mkIf isLinux ({
    enable = true;

    windowManager.bspwm = {
      enable = true;
    } // (import "${configDir}/bspwm") {
      inherit pkgs colorscheme palette hexlib;
    };

    profileExtra = ''
      ${pkgs.hsetroot}/bin/hsetroot \
        -solid "${hexlib.scale 0.75 palette.primary.background}"
    '';
  });
}
