{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "flakes nix-command";
      trusted-users = [
        "root"
        "${config.home.username}"
      ];
    };
  };

  home = {
    username = "user";
    homeDirectory = if isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = lib.mkIf isLinux "sd-switch";
  home.stateVersion = "24.05";
}
