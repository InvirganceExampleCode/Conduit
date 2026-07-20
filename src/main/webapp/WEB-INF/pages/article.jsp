<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:service var="articles" path="/services/article/${param.slug}" />
<virge:service var="comments" path="/services/article/${param.slug}/comments" />
<virge:set var="article" value="${virge:first(articles)}" scope="request" />
<virge:set var="pageTitle" value="${article.title} — Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />

<virge:if test="${empty article}">
    <main class="container error-page">
        <h1>Article not found</h1>
        <p>The requested article does not exist.</p>
        <a class="button" href="${root}/">Return home</a>
    </main>
</virge:if>

<virge:if test="${not empty article}">
    <article>
        <header class="article-hero">
            <div class="container">
                <h1>${virge:html(article.title)}</h1>
                <div class="article-meta article-hero-meta">
                    <div class="avatar" aria-hidden="true">${virge:html(article.username.substring(0, 1))}</div>
                    <div>
                        <span class="article-author">${virge:html(article.username)}</span>
                        <time>${virge:html(article.created_at)}</time>
                    </div>
                    <span class="favorites">${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}</span>
                    <virge:if test="${sessionScope.currentUserId eq article.author_id}">
                        <span class="owner-actions">
                            <a href="${root}/views/editor/${virge:urlparam(article.slug)}/edit">Edit article</a>
                            <form method="post" action="${root}/views/article/${virge:urlparam(article.slug)}/delete" class="inline-form">
                                <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                                <button type="submit" class="link-button danger-link">Delete article</button>
                            </form>
                        </span>
                    </virge:if>
                </div>
            </div>
        </header>

        <div class="container article-content">
            <p class="article-description">${virge:html(article.description)}</p>
            <div class="article-body markdown">${article.bodyHtml}</div>
            <p class="tags">${virge:html(article.tags)}</p>
        </div>
    </article>

    <section class="container comments" aria-labelledby="comments-heading">
        <h2 id="comments-heading">Comments</h2>
        <virge:if test="${empty sessionScope.currentUserId}">
            <p><a href="${root}/auth/login">Sign in</a> to add a comment.</p>
        </virge:if>
        <virge:iterate var="comment" items="${comments}">
            <article class="comment">
                <p>${virge:html(comment.body)}</p>
                <footer>${virge:html(comment.username)} · ${virge:html(comment.created_at)}</footer>
            </article>
        </virge:iterate>
    </section>
</virge:if>

<jsp:include page="/include/footer.jsp" />
