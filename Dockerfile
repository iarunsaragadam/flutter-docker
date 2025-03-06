FROM ubuntu:22.04

# Set environment variables
ARG FLUTTER_VERSION=3.29.0
ENV FLUTTER_VERSION=$FLUTTER_VERSION
ENV PATH="/flutter/bin:${PATH}"

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
CMD ["flutter", "run", "-d", "web-server", "--web-port=5000"]