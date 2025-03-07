# Flutter Docker Builders

This repository provides Docker images for building Flutter applications across multiple platforms. These pre-configured images allow developers to build Flutter projects without installing Flutter and its dependencies locally.

[![Publish Flutter Docker Images](https://github.com/iarunsaragadam/flutter-docker/actions/workflows/flutter-docker-build.yml/badge.svg)](https://github.com/iarunsaragadam/flutter-docker/actions/workflows/flutter-docker-build.yml)

## Available Images

| Image | Purpose | GitHub Package |
|-------|---------|----------------|
| `flutter-web-builder`     | Build Flutter web applications     | [View on GHCR](https://github.com/users/iarunsaragadam/packages/container/package/flutter-web-builder)     |
| `flutter-android-builder` | Build Flutter Android applications | [View on GHCR](https://github.com/users/iarunsaragadam/packages/container/package/flutter-android-builder) |

## Using the Docker Images

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your machine
- A Flutter project you want to build

### Building Flutter Web Applications

Pull the image:

```bash
docker pull ghcr.io/iarunsaragadam/flutter-web-builder:latest
# Or specify a version
# docker pull ghcr.io/iarunsaragadam/flutter-web-builder:v3.29.0
```

Run the container to build your web app (make sure you're in your Flutter project directory):

```bash
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest
```

This will:
1. Mount your current directory to `/app` in the container
2. Run the default command which executes `flutter clean && flutter pub get && flutter build web --release`

The output web build will be available in your project at:
```
build/web/
```

If you want to run a different Flutter command:

```bash
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest flutter analyze
```

To serve the built web app on your host machine:

```bash
# Using Nginx for production-like serving
docker run -it --rm -v $(pwd)/build/web:/usr/share/nginx/html -p 8080:80 nginx:alpine
```

Then open http://localhost:8080 in your browser.

### Building Flutter Android Applications

Pull the image:

```bash
docker pull ghcr.io/iarunsaragadam/flutter-android-builder:latest
# Or specify a version
# docker pull ghcr.io/iarunsaragadam/flutter-android-builder:v3.29.0
```

Run the container to build your Android app (make sure you're in your Flutter project directory):

```bash
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-android-builder:latest
```

This will:
1. Mount your current directory to `/app` in the container
2. Run the default command which executes `flutter clean && flutter pub get && flutter build apk --release`

The output APK will be available in your project at:
```
build/app/outputs/flutter-apk/app-release.apk
```

To build an App Bundle instead:

```bash
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-android-builder:latest flutter build appbundle --release
```

After the build completes, you'll find the APK or AAB in:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- App Bundle: `build/app/outputs/bundle/release/app-release.aab`

### Using an Interactive Shell

If you need to run multiple commands or debug your build:

```bash
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest bash
```

or for Android:

```bash
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-android-builder:latest bash
```

Then you can run Flutter commands interactively:

```bash
flutter pub get
flutter test
flutter build web  # or flutter build apk
```

## Building iOS Applications

Building for iOS requires macOS and cannot be done inside a Docker container due to Apple's platform restrictions. For iOS builds, developers typically use:

- A Mac with Xcode installed
- macOS-based CI/CD runners (GitHub Actions, CircleCI, etc.)
- Specialized Flutter CI/CD services

## Cloning and Building Locally

If you want to build these Docker images locally:

```bash
# Clone the repository
git clone https://github.com/iarunsaragadam/flutter-docker.git
cd flutter-docker

# Build the web image
docker build -t flutter-web-builder:local .

# Build the Android image
docker build -f Dockerfile.android -t flutter-android-builder:local .
```

To build with a specific Flutter version:

```bash
docker build --build-arg FLUTTER_VERSION=3.29.0 -t flutter-web-builder:local .
```

## Image Details

### Web Builder

Built from `ubuntu:22.04` with:
- Flutter SDK
- Web dependencies
- Web port exposed on 5000

### Android Builder

Built from `ubuntu:22.04` with:
- Flutter SDK
- Java 17
- Android SDK
- Build tools
- NDK

## Architecture Support

Both images are built for:
- `linux/amd64` - For Intel/AMD-based systems (Windows, Intel Macs)
- `linux/arm64` - For ARM-based systems (Apple Silicon Macs)

## Versioning

Images are tagged with the Flutter version they contain:
- `latest` - Points to the most recent release
- `v3.29.0` - Specific Flutter version

## License

[MIT License](LICENSE)

## Quick Start Example

Here's a complete example to create a new Flutter app and build it using these Docker images:

### Creating a Sample Flutter App and Building for Web

```bash
# Create a directory for your app
mkdir my_flutter_app
cd my_flutter_app

# Create a sample Flutter app using the web builder
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest flutter create .

# Build the web app (will run automatically with the default command)
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest

# Your web build is now available in build/web/
# You can serve it with Nginx:
docker run -it --rm -v $(pwd)/build/web:/usr/share/nginx/html -p 8080:80 nginx:alpine
```

Then open http://localhost:8080 in your browser.

### Building the Same App for Android

```bash
# From the same app directory
docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-android-builder:latest

# Your APK is now available at build/app/outputs/flutter-apk/app-release.apk
```

### Development Workflow

For a typical development workflow:

1. **Create your app:**
   ```bash
   docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest flutter create .
   ```

2. **Work on your code locally** using your favorite editor

3. **Run tests:**
   ```bash
   docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest flutter test
   ```

4. **Build for Web:**
   ```bash
   docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:latest flutter build web
   ```

5. **Build for Android:**
   ```bash
   docker run -it --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-android-builder:latest
   ```
