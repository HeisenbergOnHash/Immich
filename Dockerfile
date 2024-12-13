# Use a lightweight Linux server image as the base for Immich Server
FROM debian:bullseye-slim

# Set environment variables 
ENV SMB_USERNAME=PinkMan
ENV SMB_PASSWORD=Jessy@# 
ENV SMB_SERVER=heisenberglabs.mywire.org
ENV IMMICH_VERSION=release  
ENV DB_USERNAME=DB_USERNAME
ENV DB_PASSWORD=DB_PASSWORD
ENV DB_DATABASE_NAME=DB_DATABASE_NAME

# Create the necessary directories
RUN mkdir -p /usr/src/app/upload /cache /var/lib/postgresql/data

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    smbclient \
    tini && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose the required ports
EXPOSE 8085

# Copy the necessary files to the container
COPY . /usr/src/app

# Set the working directory
WORKDIR /usr/src/app

# Set the entrypoint for better signal handling
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start the application using the most efficient method
CMD ["/bin/bash", "start.sh"]
