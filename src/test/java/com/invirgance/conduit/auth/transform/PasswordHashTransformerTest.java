package com.invirgance.conduit.auth.transform;

import com.invirgance.convirgance.json.JSONObject;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PasswordHashTransformerTest
{
    @Test
    void generatesStableUrlSafeProfileSlugFromFullNameAndEmail()
    {
        var record = new JSONObject();
        record.put("name", "  Élodie van Test  ");
        record.put("email", "ELODIE@example.com ");
        record.put("password", "RealWorldTest123");

        var transformer = new PasswordHashTransformer();
        transformer.setRounds(4);
        transformer.setGenerateSlug(true);
        transformer.transform(record);

        assertEquals("Élodie van Test", record.getString("name"));
        assertEquals("elodie@example.com", record.getString("email"));
        assertTrue(record.getString("slug").matches("elodie-van-test-[a-f0-9]{8}"));
    }
}
