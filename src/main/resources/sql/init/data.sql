INSERT INTO users (id, email, username, password_hash, bio, image) VALUES
    (1, 'jake@example.test', 'jake', 'development-only', 'I work at State Farm.', NULL),
    (2, 'jane@example.test', 'jane', 'development-only', 'Convirgance enthusiast.', NULL);

INSERT INTO articles (id, author_id, slug, title, description, body, created_at, updated_at) VALUES
    (100, 1, 'welcome-to-conduit', 'Welcome to Conduit',
     'A first article served by Convirgance Web.',
     '# Welcome\n\nThis article proves the database-to-service-to-JSP path is working.',
     TIMESTAMP WITH TIME ZONE '2026-07-20 10:00:00-05:00', TIMESTAMP WITH TIME ZONE '2026-07-20 10:00:00-05:00'),
    (101, 2, 'configuration-is-code', 'Configuration is code',
     'Composable services without controller boilerplate.',
     '# Configuration is code\n\nThe service graph remains explicit, versioned, and testable.',
     TIMESTAMP WITH TIME ZONE '2026-07-20 11:00:00-05:00', TIMESTAMP WITH TIME ZONE '2026-07-20 11:00:00-05:00');

INSERT INTO tags (id, name) VALUES
    (200, 'convirgance'),
    (201, 'realworld'),
    (202, 'java');

INSERT INTO article_tags (article_id, tag_id) VALUES
    (100, 200), (100, 201),
    (101, 200), (101, 202);

INSERT INTO favorites (user_id, article_id) VALUES (1, 101);
INSERT INTO follows (follower_id, followed_id) VALUES (1, 2);

