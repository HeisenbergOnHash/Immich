# Dockerfile for Immich Server 

# Use the official Immich server image as the base image
FROM ghcr.io/immich-app/immich-server:${IMMICH_VERSION:-release}

# Set environment variables 
ENV SMB_USERNAME=PinkMan 
ENV SMB_PASSWORD=Jessy@# 
ENV SMB_SERVER=heisenberglabs.mywire.org 
ENV IMMICH_VERSION=release  
ENV DB_USERNAME=DB_USERNAME 
ENV DB_PASSWORD=DB_PASSWORD 
ENV DB_DATABASE_NAME=DB_DATABASE_NAME 

# Copy the application source code (if applicable) to the container
# COPY . /usr/src/app 

# Set the working directory
WORKDIR /usr/src/app 

# Expose port 8085 for the Immich server
EXPOSE 8085

# Healthcheck for the container
HEALTHCHECK CMD curl --fail http://localhost:8085/ || exit 1

# Start the Immich server
CMD [ "npm", "run", "start" ]

# ----------------------
# Dockerfile for Immich Machine Learning
# ----------------------

# Use the official Immich Machine Learning image as the base image
FROM ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION:-release}

# Set environment variables 
ENV SMB_USERNAME=PinkMan 
ENV SMB_PASSWORD=Jessy@# 
ENV SMB_SERVER=heisenberglabs.mywire.org 
ENV IMMICH_VERSION=release  

# Copy the application source code (if applicable) to the container
# COPY . /usr/src/app 

# Set the working directory
WORKDIR /usr/src/app 

# Healthcheck for the container
HEALTHCHECK CMD curl --fail http://localhost:8080/ || exit 1

# Start the machine learning service
CMD [ "npm", "run", "start" ]

# ----------------------
# Dockerfile for Redis (Optional, since Redis has a stable official image)
# ----------------------

# Use the official Redis image
FROM redis:6.2-alpine

# Healthcheck for Redis
HEALTHCHECK CMD redis-cli ping || exit 1

# Start Redis
CMD [ "redis-server" ]

# ----------------------
# Dockerfile for PostgreSQL (Optional, since PostgreSQL has a stable official image)
# ----------------------

# Use the official TensorChord image for PostgreSQL with pgvector
FROM docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0

# Set environment variables
ENV POSTGRES_PASSWORD=${DB_PASSWORD} 
ENV POSTGRES_USER=${DB_USERNAME} 
ENV POSTGRES_DB=${DB_DATABASE_NAME} 

# Set PostgreSQL configuration
CMD [
  "postgres", 
  "-c", "shared_preload_libraries=vectors.so", 
  "-c", "search_path=\"$${user}\", public, vectors", 
  "-c", "logging_collector=on", 
  "-c", "max_wal_size=2GB", 
  "-c", "shared_buffers=512MB", 
  "-c", "wal_compression=on"
]

# Expose port 5432 for PostgreSQL
EXPOSE 5432

# ----------------------
# Notes:
# ----------------------
# 1. Docker Compose is a more suitable way to configure multi-container applications like this.
# 2. If you prefer to use Dockerfiles, consider using a multi-stage build process.
# 3. Volumes and network configurations should be handled in a `docker-compose.yml` file instead.
# 4. This setup assumes you are using `docker-compose` to link these containers together properly.
# 5. This Dockerfile provides the foundation for building individual service images but not the entire application stack. 
# 6. For multi-container orchestration, use a `docker-compose.yml` file for setting up network, volumes, and service dependencies.
