{ machine }:

let
  family = "FiraCode Nerd Font";
in
rec {
  normal = {
    inherit family;
    style = "Regular";
  };

  bold = {
    inherit family;
    style = "Bold";
  };

  italic = {
    inherit family;
    style = "Italic";
  };

  bold_italic = {
    inherit family;
    style = "Bold";
  };
} // (
  if machine == "yesod" then
    {
      size = 8;
    }
  else { }
)
