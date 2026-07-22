<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="convirgance:web" prefix="virge" %>
<virge:set var="pageTitle" value="Conduit" scope="request" />
<jsp:include page="/include/header.jsp" />

    <section class="hero">
        <div class="container">
            <h1>conduit</h1>
            <p>A place to share your Convirgance knowledge.</p>
        </div>
    </section>

    <main class="container layout">
        <section aria-labelledby="feed-title">
            <virge:set var="followingFeed" value="${param.feed eq 'following' and not empty sessionScope.currentUserId}" />
            <virge:set var="feedService" value="${followingFeed ? '/api/feed' : '/api/articles'}" />
            <virge:set var="feedCountService" value="${followingFeed ? '/api/feed/count' : '/api/articles/count'}" />
            <div class="feed-tabs">
                <nav aria-label="Article feeds">
                    <virge:if test="${not empty sessionScope.currentUserId}">
                        <a class="${followingFeed ? 'active' : ''}" href="?feed=following">Your Feed</a>
                    </virge:if>
                    <a id="feed-title" class="${followingFeed ? '' : 'active'}" href="?">Global Feed</a>
                </nav>
                <form method="get" class="search-form">
                    <virge:if test="${followingFeed}"><input type="hidden" name="feed" value="following"></virge:if>
                    <virge:if test="${not empty param.tag}"><input type="hidden" name="tag" value="${virge:html(param.tag)}"></virge:if>
                    <label class="sr-only" for="search">Search articles</label>
                    <input id="search" name="search" value="${virge:html(param.search)}" placeholder="Search articles">
                    <button type="submit">Search</button>
                </form>
            </div>

            <virge:set var="currentPage" value="${empty param.page ? 1 : param.page}" />
            <virge:service var="articles" path="${feedService}">
                <virge:parameter name="page" value="${currentPage}" />
                <virge:parameter name="search" value="${param.search}" />
                <virge:parameter name="sort" value="created_at" />
                <virge:parameter name="descending" value="true" />
                <virge:parameter name="tag" value="${param.tag}" />
            </virge:service>
            <virge:service var="articleCount" path="${feedCountService}">
                <virge:parameter name="page" value="${currentPage}" />
                <virge:parameter name="search" value="${param.search}" />
                <virge:parameter name="sort" value="created_at" />
                <virge:parameter name="descending" value="true" />
                <virge:parameter name="tag" value="${param.tag}" />
            </virge:service>
            <virge:set var="summary" value="${virge:first(articleCount)}" />

            <virge:if test="${summary.count eq 0}">
                <p class="empty-feed">${followingFeed ? 'Articles from people you follow will appear here.' : 'No articles match this feed.'}</p>
            </virge:if>

            <virge:iterate var="article" items="${articles}">
                <article class="article-preview">
                    <div class="article-meta">
                        <img class="avatar" src="${virge:html(article.image)}" alt="">
                        <div>
                            <a class="author" href="${root}/views/profile/${virge:urlparam(article.profile_slug)}">${virge:html(article.username)}</a>
                            <time>${virge:html(article.created_at)}</time>
                        </div>
                        <virge:if test="${empty sessionScope.currentUserId}">
                            <span class="favorites">♡ ${virge:html(article.favorites_count)}</span>
                        </virge:if>
                        <virge:if test="${not empty sessionScope.currentUserId}">
                            <form method="post" action="${root}/views/favorite/${virge:urlparam(article.slug)}/${article.favorited ? 'unfavorite' : 'favorite'}" class="favorite-form">
                                <input type="hidden" name="csrf" value="${virge:html(sessionScope.csrfToken)}">
                                <button type="submit" class="favorites">${article.favorited ? '♥' : '♡'} ${virge:html(article.favorites_count)}</button>
                            </form>
                        </virge:if>
                    </div>
                    <a class="article-link" href="${root}/views/article/${virge:urlparam(article.slug)}">
                        <h3>${virge:html(article.title)}</h3>
                        <p>${virge:html(article.description)}</p>
                        <span>Read more…</span>
                    </a>
                    <p class="tags">
                        <virge:iterate var="tag" items="${article.tagList}">
                            <a href="?tag=${virge:urlparam(tag.name)}">${virge:html(tag.name)}</a>
                        </virge:iterate>
                    </p>
                </article>
            </virge:iterate>

            <virge:if test="${summary.count gt 0}">
                <nav class="pagination" aria-label="Article pages">
                    <a class="${currentPage <= 1 ? 'disabled' : ''}"
                       href="?page=${currentPage - 1}&amp;feed=${followingFeed ? 'following' : ''}&amp;tag=${virge:urlparam(param.tag)}&amp;search=${virge:urlparam(param.search)}">Previous</a>
                    <span>Page ${virge:html(currentPage)} of ${virge:html(summary.pages)}</span>
                    <a class="${currentPage >= summary.pages ? 'disabled' : ''}"
                       href="?page=${currentPage + 1}&amp;feed=${followingFeed ? 'following' : ''}&amp;tag=${virge:urlparam(param.tag)}&amp;search=${virge:urlparam(param.search)}">Next</a>
                </nav>
            </virge:if>
        </section>

        <aside class="sidebar">
            <h2>Popular tags</h2>
            <virge:service var="popularTags" path="/api/tags" />
            <div class="tag-cloud">
                <virge:iterate var="tag" items="${popularTags}">
                    <a class="${param.tag eq tag.name ? 'active' : ''}" href="?tag=${virge:urlparam(tag.name)}">${virge:html(tag.name)}</a>
                </virge:iterate>
            </div>
            <virge:if test="${not empty param.tag}"><a class="clear-filter" href="?">Clear tag filter</a></virge:if>
        </aside>
    </main>
<jsp:include page="/include/footer.jsp" />
