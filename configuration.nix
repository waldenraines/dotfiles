{ pkgs
, lib
, config
, username
, homeDirectory
, machine
, colorscheme
, palette
, configDir
, hexlib
, ...
}:

let
  unstable = import <nixos-unstable> { };
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

  nixpkgs.config.allowUnfree = true;

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  users = {
    users."${username}" = {
      home = homeDirectory;
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "plugdev"
        "vboxusers"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    glibc
    neovim
  ];

  boot = {
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_priority=3"
      "button.lid_init_state=open"
      "vt.cur_default=0x700010"
    ];

    initrd.verbose = false;

    # Configuration options for LUKS Device
    initrd.luks.devices = {
      crypted = {
        device = "/dev/disk/by-partuuid/85df5657-b8ac-439d-a5c3-a8449202a87a";
        header = "/dev/disk/by-partuuid/42ad8cb0-0e62-425a-9097-e2ebc57f53c2";
        preLVM = true;
      };
    };

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  #hardware.bluetooth = {
  #  enable = true;
  #};

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

  services.blueman = {
    enable = true;
  };

  services.geoclue2 = {
    enable = true;
  };

  services.tlp = {
    enable = true;
  };

  services.printing.enable = true;
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;

  services.transmission = {
    enable = true;
  } // (import "${configDir}/transmission" {
    inherit pkgs username homeDirectory;
  });

  services.udisks2 = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    autoRepeatDelay = 150;
    autoRepeatInterval = 33;
    layout = "us";
    videoDrivers = [ "intel" ];

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
        user = username;
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

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "walden" ];

  #system.autoUpgrade.enable = true;
  #system.autoUpgrade.allowReboot = true;

  system.stateVersion = "21.11";
}

# [1]: https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
# [2]: https://shallowsky.com/linux/x-screen-blanking.html
