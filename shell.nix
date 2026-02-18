{ pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  } }:
let
  android = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "36" ];
    buildToolsVersions = [ "28.0.3" ];
    abiVersions = [ "arm64-v8a" ];
  };
in

pkgs.mkShell {
  buildInputs = [
    pkgs.flutter
    pkgs.git
    android.androidsdk
  ];

  shellHook = ''
    export ANDROID_SDK_ROOT=${android.androidsdk}/libexec/android-sdk
    export ANDROID_HOME=$ANDROID_SDK_ROOT

    export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
    export PATH=$ANDROID_SDK_ROOT/cmdline-tools/19.0/bin:$PATH
    export PATH=$ANDROID_SDK_ROOT/build-tools/34.0.0:$PATH

    echo "Android SDK Root: $ANDROID_SDK_ROOT"
  '';
}
