# DNSMASQ Deployment
This is my personal deployment of DNSMASQ, which I use as a container on my Macbook to help me not only with navigation but also with internal control of development environments.

#### (dnsmasq.conf) Parameters:

**port=53:**  
**Description:** Sets the port on which dnsmasq listens for DNS requests. The default port for DNS is 53.

**domain-needed:**  
**Description:** Ensures that dnsmasq only forwards queries that contain a fully qualified domain name (FQDN). It does not forward queries for short names that are not recognized as FQDNs.

**bogus-priv:**  
**Description:** Blocks queries for private IP addresses (such as 10.x.x.x, 172.16.x.x to 172.31.x.x, and 192.168.x.x) when those queries come from outside your local network. This helps prevent leakage of private IP addresses.

**no-hosts:**  
**Description:** Tells dnsmasq to ignore the /etc/hosts file. Normally, this file is used to define local hostnames and their corresponding IP addresses, but with this option, dnsmasq will not use it.

**keep-in-foreground:**  
**Description:** Prevents dnsmasq from daemonizing (running in the background). This is useful for debugging and ensures that the process remains in the foreground.

**no-resolv:**  
**Description:** Instructs dnsmasq not to read the /etc/resolv.conf file, which usually contains DNS server configurations. This is useful if you want dnsmasq to use only the DNS servers provided directly in its configuration.

**expand-hosts:**  
**Description:** Tells dnsmasq to expand short hostnames by appending the default domain name (local domain) to them. If you configure a local domain, short hostnames are automatically expanded.

**all-servers:**  
**Description:** Configures dnsmasq to query all configured DNS servers until it gets a response, rather than stopping at the first server that responds. This can improve the chances of receiving a correct response.

**cache-size:**  
**Description:** This option sets the maximum number of cache entries that dnsmasq can store in memory, also a larger value allows for more records to be cached, which can improve performance by avoiding repeated queries to the upstream DNS server, however, this also increases memory usage.

**min-cache-ttl:**  
**Description:** This option sets the minimum time (in seconds) that a DNS entry will be kept in the cache, regardless of the original TTL provided by the upstream DNS server. This can be useful to reduce the frequency of queries to the upstream DNS server and keep the cache longer, but it may cause issues if DNS information changes upstream within that period.

**log-queries=extra**  
This option enhances the detail level of DNS query logging. The extra details typically include:

_Query Type:_ The type of DNS record requested (e.g., A, AAAA, MX).  
_Query ID:_ A unique identifier for the DNS query.  
_Client IP:_ The IP address of the client making the DNS query.  

**log-facility=/var/log/dnsmasq.log**  
 Defines the log file where dnsmasq will write its logs.

#### (parse_logs.awk) Script
Script to parse dnsmasq logs and have a bit of comprehension of what it’s happening inside of it.

**/cached/:**  
Matches lines in the log that contain the word "cached," indicating cache returns. The script increments a counter for cache returns and prints the matching log line prefixed with "Cache Return:".

**/forwarded/:**  
Matches lines that contain the word "forwarded," which indicates a cache hit where a query was forwarded to another server. The script increments a counter for cache hits and prints the matching log line prefixed with "Cache Hit:".

**/query/:**  
Filters lines that contain the word "query" and extracts the hostname from field 6 (this may vary based on your log structure). It prints the hostname prefixed with "Hostname:".

**END:**  
At the end of processing, the script prints a summary showing the total number of cache returns and cache hits.

**Command:**  
`# awk -f parse_logs.awk log/dnsmasq.log`

**Output sample**
```shell
...
Cache Return: Sep  6 00:30:42 dnsmasq[1]: 2842 192.168.65.1/52150 cached youtube.com is 142.250.219.142
Hostname: 192.168.65.1/44483
Cache Return: Sep  6 00:30:42 dnsmasq[1]: 2843 192.168.65.1/44483 cached netflix.com is 3.230.129.93
Cache Return: Sep  6 00:30:42 dnsmasq[1]: 2843 192.168.65.1/44483 cached netflix.com is 52.3.144.142
Cache Return: Sep  6 00:30:42 dnsmasq[1]: 2843 192.168.65.1/44483 cached netflix.com is 54.237.226.164
Hostname: 192.168.65.1/57818
Cache Return: Sep  6 00:30:42 dnsmasq[1]: 2844 192.168.65.1/57818 cached blizzard.com is 137.221.106.104

Sum:
Total Cache Return: 7426
Total Cache Hit: 602
```

#### MacOS reminders
- to clean the dns local client:
`sudo dscacheutil -flushcache`  
- to kill the macos dns responder:
`sudo killall -HUP mDNSResponder`  
- to check who is owning the port 53:
`sudo lsof -nP -i4TCP:53`