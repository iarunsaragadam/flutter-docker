# Docker Image for Building Flutter Web Apps

This repository provides a Docker image that can be used to build and run Flutter web apps. It includes all necessary dependencies and configurations for Flutter web development.

## Getting Started

### Build the Docker image

You can manually build the Docker image with the specified Flutter version:

```bash
git clone https://github.com/YOUR_USERNAME/flutter-web-docker.git
cd flutter-web-docker
docker build --build-arg FLUTTER_VERSION=3.29.0 -t flutter-web-builder:3.29.0 .
```

### Release Docker Image

To release a new Docker image:

1. Tag the repository with the version number of Flutter you want to release (e.g., `v3.29.0`):

   ```bash
   git tag v3.29.0
   git push origin v3.29.0
   ```

2. GitHub Actions will automatically build the Docker image and release it as a .tar.gz asset.

### Download and Use Docker Image

To download and use the Docker image:

1. Go to the [GitHub Releases page](https://github.com/YOUR_USERNAME/flutter-web-docker/releases).
2. Download the .tar.gz file for the version you need.
3. Load the Docker image:

   ```bash
   docker load < flutter-web-builder-3.29.0.tar.gz
   ```

4. Run the Docker container:

   ```bash
   docker run --rm flutter-web-builder:3.29.0 flutter build web
   ```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
