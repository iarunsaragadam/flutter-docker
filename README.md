# Flutter Web Builder

A Docker image for building Flutter web applications with specific Flutter versions.

## Overview

This repository contains a Dockerfile and GitHub Actions workflow to build and publish Docker images with specific Flutter versions. These images can be used to build Flutter web applications in CI/CD pipelines or development environments with a consistent Flutter SDK.

## Usage

### Pull the image

```bash
docker pull ghcr.io/iarunsaragadam/flutter-web-builder:v3.29.0
```

Replace `v3.29.0` with the specific Flutter version you need.

### Run the container

```bash
docker run --rm -v $(pwd):/app ghcr.io/iarunsaragadam/flutter-web-builder:v3.29.0 bash -c "cd /app && flutter build web"
```

This mounts your current directory to `/app` in the container and runs the Flutter web build command.

## Available Versions

The Docker images are tagged with the corresponding Flutter version. For example:

- `ghcr.io/iarunsaragadam/flutter-web-builder:v3.29.0`
- `ghcr.io/iarunsaragadam/flutter-web-builder:v3.28.0`
- `ghcr.io/iarunsaragadam/flutter-web-builder:v3.27.0`

Check the [GitHub Container Registry](https://github.com/iarunsaragadam/flutter-docker/pkgs/container/flutter-web-builder) for all available versions.

## Dockerfile

The Dockerfile installs the specified Flutter version and configures it for web development. It includes:

- Flutter SDK with web support
- Chrome browser for testing
- Required dependencies

## GitHub Actions Workflow

The repository includes a GitHub Actions workflow that:

1. Builds the Docker image with the Flutter version from the tag or branch
2. Publishes the image to GitHub Container Registry (GHCR)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

[MIT License](LICENSE)
