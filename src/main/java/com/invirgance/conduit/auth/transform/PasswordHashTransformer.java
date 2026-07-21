package com.invirgance.conduit.auth.transform;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.IdentityTransformer;
import com.invirgance.convirgance.web.validation.ValidationException;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.util.Locale;
import org.mindrot.jbcrypt.BCrypt;

@Wiring("PasswordHashTransformer")
public class PasswordHashTransformer implements IdentityTransformer
{
    private int rounds = 12;
    private boolean optional;

    public int getRounds() { return rounds; }
    public void setRounds(int rounds) { this.rounds = rounds; }
    public boolean isOptional() { return optional; }
    public void setOptional(boolean optional) { this.optional = optional; }

    @Override
    public JSONObject transform(JSONObject record) throws ConvirganceException
    {
        String password = record.getString("password");
        String email = record.getString("email");

        record.put("email", email.trim().toLowerCase(Locale.ROOT));
        record.put("username", record.getString("username").trim());

        if(optional && (password == null || password.isBlank())) record.put("passwordHash", null);
        else
        {
            if(optional && password.length() < 8) throw new ValidationException("Password must contain at least 8 characters.");
            record.put("passwordHash", BCrypt.hashpw(password, BCrypt.gensalt(rounds)));
        }

        record.remove("password");
        return record;
    }
}
