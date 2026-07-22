package com.invirgance.conduit.article.parameter;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.parameter.Parameter;
import com.invirgance.convirgance.web.validation.ValidationException;
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
        var values = new JSONObject();
        var result = new JSONArray<JSONObject>();
        
        String[] submitted = request.getParameterValues(sourceParameter);
        JSONObject record;

        if(submitted != null)
        {
            for(String tags : submitted)
            {
                for(String tag : tags.split(","))
                {
                    tag = tag.trim().toLowerCase(Locale.ROOT);
                    record = new JSONObject();
                    
                    if(tag.isBlank() || values.containsKey(tag)) continue;
                    
                    record.put("tagName", tag);
                    values.put(tag, true);
                    result.add(record);
                }
            }
        }

        return result;
    }
}
