{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  networking = {
    hostName = "aersNix";
    networkmanager.enable = true; 
  };

  time.timeZone = "Europe/Amsterdam";

  # NerdFonts
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "IBMPlexMono" "GeistMono" "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "JetBrains Mono" "Geist Mono" "IBM Plex Mono" ];
        sansSerif = [ "JetBrains Mono" "Geist Mono" "IBM Plex Mono" ]; 
        monospace = [ "JetBrains Mono" "Geist Mono" "IBM Plex Mono" ];
      };  
    };
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-sdk
      intel-media-driver
      vaapiIntel
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  security.rtkit.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aers= {
    isNormalUser = true;
    home = "/home/aers";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    waybar = {
      enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    };
    firefox.enable = true;
    git.enable = true;
    neovim = {
      viAlias = true;
      vimAlias = true;
    };
  };
 
  services = {
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
      xkb.options = "grp:caps_toggle";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
  
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    git
    git-credential-manager
    gnupg
    pass
    pinentry-curses
    fastfetch
    neovim
    wget
    curl
    ghostty
    waybar
    rofi-wayland
    dolphin
    clipse
    libnotify
    dunst
    telegram-desktop
    grim
    swappy
    slurp
    zed-editor
    nodejs_20
    pnpm
  ];

  

  system.stateVersion = "24.11"; # Do not override!
}

