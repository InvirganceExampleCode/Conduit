package com.invirgance.conduit.auth.binding;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.binding.Binding;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;
import org.mindrot.jbcrypt.BCrypt;

/** Converts a user lookup into either an authenticated user or a login-failure result. */
@Wiring("AuthenticationBinding")
public class AuthenticationBinding implements Binding
{
    private Binding binding;

    public Binding getBinding() { return binding; }
    public void setBinding(Binding binding) { this.binding = binding; }

    @Override
    public Iterable<JSONObject> getBinding(JSONObject parameters)
    {
        SessionSecurity.validateCsrf(parameters.getString("csrf"));

        JSONObject user = null;
        for(JSONObject record : binding.getBinding(parameters)) if(user == null) user = record;

        if(user == null || !passwordMatches(parameters.getString("password"), user.getString("passwordHash"))) return failure();

        user.remove("passwordHash");
        user.put("authenticated", true);
        user.put("redirect", "");
        return new JSONArray<>(user);
    }

    private boolean passwordMatches(String password, String hash)
    {
        if(password == null || hash == null) return false;

        try { return BCrypt.checkpw(password, hash); }
        catch(IllegalArgumentException exception) { return false; }
    }

    private Iterable<JSONObject> failure()
    {
        var failure = new JSONObject();
        failure.put("authenticated", false);
        failure.put("authenticationFailed", true);
        failure.put("redirect", "auth/login?authenticationFailed=true");
        return new JSONArray<>(failure);
    }
}

