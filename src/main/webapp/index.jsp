<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Conduit</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/conduit.css">
</head>
<body>
    <header class="site-header">
        <nav class="container nav" aria-label="Primary navigation">
            <a class="brand" href="${pageContext.request.contextPath}/">conduit</a>
            <div class="nav-links">
                <a aria-current="page" href="${pageContext.request.contextPath}/">Home</a>
                <a href="#signin" aria-disabled="true">Sign in</a>
                <a href="#register" aria-disabled="true">Sign up</a>
            </div>
        </nav>
    </header>

    <section class="hero">
        <div class="container">
            <h1>conduit</h1>
            <p>A place to share your Convirgance knowledge.</p>
        </div>
    </section>

    <main class="container layout">
        <section aria-labelledby="feed-title">
            <div class="feed-tabs">
                <h2 id="feed-title">Global Feed</h2>
                <form method="get" class="search-form">
                    <label class="sr-only" for="search">Search articles</label>
                    <input id="search" name="search" value="${virge:html(param.search)}" placeholder="Search articles">
                    <button type="submit">Search</button>
                </form>
            </div>

            <virge:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
            <virge:service var="articles" path="/services/articles">
                <virge:parameter name="page" value="${currentPage}" />
                <virge:parameter name="search" value="${param.search}" />
                <virge:parameter name="sort" value="created_at" />
                <virge:parameter name="descending" value="true" />
            </virge:service>
            <virge:service var="articleCount" path="/services/articles/count">
                <virge:parameter name="page" value="${currentPage}" />
                <virge:parameter name="search" value="${param.search}" />
                <virge:parameter name="sort" value="created_at" />
                <virge:parameter name="descending" value="true" />
            </virge:service>

            <virge:iterate var="article" items="${articles}">
                <article class="article-preview">
                    <div class="article-meta">
                        <div class="avatar" aria-hidden="true">${virge:html(article.username.substring(0, 1))}</div>
                        <div>
                            <a class="author" href="#profile">${virge:html(article.username)}</a>
                            <time>${virge:html(article.created_at)}</time>
                        </div>
                        <span class="favorites">♡ ${virge:html(article.favorites_count)}</span>
                    </div>
                    <a class="article-link" href="#article-${virge:urlparam(article.slug)}">
                        <h3>${virge:html(article.title)}</h3>
                        <p>${virge:html(article.description)}</p>
                        <span>Read more…</span>
                    </a>
                    <p class="tags">${virge:html(article.tags)}</p>
                </article>
            </virge:iterate>

            <virge:iterate var="summary" items="${articleCount}">
                <nav class="pagination" aria-label="Article pages">
                    <a class="${currentPage <= 1 ? 'disabled' : ''}"
                       href="?page=${currentPage - 1}&amp;search=${virge:urlparam(param.search)}">Previous</a>
                    <span>Page ${virge:html(currentPage)} of ${virge:html(summary.pages)}</span>
                    <a class="${currentPage >= summary.pages ? 'disabled' : ''}"
                       href="?page=${currentPage + 1}&amp;search=${virge:urlparam(param.search)}">Next</a>
                </nav>
            </virge:iterate>
        </section>

        <aside class="sidebar">
            <h2>Skeleton status</h2>
            <p>The database, service pipeline, pagination, JSON output, and JSP rendering are active.</p>
            <p>Authentication and article mutations are the next vertical slice.</p>
        </aside>
    </main>
</body>
</html>

