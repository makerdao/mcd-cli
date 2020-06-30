{ lib, stdenv, fetchFromGitHub, makeWrapper, glibcLocales
, bc, coreutils, curl, findutils, gawk, gnugrep, gnused, perl
, jshon, jq, nodejs, git
, solc, go-ethereum, seth, ethabi, ethsign
}:

stdenv.mkDerivation rec {
  name = "mcd-${version}";
  version = lib.fileContents ./version;
  src = lib.sourceByRegex ./. [
    "bin" "bin/.*"
    "libexec" "libexec/.*"
    "Makefile"
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    bc coreutils curl findutils gawk gnugrep gnused perl
    jshon jq nodejs git
    solc go-ethereum seth ethabi ethsign
  ];

  buildPhase = "true";
  makeFlags = ["prefix=$(out)"];

  postInstall = let
    path = lib.makeBinPath buildInputs;
    locales = lib.optionalString (glibcLocales != null)
      "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive";
  in ''
    wrapProgram "$out/bin/mcd" \
      --set PATH "${path}" \
      ${locales}
  '';

  meta = {
    description = "Command-line client Multicollateral Dai";
    homepage = https://github.com/makerdao/mcd-cli/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    license = lib.licenses.gpl3;
    inherit version;
  };
}
