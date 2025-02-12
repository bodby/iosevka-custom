{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  importNpmLock,
  pname,
  ttfautohint,
}:

buildNpmPackage rec {
  inherit pname;
  version = "32.5.0";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "Iosevka";
    rev = "7b39833e2774d3234b92501544016617ad158588";
    sha256 = "sha256-MzsAkq5l4TP19UJNPW/8hvIqsJd94pADrrv8wLG6NMQ=";
  };

  # "package-lock.json" = builtins.readFile ../package-lock.json;
  # "package.json" = builtins.readFile ../package.json;

  npmDeps = importNpmLock {
    npmRoot = src;
  };

  npmConfigHook = importNpmLock.npmConfigHook;

  nativeBuildInputs = [ ttfautohint ];

  postPatch = ''
    cp -v ${../private-build-plans.toml} private-build-plans.toml
  '';

  enableParallelBuilding = true;

  buildPhase = ''
    export HOME=$TMPDIR
    runHook preBuild

    npm run build --no-update-notifier --targets contents::IosevkaCustom -- --jCmd=$NIX_BUILD_CORES --verbose=9

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -t $out/share/fonts/truetype/ dist/IosevkaCustom/TTF/*.ttf

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/be5invis/Iosevka";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ bodby ];
    platform = lib.platforms.linux;
  };
}
