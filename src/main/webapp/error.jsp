<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="pageTitle" value="Conduit — Request failed" scope="request" />
<jsp:include page="/include/header.jsp" />
    <main class="container error-page">
        <p class="brand">conduit</p>
        <h1>That request could not be completed.</h1>
        <p>Please return to the feed and try again.</p>
        <a class="button" href="${root}/">Return home</a>
    </main>
<jsp:include page="/include/footer.jsp" />
