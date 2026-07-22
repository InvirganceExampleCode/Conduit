package com.invirgance.conduit.transform;

import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.SortedGroupByTransformer;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class HierarchicalTagGroupingTest
{
    @Test
    void joinedTagRowsBecomeAChildArray()
    {
        var rows = new JSONArray<JSONObject>();
        var first = new JSONObject();
        var second = new JSONObject();

        first.put("id", 100);
        first.put("title", "Welcome");
        first.put("name", "convirgance");
        second.put("id", 100);
        second.put("title", "Welcome");
        second.put("name", "realworld");
        rows.add(first);
        rows.add(second);

        var transformer = new SortedGroupByTransformer(new String[]{"id", "title"}, "tagList");
        JSONObject article = transformer.transform(rows).iterator().next();

        assertEquals(100, ((Number)article.get("id")).intValue());
        assertEquals("Welcome", article.getString("title"));
        assertEquals(2, article.getJSONArray("tagList").size());
        assertEquals("convirgance", article.getJSONArray("tagList").getJSONObject(0).getString("name"));
        assertEquals("realworld", article.getJSONArray("tagList").getJSONObject(1).getString("name"));
    }
}
