package com.invirgance.conduit.auth.session;

import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.http.Session;
import com.invirgance.convirgance.web.servlet.ServiceState;
import com.invirgance.convirgance.web.validation.ValidationException;
import java.security.SecureRandom;
import java.util.Base64;

public final class SessionSecurity
{
    static final String CSRF_TOKEN = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    private SessionSecurity() {}

    static HttpRequest request()
    {
        return (HttpRequest)ServiceState.get("request");
    }

    public static String ensureCsrfToken()
    {
        Session session = request().getSession();
        Object existing = session.getAttribute(CSRF_TOKEN);

        if(existing != null) return existing.toString();

        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        String token = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        session.setAttribute(CSRF_TOKEN, token);
        return token;
    }

    public static void validateCsrf(String submitted)
    {
        Object expected = request().getSession().getAttribute(CSRF_TOKEN);
        if(submitted == null || expected == null || !submitted.equals(expected.toString())) throw new ValidationException("The form has expired. Please try again.");
    }

    public static void establish(JSONObject user)
    {
        Session session = request().getSession();
        session.setAttribute("currentUserId", user.get("id"));
        session.setAttribute("currentUsername", user.get("username") == null ? user.get("name") : user.get("username"));

        Object profileSlug = user.get("profileSlug") == null ? user.get("slug") : user.get("profileSlug");
        if(profileSlug != null) session.setAttribute("currentProfileSlug", profileSlug);
        session.setAttribute("currentEmail", user.get("email"));
        session.setAttribute("currentBio", user.get("bio"));
        session.setAttribute("currentImage", user.get("image"));
        session.setAttribute(CSRF_TOKEN, null);
        ensureCsrfToken();
    }

    public static void clear()
    {
        Session session = request().getSession();
        session.setAttribute("currentUserId", null);
        session.setAttribute("currentUsername", null);
        session.setAttribute("currentProfileSlug", null);
        session.setAttribute("currentEmail", null);
        session.setAttribute("currentBio", null);
        session.setAttribute("currentImage", null);
        session.setAttribute(CSRF_TOKEN, null);
        ensureCsrfToken();
    }
}
