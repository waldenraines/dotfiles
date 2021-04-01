{ pkgs ? import <nixpkgs> { } }:

{
  settings = {
    dircounts = true;
    drawbox = true;
    hidden = true;
    ifs = "\\n";
    info = "size";
    period = 1;
    shell = "bash";
    timefmt = "January 02, 2006 at 15:04:05";
  };

  commands = {
    open = ''
      ''${{
        text_files=()
        for f in $fx; do
          case $(file -Lb --mime-type $f) in
            text/*|application/json|inode/x-empty) text_files+=("$f");;
          esac
        done
        [[ ''${#text_files[@]} -eq 0 ]] || $EDITOR "''${text_files[@]}"
      }}
    '';

    touch = ''%touch "$@"; lf -remote "send $id select \"$@\""'';
    mkdir = ''%mkdir -p "$@"; lf -remote "send $id select \"$@\""'';
    give_ex = ''%chmod +x $fx; lf -remote "send $id reload"'';
    remove_ex = ''%chmod -x $fx; lf -remote "send $id reload"'';

    fuzzy_edit = ''
      ''${{
        clear
        filename="$(fzf -m --prompt="Edit> ")" \
          && $EDITOR "''${HOME}/''${filename}" \
          || true
      }}
    '';

    fuzzy_cd = ''
      ''${{
        clear
        dirname="$(eval $(echo $FZF_ONLYDIRS_COMMAND) \
                    | fzf --prompt="Cd> " \
                    | sed 's/\ /\\\ /g')" \
          && lf -remote "send $id cd ~/''${dirname}" \
          || true
      }}
    '';
  };

  keybindings = {
    m = null;
    u = null;
    x = "cut";
    d = "delete";
    "<enter>" = "push $";
    t = "push :touch<space>";
    k = "push :mkdir<space>";
    "+" = "give_ex";
    "-" = "remove_ex";
    "<c-x><c-e>" = "fuzzy_edit";
    "<c-x><c-d>" = "fuzzy_cd";
  };

  cmdKeybindings = {
    "<up>" = "cmd-history-prev";
    "<down>" = "cmd-history-next";
  };

  previewer.source = pkgs.writeShellScript "pv.sh" ''
    #!/usr/bin/env sh

    file="$1"

    case "$(file -b --mime-type "$file")" in
      text/*)
        bat "$file"
        ;;
      */pdf)
        pdftotext "$file" -
        ;;
      image/*)
        chafa --fill=block --symbols=block "$file"
        ;;
      video/*)
        mediainfo "$file"
        ;;
      audio/*)
        mediainfo "$file"
        ;;
      *)
        bat "$file"
        ;;
    esac
  '';
}
