{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };

  colorscheme = "onedark";

  dirs = {
    colorscheme = ../../colorschemes + "/${colorscheme}";
    configs = ../../configs;
  };

  configs = {
    transmission = import (dirs.configs + /transmission);
  };

in
{
  imports = [
    <nixos-hardware/purism/librem/13v3>
    /etc/nixos/hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  users = {
    users."walden" = {
      home = "/home/walden";
      shell = pkgs.bash;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
      ];
    };
  };

  #nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bash
    vim
    wget
  ];

  hardware.bluetooth = {
    enable = true;
  };

  hardware.ledger.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  networking = {
    hostName = "yesod";
    useDHCP = false;
    interfaces.eno0.useDHCP = true;
    interfaces.wlp1s0.useDHCP = true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      8384
    ];
  };

  sound = {
    enable = true;
  };

  programs.fish = {
    enable = true;
  };

  programs.nm-applet = {
    enable = true;
  };

  services.geoclue2 = {
    enable = true;
  };

  services.tlp = {
    enable = true;
  };

  services.transmission = {
    enable = true;
  } // configs.transmission;

  services.trezord.enable = true;

  services.udisks2 = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 150;
    autoRepeatInterval = 33;
    layout = "us";

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = false;
        disableWhileTyping = true;
      };
    };

    displayManager = {
      autoLogin = {
        enable = true;
        user = "walden";
      };
    };

    windowManager = {
      bspwm.enable = true;
    };

    # This together with 'xset s off'should disable every display power
    # management option. See [1] and [2] for more infos.
    config = ''
      Section "Extensions"
          Option "DPMS" "off"
      EndSection
    '';
  };

  system.stateVersion = "21.11";
}

# [1]: https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
# [2]: https://shallowsky.com/linux/x-screen-blanking.html
