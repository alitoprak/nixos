{ config, lib, pkgs, hostname, users, ... }:
  let
    mkSystemUser = username: userConfig: {
      isNormalUser = true;
      description = userConfig.description or username;
      extraGroups = userConfig.extraGroups or [];
    };

    mkHomeUser = username: userConfig: {
      _module.args = {
        inherit hostname username userConfig;
      };
      
      imports = [
        (./users + "/${username}/home.nix")
      ];

      home = {
        username = username;
        homeDirectory = userConfig.homeDirectory or "/home/${username}";
        stateVersion = "26.05";
      };
    };
  in {
    imports = [
      ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    security.rtkit.enable = true;
 
    networking.hostName = hostname;
    networking.networkmanager.enable = true;

    nixpkgs.config.allowUnfree = true;

    services.sshd.enable = true;

    services = {
      pipewire = {
        enable = true;

        alsa.enable = true;
        alsa.support32Bit = true;
  
        pulse.enable = true;
      };
  
      desktopManager.plasma6.enable = true;
  
      displayManager.plasma-login-manager.enable = true;
    };

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    users.users = lib.mapAttrs mkSystemUser users;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users = lib.mapAttrs mkHomeUser users;
    };

    system.stateVersion = "26.05";
  }

