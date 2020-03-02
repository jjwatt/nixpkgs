# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # kernel params
  # boot.kernelParams = [ "amd_iommu=on iommu=pt" ];
  # Need this for now because my video card is broken on kms  
  # boot.kernelParams = [ "nomodeset" ];
  networking.hostName = "wisdom-like-silence"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n = {
     consoleFont = "Lat2-Terminus16";
     consoleKeyMap = "us";
     defaultLocale = "en_US.UTF-8";
   };

  # Set your time zone.
  time.timeZone = "America/New_York";


  nixpkgs.config = {
	allowUnfree = true;
	allowBroken = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    tmux
    zsh firefox gnupg git pass mkpasswd unzip
    aspell
    aspellDicts.en
    curl
    cdrtools
    dvdplusrwtools
#    (import /etc/nixos/emacs.nix { inherit pkgs; })
    taskwarrior
  ];

  security.wrappers."cdrecord".source = "${pkgs.cdrtools}/bin/cdrecord";
  security.wrappers."readcd".source = "${pkgs.cdrtools}/bin/readcd";
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  services.flatpak.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;


  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip pkgs.brlaser ];
  services.printing.browsing = true;
  services.printing.listenAddresses = [ "*:631" ];
  services.printing.defaultShared = true;
  networking.firewall.allowedUDPPorts = [ 631 ];
  networking.firewall.allowedTCPPorts = [ 631 ];

  # AVAHI, mainly for CUPs and helps to resolve printers, etc. hostnames
  # May be good for NFS eventually, too.
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;

  # Try out scanner support
  hardware.sane.enable = true;
  # HP all-in-one
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Nix Garbage Collection
  nix.gc.automatic = true;
  nix.gc.dates = "03:15";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.mate.enable = true;
  # services.xserver.desktopManager.lumina.enable = true;
  # services.xserver.desktopManager.lxqt.enable = true;
  # services.xserver.desktopManager.pantheon.enable  true;
  services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.2bwm.enable = true;
  # services.xserver.windowManager.awesome.enable = true;
  # services.xserver.windowManager.bspwm.enable  true;
  services.xserver.windowManager = {
	fvwm.enable = true;
	openbox.enable = true;
	dwm.enable = true;
	# cwm.enable = true;
	# herbstluftwm.enable = true;
  };
  # services.xserver.displayManager.lightdm = true;

  # Try enabling telepathy directly. Thought it would come with gnome3,
  # but doesn't appear to.
  services.telepathy.enable = true;
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.jwatt = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" "scanner" "lp" "cdrom" ];
     hashedPassword = "$5$CWEkLQWfM$KoKp.B3qzOZGVoFeIv4/uy.x1ZuaNYqPafGUm5ynWD3";
   };

   fileSystems."/lasting-damage" = {
     device = "/dev/disk/by-uuid/4aa4ffc2-2b25-4df0-a7fe-36abff70d4e4";
     fsType = "btrfs";
   };

   fileSystems."/sto" = {
     device = "/dev/disk/by-label/sto";
     fsType = "btrfs";
     # TODO: Add flags (noatime, etc)
   };

  # NFS shares
  fileSystems."/export/sto" = {
    device = "/sto";
    options = [ "bind" ];
  };
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export/sto        192.168.1.0/24(ro,sync,crossmnt,fsid=0,no_subtree_check,insecure)'';

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

