package com.invirgance.conduit.article.parameter;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.parameter.Parameter;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.text.Normalizer;
import java.util.Locale;
import java.util.UUID;

@Wiring("GeneratedSlugParameter")
public class GeneratedSlugParameter implements Parameter
{
    private String name = "slug";
    private String sourceParameter = "title";

    @Override
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSourceParameter() { return sourceParameter; }
    public void setSourceParameter(String sourceParameter) { this.sourceParameter = sourceParameter; }

    @Override
    public Object getValue(HttpRequest request)
    {
        String title = request.getParameter(sourceParameter);
        if(title == null || title.isBlank()) throw new ConvirganceException("A title is required to generate an article slug.");
        String normalized = Normalizer.normalize(title, Normalizer.Form.NFKD).replaceAll("\\p{M}", "").toLowerCase(Locale.ROOT);
        String base = normalized.replaceAll("[^a-z0-9]+", "-").replaceAll("(^-|-$)", "");
        if(base.isEmpty()) base = "article";
        return base + "-" + UUID.randomUUID().toString().substring(0, 8);
    }
}
