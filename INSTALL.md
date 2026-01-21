# MySQL MCP Installation and Configuration

## QuickStart

### MacOS Installation

To install and review of options via help:
```
brew install askdba/tap/mysql-mcp-server
mysql-mcp-server --version
mysql-mcp-server --help
```
```
$ mysql-mcp-server --version
mysql-mcp-server 1.4.0
  Build time: 2025-12-29T19:37:27Z
  Git commit: dd7cd0f5da0f589d51ebac3829d8d5fcb678bf91
```

```
$ mysql-mcp-server --help
mysql-mcp-server - MySQL Server for Model Context Protocol (MCP)

USAGE:
    mysql-mcp-server [OPTIONS]

OPTIONS:
    -h, --help                  Show this help message
    -v, --version               Show version information
    -c, --config PATH           Use config file at PATH
    --print-config              Print current configuration as YAML
    --validate-config PATH      Validate config file at PATH

DESCRIPTION:
    A fast, read-only MySQL Server for the Model Context Protocol (MCP).
    Exposes safe MySQL introspection tools to Claude Desktop via MCP.

...
```
See the [Appendix](#appendix) for the full Help Text.

### Installation Footnote
NOTE: The installation will give you the following useful instructions.
```
...
To use mysql-mcp-server with Claude Desktop, add to your config:

  {
    "mcpServers": {
      "mysql": {
        "command": "/opt/homebrew/bin/mysql-mcp-server",
        "env": {
          "MYSQL_DSN": "user:password@tcp(localhost:3306)/database"
        }
      }
    }
  }

Config location:
  macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
  Linux: ~/.config/Claude/claude_desktop_config.json
```

## MacOS Configuration

The configuration to connect to MySQL in Claude is held in the following file. It is possible with Claude Desktop installed this file does not yet exist.
```
cat ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

### Configuration Optimization

To assist in both the verification of your MySQL installation, new MySQL user and configuration of ClaudeAI I use the following optimizations.

1. Create a `.envrc` config file, see [.envrc.example]
2. Create the MySQL user defined. NOTE: This has to be performed manually with a privileged user.
    ```
    CREATE USER mcp IDENTIFIED BY 'Pick@Strong.Password';
    GRANT SELECT ON imdb.* TO mcp;
    ```
3. Source the config file with `source .envrc`
4. Validate MySQL connection with `my  -e "SELECT VERSION(), USER()"`.  `my` is a pre-created alias with the user configuration.
5. Generate Claude MCP config `curl -s https://gist.githubusercontent.com/ronaldbradford/d5e7c6f579b739d5ccd02f1f41fb232d/raw/3c6d16adff8530c1ed6163a45142fef5e0775b24/mysql-mcp-config-example.json | envsubst`
6. Restart Claude Desktop `curl -s https://gist.githubusercontent.com/ronaldbradford/a331fb48cb29425ac8e83323c050b0c4/raw/4d1070933aebe529306dbaa5b006982ab33779b0/restart-claude.sh | bash`

Depending on your setup, you may already have some content in `claude_desktop_config.json`. The following will append, however you should verify the file is valid JSON after and adjust accordingly.

```
curl -s https://gist.githubusercontent.com/ronaldbradford/d5e7c6f579b739d5ccd02f1f41fb232d/raw/3c6d16adff8530c1ed6163a45142fef5e0775b24/mysql-mcp-config-example.json | envsubst >> ~/Library/Application\ Support/Claude/claude_desktop_config.json
jq . ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

NOTE: This is just a quickstart example.

# Appendix
## `mysql-mcp-server help`

```
$ mysql-mcp-server --help
mysql-mcp-server - MySQL Server for Model Context Protocol (MCP)

USAGE:
    mysql-mcp-server [OPTIONS]

OPTIONS:
    -h, --help                  Show this help message
    -v, --version               Show version information
    -c, --config PATH           Use config file at PATH
    --print-config              Print current configuration as YAML
    --validate-config PATH      Validate config file at PATH

DESCRIPTION:
    A fast, read-only MySQL Server for the Model Context Protocol (MCP).
    Exposes safe MySQL introspection tools to Claude Desktop via MCP.

CONFIGURATION:
    Configuration can be provided via config file or environment variables.
    Environment variables take precedence over config file values.

    Config file search order:
        1. --config flag or MYSQL_MCP_CONFIG env var
        2. ./mysql-mcp-server.yaml (current directory)
        3. ~/.config/mysql-mcp-server/config.yaml (user config)
        4. /etc/mysql-mcp-server/config.yaml (system config)

    Required (via env var or config file):
        MYSQL_DSN                    MySQL DSN (e.g., user:pass@tcp(localhost:3306)/db)

    Optional:
        MYSQL_MAX_ROWS               Max rows returned (default: 200)
        MYSQL_QUERY_TIMEOUT_SECONDS  Query timeout in seconds (default: 30)
        MYSQL_MCP_EXTENDED           Enable extended tools (set to 1)
        MYSQL_MCP_JSON_LOGS          Enable JSON structured logging (set to 1)
        MYSQL_MCP_TOKEN_TRACKING     Enable token usage estimation (set to 1)
        MYSQL_MCP_TOKEN_MODEL        Tokenizer encoding to use (default: cl100k_base)
        MYSQL_MCP_AUDIT_LOG          Path to audit log file
        MYSQL_MCP_VECTOR             Enable vector tools for MySQL 9.0+ (set to 1)
        MYSQL_MCP_HTTP               Enable REST API mode (set to 1)
        MYSQL_HTTP_PORT              HTTP port for REST API mode (default: 9306)
        MYSQL_HTTP_RATE_LIMIT        Enable rate limiting for HTTP mode (set to 1)
        MYSQL_HTTP_RATE_LIMIT_RPS    Rate limit: requests per second (default: 100)
        MYSQL_HTTP_RATE_LIMIT_BURST  Rate limit: burst size (default: 200)
        MYSQL_MAX_OPEN_CONNS         Max open database connections (default: 10)
        MYSQL_MAX_IDLE_CONNS         Max idle database connections (default: 5)
        MYSQL_CONN_MAX_LIFETIME_MINUTES  Connection max lifetime in minutes (default: 30)

MULTI-DSN CONFIGURATION:
    Configure multiple MySQL connections using numbered environment variables:

        MYSQL_DSN_1                  Additional connection DSN
        MYSQL_DSN_1_NAME             Connection name (default: connection_1)
        MYSQL_DSN_1_DESC             Connection description

    Or use JSON configuration:

        MYSQL_CONNECTIONS='[
          {"name": "production", "dsn": "user:pass@tcp(prod:3306)/db", "description": "Production"},
          {"name": "staging", "dsn": "user:pass@tcp(staging:3306)/db", "description": "Staging"}
        ]'

