{ pkgs ? import <nixpkgs> { } }:
let
  inherit (pkgs.lib) getExe;
  inherit (pkgs.lib.fileset) toSource unions;
in
pkgs.stdenv.mkDerivation rec {
  pname = "datetime";
  version = "0.2.3";

  src = toSource {
    root = ./.;
    fileset = unions [
      ./.babelrc
      ./gatsby-config.js
      ./package.json
      ./pnpm-lock.yaml
      ./pnpm-workspace.yaml
      ./src
    ];
  };

  nativeBuildInputs = with pkgs; [
    makeBinaryWrapper

    nodejs
    pnpm
    pnpmConfigHook

    # for sharp build:
    node-gyp
    pkg-config
    python3
  ];

  buildInputs = with pkgs; [
    vips
  ];

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-R7E55MuvIjHaX+6dSH3HLQMV5lWeCpPC+QI3nT6XCzc=";
  };

  buildPhase = ''
    export MAKEFLAGS="-j$NIX_BUILD_CORES"
    pnpm config set nodedir ${pkgs.nodejs}
    pnpm install --force --frozen-lockfile --offline
    pnpm build
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r public $out/app

    makeWrapper                                \
      ${getExe pkgs.python3} $out/bin/datetime \
      --add-flags "-m http.server -d $out/app"
  '';

  meta = {
    description = "A site that tells you what date and time it is right now";
    homepage = "https://github.com/42LoCo42/what-datetime-is-it-right-now-dot-com";
    mainProgram = pname;
  };
}
