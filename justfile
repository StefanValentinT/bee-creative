default:
    rm -rf build/web
    flutter build web --release
    python3 -m http.server 8080 -d build/web
