{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.nodejs_20
    pkgs.watchman
    pkgs.jdk21_headless
    pkgs.gradle
  ];

  env = {
    EXPO_USE_FAST_RESOLVER = 1;
  };

  idx = {
    extensions = [ "msjsdiag.vscode-react-native" ];

    workspace = {
      onCreate = {
        setup = ''
          PROJECT_NAME="expo-app"
          npx create-expo-app@"latest" "$PROJECT_NAME" --template blank@sdk-52
          cd "$PROJECT_NAME"
          npx expo install react-native-purchases
          npx expo install expo-dev-client
          npx expo prebuild --platform all
          cd ios && pod install && cd ..
        '';
      };
      onStart = {
        android = ''
          cd $(find . -maxdepth 1 -type d -not -name 'node_modules' -not -name '.' | head -n 1)
          adb -s emulator-5554 wait-for-device
          npx expo run:android
        '';
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = [ "npx" "expo" "start" "--" "--port" "$PORT" ];
          manager = "web";
        };
        android = {
          command = [ "tail" "-f" "/dev/null" ];
          manager = "web";
        };
        ios = {
          command = [ "tail" "-f" "/dev/null" ];
          manager = "web";
        };
      };
    };
  };
}