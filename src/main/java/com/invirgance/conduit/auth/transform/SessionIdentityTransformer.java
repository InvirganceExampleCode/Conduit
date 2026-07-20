package com.invirgance.conduit.auth.transform;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.IdentityTransformer;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;

@Wiring("SessionIdentityTransformer")
public class SessionIdentityTransformer implements IdentityTransformer
{
    @Override
    public JSONObject transform(JSONObject user) throws ConvirganceException
    {
        if(Boolean.TRUE.equals(user.get("authenticated"))) SessionSecurity.establish(user);
        return user;
    }
}

