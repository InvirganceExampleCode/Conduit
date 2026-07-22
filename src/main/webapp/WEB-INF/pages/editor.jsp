<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:if test="${not empty param.slug}">
    <virge:service var="articles" path="/api/article/${param.slug}" />
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
        <div class="markdown-editor" data-markdown-editor data-preview-url="${root}/api/markdown">
            <span class="markdown-editor-label">Article body (Markdown)</span>
            <div class="markdown-tabs" role="tablist" aria-label="Article body">
                <button type="button" class="markdown-tab active" role="tab" aria-selected="true" aria-controls="markdown-write" data-markdown-write>Write</button>
                <button type="button" class="markdown-tab" role="tab" aria-selected="false" aria-controls="markdown-preview" data-markdown-preview>Preview</button>
            </div>
            <div id="markdown-write" class="markdown-panel" role="tabpanel">
                <label class="sr-only" for="article-body">Article body</label>
                <textarea id="article-body" name="body" required rows="16" data-markdown-body>${virge:html(article.body)}</textarea>
            </div>
            <div id="markdown-preview" class="markdown-panel markdown-preview markdown" role="tabpanel" hidden data-markdown-output></div>
            <p class="markdown-status" role="status" aria-live="polite" data-markdown-status></p>
        </div>
        <fieldset class="tag-editor" data-tag-editor>
            <legend>Tags</legend>
            <div class="tag-list" data-tag-list aria-live="polite">
                <virge:iterate var="tag" items="${article.tagList}">
                    <span class="tag-chip" data-tag-value="${virge:html(tag.name)}">
                        <span>${virge:html(tag.name)}</span>
                        <button type="button" class="tag-remove" aria-label="Remove ${virge:html(tag.name)}" data-tag-remove>&times;</button>
                        <input type="hidden" name="tagName" value="${virge:html(tag.name)}">
                    </span>
                </virge:iterate>
            </div>
            <div class="tag-entry-row">
                <label for="tag-entry">Add tags</label>
                <div class="tag-entry-controls">
                    <input id="tag-entry" data-tag-entry maxlength="512" placeholder="java, convirgance">
                    <button type="button" data-tag-add>Add</button>
                </div>
            </div>
            <p class="tag-help">Enter one tag or separate multiple tags with commas. Press Enter or choose Add.</p>
        </fieldset>
        <button type="submit">Publish article</button>
    </form>
</main>

<script src="${root}/resources/markdown-editor.js" defer></script>
<script src="${root}/resources/tag-editor.js" defer></script>
<jsp:include page="/include/footer.jsp" />
