# Use the official Flutter image as the base
FROM cirrusci/flutter:stable

# Set the environment variable for Flutter version (this can be dynamic if needed)
ARG FLUTTER_VERSION=3.29.0
ENV FLUTTER_VERSION=3.29.0

# Install necessary dependencies
RUN apt-get update && apt-get install -y   curl   git   unzip   xz-utils   bash   build-essential   libglu1-mesa

# Install Flutter version (you can specify different versions dynamically)
RUN git clone https://github.com/flutter/flutter.git /flutter
WORKDIR /flutter
RUN git checkout $FLUTTER_VERSION
RUN flutter doctor

# Enable Flutter web support
RUN flutter config --enable-web

# Set the working directory for Flutter project
WORKDIR /workspace

# Expose port 5000 for the Flutter web server
EXPOSE 5000

# Command to run the Flutter web app (replace with your project's default behavior)
CMD ["flutter", "run", "-d", "chrome", "--web-port=5000"]
