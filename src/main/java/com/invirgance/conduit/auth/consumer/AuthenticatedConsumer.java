package com.invirgance.conduit.auth.consumer;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.consumer.Consumer;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import com.invirgance.conduit.auth.session.SessionSecurity;

@Wiring("AuthenticatedConsumer")
public class AuthenticatedConsumer implements Consumer
{
    private Consumer consumer;

    public Consumer getConsumer() { return consumer; }
    public void setConsumer(Consumer consumer) { this.consumer = consumer; }

    @Override
    public Iterable<JSONObject> consume(Iterable<JSONObject> iterable, JSONObject parameters)
    {
        var records = new JSONArray<JSONObject>();
        for(JSONObject record : iterable) records.add(record);

        Iterable<JSONObject> result = consumer.consume(records, parameters);
        if(!records.isEmpty()) SessionSecurity.establish(records.get(0));
        return result;
    }
}
