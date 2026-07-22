<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:service var="profiles" path="/services/profile/${param.username}" />
<virge:set var="profileTab" value="${param.tab eq 'favorited' ? 'favorited' : 'articles'}" />
<virge:service var="articles" path="/services/profile/${param.username}/articles">
    <virge:parameter name="tab" value="${profileTab}" />
</virge:service>
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
            <img class="avatar profile-avatar" src="${virge:html(profile.image)}" alt="">
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
        <nav class="profile-tabs" aria-label="Profile articles">
            <a class="${profileTab eq 'articles' ? 'active' : ''}" href="?tab=articles">Articles by ${virge:html(profile.username)}</a>
            <a class="${profileTab eq 'favorited' ? 'active' : ''}" href="?tab=favorited">Favorited articles</a>
        </nav>
        <virge:if test="${empty articles}"><p>No articles published yet.</p></virge:if>
        <virge:iterate var="article" items="${articles}">
            <article class="article-preview">
                <div class="article-meta">
                    <img class="avatar" src="${virge:html(article.image)}" alt="">
                    <div>
                        <span class="author">${virge:html(article.username)}</span>
                        <time>${virge:html(article.created_at)}</time>
                    </div>
                    <virge:if test="${empty sessionScope.currentUserId}">
                        <span class="favorites">♡ ${virge:html(article.favorites_count)}</span>
                    </virge:if>
                    <virge:if test="${not empty sessionScope.currentUserId}">
                        <form method="post" action="${root}/views/profile/${virge:urlparam(profile.username)}/articles/${virge:urlparam(article.slug)}/${article.favorited ? 'unfavorite' : 'favorite'}?tab=${profileTab}" class="favorite-form">
                            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                            <button type="submit" class="favorites">${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}</button>
                        </form>
                    </virge:if>
                </div>
                <a class="article-link" href="${root}/views/article/${virge:urlparam(article.slug)}">
                    <h3>${virge:html(article.title)}</h3>
                    <p>${virge:html(article.description)}</p>
                    <span>Read more…</span>
                </a>
                <p class="tags">
                    <virge:iterate var="tag" items="${article.tagList}">
                        <a href="${root}/?tag=${virge:urlparam(tag.name)}">${virge:html(tag.name)}</a>
                    </virge:iterate>
                </p>
            </article>
        </virge:iterate>
    </main>
</virge:if>

<jsp:include page="/include/footer.jsp" />
