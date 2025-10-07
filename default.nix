{ pkgs ? import <nixpkgs> { } }:

let
  appName = "elixir_playground";
  appVersion = "0.1";

  elixirEnv = with pkgs; [
    elixir
    erlang
  ];

  dependencies = with pkgs; [
    wget
    nixpkgs-fmt
  ];

  shell = pkgs.mkShell {
    buildInputs = [ elixirEnv dependencies ];
    shellHook = ''
      alias run='mix eval "PlayApp.run"'
      alias app='iex -S mix'
      alias make='cd .. && nix-build -A package; cd play_app'
      nixpkgs-fmt default.nix
      cd play_app
      mix format
    '';
  };

  package = pkgs.stdenv.mkDerivation {
    pname = appName;
    version = appVersion;

    src = ./play_app/.;

    nativeBuildInputs = [ pkgs.makeWrapper ];
    buildInputs = [ elixirEnv ];

    #TODO create matching installPhase
    installPhase = ''
      mkdir -p $out/bin
    '';

    meta = with pkgs.lib; {
      description = "My Elixir application";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
in
{ shell = shell; package = package; }
