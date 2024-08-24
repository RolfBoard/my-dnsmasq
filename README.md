# DNSMASQ Deployment
This is my personal deployment of DNSMASQ, which I use as a container on my Macbook to help me not only with navigation but also with internal control of development environments.

### Config File Parameters:

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
no-resolv:

**Description:** Instructs dnsmasq not to read the /etc/resolv.conf file, which usually contains DNS server configurations. This is useful if you want dnsmasq to use only the DNS servers provided directly in its configuration.

**expand-hosts:**

**Description:** Tells dnsmasq to expand short hostnames by appending the default domain name (local domain) to them. If you configure a local domain, short hostnames are automatically expanded.

**all-servers:**

**Description:** Configures dnsmasq to query all configured DNS servers until it gets a response, rather than stopping at the first server that responds. This can improve the chances of receiving a correct response.

### MacOS reminders
- to clean the dns local client:
`sudo dscacheutil -flushcache`

- to kill the macos dns responder:
`sudo killall -HUP mDNSResponder`

- to check who is owning the port 53:
`sudo lsof -nP -i4TCP:53`