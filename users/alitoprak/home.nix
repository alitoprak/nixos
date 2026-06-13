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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        mkhl.direnv
        ziglang.vscode-zig
        ms-vscode.hexeditor
      ];

      userSettings = {
        "chat.disableAIFeatures" = true;
        "security.workspace.trust.enabled" = false;
        "zig.zls.enabled" = "on";
      };
    };
  };
}