EXAMPLES:
    # Basic usage with single connection
    export MYSQL_DSN="root:password@tcp(127.0.0.1:3306)/mysql?parseTime=true"
    mysql-mcp-server

    # With config file
    mysql-mcp-server --config /path/to/config.yaml

    # Validate a config file
    mysql-mcp-server --validate-config /path/to/config.yaml

    # Print current configuration
    mysql-mcp-server --print-config

    # With extended tools enabled
    export MYSQL_DSN="user:pass@tcp(localhost:3306)/mydb"
    export MYSQL_MCP_EXTENDED=1
    mysql-mcp-server

    # HTTP REST API mode
    export MYSQL_DSN="user:pass@tcp(localhost:3306)/mydb"
    export MYSQL_MCP_HTTP=1
    export MYSQL_HTTP_PORT=9306
    mysql-mcp-server

FEATURES:
    - Fully read-only (blocks all non-SELECT/SHOW/DESCRIBE/EXPLAIN)
    - Multi-DSN support (connect to multiple MySQL instances)
    - Vector search (MySQL 9.0+)
    - Query timeouts and row limits
    - Structured logging and audit logs
    - REST API mode for HTTP clients

MCP TOOLS:
    Core: list_databases, list_tables, describe_table, run_query, ping, server_info
    Connections: list_connections, use_connection
    Extended: list_indexes, show_create_table, explain_query, list_views, etc.
    Vector: vector_search, vector_info (MySQL 9.0+)

SECURITY:
    - SQL validation blocks dangerous operations
    - Read-only enforcement
    - Multi-statement prevention
    - Recommended: Use a read-only MySQL user

    CREATE USER 'mcp'@'localhost' IDENTIFIED BY 'strongpass';
    GRANT SELECT ON *.* TO 'mcp'@'localhost';

DOCUMENTATION:
    Full documentation: https://github.com/askdba/mysql-mcp-server

```
