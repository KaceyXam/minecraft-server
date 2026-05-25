{ pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    playit-nixos-module.nixosModules.default
  ];

  services.playit = {
    enable = true;
    secretPath = ./secret.toml;
  };
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "kniffen-server"; # Define your hostname.

  networking.networkmanager.enable = true;

  services.tuned.enable = true;
  services.upower.enable = true;
  
  time.timeZone = "America/Chicago";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.kniffen = {
    isNormalUser = true;
    description = "Kniffen Family";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  users.users.kxkniffen = {
    isNormalUser = true;
    description = "Admin Account";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    tmux
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11";
}
