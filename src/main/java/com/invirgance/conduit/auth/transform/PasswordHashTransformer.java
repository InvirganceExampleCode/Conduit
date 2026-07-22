package com.invirgance.conduit.auth.transform;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.IdentityTransformer;
import com.invirgance.convirgance.web.validation.ValidationException;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.util.Locale;
import java.text.Normalizer;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import org.mindrot.jbcrypt.BCrypt;

@Wiring("PasswordHashTransformer")
public class PasswordHashTransformer implements IdentityTransformer
{
    private int rounds = 12;
    private boolean optional;
    private boolean generateSlug;

    public int getRounds() { return rounds; }
    public void setRounds(int rounds) { this.rounds = rounds; }
    public boolean isOptional() { return optional; }
    public void setOptional(boolean optional) { this.optional = optional; }
    public boolean isGenerateSlug() { return generateSlug; }
    public void setGenerateSlug(boolean generateSlug) { this.generateSlug = generateSlug; }

    @Override
    public JSONObject transform(JSONObject record) throws ConvirganceException
    {
        String password = record.getString("password");
        String email = record.getString("email");

        record.put("email", email.trim().toLowerCase(Locale.ROOT));
        String name = record.getString("name").trim();
        record.put("name", name);

        if(generateSlug) record.put("slug", generateSlug(name, record.getString("email")));

        if(optional && (password == null || password.isBlank())) record.put("passwordHash", null);
        else
        {
            if(optional && password.length() < 8) throw new ValidationException("Password must contain at least 8 characters.");
            record.put("passwordHash", BCrypt.hashpw(password, BCrypt.gensalt(rounds)));
        }

        record.remove("password");
        return record;
    }

    private String generateSlug(String name, String email)
    {
        String normalized = Normalizer.normalize(name, Normalizer.Form.NFD).replaceAll("\\p{M}+", "");
        String base = normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]+", "-").replaceAll("(^-|-$)", "");

        if(base.isEmpty()) base = "user";

        try
        {
            byte[] digest = MessageDigest.getInstance("SHA-256").digest(email.getBytes(StandardCharsets.UTF_8));
            return base + "-" + java.util.HexFormat.of().formatHex(digest, 0, 4);
        }
        catch(NoSuchAlgorithmException exception)
        {
            throw new ConvirganceException("SHA-256 is unavailable while generating the profile slug.", exception);
        }
    }
}
