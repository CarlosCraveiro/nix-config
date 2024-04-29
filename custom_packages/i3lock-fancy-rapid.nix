{ lib, stdenv, fetchFromGitHub, xorg, pkgs }:

stdenv.mkDerivation {
  pname = "i3lock-fancy-rapid";
  version = "unstable-2024-04-29";

  src = fetchFromGitHub {
    owner = "yvbbrjdr";
    repo = "i3lock-fancy-rapid";
    rev = "6eeebd4caa177b82fa5010b5e8828cce3f89fb97";
    hash = "sha256-EoX8ts0yV/zkb4wgEh4P8noU+UraRS4w9pp+76v+Nm0=";
  };

  buildInputs = [ xorg.libX11 ];

  propagatedBuildInputs = [ pkgs.i3lock-color ];

  postPatch = ''
    substituteInPlace i3lock-fancy-rapid.c \
      --replace '"i3lock"' '"${pkgs.i3lock-color}/bin/i3lock-color"'
  '';

  installPhase = ''
    runHook preInstall

    install -D i3lock-fancy-rapid $out/bin/i3lock-fancy-rapid
    ln -s $out/bin/i3lock-fancy-rapid $out/bin/i3lock

    runHook postInstall
  '';

  meta = with lib; {
    description = "A faster implementation of i3lock-fancy";
    homepage = "https://github.com/yvbbrjdr/i3lock-fancy-rapid";
    maintainers = with maintainers; [ CarlosCraveiro ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
