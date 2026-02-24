*This project has been created as part of the 42 curriculum by pmachado.*

# Inception

---
## Documentation Portal

Depending on your needs, please refer to the detailed documentation below:

*   **[What is this project?](#overview)** (Read on above for a high-level summary)
*   **[User Documentation](docs/USER_DOC.md):** Read this if you just want to **run and use** the application. It covers prerequisites, installation steps, accessing the site, and basic troubleshooting.
*   **[Developer Documentation](docs/DEV_DOC.md):** Read this if you want to understand the **technical implementation**. It covers the Dockerfile strategies, configuration choices, network design, and the `Makefile` structure.
---

## Overview

Inception is a system administration project focused on setting up a small-scale, containerized web infrastructure using Docker.

The primary goal is to understand containerization and networking by building services **from scratch**, rather than relying on pre-configured images.
The project deploys a functional WordPress website built on a multi-container architecture composed of:

-   **NGINX:** The single public entry point, handling HTTPS (TLSv1.2 / TLSv1.3).
-   **WordPress + PHP-FPM:** The application layer serving dynamic content.
-   **MariaDB:** The database storing site data.
-   **Docker named volumes:** Ensuring persistence of both database and website files.
-   **Private Docker network:** Allowing internal communication between services.

The entire infrastructure runs inside a Linux virtual machine and only exposes port **443 (HTTPS)**.

## Key Concepts Demonstrated

- Container orchestration with Docker Compose  
- Service isolation and networking  
- TLS configuration and HTTPS enforcement  
- Persistent storage with Docker volumes  
- Secure handling of environment variables and secrets

## High-Level Architecture

This diagram illustrates how the services communicate and where persistent data is stored.

```mermaid
%%{init: {'theme':'base', 'themeVariables': {
  'primaryColor': '#ffffff',
  'primaryBorderColor': '#000000',
  'lineColor': '#000000',
  'secondaryColor': '#ffffff',
  'tertiaryColor': '#ffffff'
}}}%%
graph TD

Client["Client Browser"] -->|HTTPS :443| NGINX["NGINX"]

subgraph "Docker Network"
NGINX -->|FastCGI :9000| WP["WordPress + PHP-FPM"]
WP -->|TCP :3306| DB["MariaDB"]
end

subgraph "Named Volumes"
WP -.->|/var/www/html| VolWP["WordPress Data"]
DB -.->|/var/lib/mysql| VolDB["Database Data"]
end

```

## Project Structure

The repository is organized as follows:

```
inception/
├── Makefile
├── README.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── 50-server.cnf
        │   └── tools/
        │       └── entrypoint.sh
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        │       └── site.conf
        |
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            │   └── www.conf
            └── tools/
                └── entrypoint_wp.sh

```

## Quick Start (TL;DR)

1.  **Prerequisites:** Ensure Docker, Docker Compose, and Make are installed in a Debian Bookworm VM.
2.  **Host Config:** Add the following line to your host's `/etc/hosts` file:
    `127.0.0.1 pmachado.42.fr`
3.  **Run:** Execute the following command at the project root:
    ```bash
    make up
    ```
    *(The first build might take a few minutes).*
4.  **Access:** Open `https://pmachado.42.fr` in your browser. A warning will be issued due to our self-signed certificate but you can safely proceed.
---
