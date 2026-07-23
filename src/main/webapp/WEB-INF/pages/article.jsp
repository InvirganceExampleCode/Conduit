<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<%@taglib uri="convirgance:component" prefix="component" %>
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
                    <component:include page="/WEB-INF/components/author-meta.jsp">
                        <component:arg name="author" value="${article}" />
                        <component:arg name="authorClass" value="article-author" />
                    </component:include>
                    <component:include page="/WEB-INF/components/favorite-control.jsp">
                        <component:arg name="article" value="${article}" />
                        <component:arg name="action" value="${root}/views/article/${virge:urlparam(article.slug)}/${article.favorited ? 'unfavorite' : 'favorite'}" />
                        <component:arg name="loginRedirect" value="views/article/${virge:urlparam(article.slug)}" />
                    </component:include>
                    <virge:if test="${sessionScope.currentUserId eq article.author_id}">
                        <span class="owner-actions">
                            <a href="${root}/views/editor/${virge:urlparam(article.slug)}/edit">Edit article</a>
                            <form method="post" action="${root}/views/article/${virge:urlparam(article.slug)}/delete" class="inline-form" data-confirm="Delete this article? This cannot be undone.">
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
            <component:include page="/WEB-INF/components/tag-list.jsp">
                <component:arg name="tags" value="${article.tagList}" />
                <component:arg name="baseUrl" value="${root}/?tag=" />
            </component:include>
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
            <component:include page="/WEB-INF/components/comment-card.jsp">
                <component:arg name="comment" value="${comment}" />
                <component:arg name="article" value="${article}" />
                <component:arg name="profileActivity" value="${false}" />
            </component:include>
        </virge:iterate>
    </section>
</virge:if>

<jsp:include page="/include/footer.jsp" />
