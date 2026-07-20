package com.invirgance.example.conduit.service;

import com.invirgance.convirgance.ConvirganceException;
import com.invirgance.convirgance.dbms.DBMS;
import com.invirgance.convirgance.dbms.Query;
import com.invirgance.convirgance.json.JSONArray;
import com.invirgance.convirgance.json.JSONObject;
import com.invirgance.convirgance.output.Output;
import com.invirgance.convirgance.target.OutputStreamTarget;
import com.invirgance.convirgance.transform.Transformer;
import com.invirgance.convirgance.transform.filter.Filter;
import com.invirgance.convirgance.web.http.HttpRequest;
import com.invirgance.convirgance.web.http.HttpResponse;
import com.invirgance.convirgance.web.parameter.Parameter;
import com.invirgance.convirgance.web.service.Processable;
import com.invirgance.convirgance.web.service.Service;
import com.invirgance.convirgance.web.servlet.ApplicationInitializer;
import com.invirgance.convirgance.web.servlet.ServiceState;
import com.invirgance.convirgance.wiring.annotation.Wiring;
import java.util.Arrays;
import java.util.List;
import javax.sql.DataSource;

/**
 * A Wiring-configurable table service with filtering, search, sorting,
 * transformation-aware counts, and pagination.
 */
@Wiring("PaginatedTableService")
public class PaginatedTableService implements Service, Processable
{
    private static final String SEARCH_PARAMETER = "_paginatedSearch";

    private List<Parameter> parameters;
    private int pageSize = 10;
    private Parameter page;
    private Parameter search;
    private List<Parameter> filters;
    private Parameter sort;
    private Parameter sortDirection;
    private String[] columns;
    private String[] searchKeys;
    private String sql;
    private String jndiName;
    private String primaryKey;
    private List<Transformer> transformers;
    private Output output;

