<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="comment" value="${args.comment}" />
<article class="comment ${args.profileActivity ? 'profile-comment' : ''}">
    <p>${virge:html(comment.body)}</p>
    <footer>
        <virge:if test="${args.profileActivity}">
            <time datetime="${virge:html(comment.created_at)}" data-relative-time>${virge:html(comment.created_at)}</time>
            on <a href="${root}/views/article/${virge:urlparam(comment.article_slug)}">${virge:html(comment.article_title)}</a>
        </virge:if>
        <virge:if test="${not args.profileActivity}">
            <a href="${root}/views/profile/${virge:urlparam(comment.profile_slug)}">${virge:html(comment.username)}</a> ·
            <time datetime="${virge:html(comment.created_at)}" data-relative-time>${virge:html(comment.created_at)}</time>
            <virge:if test="${sessionScope.currentUserId eq comment.author_id}">
                <form method="post" action="${root}/views/article/${virge:urlparam(args.article.slug)}/comments/${comment.id}/delete-comment" class="inline-form">
                    <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                    <button type="submit" class="link-button danger-link">Delete</button>
                </form>
            </virge:if>
        </virge:if>
    </footer>
</article>
