FROM didstopia/base:nodejs-12-steamcmd-ubuntu-18.04

# Fixes apt-get warnings
ARG DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
	apt-get install -y --no-install-recommends xvfb xdg-user-dirs xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Create the volume directories
RUN mkdir -p /steamcmd/fg

# Add the steamcmd installation script
ADD install.txt /app/install.txt

# Copy scripts
ADD start_fg.sh /app/start.sh

# Fix permissions
RUN chown -R 1000:1000 \
    /steamcmd \
    /app

# Run as a non-root user by default
ENV PGID 1000
ENV PUID 1000

# Expose necessary ports
EXPOSE 15777/udp
EXPOSE 15000/udp
EXPOSE 7777/udp

# Setup default environment variables for the server
ENV FG_SERVER_STARTUP_ARGUMENTS ""
ENV FG_BRANCH "public"
ENV FG_START_MODE "0"

# Define directories to take ownership of
ENV CHOWN_DIRS "/app,/steamcmd"

# Expose the volumes
VOLUME [ "/steamcmd/fg", "/app/.config/Epic" ]

# Start the server
CMD [ "bash", "/app/start.sh" ]

