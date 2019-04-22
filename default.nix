{ lib, stdenv, fetchFromGitHub, makeWrapper, glibcLocales, bc, coreutils
, curl, ethabi, ethsign, git, go-ethereum, gnused, jshon, jq, nodejs, perl, solc }:

stdenv.mkDerivation rec {
  name = "mcd-${version}";
  version = "0.2.4-rc.1";
  src = ./.;

  nativeBuildInputs = [makeWrapper];
  buildPhase = "true";
  makeFlags = ["prefix=$(out)"];
  postInstall = let path = lib.makeBinPath [
    bc coreutils curl ethabi ethsign git go-ethereum gnused jshon jq nodejs perl solc
  ]; in ''
    wrapProgram "$out/bin/mcd" --prefix PATH : "${path}" \
      ${if glibcLocales != null then
        "--set LOCALE_ARCHIVE \"${glibcLocales}\"/lib/locale/locale-archive"
        else ""}
  '';

  meta = {
    description = "Command-line client Multicollateral Dai";
    homepage = https://github.com/makerdao/mcd-cli/;
    maintainers = [stdenv.lib.maintainers.dbrock];
    license = lib.licenses.gpl3;
    inherit version;
  };
}
