{ config, pkgs, ... }:

{
  home.username = "meismeric";
  home.homeDirectory = "/home/meismeric";
  home.stateVersion = "26.05";

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