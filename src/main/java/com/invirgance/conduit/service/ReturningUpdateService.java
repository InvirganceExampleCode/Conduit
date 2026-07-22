package com.invirgance.conduit.service;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.service.UpdateService;
import com.invirgance.convirgance.web.servlet.ServiceState;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.util.List;

@Wiring("ReturningUpdateService")
public class ReturningUpdateService extends UpdateService
{
    private List<String> returnParameters;

    public List<String> getReturnParameters() { return returnParameters; }
    public void setReturnParameters(List<String> returnParameters) { this.returnParameters = returnParameters; }

    @Override
    public Iterable<JSONObject> process(HttpRequest request)
    {
        super.process(request);

        var results = new JSONArray<JSONObject>();
        var result = new JSONObject();
        var parameters = (JSONObject)ServiceState.get("parameters");

        if(returnParameters != null)
        {
            for(String name : returnParameters) result.put(name, parameters.get(name));
        }

        results.add(result);
        return results;
    }
}
