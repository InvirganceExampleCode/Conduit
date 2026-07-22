<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:service var="articles" path="/api/article/${param.slug}" />
<virge:service var="comments" path="/api/article/${param.slug}/comments" />
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
                    <img class="avatar" src="${virge:html(article.image)}" alt="">
                    <div>
                        <a class="article-author" href="${root}/views/profile/${virge:urlparam(article.profile_slug)}">${virge:html(article.username)}</a>
                        <time datetime="${virge:html(article.created_at)}" data-relative-time>${virge:html(article.created_at)}</time>
                    </div>
                    <virge:if test="${empty sessionScope.currentUserId}">
                        <span class="favorites">♡ ${virge:html(article.favorites_count)}</span>
                    </virge:if>
                    <virge:if test="${not empty sessionScope.currentUserId}">
                        <form method="post" action="${root}/views/article/${virge:urlparam(article.slug)}/${article.favorited ? 'unfavorite' : 'favorite'}" class="favorite-form">
                            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                            <button type="submit" class="favorites">${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}</button>
                        </form>
                    </virge:if>
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
            <p class="tags">
                <virge:iterate var="tag" items="${article.tagList}">
                    <a href="${root}/?tag=${virge:urlparam(tag.name)}">${virge:html(tag.name)}</a>
                </virge:iterate>
            </p>
        </div>
    </article>

    <section class="container comments" aria-labelledby="comments-heading">
        <h2 id="comments-heading">Comments</h2>
        <virge:if test="${empty sessionScope.currentUserId}">
            <p><a href="${root}/auth/login">Sign in</a> to add a comment.</p>
        </virge:if>
        <virge:if test="${not empty sessionScope.currentUserId}">
            <form method="post" action="${root}/views/article/${virge:urlparam(article.slug)}/comment" class="comment-form">
                <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                <label for="comment-body">Add a comment</label>
                <textarea id="comment-body" name="body" rows="4" maxlength="4000" required></textarea>
                <button type="submit">Post comment</button>
            </form>
        </virge:if>
        <virge:iterate var="comment" items="${comments}">
            <article class="comment">
                <p>${virge:html(comment.body)}</p>
                <footer>
                    <a href="${root}/views/profile/${virge:urlparam(comment.profile_slug)}">${virge:html(comment.username)}</a> ·
                    <time datetime="${virge:html(comment.created_at)}" data-relative-time>${virge:html(comment.created_at)}</time>
                    <virge:if test="${sessionScope.currentUserId eq comment.author_id}">
                        <form method="post" action="${root}/views/article/${virge:urlparam(article.slug)}/comments/${comment.id}/delete-comment" class="inline-form">
                            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                            <button type="submit" class="link-button danger-link">Delete</button>
                        </form>
                    </virge:if>
                </footer>
            </article>
        </virge:iterate>
    </section>
</virge:if>

<jsp:include page="/include/footer.jsp" />
