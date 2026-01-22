# Meta data about MySQL and Tables

The MCP server enables you to get meta data around the tables and other database objects.

EXAMPLES

## Configuration

You can also gather configuration information.  NOTE: that that it has categorized the variables, as well as automatically run a status query to get a current

Prompt `show me the values for configuration that are related to connections`


Here are the connection-related MySQL configuration variables:

Connection Limits & Timeouts:

* `connect_timeout` = 10 (seconds before connection attempt times out)
* `max_connections` = (need to check status for current value)
* `max_connect_errors` = (need to check status)

Connection Memory:

* `connection_memory_chunk_size` = 8192 (8 KB - memory allocation chunk size per connection)
* `connection_memory_limit` = 18446744073709551615 (essentially unlimited per connection)
* `global_connection_memory_limit` = 18446744073709551615 (essentially unlimited globally)
* `global_connection_memory_tracking` = OFF

Connection Queue:

* `back_log` = 1000 (number of outstanding connection requests MySQL can have)

Network & Binding:

* `bind_address` = * (listens on all network interfaces)
* `admin_address` = (empty - admin interface not separately bound)
* `admin_port` = 33062

Host Caching:

* `host_cache_size` = 653 (caches host/IP mappings to speed up connections)

Authentication:

* `default_authentication_plugin` = caching_sha2_password
* `disconnect_on_expired_password` = ON

Let me get the actual max_connections value from the status:

* `max_connections` = 1000 (maximum simultaneous client connections)

Would you like me to also show the current connection status (how many connections are active, max used, etc.)?

Prompt `yes`

Here's the current connection status:
Connection Statistics:

- `Connections` = 593,794 (total connections since server start)
- `Threads_connected` = 4 (currently active connections)
- `Max_used_connections` = 6 (peak concurrent connections)
- `Max_used_connections_time` = 2026-01-07 17:54:00 (when peak occurred)
