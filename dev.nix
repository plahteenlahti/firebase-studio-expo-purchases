{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.nodejs_20
    pkgs.watchman
    pkgs.yarn
    pkgs.cocoapods
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
          echo "Enter project name:"
          read PROJECT_NAME
          npx create-expo-app@"latest" "$PROJECT_NAME" --template blank@sdk-52
          cd "$PROJECT_NAME"
          yarn add react-native-purchases
          npx expo install expo-dev-client
          npx expo prebuild --platform all
          cd ios && pod install && cd ..
        '';
      };
      onStart = {
        android = ''
          cd $(find . -maxdepth 1 -type d -not -name 'node_modules' -not -name '.' | head -n 1)
          adb -s emulator-5554 wait-for-device
          yarn android
        '';
        ios = ''
          cd $(find . -maxdepth 1 -type d -not -name 'node_modules' -not -name '.' | head -n 1)
          xcrun simctl boot "iPhone 14" || true
          yarn ios
        '';
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = [ "yarn" "web" "--" "--port" "$PORT" ];
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