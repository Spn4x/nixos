{ config, pkgs, inputs, freesmlauncher, ... }:

let
  pt = import inputs.nixpkgs-pt {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
  unstable = import inputs.nixpkgs-unstable {
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

        SATA_LINKPWR_ON_AC = "max_performance";
        SATA_LINKPWR_ON_BAT = "max_performance"; 

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_performance";
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

  # Run all appimages natively
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  

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

  programs.zsh.enable = true;
  programs.firefox.enable = false;
  programs.niri.enable = true;
  programs.kdeconnect.enable = true;
  nixpkgs.config.allowUnfree = true;


  virtualisation.waydroid.enable = false;
  networking.nftables.enable = false;
  networking.firewall.enable = false;

  services.thermald.enable = false;
  services.throttled.enable = true;
  programs.gpu-screen-recorder.enable = false;
  programs.nix-ld.enable = true;
  virtualisation.docker.enable = true;

  services.mysql = {
      enable = true;
      package = pkgs.mysql84;
      initialDatabases = [
        { name = "dev_db"; }
      ];
      ensureUsers = [
        {
          name = "devuser";
          ensurePermissions = {
            "dev_db.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

  services.sunshine = {
  enable = true;
  autoStart = true;
  capSysAdmin = true; 
  openFirewall = true; 
};

  hardware.uinput.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # iHD driver for 8th Gen (UHD 620)
      intel-vaapi-driver      
      libva
      libva-utils
    ];
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  users.users."meismeric" = {
    isNormalUser = true;
    uid = 1000;
    description = "Meismeric";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video" "render" "input" "uinput" "docker" ];
    packages = with pkgs; [];
  };
  
  services.udev.extraRules = ''
  KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", MODE="0660", GROUP="uinput"
'';

environment.systemPackages = (with pkgs; [
     # --- Unstable ---
     #unstable.umbriel  

     # --- b1 ---
     spotiflac
     obsidian
     easyeffects
     #lutris
     #beeper
     discord
     gnome-sound-recorder

     # --- b2 ---
     vscode
     obs-studio  
     android-tools
     #  waydroid
     #gnome-tweaks
     nwg-look
     scrcpy

     # --- b3 ---
     brave
     onlyoffice-desktopeditors
     mysql-workbench
     #localsend
     
     pt.cisco-packet-tracer_9

     # --- b4 ---
     jdk
     mysql84
     gcc
     nodejs
     godot_4
     
     # PHP + MySQL extensions + Composer
     (php.buildEnv {
       extensions = ({ enabled, all }: enabled ++ (with all; [
         mysqli
         pdo_mysql
         mbstring
         curl
         zip
         openssl
       ]));
       extraConfig = ''
         memory_limit = 512M
         upload_max_filesize = 64M
         post_max_size = 64M
       '';
     })
     phpPackages.composer

     fastfetch
     ncdu
     bibata-cursors    
     phinger-cursors  
     vanilla-dmz 
     foot
     btop
     cava
     gparted
     dysk
     git
     gnumake
     live-server
     xwayland-satellite
     cbonsai
     ncdu
     tree

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

  fileSystems."/var/lib/flatpak" = {
  device = "/home/.flatpak-system";
  fsType = "none";
  options = [ "bind" ];
  depends = [ "/home" ];
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
    LIBVA_DRIVER_NAME = "iHD";
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