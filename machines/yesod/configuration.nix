{ config, lib, pkgs, ... }:

let
  unstable = import <nixos-unstable> { };

  colorscheme = "";

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

  # Enable flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Rome";

  users = {
    users."walden" = {
      home = "/home/walden";
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "plugdev"
      ];
    };

    users."couchdb" = {
      home = "/home/couchdb";
      shell = pkgs.fish;
      isSystemUser = true;
      createHome = true;
      extraGroups = [ "couchdb" ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
  ];

  boot.loader.systemd-boot.enable = true; 

  hardware.bluetooth = {
    enable = true;
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  networking = {
    hostName = "yesod";
    useDHCP = false;
    interfaces.enp2s0.useDHCP = true;
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [
      8384
    ];
    wireless.enable = true;

    wireless.networks = {
     "Co-working WiFi" = {
       psk = "FW123456";
     };
    };
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

  services.couchdb = {
    enable = true;
    package = unstable.couchdb3;
    user = "couchdb";
    group = "couchdb";
    databaseDir = "/home/couchdb/couchdb";
    bindAddress = "0.0.0.0";
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

  services.udisks2 = {
    enable = true;
  };

  services.udev = {
    extraHwdb = ''
      evdev:input:b0003v1532p026F*
       KEYBOARD_KEY_700e2=leftmeta
       KEYBOARD_KEY_700e3=leftalt
       KEYBOARD_KEY_700e6=rightmeta
    '';
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 150;
    autoRepeatInterval = 33;
    layout = "us";

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
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
