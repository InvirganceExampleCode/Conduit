<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="author" value="${args.author}" />
<img class="avatar" src="${virge:html(author.image)}" alt="">
<div>
    <a class="${virge:html(args.authorClass)}" href="${root}/views/profile/${virge:urlparam(author.profile_slug)}">${virge:html(author.username)}</a>
    <time datetime="${virge:html(author.created_at)}" data-relative-time>${virge:html(author.created_at)}</time>
</div>
