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

    networking.hostName = hostname;
    networking.networkmanager.enable = true;

    systemd.tmpfiles.rules = [
      "d /etc/nixos 2775 root wheel - -"
    ];

    system.activationScripts.etcNixosPermissions.text = ''
      if [ -d /etc/nixos ]; then
        chown -R root:wheel /etc/nixos
        chmod -R u+rwX,g+rwX,o+rX /etc/nixos
        find /etc/nixos -type d -exec chmod 2775 {} +
      fi
    '';

    services.sshd.enable = true;

    users.users = lib.mapAttrs mkSystemUser users;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users = lib.mapAttrs mkHomeUser users;
    };

    system.stateVersion = "26.05";
  }

