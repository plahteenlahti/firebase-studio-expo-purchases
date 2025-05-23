{ pkgs, projectName ? "expo-app", ... }: {
  packages = [
    pkgs.nodejs_20
    pkgs.watchman
    pkgs.jdk21_headless
    pkgs.gradle
  ];

  bootstrap = ''
    mkdir "$out"
    cd "$out"
    npx create-expo-app@"latest" . --template blank@sdk-52
    npx expo install react-native-purchases
    npx expo install expo-dev-client
    npx expo prebuild --platform android
    cd ios && pod install || true
    mkdir -p .idx
    cp -rf ${./.idx/dev.nix} .idx/dev.nix
    chmod -R +w "$out"
  '';
}