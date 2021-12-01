{ colorscheme }:

# TODO: change delta syntax-theme according to the colorscheme

{
  userName = "Walden Raines";
  userEmail = "walden@waldenraines.com";

  #signing = {
    #key = "riccardo.mazzarini@pm.me";
    #signByDefault = true;
  #};

  extraConfig = {
    init = {
      defaultBranch = "master";
    };

    pull = {
      rebase = false;
    };

    pager = {
      #diff = "delta";
      log = "delta";
      reflog = "delta";
      show = "delta";
    };

    interactive = {
      diffFilter = "delta --color-only";
    };

    delta = {
      features = "line-numbers decorations";
      # syntax-theme = "TwoDark";
      syntax-theme = "Nord";
      decorations = {
        file-style = "omit";
        commit-decoration-style = "bold yellow box ul";
      };
    };
  };

  ignores = [
    ".direnv"
    ".envrc"
    "shell.nix"
  ];
}
