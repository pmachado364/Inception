# User Documentation

## Overview

This project deploys a secure WordPress website using Docker.

The stack includes:

- NGINX (HTTPS reverse proxy)
- WordPress (PHP-FPM)
- mariadb (database)

All services run in isolated containers and communicate through a private Docker network.

---

## Prerequisites

Before running the project, ensure:

- You are inside a Debian Bookworm virtual machine
- Docker is installed and running
- Docker Compose is installed
- Make is installed

---

## Initial Setup

#### Configure Local Domain

Edit your `/etc/hosts` file:

```bash
sudo nano /etc/hosts
```

Add the following line:  
`127.0.0.1 <your_login>.42.fr`  
Replace <your_login> with your system username (whoami).  

## Starting the project

From the project root directory:  
```bash
make up
```  
The first build may take a few minutes.


## Stopping the project

To stop the containers: 
```bash
make down
```  
To remove containers and volumes completely:
```bash
make clean
```

To remove everything including stored data:
```bash
make fclean
```

## Accessing the website
Open your browser and navigate to:  
`https://<your_login>.42.fr`  
Because a self-signed certificate is used, your browser will display a warning. You can safely proceed.

## Accessing the WordPress Admin Panel 
Navigate to:  
`https://<your_login>.42.fr/wp-admin`  
Use the administrator credentials defined in the .env file.

## Managing credentials
All credentials are stored in:  
`srcs/.env`  
You can modify:
- Database name and user
- WordPress administrator account
- Additional WordPress user  

After modifying credentials, run:
```bash
make fclean
make up
```
To reboot the stack.

## Checking if services are running
To verify running containers:
```bash
docker ps -a
```
You should see:
- mariadb
- WordPress
- nginx  

To inspect logs:
```bash
docker logs <container_name>
```
Example:
```bash
docker logs <wordpress>
```

## Data persistence
All WordPress and database data are stored at:
`/home/<your_login>/data/`  

This means:
- Data persists after containers restart
- Data persists after your virtual machine reboot
- Data is removed only with `make fclean`  

---

#### You now have a secure, fully containerized web infrastructure running inside your virtual machine.