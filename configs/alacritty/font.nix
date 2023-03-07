{ family
, machine
}:

let
  overrides = {
    "FiraCode Nerd Font" = {
      bold_italic.style = "Bold";
      "yesod".size = 9;
      "mbair".size = 19;
    };

    "Inconsolata Nerd Font" = {
      "yesod".size = 11;
      "mbair".size = 19;
    };

    "Iosevka Nerd Font" = {
      "yesod".size = 11;
      "mbair".size = 19;
    };

    "JetBrainsMono Nerd Font" = {
      bold.style = "Extra Bold";
      bold_italic.style = "Extra Bold";
      "yesod".size = 9.5;
      "mbair".size = 19;
      "mbair".offset.y = 1;
    };

    "Mononoki Nerd Font" = {
      bold_italic.style = "Bold";
      "yesod".size = 10;
      "mbair".size = 19;
    };

    "RobotoMono Nerd Font" = {
      "yesod".size = 10;
      "yesod".offset.y = 1;
      "mbair".size = 19;
      "mbair".offset.y = 1;
    };
  };

  default_size = {
    "yesod" = 10;
    "skunk" = 16;
  };
in
{
  normal = {
    inherit family;
    style = "Regular";
  };

  bold = {
    inherit family;
    style = overrides.${family}.bold.style or "Bold";
  };

  italic = {
    inherit family;
    style = "Italic";
  };

  bold_italic = {
    inherit family;
    style = overrides.${family}.bold_italic.style or "Bold Italic";
  };

  size = overrides.${family}.${machine}.size or default_size.${machine};
  offset.y = overrides.${family}.${machine}.offset.y or 0;
}
