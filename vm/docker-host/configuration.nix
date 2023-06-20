{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "freki";
  networking.hostId = "7782BF0F";

  boot.initrd.supportedFilesystems = ["zfs"];
  boot.supportedFilesystems = [ "zfs" ];
  services.zfs.autoSnapshot = { 
    enable = true;
    frequent = 30;
  };

  networking.useDHCP = false;
  networking.interfaces.docker0.useDHCP = true;
  networking.interfaces.ens18.ipv4.addresses = [ {
    address = "10.10.30.100";
    prefixLength = 24;
  } ];
  networking.defaultGateway = "10.10.30.1";
  networking.nameservers = [ "1.1.1.1" ];

  users.users.cuken = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    wget
    inetutils
    curl
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;
  
  system.stateVersion = "23.05";

}

