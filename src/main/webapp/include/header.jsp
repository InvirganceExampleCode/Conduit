<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="root" value="${pageContext.request.contextPath}" scope="request" />
<virge:service var="csrfService" path="/api/csrf" />
<virge:set var="csrf" value="${virge:first(csrfService)}" scope="request" />
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${virge:html(requestScope.pageTitle)}</title>
    <link rel="stylesheet" href="${root}/webjars/highlightjs__cdn-assets/11.11.1/styles/github.min.css">
    <link rel="stylesheet" href="${root}/resources/conduit.css">
</head>
<body>
    <header class="site-header">
        <nav class="container nav" aria-label="Primary navigation">
            <a class="brand" href="${root}/">conduit</a>
            <div class="nav-links">
                <a href="${root}/">Home</a>
                <virge:if test="${empty sessionScope.currentUserId}">
                    <a href="${root}/auth/login">Sign in</a>
                    <a href="${root}/auth/register">Sign up</a>
                </virge:if>
                <virge:if test="${not empty sessionScope.currentUserId}">
                    <a href="${root}/views/editor/create">New article</a>
                    <a href="${root}/auth/settings">Settings</a>
                    <a href="${root}/views/profile/${virge:urlparam(sessionScope.currentProfileSlug)}">${virge:html(sessionScope.currentUsername)}</a>
                    <form method="post" action="${root}/auth/logout" class="nav-form">
                        <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                        <button type="submit" class="link-button">Log out</button>
                    </form>
                </virge:if>
            </div>
        </nav>
    </header>
