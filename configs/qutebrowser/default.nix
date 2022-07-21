{ pkgs
, colorscheme
, font-family
, palette
, hexlib
}:

let
  colors = import ./colors.nix { inherit colorscheme palette hexlib; };
  font = import ./font.nix { family = font-family; };

  add-torrent = pkgs.writeShellScriptBin "add-torrent"
    (builtins.readFile ./scripts/add-torrent.sh);

  fill-bitwarden = pkgs.writers.writePython3Bin "fill-bitwarden"
    {
      libraries = [
        pkgs.python38Packages.tldextract
      ];
    }
    (builtins.readFile ./scripts/fill-bitwarden.py);

  homePage = "https://duckduckgo.com";
in
{
  searchEngines = {
    "DEFAULT" = "https://duckduckgo.com/?q={}";
    "yt" = "https://youtube.com/results?search_query={}";
    "nixo" = "https://search.nixos.org/options?channel=unstable&query={}";
    "nixp" = "https://search.nixos.org/packages?channel=unstable&query={}";
  };

  settings = {
    fonts = {
      default_family = font-family;
      default_size = (toString font.size) + "pt";
    };

    colors = {
      tabs = {
        odd.bg = colors.tabs.unfocused.bg;
        odd.fg = colors.tabs.unfocused.fg;
        even.bg = colors.tabs.unfocused.bg;
        even.fg = colors.tabs.unfocused.fg;
        selected.odd.bg = colors.tabs.focused.bg;
        selected.odd.fg = colors.tabs.focused.fg;
        selected.even.bg = colors.tabs.focused.bg;
        selected.even.fg = colors.tabs.focused.fg;
        indicator.error = colors.tabs.indicator.error;
        indicator.start = colors.tabs.indicator.start;
        indicator.stop = colors.tabs.indicator.stop;
      };

      hints = {
        bg = colors.hints.bg;
        fg = colors.hints.fg;
        match.fg = colors.hints.match.fg;
      };

      completion = {
        category.bg = colors.completion.header.bg;
        category.fg = colors.completion.header.fg;
        category.border.top = colors.completion.header.bg;
        category.border.bottom = colors.completion.header.bg;

        odd.bg = colors.completion.odd.bg;
        even.bg = colors.completion.even.bg;

        fg = [
          colors.completion.fg
          colors.completion.urls.fg
          colors.completion.fg
        ];

        match.fg = colors.completion.match.fg;

        item.selected.bg = colors.completion.selected.bg;
        item.selected.border.top = colors.completion.selected.bg;
        item.selected.border.bottom = colors.completion.selected.bg;
        item.selected.fg = colors.completion.selected.fg;
        item.selected.match.fg = colors.completion.selected.match.fg;
      };

      statusbar = {
        normal.bg = colors.statusbar.bg;
        normal.fg = colors.statusbar.fg;
        private.bg = colors.statusbar.private.bg;
        private.fg = colors.statusbar.private.fg;
        command = {
          bg = colors.statusbar.bg;
          fg = colors.statusbar.fg;
          private.bg = colors.statusbar.private.bg;
          private.fg = colors.statusbar.private.fg;
        };
      };

      messages = {
        info = {
          bg = colors.statusbar.bg;
          fg = colors.statusbar.fg;
          border = colors.statusbar.bg;
        };

        error = {
          bg = colors.messages.error.bg;
          fg = colors.messages.error.fg;
          border = colors.messages.error.bg;
        };
      };
    };

    completion = {
      height = "30%";
      open_categories = [ "history" ];
      scrollbar = {
        padding = 0;
        width = 0;
      };
      show = "always";
      shrink = true;
      timestamp_format = "";
      web_history.max_items = 7;
    };

    content = {
      autoplay = false;
      javascript.can_access_clipboard = true;
      pdfjs = true;
    };

    downloads = {
      position = "bottom";
      remove_finished = 0;
    };

    fileselect = {
      handler = "external";
      multiple_files.command = [
        "alacritty"
        "--embed"
        "$(xdotool getactivewindow)"
        "-e"
        "lf"
        "-selection-path"
        "{}"
      ];
      single_file.command = [
        "alacritty"
        "--embed"
        "$(xdotool getactivewindow)"
        "-e"
        "lf"
        "-selection-path"
        "{}"
      ];
    };

    hints = {
      border = "none";
      radius = 1;
    };

    scrolling = {
      bar = "never";
      smooth = true;
    };

    statusbar = {
      show = "never";
      widgets = [ ];
    };

    tabs = {
      show = "multiple";
      last_close = "close";
      mode_on_change = "restore";
      close_mouse_button = "right";
    };

    url = {
      default_page = homePage;
      start_pages = [ homePage ];
    };

    zoom.default = "100%";
  };

  keyMappings = {
    "<Super-l>" = "o";
    "<Super-t>" = "O";
  };

  keyBindings = {
    normal = {
      ",p" = "tab-move -";
      ",n" = "tab-move +";

      "<Super-r>" = "config-source";

      "<Super-c>" = "fake-key <Ctrl-c>";

      "<Super-Up>" = "scroll-to-perc 0";
      "<Super-Down>" = "scroll-to-perc";
      "<Super-Left>" = "back";
      "<Super-Right>" = "forward";

      "<Super-n>" = "open -w";
      "<Super-Shift-p>" = "open -p";

      "<Super-w>" = "tab-close";
      "<Super-1>" = "tab-focus 1";
      "<Super-2>" = "tab-focus 2";
      "<Super-3>" = "tab-focus 3";
      "<Super-4>" = "tab-focus 4";
      "<Super-5>" = "tab-focus 5";
      "<Super-6>" = "tab-focus 6";
      "<Super-7>" = "tab-focus 7";
      "<Super-8>" = "tab-focus 8";
      "<Super-9>" = "tab-focus 9";
      "<Super-0>" = "tab-focus 10";

      ",f" = "spawn --userscript ${fill-bitwarden}/bin/fill-bitwarden";
      ",t" = "hint links userscript ${add-torrent}/bin/add-torrent";

      "gh" = "open ${homePage}";
      "th" = "open -t ${homePage}";

      "pm" = "open https://mail.protonmail.com/u/0/inbox";
      "tpm" = "open -t https://mail.protonmail.com/u/0/inbox";

      "gtb" = "open https://github.com/";
      "tgtb" = "open -t https://github.com/";
    };

    command = {
      "<Super-w>" = "tab-close";

      "<Super-c>" = "completion-item-yank";
      "<Super-v>" = "fake-key --global <Ctrl-v>";

      "<Super-Left>" = "rl-beginning-of-line";
      "<Super-Right>" = "rl-end-of-line";
      "<Alt-Backspace>" = "rl-backward-kill-word";
      "<Super-Backspace>" = "rl-unix-line-discard";
    };

    insert = {
      "<Super-w>" = "tab-close";

      "<Super-c>" = "fake-key <Ctrl-c>";
      "<Super-v>" = "fake-key <Ctrl-v>";
      "<Super-x>" = "fake-key <Ctrl-x>";
      "<Super-z>" = "fake-key <Ctrl-z>";

      "<Super-Left>" = "fake-key <Home>";
      "<Super-Right>" = "fake-key <End>";
      "<Alt-Backspace>" = "fake-key <Ctrl-Backspace>";
      "<Super-Backspace>" = "fake-key <Shift-Home><Delete>";

      "<Super-1>" = "tab-focus 1";
      "<Super-2>" = "tab-focus 2";
      "<Super-3>" = "tab-focus 3";
      "<Super-4>" = "tab-focus 4";
      "<Super-5>" = "tab-focus 5";
      "<Super-6>" = "tab-focus 6";
      "<Super-7>" = "tab-focus 7";
      "<Super-8>" = "tab-focus 8";
      "<Super-9>" = "tab-focus 9";
      "<Super-0>" = "tab-focus 10";
    };
  };

  extraConfig = ''
    config.unbind("gm")
    config.unbind("gd")
    config.unbind("gb")
    config.unbind("tl")
    config.unbind("gt")

    c.tabs.padding = {"bottom": 0, "left": 7, "right": 7, "top": 0}

    config.load_autoconfig(True)
  '';
}
