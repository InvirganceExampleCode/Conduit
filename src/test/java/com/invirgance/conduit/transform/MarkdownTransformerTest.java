package com.invirgance.conduit.transform;

import com.invirgance.convirgance.json.JSONObject;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class MarkdownTransformerTest
{
    @Test
    void rendersMarkdownAndEscapesRawHtml()
    {
        var record = new JSONObject();
        record.put("body", "# Heading\n\nThis is **important**.\n\n<script>alert('xss')</script>");

        new MarkdownTransformer().transform(record);

        String html = record.getString("bodyHtml");
        assertTrue(html.contains("<h1>Heading</h1>"));
        assertTrue(html.contains("<strong>important</strong>"));
        assertFalse(html.contains("<script>"));
        assertTrue(html.contains("&lt;script&gt;"));
    }

    @Test
    void removesUnsafeLinkTargets()
    {
        var record = new JSONObject();
        record.put("body", "[unsafe](javascript:alert('xss'))");

        new MarkdownTransformer().transform(record);

        assertFalse(record.getString("bodyHtml").contains("javascript:"));
    }

    @Test
    void preservesFencedCodeLanguageForClientSideHighlighting()
    {
        var record = new JSONObject();
        record.put("body", "```java\npublic class Example {}\n```");

        new MarkdownTransformer().transform(record);

        String html = record.getString("bodyHtml");
        assertTrue(html.contains("<code class=\"language-java\">"));
        assertTrue(html.contains("public class Example {}"));
    }
}
