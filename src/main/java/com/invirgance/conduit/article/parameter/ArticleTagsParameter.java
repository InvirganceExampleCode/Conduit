package com.invirgance.conduit.article.parameter;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.parameter.Parameter;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.util.LinkedHashSet;
import java.util.Locale;

@Wiring("ArticleTagsParameter")
public class ArticleTagsParameter implements Parameter
{
    private String name = "tagList";
    private String sourceParameter = "tags";

    @Override
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getSourceParameter() { return sourceParameter; }
    public void setSourceParameter(String sourceParameter) { this.sourceParameter = sourceParameter; }

    @Override
    public Object getValue(HttpRequest request)
    {
        var values = new LinkedHashSet<String>();
        var result = new JSONArray<JSONObject>();
        String tags = request.getParameter(sourceParameter);

        if(tags != null) for(String tag : tags.split(",")) if(!tag.isBlank()) values.add(tag.trim().toLowerCase(Locale.ROOT));

        for(String tag : values)
        {
            var record = new JSONObject();
            record.put("tagName", tag);
            result.add(record);
        }

        return result;
    }
}

