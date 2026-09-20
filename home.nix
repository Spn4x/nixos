{ config, pkgs, ... }:

{
  home.username = "meismeric";
  home.homeDirectory = "/home/meismeric";
  home.stateVersion = "26.05";

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

    dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark"; 
      icon-theme = "Adwaita";
      cursor-theme = "Bibata-Modern-Classic";
      cursor-size = 24;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Spn4x";
      user.email = "164689179+Spn4x@users.noreply.github.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential.helper = "store";
      safe.directory = [ "/home/meismeric/NixDots" ];
    };
  };

  programs.home-manager.enable = true;
}