    public List<Parameter> getParameters() { return parameters; }
    public void setParameters(List<Parameter> parameters) { this.parameters = parameters; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public Parameter getPage() { return page; }
    public void setPage(Parameter page) { this.page = page; }
    public Parameter getSearch() { return search; }
    public void setSearch(Parameter search) { this.search = search; }
    public List<Parameter> getFilters() { return filters; }
    public void setFilters(List<Parameter> filters) { this.filters = filters; }
    public Parameter getSort() { return sort; }
    public void setSort(Parameter sort) { this.sort = sort; }
    public Parameter getSortDirection() { return sortDirection; }
    public void setSortDirection(Parameter sortDirection) { this.sortDirection = sortDirection; }
    public String[] getColumns() { return columns; }
    public void setColumns(String[] columns) { this.columns = columns; }
    public String[] getSearchKeys() { return searchKeys; }
    public void setSearchKeys(String[] searchKeys) { this.searchKeys = searchKeys; }
    public String getSql() { return sql; }
    public void setSql(String sql) { this.sql = sql; }
    public String getJndiName() { return jndiName; }
    public void setJndiName(String jndiName) { this.jndiName = jndiName; }
    public String getPrimaryKey() { return primaryKey; }
    public void setPrimaryKey(String primaryKey) { this.primaryKey = primaryKey; }
    public List<Transformer> getTransformers() { return transformers; }
    public void setTransformers(List<Transformer> transformers) { this.transformers = transformers; }
    public Output getOutput() { return output; }
    public void setOutput(Output output) { this.output = output; }

    private JSONObject getParams()
    {
        var params = new JSONObject();
        var request = (HttpRequest)ServiceState.get("request");

        if(parameters != null)
        {
            for(Parameter parameter : parameters)
            {
                params.put(parameter.getName(), parameter.getValue(request));
            }
        }

        return params;
    }

    public String generateSQL(Integer page, String search, String sort, boolean direction, boolean pagination)
    {
        return generateSQL(page, search, sort, direction, pagination, null);
    }

    public String generateSQL(Integer page, String search, String sort, boolean direction,
                              boolean pagination, JSONObject filters)
    {
        var statement = new StringBuilder("select");
        var filter = new StringBuilder();

        if(columns == null) throw new ConvirganceException("Columns (columns) to select must be set.");

        for(int i = 0; i < columns.length; i++)
        {
            if(i > 0) statement.append(',');
            statement.append("\n    source.").append(columns[i])
                     .append(" as \"").append(columns[i]).append('"');
        }

        statement.append("\nfrom (").append(sql).append(") source");

        if(filters != null)
        {
            if(primaryKey == null) throw new ConvirganceException("Primary key must be set to use filters.");

            for(String key : filters.keySet())
            {
                if(filter.length() > 0) filter.append("\n  and ");
                filter.append(key).append(" = :").append(key);
            }

            String sourceSql = statement.toString();
            statement.append("\njoin (").append(sourceSql).append("\nwhere ")
                     .append(new Query(filter.toString(), filters).getDatabaseSQL())
                     .append(") filter on filter.\"").append(primaryKey).append('"')
                     .append(" = source.").append(primaryKey);
        }

        if(search != null && searchKeys != null)
        {
            statement.append(filters != null ? "\n  and (" : "\nwhere (");

            for(int i = 0; i < searchKeys.length; i++)
            {
                if(i > 0) statement.append("\n    or ");
                statement.append("lower(source.").append(searchKeys[i])
                         .append(") like :").append(SEARCH_PARAMETER);
            }

            statement.append(')');
        }

        if(sort != null && !sort.isBlank())
        {
            if(!Arrays.asList(columns).contains(sort))
            {
                throw new ConvirganceException("Unsupported sort column: " + sort);
            }

            statement.append("\norder by source.").append(sort).append(direction ? " desc" : " asc")
                     .append(" nulls last");
        }

        if(page != null && pagination && (transformers == null || transformers.isEmpty()))
        {
            statement.append("\nlimit ").append(pageSize)
                     .append("\noffset ").append((page - 1) * pageSize);
        }

        return statement.toString();
    }

    private Integer getPage(HttpRequest request)
    {
        String value = (String)page.getValue(request);
        return value == null ? null : Integer.valueOf(value);
    }

    private JSONObject computeFilter(HttpRequest request)
    {
        var result = new JSONObject();

        if(filters == null) return null;

        for(Parameter filter : filters)
        {
            Object value = filter.getValue(request);

            if(value != null && !value.toString().isEmpty()) result.put(filter.getName(), value);
        }

        return result.isEmpty() ? null : result;
    }

    private Iterable<JSONObject> getRecords(HttpRequest request, boolean paginated)
    {
        Integer pageNumber = getPage(request);
        String searchValue = (String)search.getValue(request);
        String sortValue = (String)sort.getValue(request);
        boolean descending = Boolean.parseBoolean((String)sortDirection.getValue(request));
        JSONObject queryParameters = getParams();

        if(searchValue != null)
        {
            queryParameters.put(SEARCH_PARAMETER, "%" + searchValue.toLowerCase() + "%");
        }

        String generatedSql = generateSQL(pageNumber, searchValue, sortValue, descending,
                                          paginated, computeFilter(request));
        DataSource source = ApplicationInitializer.lookup(jndiName);
        DBMS dbms = source == null ? DBMS.lookup(jndiName) : new DBMS(source);
        Iterable<JSONObject> records = dbms.query(new Query(generatedSql, queryParameters));

        if(transformers != null)
        {
            for(Transformer transformer : transformers) records = transformer.transform(records);
        }

        if(transformers != null && !transformers.isEmpty() && paginated)
        {
            records = new Filter()
            {
                private int index;
                private final int offset = (pageNumber - 1) * pageSize;
                private final int limit = offset + pageSize;

                @Override
                public boolean test(JSONObject record)
                {
                    int current = index++;
                    return current >= offset && current < limit;
                }
            }.transform(records);
        }

        return records;
    }

    private Iterable<JSONObject> getCount(HttpRequest request)
    {
        var results = new JSONArray<JSONObject>();
        var result = new JSONObject();
        int count = 0;

        for(JSONObject ignored : getRecords(request, false)) count++;

        result.put("count", count);
        result.put("pages", (count / pageSize) + (count % pageSize > 0 ? 1 : 0));
        results.add(result);
        return results;
    }

    @Override
    public Iterable<JSONObject> process(HttpRequest request)
    {
        return request.getRequestURI().endsWith("/count") ? getCount(request) : getRecords(request, true);
    }

    @Override
    public void execute(HttpRequest request, HttpResponse response)
    {
        response.setContentType(output.getContentType());
        output.write(new OutputStreamTarget(response.getOutputStream()), process(request));
    }
}
