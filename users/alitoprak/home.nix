{ config, lib, pkgs, hostname, username, userConfig, ... }: {
  /*
  imports =
    [
    ];
  */

  programs.git = {
    enable = true;
        
    settings = {
      user.name = "alitoprak";
      user.email = "kaynakalitoprak@gmail.com";

      init.defaultBranch = "main";

      safe.directory = "/etc/nixos";
    };
  };

  programs.firefox.enable = true;
}
