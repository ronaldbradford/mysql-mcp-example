# Using the MCP API

If you have defined `export MYSQL_MCP_HTTP=1` before starting `mysql-mcp-server` you will automatically get a HTTP REST interface for direct access to your MySQL setup which you can use via other products.

NOTE: In my example the MySQL server is a remote host, however your MCP HTTP interface is in this  case on your local machine.

```
$ curl -s http://localhost:9306/api/databases | jq .
{
  "success": true,
  "data": {
    "databases": [
      {
        "name": "imdb"
      },
      {
        "name": "information_schema"
      },
      {
        "name": "performance_schema"
      }
    ]
  }
}
```

```
$ curl -s http://localhost:9306/api/server-info | jq .
{
  "success": true,
  "data": {
    "version": "8.0.44-0ubuntu0.22.04.1",
    "version_comment": "(Ubuntu)",
    "uptime_seconds": 1215402,
    "current_database": "imdb",
    "current_user": "mcp@%",
    "character_set": "utf8mb4",
    "collation": "utf8mb4_0900_ai_ci",
    "max_connections": 1000,
    "threads_connected": 3
  }
}
```


```
curl -X POST http://localhost:9306/api/query   -H "Content-Type: application/json"   -d '{"sql": "SELECT * FROM title LIMIT 5", "database": "imdb"}'
{"success":true,"data":{"columns":["title_id","tconst","type","title","original_title","is_adult","start_year","end_year","run_time_mins","updated","views"],"rows":[[1,"tt0000001","short","Carmencita","Carmencita",0,1894,null,1,"2025-02-28T21:15:38Z",0],[2,"tt0000002","short","Le clown et ses chiens","Le clown et ses chiens",0,1892,null,5,"2025-02-28T21:15:38Z",0],[3,"tt0000003","short","Poor Pierrot","Pauvre Pierrot",0,1892,null,5,"2025-02-28T21:15:38Z",0],[4,"tt0000004","short","Un bon bock","Un bon bock",0,1892,null,12,"2025-02-28T21:15:38Z",0],[5,"tt0000005","short","Blacksmith Scene","Blacksmith Scene",0,1893,null,1,"2025-02-28T21:15:38Z",0]]}}
```

Be warned that some of the default settings are high. For example the HTTP interface can accept 100 requests per second, with a burst to 200 per second.  If you are using the HTTP interface for all queries that may be appropriate, but if this is running along side your application it may high. You need to ensure your queries are efficient.

These are the defaults, before the setting of any ENV variables.

```
$ mysql-mcp-server --print-config
connections:
    default:
        dsn: mcp:***@tcp(picard:3306)/imdb?parseTime=true
        description: Default connection
        read_only: false
query:
    max_rows: 200
    timeout_seconds: 30
pool:
    max_open_conns: 10
    max_idle_conns: 5
    conn_max_lifetime_minutes: 30
    conn_max_idle_time_minutes: 5
    ping_timeout_seconds: 5
features:
    extended_tools: false
    vector_tools: false
logging:
    json_format: false
    audit_log_path: ""
    token_tracking: false
    token_model: cl100k_base
http:
    enabled: false
    port: 9306
    request_timeout_seconds: 60
    rate_limit:
        enabled: false
        rps: 100
        burst: 200
```
