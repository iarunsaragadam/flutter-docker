FROM ubuntu:22.04

# Set environment variables
ARG FLUTTER_VERSION=3.29.0
ENV FLUTTER_VERSION=$FLUTTER_VERSION
ENV PATH="/flutter/bin:${PATH}"

LABEL org.opencontainers.image.source="https://github.com/iarunsaragadam/flutter-docker"
LABEL org.opencontainers.image.description="Flutter Web Builder - Pre-configured Docker image for building Flutter web applications. Includes Flutter SDK, web dependencies, and build tools. Default command runs 'flutter clean && flutter pub get && flutter build web --release'. Built for both amd64 and arm64 architectures."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.documentation="https://github.com/iarunsaragadam/flutter-docker"

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    bash \
    build-essential \
    libglu1-mesa \
    wget \
    chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter
WORKDIR /flutter
RUN git checkout $FLUTTER_VERSION
RUN flutter doctor

# Enable Flutter web support
RUN flutter config --enable-web

# After enabling web support, download the web SDK
RUN flutter config --enable-web
RUN flutter precache --web

# Set the working directory for Flutter projects
WORKDIR /app

# Expose port 5000 for the Flutter web server
EXPOSE 5000

# Command to run the Flutter web app
CMD ["bash", "-c", "flutter clean && flutter pub get && flutter build web --release"]