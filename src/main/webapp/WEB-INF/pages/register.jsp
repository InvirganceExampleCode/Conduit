<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="pageTitle" value="Sign up — Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />
    <main class="auth-page">
        <h1>Sign up</h1>
        <p><a href="${root}/auth/login">Have an account?</a></p>
        <virge:if test="${not empty requestScope.error}">
            <div class="form-error" role="alert">${virge:html(requestScope.error)}</div>
        </virge:if>
        <form method="post" action="${root}/auth/register" class="auth-form">
            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
            <label>Username
                <input name="username" value="${virge:html(requestScope.username)}" required minlength="3" maxlength="32" pattern="[A-Za-z0-9_]+" autocomplete="username">
            </label>
            <label>Email
                <input type="email" name="email" value="${virge:html(requestScope.email)}" required autocomplete="email">
            </label>
            <label>Password
                <input type="password" name="password" required minlength="8" autocomplete="new-password">
            </label>
            <button type="submit">Create account</button>
        </form>
    </main>
<jsp:include page="/include/footer.jsp" />
