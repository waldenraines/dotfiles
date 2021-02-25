{
  core = {
    regular_file = {};
    directory = {
      foreground = "blue";
      font-style = "bold";
    };
    executable_file = {
      foreground = "green";
      font-style = "bold";
    };
    symlink = {
      foreground = "cyan";
    };
    broken_symlink = {
      foreground = "black";
      background = "red";
    };
    missing_symlink_target = {
      foreground = "black";
      background = "red";
    };
    fifo = {
      foreground = "black";
      background = "blue";
    };
    socket = {
      foreground = "black";
      background = "orange";
    };
    character_device = {
      foreground = "black";
      background = "cyan";
    };
    block_device = {
      foreground = "black";
      background = "red";
    };
    normal_text = {};
    sticky = {};
    sticky_other_writable = {};
    other_writable = {};
  };

  markup = {
    foreground = "yellow";
  };

  text = {
    foreground = "yellow";
    readme = {
      foreground = "yellow";
      font-style = "underline";
    };
  };

  programming = {
    source = {
      foreground = "magenta";
      latex = {
        foreground = "magenta";
        special = {
          font-style = "underline";
          foreground = "cyan";
        };
      };
    };
    tooling = {
      foreground = "gray";
      continuous-integration = {
        foreground = "gray";
      };
    };
  };

  media = {
    image = {
      foreground = "orange";
    };
    audio = {
      foreground = "orange";
    };
    video = {
      foreground = "cyan";
    };
  };


  office = {
    foreground = "cyan";
  };

  archives = {
    foreground = "red";
  };

  executable = {
    foreground = "red";
    font-style = "bold";
  };

  unimportant = {
    foreground = "gray";
  };

  fzf-grayed-out-dir = {
    foreground = "gray";
    font-style = "bold";
  };
}
