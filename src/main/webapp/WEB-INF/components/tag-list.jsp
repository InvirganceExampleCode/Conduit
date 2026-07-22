<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<p class="tags">
    <virge:iterate var="tag" items="${args.tags}">
        <a href="${virge:html(args.baseUrl)}${virge:urlparam(tag.name)}">${virge:html(tag.name)}</a>
    </virge:iterate>
</p>
