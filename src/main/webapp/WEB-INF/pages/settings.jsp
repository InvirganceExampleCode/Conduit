<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="pageTitle" value="Settings — Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />
    <main class="auth-page">
        <h1>Your settings</h1>
        <virge:if test="${param.updated eq 'true'}">
            <p class="form-success" role="status">Your settings have been updated.</p>
        </virge:if>
        <form method="post" action="${root}/auth/settings" class="auth-form">
            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
            <label>
                Full name
                <input name="name" value="${virge:html(sessionScope.currentUsername)}" required minlength="2" maxlength="128" autocomplete="name" placeholder="Full name">
            </label>
            <label>
                Email
                <input type="email" name="email" value="${virge:html(sessionScope.currentEmail)}" required maxlength="320" autocomplete="email">
            </label>
            <label>
                Bio
                <textarea name="bio" rows="4" maxlength="1024">${virge:html(sessionScope.currentBio)}</textarea>
            </label>
            <p class="field-help">Your profile image is provided by <a href="https://gravatar.com/" target="_blank" rel="noopener noreferrer">Gravatar</a> using your email address.</p>
            <label>
                New password
                <input type="password" name="password" minlength="8" autocomplete="new-password" aria-describedby="password-help">
            </label>
            <small id="password-help">Leave blank to keep your current password.</small>
            <button type="submit">Update settings</button>
        </form>
        <hr>
        <form method="post" action="${root}/auth/logout">
            <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
            <button type="submit" class="danger-button">Log out</button>
        </form>
    </main>
<jsp:include page="/include/footer.jsp" />
