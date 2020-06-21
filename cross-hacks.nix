# From this upstream repo:
# https://github.com/samueldr/cross-system
{ config, pkgs, lib, ... }:
{

  nixpkgs.overlays = [
    (self: super: {
      # Does not cross-compile...
      alsa-firmware = pkgs.runCommandNoCC "neutered-firmware" {} "mkdir -p $out";

    # A "regression" in nixpkgs, where python3 pycryptodome does not cross-compile.
    crda = pkgs.runCommandNoCC "neutered-firmware" {} "mkdir -p $out";
    })
  ];

  # (Failing build in a dep to be investigated)
  security.polkit.enable = false;

  # cifs-utils fails to cross-compile
  # Let's simplify this by removing all unneeded filesystems from the image.
  boot.supportedFilesystems = lib.mkForce [ "vfat" ];

  # texinfoInteractive has trouble cross-compiling
  documentation.info.enable = lib.mkForce false;

  # `xterm` is being included even though this is GUI-less.
  # → https://github.com/NixOS/nixpkgs/pull/62852
  services.xserver.desktopManager.xterm.enable = lib.mkForce false;

  # ec6224b6cd147943eee685ef671811b3683cb2ce re-introduced udisks in the installer
  # udisks fails due to gobject-introspection being not cross-compilation friendly.
  services.udisks2.enable = lib.mkForce false;
}
