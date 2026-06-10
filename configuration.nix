{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  programs.git.enable = true;

  services.sshd.enable = true;

  users.users.alitoprak = {
    isNormalUser = true;
    home = "/home/alitoprak";
    description = "My personal user.";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  system.stateVersion = "26.05";
}

