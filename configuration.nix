{ config, pkgs, inputs, freesmlauncher, ... }:

let
  pt = import inputs.nixpkgs-pt {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  b1 = import inputs.nixpkgs-batch1 {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  b2 = import inputs.nixpkgs-batch2 {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  b3 = import inputs.nixpkgs-batch3 {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  b4 = import inputs.nixpkgs-batch4 {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  b5 = import inputs.nixpkgs-batch5 {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in

let
  # Custom Flake Apps Group
  custom = [
    inputs.zen-browser.packages.${pkgs.system}.default
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.freesmlauncher.packages.${pkgs.system}.freesmlauncher
  ];
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;
  services.power-profiles-daemon.enable = false;

  # Enable TLP with battery charge thresholds
  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 78;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true; 
  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties.
 i18n.defaultLocale = "en_PH.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_PH.UTF-8";
    LC_IDENTIFICATION = "en_PH.UTF-8";
    LC_MEASUREMENT = "en_PH.UTF-8";
    LC_MONETARY = "en_PH.UTF-8";
    LC_NAME = "en_PH.UTF-8";
    LC_NUMERIC = "en_PH.UTF-8";
    LC_PAPER = "en_PH.UTF-8";
    LC_TELEPHONE = "en_PH.UTF-8";
    LC_TIME = "en_PH.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.openssh.enable = true;
  

environment.gnome.excludePackages = with pkgs; [
    epiphany       
    gnome-software
    gnome-contacts 
    gnome-music
    gnome-weather
    gnome-tour
    gnome-characters
    gnome-connections
    gnome-logs
    gnome-font-viewer
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users."meismeric" = {
    isNormalUser = true;
    uid = 1001;
    description = "Meismeric";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  programs.zsh.enable = true;
  programs.firefox.enable = false;
  programs.niri.enable = true;
  programs.kdeconnect.enable = true;
  nixpkgs.config.allowUnfree = true;


  virtualisation.waydroid.enable = false;
  networking.nftables.enable = false;
  networking.firewall.enable = true;


  services.thermald.enable = true;

  programs.gpu-screen-recorder.enable = false;

  programs.nix-ld.enable = true;

  services.mysql = {
  enable = true;
  package = pkgs.mysql84; 
  };

environment.systemPackages = (with pkgs; [
     # --- b1 ---
     b1.spotiflac
     b1.obsidian
     b1.easyeffects
     #b1.lutris
     b1.beeper

     # --- b2 ---
     b2.vscode
     b2.obs-studio  
     b2.android-tools
     #  b2.waydroid
     # --- b3 ---
     b3.brave
     b3.onlyoffice-desktopeditors
     b3.mysql-workbench
     #b3.localsend
     
     
     pt.cisco-packet-tracer_9

     # --- b4 ---
     b4.jdk
     b4.mysql84
     b4.gcc
     b4.nodejs

     b5.fastfetch
     b5.ncdu
     b5.bibata-cursors    
     b5.phinger-cursors  
     b5.vanilla-dmz 
     b5.foot
     b5.btop
     b5.cava
     b5.gparted
     b5.dysk
     b5.git
     b5.gnumake
     b5.live-server
     b5.xwayland-satellite
     b5.cbonsai
     b5.ncdu

     # --- commented ---
     # fastfetch
     # ncdu
     # bibata-cursors    
     # phinger-cursors  
     # vanilla-dmz 
     # foot
     # btop
     # cava
     # gparted
     # dysk
     # git
     # gnumake
     # live-server
     # xwayland-satellite
     # gnome-tweaks     
     # spotify
     # gpu-screen-recorder-gtk
     # wine
     # android-studio
     # jetbrains.idea
   ]) ++ custom;
  
  # Fonts Configuration
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    inter
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code

    
    corefonts
    vista-fonts
    noto-fonts
    #noto-fonts-cjk-sans
    #noto-fonts-cjk-serif
    noto-fonts-color-emoji
    liberation_ttf

    stix-two
    dejavu_fonts
  ];
  

  fonts.fontconfig = {
  enable = true;
  defaultFonts = {
      sansSerif = [ "Inter" "Noto Sans" "Noto Sans CJK JP" ];
      serif     = [ "Noto Serif" "Noto Serif CJK JP" ];
      monospace = [ "JetBrainsMono Nerd Font" "Noto Sans Mono CJK JP" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };

  # Declarative Flatpaks
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "org.vinegarhq.Sober"
    "com.github.neithern.g4music"
    "io.mrarm.mcpelauncher"
    "com.google.AndroidStudio"
    "org.localsend.localsend_app"
    "net.lutris.Lutris"
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };


    zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; 
    priority = 100;
  };


  system.stateVersion = "26.05"; 
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    
    # Bypasses local compilation for Noctalia
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://freesmlauncher.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "freesmlauncher.cachix.org-1:hX0BqSt13djXVbhagJ6toEEBA15xxZPWwKGpYksuiQ0="
    ];
  };

  boot.loader.systemd-boot.configurationLimit = 1;

  nix.gc = {
    automatic = true;
    dates = "daily";
  };

  systemd.services.nix-gc.wants = [ "nix-gen-gc.service" ];
  systemd.services.nix-gen-gc = {
  description = "Delete all old NixOS generations except current";
  script = "exec ${config.nix.package.out}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations old";
  serviceConfig.Type = "oneshot";
};
}