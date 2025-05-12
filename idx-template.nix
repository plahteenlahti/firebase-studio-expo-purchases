{ pkgs, projectName ? "expo-app", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.watchman
    pkgs.yarn
    pkgs.cocoapods
    pkgs.jdk21_headless
    pkgs.gradle
  ];

  bootstrap = ''
    mkdir "$out"
    mkdir -p "$out/.idx/"
    cp -rf ${./template/dev.nix} "$out/.idx/dev.nix"
    shopt -s dotglob; cp -r ${./template}/* "$out"

    cd "$out"
    npx create-expo-app@"latest" "${projectName}" --template blank@sdk-52
    cd "${projectName}"
    yarn add react-native-purchases
    npx expo install expo-dev-client
    npx expo prebuild --platform android
    cd ios && pod install || true
    chmod -R +w "$out"
  '';
}