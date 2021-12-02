let
  pkgs = import <nixpkgs> { };

  notify-done = pkgs.writeShellScriptBin "notify-done"
    (import ./notify-done.sh.nix);
in
{
  user = "walden";
  settings = {
    download-dir = "/home/walden/Downloads";
    script-torrent-done-enabled = true;
    script-torrent-done-filename = "${notify-done}/bin/notify-done";
  };
}
