{ pkgs
, lib
, machine
, colorscheme
, font-family
, palette
, configDir
, cloudDir
, hexlib
, ...
}:

{
  environment = {
    loginShell = "${pkgs.fish}/bin/fish";
    shells = [ pkgs.fish ];
  };

  homebrew = {
    enable = true;
    cleanup = "zap";
    brews = [
      "mas"
      "swift-format"
    ];
    casks = [
      "alacritty"
      "brave-browser"
      "docker"
      "nordvpn"
      "selfcontrol"
      "signal"
      "visual-studio-code"
      "zoom"
    ];
  };

  networking = {
    computerName = machine;
    hostName = machine;
    localHostName = machine;
  };

  programs.fish.enable = true;

  services.nix-daemon.enable = true;

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      QuitMenuItem = true;
    };

    trackpad.Clicking = true;

    LaunchServices.LSQuarantine = false;

    NSGlobalDomain = {
      AppleShowAllFiles = true;
      InitialKeyRepeat = 10;
      KeyRepeat = 2;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };
}
