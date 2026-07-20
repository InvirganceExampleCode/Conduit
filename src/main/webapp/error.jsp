<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Conduit — Request failed</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/conduit.css">
</head>
<body>
    <main class="container error-page">
        <p class="brand">conduit</p>
        <h1>That request could not be completed.</h1>
        <p>Please return to the feed and try again.</p>
        <a class="button" href="${pageContext.request.contextPath}/">Return home</a>
    </main>
</body>
</html>

