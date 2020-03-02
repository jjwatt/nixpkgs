{ pkgs ? import <nixos> {} }:
let
	myEmacs = pkgs.emacs;
	emacsWithPackages = (pkgs.emacsPackagesGen myEmacs).emacsWithPackages;
in
	emacsWithPackages (epkgs: (with epkgs.melpaPackages; [
		nix-mode ]))

