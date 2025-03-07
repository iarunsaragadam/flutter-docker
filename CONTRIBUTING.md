# Contributing to Flutter Docker Builders

Thank you for your interest in contributing to the Flutter Docker Builders project. This document outlines our contribution guidelines and explains the project's maintenance philosophy.

## Project Philosophy

This project aims to provide simple, reliable Docker images for building Flutter applications across platforms. The images are designed to be:

1. **Minimal** - Including only what's necessary for building Flutter apps
2. **Reliable** - Working consistently across different environments
3. **Up-to-date** - Supporting recent Flutter versions
4. **Well-documented** - Easy for new users to understand and use

## Limited Contribution Scope

This project is relatively stable and requires minimal maintenance. The primary ongoing work involves:

1. Updating Flutter versions
2. Maintaining compatibility with latest Flutter features
3. Ensuring multi-architecture support

For these reasons, we typically don't require extensive contributions. The automated workflows handle most updates, and the Dockerfiles are intentionally kept simple.

## When Contributions Are Welcome

Despite the limited scope, we welcome contributions in the following areas:

### 1. Bug Fixes

If you encounter a bug or an issue with the Docker images, please open an issue describing:
- What you were trying to do
- What you expected to happen
- What actually happened
- Steps to reproduce the issue

If you have a fix for the bug, please follow the pull request process below.

### 2. Documentation Improvements

Contributions that improve the documentation are always welcome, including:
- Fixing typos or errors
- Improving clarity
- Adding examples or use cases
- Translating documentation

### 3. Performance Optimizations

If you identify ways to make the Docker images smaller, faster, or more efficient without sacrificing reliability, please submit a pull request.

### 4. Support for New Flutter Features

When Flutter adds new capabilities that require changes to the Docker build environment, contributions to support these features are welcome.

## Pull Request Process

1. **Fork the repository** to your own GitHub account
2. **Create a branch** from `main` with a descriptive name
3. **Make your changes**, ensuring they follow the project's style and philosophy
4. **Test your changes** thoroughly
   - Build the Docker images locally
   - Verify they work with sample Flutter projects
   - Check compatibility with different Flutter versions
5. **Update documentation** if necessary
6. **Submit a pull request** describing:
   - The problem you're solving
   - How your changes solve it
   - Any potential side effects
   - Testing you've performed

## Development Environment Setup

To work on this project, you'll need:

1. **Docker** installed on your machine
2. **Git** for version control
3. A **Flutter project** for testing the images

### Local Build and Test Workflow

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/flutter-docker.git
cd flutter-docker

# Build the images
docker build -t flutter-web-builder:dev .
docker build -f Dockerfile.android -t flutter-android-builder:dev .

# Test with a Flutter project
cd path/to/flutter/project
docker run -it --rm -v $(pwd):/app flutter-web-builder:dev flutter build web
docker run -it --rm -v $(pwd):/app flutter-android-builder:dev flutter build apk
```

## Code Review Process

Pull requests will be reviewed with focus on:
1. **Simplicity** - Avoiding unnecessary complexity
2. **Reliability** - Ensuring consistent behavior
3. **Performance** - Minimizing image size and build time
4. **Documentation** - Clear explanation of changes

## Adding Support for New Flutter Versions

The most common contribution will be updating for new Flutter versions. This is typically handled automatically via the GitHub Actions workflow, but if you need to do it manually:

1. Test the Dockerfiles with the new Flutter version
2. Update documentation if there are any compatibility notes
3. Submit a pull request with these changes

## Reporting Security Issues

If you discover a security vulnerability, please do NOT open a public issue. Instead, email security@example.com with details, and we'll address it promptly.

## Code of Conduct

Please be respectful and professional when interacting with other contributors. We aim to maintain a welcoming and inclusive environment for everyone.

## Questions or Need Help?

If you have questions about contributing or need assistance, please open an issue with the "question" label.

Thank you for your interest in improving Flutter Docker Builders!
