# Convirgance RealWorld Conduit

A Convirgance-native implementation of the RealWorld Conduit social publishing application. The project intentionally starts as a server-rendered monolith: Convirgance services remain independently callable, while JSP pages use those services without requiring a separate SPA.

## Current vertical slice

- Executable Convirgance Boot application and standard WAR packaging
- H2 schema for users, articles, tags, comments, favorites, and follows
- Seeded development data
- Wiring-configured paginated article service
- Bound search parameter and configured-column sort whitelist
- `/services/articles` JSON records and `/services/articles/count` summary
- Server-rendered global feed at `/`
- Hypermedia article detail pages with author, tags, favorite metadata, and comments
- Safe server-side CommonMark rendering for article bodies
- Registration, login, logout, CSRF protection, and session-backed identity
- Protected account settings page
- Hypermedia authentication pages backed by declarative `/api/users` and `/api/session` services

Article mutations, article detail pages, comments, favorites, follows, and profiles are intentionally left for subsequent vertical slices.

## Build and run

Requires Java 17 or newer and Maven 3.9 or newer.

```shell
mvn clean verify
java -jar target/realworld-conduit.jar
```

Then open <http://localhost:8080/>. The service endpoints are available at:

- <http://localhost:8080/services/articles>
- <http://localhost:8080/services/articles/count>

Both accept `page`, `search`, `sort`, and `descending` request parameters. Sort values are restricted to the configured selected columns.

The in-memory database and development-only password placeholders are deliberate skeleton choices. They must not be used as a production identity store.

## Structure

```text
src/main/java/                       custom Convirgance components
src/main/resources/application.properties
src/main/resources/sql/init/        schema and development seed data
src/main/webapp/auth/                hypermedia page/action services
src/main/webapp/api/                 user and session API services
src/main/webapp/services/            Wiring service definitions
src/main/webapp/                     JSP pages and static resources
```

Authentication routing, validation, SQL, transactions, rendering, and redirects are composed with Convirgance Web Services. Java code is organized under `com.invirgance.conduit`, with authentication components separated into binding, consumer, filter, service, session, and transformer packages.
