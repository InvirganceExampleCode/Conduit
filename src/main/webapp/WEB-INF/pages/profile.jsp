<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:service var="profiles" path="/services/profile/${param.username}" />
<virge:service var="articles" path="/services/profile/${param.username}/articles" />
<virge:set var="profile" value="${virge:first(profiles)}" scope="request" />
<virge:set var="pageTitle" value="${profile.username} — Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />

<virge:if test="${empty profile}">
    <main class="container error-page">
        <h1>Profile not found</h1>
        <p>The requested user does not exist.</p>
        <a class="button" href="${root}/">Return home</a>
    </main>
</virge:if>

<virge:if test="${not empty profile}">
    <header class="profile-hero">
        <div class="container profile-summary">
            <div class="avatar profile-avatar" aria-hidden="true">${virge:html(profile.username.substring(0, 1))}</div>
            <h1>${virge:html(profile.username)}</h1>
            <p>${virge:html(profile.bio)}</p>
            <virge:if test="${not empty sessionScope.currentUserId and sessionScope.currentUserId ne profile.id}">
                <form method="post" action="${root}/views/profile/${virge:urlparam(profile.username)}/${profile.following ? 'unfollow' : 'follow'}">
                    <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                    <button type="submit" class="secondary-button">${profile.following ? 'Unfollow' : 'Follow'} ${virge:html(profile.username)}</button>
                </form>
            </virge:if>
            <virge:if test="${sessionScope.currentUserId eq profile.id}">
                <a class="button secondary-button" href="${root}/auth/settings">Edit profile settings</a>
            </virge:if>
        </div>
    </header>

    <main class="container profile-articles">
        <h2>Articles by ${virge:html(profile.username)}</h2>
        <virge:if test="${empty articles}"><p>No articles published yet.</p></virge:if>
        <virge:iterate var="article" items="${articles}">
            <article class="article-preview">
                <div class="article-meta">
                    <div class="avatar" aria-hidden="true">${virge:html(article.username.substring(0, 1))}</div>
                    <div>
                        <span class="author">${virge:html(article.username)}</span>
                        <time>${virge:html(article.created_at)}</time>
                    </div>
                    <span class="favorites">${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}</span>
                </div>
                <a class="article-link" href="${root}/views/article/${virge:urlparam(article.slug)}">
                    <h3>${virge:html(article.title)}</h3>
                    <p>${virge:html(article.description)}</p>
                    <span>Read more…</span>
                </a>
                <p class="tags">${virge:html(article.tags)}</p>
            </article>
        </virge:iterate>
    </main>
</virge:if>

<jsp:include page="/include/footer.jsp" />
