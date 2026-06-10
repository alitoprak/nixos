{ config, lib, pkgs, hostname, username, userConfig, ... }: {
  /*
  imports =
    [
    ];
  */

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
        
    settings = {
      user.name = "alitoprak";
      user.email = "kaynakalitoprak@gmail.com";

      init.defaultBranch = "main";

      safe.directory = "/etc/nixos";
    };
  };
}
