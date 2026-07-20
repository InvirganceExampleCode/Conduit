package com.invirgance.conduit.auth.service;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.http.HttpResponse;
import com.invirgance.convirgance.web.service.Processable;
import com.invirgance.convirgance.web.service.Service;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;

@Wiring("LogoutService")
public class LogoutService implements Service, Processable
{
    @Override
    public Iterable<JSONObject> process(HttpRequest request)
    {
        SessionSecurity.validateCsrf(request.getParameter("csrf"));
        SessionSecurity.clear();
        return new JSONArray<>();
    }

    @Override
    public void execute(HttpRequest request, HttpResponse response)
    {
        process(request);
        response.setStatus(204);
    }
}
