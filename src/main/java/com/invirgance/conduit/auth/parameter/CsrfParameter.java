package com.invirgance.conduit.auth.parameter;

import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.parameter.Parameter;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;

@Wiring("CsrfParameter")
public class CsrfParameter implements Parameter
{
    private String name = "csrf";

    @Override
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    @Override
    public Object getValue(HttpRequest request)
    {
        String value = request.getParameter(name);
        SessionSecurity.validateCsrf(value);
        return value;
    }
}

