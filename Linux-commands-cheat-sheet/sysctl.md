### Linux Kernel /etc/sysctl.conf Security Hardening
<p align="center">
<img src="/Note/img/linux-logo.PNG">
</p>

<br>
* How do I set advanced security options of the TCP/IP stack and virtual memory to improve the security and performance of my Linux based system? How do I configure Linux kernel to prevent certain kinds of attacks using /etc/sysctl.conf? How do I set Linux kernel parameters?

sysctl is an interface that allows you to make changes to a running Linux kernel. With /etc/sysctl.conf you can configure various Linux networking and system settings such as:

```
1. Limit network-transmitted configuration for IPv4
2. Limit network-transmitted configuration for IPv6
3. Turn on execshield protection
4. Prevent against the common ‘syn flood attack’
5. Turn on source IP address verification
6. Prevents a cracker from using a spoofing attack against the IP address of the server.
7. Logs several types of suspicious packets, such as spoofed packets, source-routed packets, and redirects.
```
<p align="center">
<img src="/Note/img/Linux-Kernel-etc-sysctl.PNG">
</p>

<br>
Linux Kernel /etc/sysctl.conf Security Hardening with sysctl
The sysctl command is used to modify kernel parameters at runtime. /etc/sysctl.conf is a text file containing sysctl values to be read in and set by sysct at boot time. To view current values, enter:

```
# sysctl -a
# sysctl -A
# sysctl mib
# sysctl net.ipv4.conf.all.rp_filter
# sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

To load settings, enter:
# sysctl -p
```

Sample /etc/sysctl.conf for Linux server hardening
Edit /etc/sysctl.conf or /etc/sysctl.d/99-custom.conf and update it as follows. The file is documented with comments. However, I recommend reading the official Linux kernel sysctl tuning help file (see below):

```
# The following is suitable for dedicated web server, mail, ftp server etc. 
# ---------------------------------------
# BOOLEAN Values:
# a) 0 (zero) - disabled / no / false
# b) Non zero - enabled / yes / true
# --------------------------------------
# Controls IP packet forwarding
net.ipv4.ip_forward = 0
 
# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0
 
# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0
 
# Controls whether core dumps will append the PID to the core filename
# Useful for debugging multi-threaded applications
kernel.core_uses_pid = 1
 
# Controls the use of TCP syncookies
# Turn on SYN-flood protections
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_synack_retries = 5
 
########## IPv4 networking start ##############
# Send redirects, if router, but this is just server
# So no routing allowed 
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
 
# Accept packets with SRR option? No
net.ipv4.conf.all.accept_source_route = 0
 
# Accept Redirects? No, this is not router
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
 
# Log packets with impossible addresses to kernel log? yes
net.ipv4.conf.all.log_martians = 1
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
 
# Ignore all ICMP ECHO and TIMESTAMP requests sent to it via broadcast/multicast
net.ipv4.icmp_echo_ignore_broadcasts = 1
 
# Prevent against the common 'syn flood attack'
net.ipv4.tcp_syncookies = 1
 
# Enable source validation by reversed path, as specified in RFC1812
net.ipv4.conf.all.rp_filter = 1
 
# Controls source route verification
net.ipv4.conf.default.rp_filter = 1 
 
########## IPv6 networking start ##############
# Number of Router Solicitations to send until assuming no routers are present.
# This is host and not router
net.ipv6.conf.default.router_solicitations = 0
 
# Accept Router Preference in RA?
net.ipv6.conf.default.accept_ra_rtr_pref = 0
 
# Learn Prefix Information in Router Advertisement
net.ipv6.conf.default.accept_ra_pinfo = 0
 
# Setting controls whether the system will accept Hop Limit settings from a router advertisement
net.ipv6.conf.default.accept_ra_defrtr = 0
 
#router advertisements can cause the system to assign a global unicast address to an interface
net.ipv6.conf.default.autoconf = 0
 
#how many neighbor solicitations to send out per address?
net.ipv6.conf.default.dad_transmits = 0
 
# How many global unicast IPv6 addresses can be assigned to each interface?
net.ipv6.conf.default.max_addresses = 1
 
########## IPv6 networking ends ##############
 
#Enable ExecShield protection
#Set value to 1 or 2 (recommended) 
#kernel.exec-shield = 2
#kernel.randomize_va_space=2
 
# TCP and memory optimization 
# increase TCP max buffer size setable using setsockopt()
#net.ipv4.tcp_rmem = 4096 87380 8388608
#net.ipv4.tcp_wmem = 4096 87380 8388608
 
# increase Linux auto tuning TCP buffer limits
#net.core.rmem_max = 8388608
#net.core.wmem_max = 8388608
#net.core.netdev_max_backlog = 5000
#net.ipv4.tcp_window_scaling = 1
 
# increase system file descriptor limit    
fs.file-max = 65535
 
#Allow for more PIDs 
kernel.pid_max = 65536
 
#Increase system IP port limits
net.ipv4.ip_local_port_range = 2000 65000
 
# RFC 1337 fix
net.ipv4.tcp_rfc1337=1
```

Reboot the machine soon after a kernel panic:

`kernel.panic=10`

Addresses of mmap base, heap, stack and VDSO page are randomized:

`kernel.randomize_va_space=2`

Ignore bad ICMP errors:

`net.ipv4.icmp_ignore_bogus_error_responses=1`

Protects against creating or following links under certain conditions

```
fs.protected_hardlinks=1
fs.protected_symlinks=1
```

### How to reload sysctl.conf variables on Linux

- Reading the Linux variable from command line

```
sysctl kernel.ostype
-->
kernel.ostype = Linux
```

* To see all variables pass the -a option as follows:

```
$ sysctl -a
# use the more command/grep command as filter #
$ sysctl -a | grep kernel
$ sysctl -a | more
```

* Regex support

```
# sysctl -a --pattern forward
# sysctl -a --pattern forward$
# sysctl -a -r version
```

* Write variable from command line


The syntax is:

`sysctl -w variable=value`

To enable packet forwarding for IPv4, enter:

`sysctl -w net.ipv4.ip_forward=1`

How to reload sysctl.conf variables on Linux

Type the following command to reload settings from config files without rebooting the box:

`sysctl --system`

The settings are read from all of the following system configuration files:
```
/run/sysctl.d/*.conf
/etc/sysctl.d/*.conf
/usr/local/lib/sysctl.d/*.conf
/usr/lib/sysctl.d/*.conf
/lib/sysctl.d/*.conf
/etc/sysctl.conf
```

* Persistent configuration
You need to edit the /etc/sysctl.conf or file from the /etc/sysctl.d/ directory. Your custom Linux kernel system variables typically goes into the /etc/sysctl.d/1000-custom.conf file:

`vi /etc/sysctl.conf`

OR
`vi /etc/sysctl.d/1000-custom.conf`

Modify or add in the file. For example:

```
vm.max_map_count=262144
vm.mmap_min_addr=65536
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.ip_nonlocal_bind=1
```

Close and save the file. To load in sysctl settings from the file specified or /etc/sysctl.conf if none given, enter:
`sysctl -p`

Let us read values from file called /etc/sysctl.d/1000-custom.conf:
`sudo sysctl -p /etc/sysctl.d/1000-custom.conf
OR
`sudo sysctl --load=/etc/sysctl.d/1000-custom.conf`
OR
`sudo sysctl -f /etc/sysctl.d/1000-custom.conf`


