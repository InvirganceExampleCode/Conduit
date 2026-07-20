package com.invirgance.conduit.transform;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.transform.IdentityTransformer;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import org.commonmark.parser.Parser;
import org.commonmark.renderer.html.HtmlRenderer;

/** Renders a Markdown field as safe HTML while preserving the original source. */
@Wiring("MarkdownTransformer")
public class MarkdownTransformer implements IdentityTransformer
{
    private static final Parser PARSER = Parser.builder().build();
    private static final HtmlRenderer RENDERER = HtmlRenderer.builder().escapeHtml(true).sanitizeUrls(true).build();

    private String input = "body";
    private String output = "bodyHtml";

    public String getInput() { return input; }
    public void setInput(String input) { this.input = input; }
    public String getOutput() { return output; }
    public void setOutput(String output) { this.output = output; }

    @Override
    public JSONObject transform(JSONObject record) throws ConvirganceException
    {
        String markdown = record.getString(input);
        record.put(output, markdown == null ? "" : RENDERER.render(PARSER.parse(markdown)));
        return record;
    }
}

