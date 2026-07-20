<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="pageTitle" value="Sign in — Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />
    <main class="auth-page">
        <h1>Sign in</h1>
        <p><a href="${root}/auth/register">Need an account?</a></p>
        <virge:if test="${param.authenticationFailed eq 'true'}">
            <div class="form-error" role="alert">Email or password is invalid.</div>
        </virge:if>
        <virge:if test="${not empty requestScope.error}">
            <div class="form-error" role="alert">${virge:html(requestScope.error)}</div>
        </virge:if>
        <form method="post" action="${root}/auth/login" class="auth-form">
            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
            <label>Email
                <input type="email" name="email" value="${virge:html(requestScope.email)}" required autocomplete="email">
            </label>
            <label>Password
                <input type="password" name="password" required autocomplete="current-password">
            </label>
            <button type="submit">Sign in</button>
        </form>
    </main>
<jsp:include page="/include/footer.jsp" />
