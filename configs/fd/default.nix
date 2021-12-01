{ machine }:

{
  ignored = [
    "/*"
    "!/Dropbox"
    "!/Downloads"
    "!/.config"
    "/.config/*"
    "**/.direnv"
    "**/.git"
    "**/.stfolder"
    "**/gnupg/*"
    "*.aux"
    "*.bbl"
    "*.bcf"
    "*.blg"
    "*.loe"
    "*.log"
    "*.out"
    "*.run.xml"
    "*.synctex(busy)"
    "*.synctex.gz"
    "*.toc"
  ];
}
