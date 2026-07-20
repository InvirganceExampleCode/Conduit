package com.invirgance.conduit.auth.transform;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.IdentityTransformer;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.util.Locale;
import org.mindrot.jbcrypt.BCrypt;

@Wiring("PasswordHashTransformer")
public class PasswordHashTransformer implements IdentityTransformer
{
    private int rounds = 12;

    public int getRounds() { return rounds; }
    public void setRounds(int rounds) { this.rounds = rounds; }

    @Override
    public JSONObject transform(JSONObject record) throws ConvirganceException
    {
        String password = record.getString("password");
        String email = record.getString("email");

        record.put("email", email.trim().toLowerCase(Locale.ROOT));
        record.put("username", record.getString("username").trim());
        record.put("passwordHash", BCrypt.hashpw(password, BCrypt.gensalt(rounds)));
        record.remove("password");
        return record;
    }
}
