<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<%
    Throwable failure = exception;
    while(failure != null && failure.getCause() != null) failure = failure.getCause();
    request.setAttribute("failureMessage", failure == null ? null : failure.getMessage());
%>
<virge:set var="pageTitle" value="Conduit — Request failed" scope="request" />
<jsp:include page="/include/header.jsp" />
    <main class="container error-page">
        <p class="brand">conduit</p>
        <h1>That request could not be completed.</h1>
        <virge:if test="${not empty requestScope.failureMessage}">
            <p class="form-error" role="alert">${virge:html(requestScope.failureMessage)}</p>
        </virge:if>
        <p>Correct the submitted information and try again.</p>
        <button type="button" onclick="history.back()">Return to the form</button>
        <a class="button" href="${root}/">Return home</a>
    </main>
<jsp:include page="/include/footer.jsp" />
