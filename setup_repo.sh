#!/bin/bash

# Set the repository name
REPO_NAME="flutter-web-docker"
FLUTTER_VERSION="3.29.0"

# Create the directory structure
mkdir -p $REPO_NAME/.github/workflows

# Create Dockerfile
cat <<EOF > $REPO_NAME/Dockerfile
# Use the official Flutter image as the base
FROM cirrusci/flutter:stable

# Set the environment variable for Flutter version (this can be dynamic if needed)
ARG FLUTTER_VERSION=$FLUTTER_VERSION
ENV FLUTTER_VERSION=$FLUTTER_VERSION

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
  curl \
  git \
  unzip \
  xz-utils \
  bash \
  build-essential \
  libglu1-mesa

# Install Flutter version (you can specify different versions dynamically)
RUN git clone https://github.com/flutter/flutter.git /flutter
WORKDIR /flutter
RUN git checkout \$FLUTTER_VERSION
RUN flutter doctor

# Enable Flutter web support
RUN flutter config --enable-web

# Set the working directory for Flutter project
WORKDIR /workspace

# Expose port 5000 for the Flutter web server
EXPOSE 5000

# Command to run the Flutter web app (replace with your project's default behavior)
CMD ["flutter", "run", "-d", "chrome", "--web-port=5000"]
EOF

# Create .dockerignore
cat <<EOF > $REPO_NAME/.dockerignore
**/.git
**/.idea
**/.vscode
**/.dart_tool
**/.flutter-plugins
**/.flutter-plugins-dependencies
**/.packages
**/build
EOF

# Create GitHub Actions workflow for release
cat <<EOF > $REPO_NAME/.github/workflows/release.yml
name: Release Docker Image for Flutter Web App

on:
  push:
    tags:
      - "v*"

jobs:
  release:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up Flutter version from the tag
      run: echo "FLUTTER_VERSION=\$(echo \${GITHUB_REF#refs/tags/})" >> \$GITHUB_ENV

    - name: Build Docker image
      run: |
        docker build --build-arg FLUTTER_VERSION=\$FLUTTER_VERSION -t flutter-web-builder:\$FLUTTER_VERSION .

    - name: Save Docker image to file
      run: |
        docker save flutter-web-builder:\$FLUTTER_VERSION | gzip > flutter-web-builder-\$FLUTTER_VERSION.tar.gz

    - name: Upload release asset
      uses: softprops/action-gh-release@v1
      with:
        files: flutter-web-builder-\$FLUTTER_VERSION.tar.gz
      env:
        GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
EOF

# Create README.md
cat <<EOF > $REPO_NAME/README.md
# Docker Image for Building Flutter Web Apps

This repository provides a Docker image that can be used to build and run Flutter web apps. It includes all necessary dependencies and configurations for Flutter web development.

## Getting Started

### Build the Docker image

You can manually build the Docker image with the specified Flutter version:

\`\`\`bash
git clone https://github.com/YOUR_USERNAME/flutter-web-docker.git
cd flutter-web-docker
docker build --build-arg FLUTTER_VERSION=3.29.0 -t flutter-web-builder:3.29.0 .
\`\`\`

### Release Docker Image

To release a new Docker image:

1. Tag the repository with the version number of Flutter you want to release (e.g., \`v3.29.0\`):

   \`\`\`bash
   git tag v3.29.0
   git push origin v3.29.0
   \`\`\`

2. GitHub Actions will automatically build the Docker image and release it as a .tar.gz asset.

### Download and Use Docker Image

To download and use the Docker image:

1. Go to the [GitHub Releases page](https://github.com/YOUR_USERNAME/flutter-web-docker/releases).
2. Download the .tar.gz file for the version you need.
3. Load the Docker image:

   \`\`\`bash
   docker load < flutter-web-builder-3.29.0.tar.gz
   \`\`\`

4. Run the Docker container:

   \`\`\`bash
   docker run --rm flutter-web-builder:3.29.0 flutter build web
   \`\`\`

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
EOF

# Create VERSION file (optional)
echo "3.29.0" > $REPO_NAME/VERSION

echo "All files have been created in the $REPO_NAME directory."

