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
  version = "32.3.0";

  src = fetchFromGitHub {
    owner = "be5invis";
    repo = "Iosevka";
    rev = "6f207f827dd957b64f249ba3877803afe8bcbd3c";
    sha256 = "sha256-wK2UlDMV284wU7Tis8uOt1aC+ik/hBQbA9oQbKtcxDA=";
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
