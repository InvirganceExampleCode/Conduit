<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="article" value="${args.article}" />
<virge:if test="${empty sessionScope.currentUserId}">
    <a class="favorites favorites-login" href="${root}/auth/login?returnTo=${virge:urlparam(args.loginRedirect)}" title="Sign in to favorite this article" aria-label="Sign in to favorite this article">
        ♡ ${virge:html(article.favorites_count)}
    </a>
</virge:if>
<virge:if test="${not empty sessionScope.currentUserId}">
    <form method="post" action="${args.action}" class="favorite-form">
        <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
        <button type="submit" class="favorites" aria-label="${article.favorited ? 'Remove from favorites' : 'Add to favorites'}">
            ${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}
        </button>
    </form>
</virge:if>
