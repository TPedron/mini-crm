# Mini CRM API

This is a sample project building a Ruby on Rails backend API for a miniature CRM application.

## 1. Project Overview

The requirements of this project are:
1. REST APIs to allow for CRUD of Contacts and associated Tags.
   - `GET (index)/POST/PATCH/DELETE` endpoints are exposed for both `contact` and `tag` resources.
   - Tags can also be created through the the `POST/PATCH contact` endpoints through the `find_or_create` mechanism.
   - All example Contacts + Tags provided in project description are seeded into system during setup (See *Section 3.2 Running the Application Using Docker*).
2. The ability to search for all Contacts with a given Tag name.
   - The `GET contacts` index endpoint has an optional `tag=<tag_name>` query parameter filter.
3. Sound Design choices
   - See *Section 2: Application Design & Architecture*
4. Excellent coding practices
   - See *Section 2: Application Design & Architecture*
5. Robust tests
   - Full set of tests for Controllers, Models and Service classes.
   - Using FactoryBot (see: https://github.com/thoughtbot/factory_bot) & Faker (see https://github.com/faker-ruby/faker) gems for high quality testing data.
   - Manual testing supported with provided Postman suite (See *Section 6. Postman*).
6. GitHub Repository With Clear Commit History
   - All commits were merged into `master` with PRs and descriptive commit messages.
7. WOW Factors
   - The application is fully Dockerized (See *Section 3.2 Running the Application Using Docker*).
   - API implemented using JSON API spec & the Netflix FastJSONApi gem (See https://github.com/jsonapi-serializer/jsonapi-serializer).
   - API documentation using OpenAPI (See *Section 4. API Documentation*) and Redoc (See https://github.com/Redocly/redoc).
   - Postman suite (See *Section 6. Postman*).
   - UML documentation (See *Section 2.3 Models*).
   - New Tags can be easily created as part of creating or updating a Contact (See *Section 2.3.1 Contacts*).
   - Rubocop linting configurations followed throughout development. (See *Section 5. Code Quality & Linting*).

Below is a list of tasks I would have liked to have implemented but did not have the time:
- Pagination on the Contact & Tag index endpoints
- More filter options on the Contact index endpoint
- Contact Show endpoint (`GET /api/v1/contacts/:contact_uuid`)
- Improve the Postman suite to validate response JSON returned.
- Add schema validation logic to controllers HTTP requests and in controller tests for responses. This ensures that expected JSON coming in and leaving the system are in sync with the schema files used to generate API docs.
- Tag archiving functionality.
- More examples in API Docs.

## 2. Application Design

### 2.1 Design Decisions

Below is a list of design decisions:
- REST API follows the JSON API Specification (See: https://jsonapi.org).
- UUID fields are used as public identifiers for records in API requests/responses, numeric IDs are only used internally.
  - I do not like using UUIDs as database primary keys on tables since it has affects on the sorting implementation in ActiveRecord.
- Errors are caught in `ApplicationController` and return standardized error messages using an `ErrorMessageBuilderService`.
- All endpoints are namespaced to `/api/v1`.

### 2.2 Architecture

This project implements the following application architecture for handling API Requests:
- The Controller receives HTTP request + parameters/JSON body.
- A DataTransferObject (aka DTO) is created to parse the JSON body into a PORO (Plain Old Ruby Object) to decouple the API interface from the rest of the implementation.
- The DTO is passed to an Application Service to perform the required action(s).
- The Services perform the CRUD actions and return an ActiveRecord model.
  - The Services are also the only files in the system, that touch ActiveRecord in order to decouple the implementation from the ORM.
- The ActiveRecord model is returned to the Controller and passed to Serializer.
- Serializer generates JSON API spec-conforming responses to return to client.

### 2.3 Models

Below is an entity-relationship diagram for the database schema.

![ERD](uml/export/erd-v1.0.png)

#### 2.3.1 Contacts

- Contacts have a many to many relationship to Tags through a join table.
- Contacts can be "soft deleted" (see `deleted` bool field) to prevent critical data loss.
- Tags can be added or removed from a Contact through the `POST/PATCH contact` endpoints.
  - This works by performing `find_or_creates` using the provided name(s) and then updating the associations to the Contact accordingly.
  - The reasoning for this is that it is important to make managing Contacts as easy and simple as possible without as much required overhead for managing Tags. One should be able to create a new Contact associated to a new Tag without having to through multiple steps:
    - Having to create Tags before Contact creation so you can add them as part of Contact creation.
    - Having to create Tags after Contact creation then update the Contact with the Tag.
- From an API perspective, Tags are an attribute of Contact to simplify API usage (tags serialized as part of Contact response as a list of String).

Below is sequence diagram for basic CRUD on Contacts:

![Contact CRUD](uml/export/contact-crud-sequence-diagram-v1.0.png)

#### 2.3.2 Tags

- Tags have a many to many relationship to Contacts through a join table.
- Tags can be "hard deleted" since they are not critical.
- It is impossible to create duplicate tags since all create actions are actually `find_or_creates`.
  - This was done to increase referential data integrity and to reduce the amount of duplicate data in the system.
  - Note that this means that the `POST tag` endpoint returns a status code `200` and not `201` since new records are not always created.

Below is sequence diagram for basic CRUD on Tags:

![Tag CRUD](uml/export/tag-crud-sequence-diagram-v1.0.png)

### 3 Running The Application

### 3.1 Installation

First, if you don't already have it installed, please install Docker following the steps at https://docs.docker.com/install/. You will also need the `docker-compose` tool which can be installed easily through a package manager such as `brew` with `brew install docker-compose`.

Next, run `git clone https://github.com/TPedron/mini-crm.git` to clone the repository to your local machine.

### 3.2 Running the Application Using Docker

1. Run `docker-compose build` to build the backend image (called `web`).
2. Run `docker-compose up -d` to bring the API up, accepting requests at `http://localhost:3000`.
3. Run `CONTAINERID=$(docker ps -qf "name=web"); docker exec -it $CONTAINERID rake db:setup` to setup the database and add seeds.
4. If you need to, enter the container using `CONTAINERID=$(docker ps -qf "name=web"); docker exec -it $CONTAINERID bash`

## 4. API Documentation

The API documents are written in OpenAPI, see: https://www.openapis.org.

Schema and example request/response files are located in the `api_docs` directory.

You can generate the API Docs using the following command `npx redoc-cli bundle --cdn -o mini-crm-api-docs.html api_docs/openapi.yml`.


## 5. Code Quality & Linting

The `Rubocop` gem has been installed, see: https://github.com/rubocop-hq/rubocop. 

See `.rubocop.yml` for configurations.

Run `rubocop -a` before merge and fix any linting issues presented.

## 6. Postman

A Postman collection with requests defined for all endpoints can be found in the `/postman` directory along with an environment file.

Note the optional and present `tag` query parameter on the `GET contacts` request.

The environment variables `CONTACT_UUID` and `TAG_UUID` are used in `PATCH/DELETE` requests and are auto-set after `POST` calls.
