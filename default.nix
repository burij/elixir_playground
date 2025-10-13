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
      alias run='mix format; mix run_cli'
      alias repl='iex -S mix'
      alias make='nix-build -A package'
      nixpkgs-fmt default.nix
      mix deps.get
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
