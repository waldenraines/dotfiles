{ family
, machine
}:

let
  f = {
    "Iosevka Nerd Font" = {
      "yesod".size = 23;
      "mbair".size = 20;
    };
    "Mononoki Nerd Font" = {
      "yesod".size = 23;
      "mbair".size = 20;
    };
  };

  default_size = {
    "yesod" = 22;
    "skunk" = 19;
  };
in
{
  inherit family;
  size = f.${family}.${machine}.size or default_size.${machine};
}
