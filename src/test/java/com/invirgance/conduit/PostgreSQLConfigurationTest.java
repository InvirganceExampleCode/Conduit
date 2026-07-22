package com.invirgance.conduit;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class PostgreSQLConfigurationTest
{
    private String resource(String path) throws IOException
    {
        try(var stream = getClass().getResourceAsStream(path))
        {
            assertTrue(stream != null, "Missing resource: " + path);

            return new String(stream.readAllBytes(), StandardCharsets.UTF_8);
        }
    }

    @Test
    public void usesPostgreSQLDataSource() throws IOException
    {
        var properties = resource("/application.properties");

        assertTrue(properties.contains("jdbc.database=PostgreSQL"));
        assertTrue(properties.contains("jdbc.database.url=jdbc:postgresql://localhost:5432/conduit"));
        assertFalse(properties.toLowerCase().contains("jdbc:h2:"));
    }

    @Test
    public void containsNoH2SpecificSQL() throws IOException
    {
        var resources = new String[] {
            "src/main/resources/sql/init/schema.sql",
            "src/main/resources/sql/init/data.sql",
            "src/main/webapp/api/articles.xml",
            "src/main/webapp/api/article.xml",
            "src/main/webapp/api/feed.xml",
            "src/main/webapp/api/profile.xml",
            "src/main/webapp/api/profiles.xml",
            "src/main/webapp/api/users.xml"
        };

        for(var path : resources)
        {
            var sql = Files.readString(Path.of(path)).toLowerCase();

            assertFalse(sql.contains("next value for"), path);
            assertFalse(sql.contains("merge into"), path);
            assertFalse(sql.contains("final table"), path);
            assertFalse(sql.contains("rawtohex"), path);
            assertFalse(sql.contains("stringtoutf8"), path);
        }
    }

    @Test
    public void initializationIsNonDestructive() throws IOException
    {
        var schema = resource("/sql/init/schema.sql").toLowerCase();
        var data = resource("/sql/init/data.sql").toLowerCase();

        assertFalse(schema.contains("drop table"));
        assertFalse(schema.contains("drop sequence"));
        assertTrue(schema.contains("create table if not exists"));
        assertTrue(data.contains("on conflict"));
    }
}
