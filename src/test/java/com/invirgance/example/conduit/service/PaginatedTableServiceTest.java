package com.invirgance.example.conduit.service;

import com.invirgance.convirgance.ConvirganceException;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class PaginatedTableServiceTest
{
    @Test
    void searchUsesABoundParameter()
    {
        var service = service();
        String sql = service.generateSQL(1, "conduit", "created_at", true, true);

        assertTrue(sql.contains("like :_paginatedSearch"));
        assertTrue(sql.contains("limit 20"));
        assertTrue(sql.contains("offset 0"));
    }

    @Test
    void sortMustBeAConfiguredColumn()
    {
        var service = service();

        assertThrows(ConvirganceException.class,
                     () -> service.generateSQL(1, null, "created_at; drop table articles", true, true));
    }

    private PaginatedTableService service()
    {
        var service = new PaginatedTableService();
        service.setPageSize(20);
        service.setColumns(new String[]{"id", "title", "description", "created_at"});
        service.setSearchKeys(new String[]{"title", "description"});
        service.setSql("select id, title, description, created_at from articles");
        return service;
    }
}

