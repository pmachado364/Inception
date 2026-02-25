# Developer Documentation

## Architecture Overview

This project implements a three-tier web architecture using Docker:

- **NGINX** → Reverse proxy and HTTPS termination
- **WordPress (PHP-FPM)** → Application layer
- **MariaDB** → Database layer

Each service runs in its own container and communicates over a dedicated Docker bridge network.

The design follows separation of concerns and service isolation principles.

---

## Container Design Philosophy

Each container is built from a minimal Debian Bookworm base image.

No pre-configured Docker images (such as `wordpress:latest` or `nginx:alpine`) are used.  
All services are installed and configured manually inside custom Dockerfiles.

This ensures:

- Full control over installed packages
- Explicit configuration
- Clear understanding of service dependencies
- Compliance with project requirements

Containers are configured to run a single main process (PID 1) without using infinite loops.

---

## Networking Strategy

A dedicated Docker bridge network (`all`) connects all containers.

- **NGINX** exposes port 443 to the host.
- **WordPress** and **MariaDB** are not exposed externally.
- Internal communication uses service names as hostnames.

Example:

- WordPress connects to MariaDB using `mariadb:3306`.
- NGINX connects to WordPress using FastCGI on port `9000`.

This isolates internal services from the host machine and limits external exposure to HTTPS only.

---

## Volume & Persistence Strategy

Persistent data is stored using bind-mounted named volumes:  
`/home/<login>/data/database`  
`/home/<login>/data/wordpress`  

This ensures:  

- Data survives container restarts
- Data survives virtual machine reboots
- Data is removed only with `make fclean`  

MariaDB initialization is guarded to run only if the database is not already initialized.  
WordPress installation logic also checks whether the site is already installed before executing setup commands.  

---

## Environment Variables & Configuration

Configuration values are stored in `srcs/.env`.

These include:

- Database credentials
- WordPress administrator credentials
- Domain name

Build-time variables (e.g., certificate domain name) are passed using Docker build arguments.

Runtime variables are injected into containers using `environment:` in `docker-compose.yml`.

This separation ensures correct handling of build-time versus runtime configuration.

---

## TLS & NGINX Configuration

NGINX is configured to:

- Serve only HTTPS (port 443)
- Use a self-signed certificate generated during image build
- Support TLSv1.2 and TLSv1.3 only  

HTTP (port 80) is intentionally not exposed.

---

## WordPress Initialization Logic

The WordPress container:

1. Waits for MariaDB to become available.
2. Downloads WordPress core files if missing.
3. Creates `wp-config.php` if not present.
4. Installs WordPress if not already installed.
5. Creates an additional non-admin user.  

The installation uses:  

`--url="https://${DOMAIN_NAME}"`  

to ensure correct domain configuration.

All setup logic is idempotent, meaning it does not run again if already completed.

---

## MariaDB Initialization Logic

MariaDB is started using an entrypoint script that:

1. Launches the server with `--skip-networking` during initialization.
2. Waits until the database server is ready.
3. Creates the database and user if not already present.
4. Sets the root password.
5. Gracefully shuts down and restarts under normal operation.

Initialization runs only once, controlled by a marker file in the data directory.

---

## Makefile Design

The Makefile acts as a simplified orchestration interface.

It provides:

- `make up` → Build and start containers
- `make down` → Stop containers
- `make clean` → Remove containers and volumes
- `make fclean` → Remove containers and persistent data

It dynamically determines:  

`LOGIN = $(shell whoami)`
`DOMAIN_NAME = $(LOGIN).42.fr`  


This allows the project to adapt automatically to different users and environments.

---

## Design Decisions & Trade-offs

### Why Docker Instead of a Single VM Setup?

Docker provides:

- Service isolation
- Reproducibility
- Clean dependency management
- Easier teardown and rebuild

### Why Bind Mounts Instead of Anonymous Volumes?

Bind mounts allow:

- Explicit control over data location
- Easy inspection of database files
- Clear compliance with project storage requirements

### Why Separate Containers?

Following the single-responsibility principle ensures:

- Easier debugging
- Clear service boundaries
- Independent restart behavior

---

## Conclusion

This project intends to demonstrate a complete containerized web stack built from scratch, with secure configuration, controlled networking, and persistent storage.

It reflects an understanding of container orchestration, service isolation, and infrastructure design principles.