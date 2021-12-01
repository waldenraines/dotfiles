let
  pkgs = import <nixpkgs> { };

  buildFirefoxXpiAddon = { pname, version, addonId, url, sha256, meta, ... }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = pkgs.fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = false;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in
{
  # To find the addonId of an extension first install it the usual imperative
  # way. Then go in `about:memory` -> Show memory reports -> click `Measure`.
  # Scroll down to the `Other measurements` section and look for the extensions
  # block.

  bitwarden = buildFirefoxXpiAddon {
    pname = "bitwarden";
    version = "1.48.1";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/3714988/bitwarden_free_password_manager-1.48.1-an+fx.xpi";
    sha256 = "27088233b72c36f8636ae88e79d7e52a0b4480d7fc73ed6412233a2f95408256";
    meta = with pkgs.lib; {
      homepage = "https://bitwarden.com";
      description = "A secure and free password manager for all of your devices.";
      license = licenses.gpl3;
      platforms = platforms.all;
    };
  };

#  downloads-sidebar = buildFirefoxXpiAddon {
#    pname = "downloads-sidebar";
#    version = "1.0.1";
#    addonId = "{bbb81fb3-49c1-4a42-bcc9-94bc93e19fb8}";
#    url = "https://addons.mozilla.org/firefox/downloads/file/3166696/downloads_sidebar-1.0.1-fx.xpi";
#    sha256 = "1bcmr3mq0ysjkvsdh3p2w5wp9a2d1745ldx3xj3wrx53dm477cy8";
#    meta = with pkgs.lib; {
#      homepage = "https://github.com/aesqe/firefox-downloads-sidebar";
#      description = "Display a list of your latest downloads in the Firefox sidebar.";
#      license = licenses.mit;
#      platforms = platforms.all;
#    };
#  };

#  tridactyl-no-new-tab = buildFirefoxXpiAddon {
#    pname = "tridactyl";
#    version = "1.21.1";
#    addonId = "tridactyl.vim.betas.nonewtab@cmcaine.co.uk";
#    url = "https://tridactyl.cmcaine.co.uk/betas/nonewtab/tridactyl_no_new_tab_beta-latest.xpi";
#    sha256 = "0fsxjyv2d1j0gwvqqqh5l4zv9jcy1vqkkhxfsx08zd475sczmm0z";
#    meta = with pkgs.lib; {
#      homepage = "https://github.com/cmcaine/tridactyl";
#      description = ''
#        Vim, but in your browser. Replace Firefox's control mechanism with one
#        modelled on Vim.
#
#        This addon is very usable, but is in an early stage of development.
#        We intend to implement the majority of Vimperator's features.
#      '';
#      license = licenses.asl20;
#      platforms = platforms.all;
#    };
#  };
}
