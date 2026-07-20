<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:if test="${not empty param.slug}">
    <virge:service var="articles" path="/services/article/${param.slug}" />
    <virge:set var="article" value="${virge:first(articles)}" scope="request" />
</virge:if>
<virge:set var="pageTitle" value="${empty article ? 'New article — Conduit' : 'Edit article — Conduit'}" scope="request" />
<jsp:include page="/include/header.jsp" />

<main class="editor-page">
    <h1>${empty article ? 'New article' : 'Edit article'}</h1>
    <form method="post" action="${empty article ? root.concat('/views/editor/create') : root.concat('/views/editor/').concat(article.slug).concat('/edit')}" class="editor-form">
        <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
        <label>Article title
            <input name="title" value="${virge:html(article.title)}" required maxlength="255">
        </label>
        <label>Description
            <input name="description" value="${virge:html(article.description)}" required maxlength="1024">
        </label>
        <label>Article body (Markdown)
            <textarea name="body" required rows="14">${virge:html(article.body)}</textarea>
        </label>
        <label>Tags, separated by commas
            <input name="tags" value="${virge:html(article.tags)}">
        </label>
        <button type="submit">Publish article</button>
    </form>
</main>

<jsp:include page="/include/footer.jsp" />

