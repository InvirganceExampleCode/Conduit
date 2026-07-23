<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<%@taglib uri="convirgance:component" prefix="component" %>
<virge:service var="profiles" path="/api/profile/${param.username}" />
<virge:set var="profileTab" value="${param.tab eq 'favorited' ? 'favorited' : (param.tab eq 'comments' ? 'comments' : 'articles')}" />
<virge:service var="articles" path="/api/profile/${param.username}/articles">
    <virge:parameter name="tab" value="${profileTab}" />
</virge:service>
<virge:service var="comments" path="/api/profile/${param.username}/comments" />
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
                <form method="post" action="${root}/views/profile/${virge:urlparam(profile.profile_slug)}/${profile.following ? 'unfollow' : 'follow'}">
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
        <nav class="profile-tabs" aria-label="Profile activity">
            <a class="${profileTab eq 'articles' ? 'active' : ''}" href="?tab=articles">Articles by ${virge:html(profile.username)}</a>
            <a class="${profileTab eq 'favorited' ? 'active' : ''}" href="?tab=favorited">Favorited articles</a>
            <a class="${profileTab eq 'comments' ? 'active' : ''}" href="?tab=comments">Comments</a>
        </nav>
        <virge:if test="${profileTab ne 'comments'}">
        <virge:if test="${empty articles}"><p>No articles found.</p></virge:if>
        <virge:iterate var="article" items="${articles}">
            <component:include page="/WEB-INF/components/article-preview.jsp">
                <component:arg name="article" value="${article}" />
                <component:arg name="favoriteAction" value="${root}/views/profile/${virge:urlparam(profile.profile_slug)}/articles/${virge:urlparam(article.slug)}/${article.favorited ? 'unfavorite' : 'favorite'}?tab=${profileTab}" />
                <component:arg name="tagBaseUrl" value="${root}/?tag=" />
                <component:arg name="loginRedirect" value="views/profile/${virge:urlparam(profile.profile_slug)}?tab=${profileTab}" />
            </component:include>
        </virge:iterate>
        </virge:if>
        <virge:if test="${profileTab eq 'comments'}">
            <virge:if test="${empty comments}"><p>No comments posted yet.</p></virge:if>
            <virge:iterate var="comment" items="${comments}">
                <component:include page="/WEB-INF/components/comment-card.jsp">
                    <component:arg name="comment" value="${comment}" />
                    <component:arg name="profileActivity" value="${true}" />
                </component:include>
            </virge:iterate>
        </virge:if>
    </main>
</virge:if>

<jsp:include page="/include/footer.jsp" />
