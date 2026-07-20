package com.invirgance.conduit.auth.service;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.http.HttpResponse;
import com.invirgance.convirgance.web.service.Processable;
import com.invirgance.convirgance.web.service.Service;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;

@Wiring("CsrfTokenService")
public class CsrfTokenService implements Service, Processable
{
    @Override
    public Iterable<JSONObject> process(HttpRequest request)
    {
        var results = new JSONArray<JSONObject>();
        var record = new JSONObject();
        record.put("token", SessionSecurity.ensureCsrfToken());
        results.add(record);
        return results;
    }

    @Override
    public void execute(HttpRequest request, HttpResponse response)
    {
        process(request);
        response.setStatus(204);
    }
}
