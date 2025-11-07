{ pkgs ? import <nixpkgs> { } }:

let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-25.05";
  pkgs = import nixpkgs { config = { }; overlays = [ ]; };

  appName = "elixir_playground";
  appVersion = "0.1";

  elixirEnv = with pkgs; [
    elixir
    erlang
  ];

  beamPackages = pkgs.beam.packagesWith pkgs.beam.interpreters.erlang;

  dependencies = with pkgs; [
    wget
    git
    nixpkgs-fmt
    jujutsu
  ];

  shell = pkgs.mkShell {
    buildInputs = [ elixirEnv dependencies ];
    shellHook = ''
      alias run='mix run --no-halt'
      alias repl='iex -S mix'
      alias make='nix-build -A package'
      nixpkgs-fmt default.nix
      mix format
      mix deps.get
    '';
  };

  package = beamPackages.mixRelease {
    pname = appName;
    version = appVersion;
    src = ./.;
    removeCookie = false;
  };


in
{ shell = shell; package = package; }
