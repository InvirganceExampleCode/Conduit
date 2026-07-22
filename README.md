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
- Authenticated article creation, editing, deletion, and transactional tag updates
- Authenticated comment creation and owner-only deletion
- Favorite and unfavorite actions from article pages and the global feed
- Public profiles with authored articles and follow/unfollow actions
- Authored and favorited profile tabs with inline favorite controls
- Personalized, searchable, paginated feed from followed authors
- Popular tags, clickable tag navigation, and tag-filtered feeds
- Registration, login, logout, CSRF protection, and session-backed identity
- Protected account settings with profile and optional password updates
- Email-derived Gravatar images with identicon fallbacks
- Server-side article/comment validation with user-facing failure messages
- Result-returning article creation with direct navigation to the new article
- Hypermedia authentication pages backed by declarative `/api/users` and `/api/session` services

The core server-rendered RealWorld feature set is implemented. Strict compatibility with the canonical JWT/JSON API remains an intentional non-goal for this monolithic variant.

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
