<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="pageTitle" value="Settings — Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />
    <main class="auth-page">
        <h1>Your settings</h1>
        <dl class="account-summary">
            <dt>Username</dt><dd>${virge:html(sessionScope.currentUsername)}</dd>
            <dt>Email</dt><dd>${virge:html(sessionScope.currentEmail)}</dd>
        </dl>
        <p>Profile editing will arrive with the profile vertical slice.</p>
        <form method="post" action="${root}/auth/logout">
            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
            <button type="submit" class="danger-button">Log out</button>
        </form>
    </main>
<jsp:include page="/include/footer.jsp" />
