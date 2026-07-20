package com.invirgance.conduit.auth.transform;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.IdentityTransformer;
import com.invirgance.convirgance.web.servlet.ServiceState;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;

@Wiring("CsrfValidationTransformer")
public class CsrfValidationTransformer implements IdentityTransformer
{
    @Override
    public JSONObject transform(JSONObject record) throws ConvirganceException
    {
        JSONObject parameters = (JSONObject)ServiceState.get("parameters");
        String submitted = record.getString("csrf");
        if(submitted == null && parameters != null) submitted = parameters.getString("csrf");
        SessionSecurity.validateCsrf(submitted);
        record.remove("csrf");
        return record;
    }
}
