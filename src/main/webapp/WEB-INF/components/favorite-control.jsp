<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="article" value="${args.article}" />
<virge:if test="${empty sessionScope.currentUserId}">
    <span class="favorites">${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}</span>
</virge:if>
<virge:if test="${not empty sessionScope.currentUserId}">
    <form method="post" action="${args.action}" class="favorite-form">
        <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
        <button type="submit" class="favorites" aria-label="${article.favorited ? 'Remove from favorites' : 'Add to favorites'}">
            ${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}
        </button>
    </form>
</virge:if>
