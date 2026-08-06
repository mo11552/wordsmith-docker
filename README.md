# [English](README.en.md)
# Wordsmith Docker Application

A three-tier application containerized with Docker and managed with Docker Compose. The project demonstrates communication between a web frontend, a Java API, and a PostgreSQL database.

## Architecture

- **Web:** Go frontend that displays randomly generated sentences
- **Words:** Java API that retrieves words from the database
- **Database:** PostgreSQL initialized with `words.sql`
- **Docker Compose:** Builds and connects all three services

## Technologies

- Docker
- Docker Compose
- Go
- Java and Maven
- PostgreSQL
- HTML, CSS, and JavaScript

## How It Works

1. The browser connects to the Web container.
2. The Web container requests words from the Words API.
3. The Words API connects to PostgreSQL.
4. PostgreSQL returns words used to create a random sentence.

## Run the Application

### Prerequisites

Install Docker Desktop and make sure the Docker engine is running.

### Start the Project

Clone the repository:

```bash
git clone https://github.com/mo11552/wordsmith-docker.git
cd wordsmith-docker

Build and start the containers:
docker compose up -d --build

Check the running containers:
docker compose ps

Use the port shown for the web service to open the application:
http://localhost:<PORT>

Stop the Project
docker compose down

Troubleshooting

View logs for all services:
docker compose logs

View logs for the API and database:
docker compose logs words db

What I Learned
Writing Dockerfiles for Go, Java, and PostgreSQL services
Building and running a multi-container application
Connecting containers through a Docker Compose network
Passing database credentials with environment variables
Troubleshooting container logs and database authentication
Using Git and GitHub to manage project changes

Author

Moyo Olojede

GitHub: mo11552
