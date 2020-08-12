# Mini CRM

This is a sample project building out a Ruby on Rails backend API for a miniature CRM application.

## Installation
First, if you don't already have it installed, please install Docker following the steps at https://docs.docker.com/install/. You will also need the docker-compose tool which can be installed easily through a package manager such as `brew` with `brew install docker-compose`.

Next, run git clone https://github.com/TPedron/mini-crm.git to clone the repository to your local machine, then continue on to each subsection below.

## Running the Application Using Docker

1. Run `docker-compose build` to build the backend image.
2. Run `docker-compose up -d` to bring the API up, accepting requests at `http://localhost:3001`.
3. Run `CONTAINERID=$(docker ps -qf "name=web"); docker exec -it $CONTAINERID rake db:migrate;docker exec -it $CONTAINERID rake db:setup` to setup the database.

## Code Quality & Linting

The `Rubocop` gem has been installed. See `.rubocop.yml` for configurations.

Run `rubocop` before merge and fix any linting issues presented.

## API Docs

You can generate the API Docs (written using OpenAPI) using the following command:

`npx redoc-cli bundle --cdn -o min-crm-api-docs.html api_docs/openapi.yml`

## Architecture

This project implements the following architecture for handling API Requests:
- Controller receives HTTP request + params
- DataTransferObject (aka DTO) is created to parse the json body params into a PORO to decouple the API interface from the implementation.
- The DTO is passed to an application Service to perform the required action(s).
- The Services are the only files in the application that touch ActiveRecord to decople from the ORM
- The ActiveRecord model is returned to the Controller and passed to serializer
