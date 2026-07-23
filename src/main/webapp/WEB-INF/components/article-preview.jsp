<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<%@taglib uri="convirgance:component" prefix="component" %>
<virge:set var="article" value="${args.article}" />
<article class="article-preview">
    <div class="article-meta">
        <component:include page="/WEB-INF/components/author-meta.jsp">
            <component:arg name="author" value="${article}" />
            <component:arg name="authorClass" value="author" />
        </component:include>
        <component:include page="/WEB-INF/components/favorite-control.jsp">
            <component:arg name="article" value="${article}" />
            <component:arg name="action" value="${args.favoriteAction}" />
            <component:arg name="loginRedirect" value="${args.loginRedirect}" />
        </component:include>
    </div>
    <a class="article-link" href="${root}/views/article/${virge:urlparam(article.slug)}">
        <h3>${virge:html(article.title)}</h3>
        <p>${virge:html(article.description)}</p>
        <span>Read more…</span>
    </a>
    <component:include page="/WEB-INF/components/tag-list.jsp">
        <component:arg name="tags" value="${article.tagList}" />
        <component:arg name="baseUrl" value="${args.tagBaseUrl}" />
    </component:include>
</article>
