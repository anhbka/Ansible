## Linux command cheat sheet

* System
* Hardware
* Users
* File Commands
* Process Related
* File Permission
* Network
* Compression / Archives
* Install Packages
* Install Source
* Search
* Login
* File Transfer
* Directory Traverse

### 1. System


|uname|	 Displays  Linux system information|
|-----|------------------------------------|
|uname -r|	Displays  kernel release information|
|uptime|	Displays how long the system has been running including load average|
|hostname|	Shows the system hostname|
|hostname -i|	Displays the IP address of the system|
|last reboot|	Shows system reboot history|
|date|	Displays current system date and time|
|timedatectl|	Query and change the System clock|
|cal|	Displays the current calendar month and day|
|w|	Displays currently  logged in users in the system|
|whoami|	Displays who you are logged in as|
|finger username|	Displays information about the user|

### 2. Hardware

<table border="0" cellspacing="0">
<colgroup width="157"></colgroup>
<colgroup width="438"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>dmesg</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays bootup messages</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cat /proc/cpuinfo</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays more information about CPU e.g model, model name, cores, vendor id</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cat /proc/meminfo</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays more information about hardware memory e.g. Total and Free memory</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>lshw</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays information about system's hardware configuration</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>lsblk</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays block devices related information</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>free -m</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays free and used memory in the system (-m flag indicates memory in MB)</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>lspci -tv</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays PCI devices in a tree-like&nbsp;diagram</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>lsusb&nbsp;-tv</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays USB devices in a tree-like diagram</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>dmidecode</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays hardware information from the BIOS</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>hdparm&nbsp;-i /dev/xda</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays information about disk data</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>hdparm&nbsp;-tT /dev/xda&nbsp;&lt;:code&gt;</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Conducts a read speed test on device xda</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>badblocks&nbsp;-s /dev/xda</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Tests&nbsp; for unreadable blocks on disk</span></td>
</tr>
</tbody>
</table>


### 3. Users

<table border="0" cellspacing="0">
<colgroup width="157"></colgroup>
<colgroup width="438"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>id</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays the details of the active user e.g. uid, gid, and groups</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>last</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Shows the last logins in the system</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>who</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Shows who is logged in to the system</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>groupadd "admin"</code> </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Adds the group 'admin'</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>adduser "Sam"</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;"> Adds user Sam</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>userdel "Sam"</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Deletes user Sam</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>usermod</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Used for changing / modifying user information</span></td>
</tr>
</tbody>
</table>


### 4. File Commands

<table border="0" cellspacing="0">
<colgroup width="157"></colgroup>
<colgroup width="438"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ls -al</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Lists files - both regular &amp;&nbsp; hidden files and their permissions as well.</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>pwd</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays the current directory file path</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>mkdir 'directory_name'</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Creates a new directory</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rm file_name </code> </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Removes a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rm -f filename</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Forcefully removes a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rm -r directory_name</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Removes a directory recursively</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rm -rf directory_name</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Removes a directory forcefully and recursively</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cp file1 file2</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Copies the contents of file1 to file2</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cp -r dir1 dir2</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Recursively Copies dir1 to dir2. dir2 is created if it does not exist</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>mv file1 file2</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Renames file1 to file2</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ln -s /path/to/file_name&nbsp; &nbsp;link_name</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Creates a symbolic link to file_name</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>touch file_name</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Creates a new file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cat &gt; file_name</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Places standard input into a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>more file_name</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Outputs the contents of a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>head file_name</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Displays the first 10 lines of a file</span></td>
</tr>
<tr>
<td align="left" height="20"><code><span style="font-family: Liberation Serif; font-size: medium;">tail file_name</span></code></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Displays the last 10 lines of a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>gpg -c file_name</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Encrypts a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>gpg file_name.gpg</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Decrypts a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>wc</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Prints the number of bytes, words and lines in a file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>xargs</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Executes commands from standard input</span></td>
</tr>
</tbody>
</table>

### 5. Process Related

<table border="0" cellspacing="0">
<colgroup width="203"></colgroup>
<colgroup width="280"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ps</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Display currently active processes</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ps aux | grep 'telnet'</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Searches for the id of the process 'telnet'</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>pmap</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Displays memory map of processes</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>top</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">&nbsp;Displays all running processes</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>kill pid</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Terminates process with a given pid</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>killall proc</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Kills / Terminates all processes named proc</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>pkill process-name</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Sends&nbsp;a signal to a process with its name</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>bg</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Resumes suspended jobs in the background</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>fg</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Brings suspended jobs to the foreground</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>fg n</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"> job n to the foreground</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>lsof</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">Lists files that are open by processes</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>renice 19 PID</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">makes a process run with very low priority</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>pgrep firefox</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">find Firefox process ID</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>pstree</code></span></td>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">visualizing processes in tree model</span></td>
</tr>
</tbody>
</table>

### 6. File Permission

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="641"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chmod octal filename</code> &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Change file permissions of the file to octal</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;">&nbsp;</span></td>
<td align="left"></td>
</tr>
<tr>
<td align="left" height="20"><strong><span style="font-family: Liberation Serif; font-size: medium;">Example</span></strong></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">&nbsp;</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chmod 777 /data/test.c</code> &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Set rwx permissions to owner, group and everyone (everyone else who has access to the server)</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chmod 755 /data/test.c</code> &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Set rwx to the owner and r_x to group and everyone</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chmod&nbsp;766 /data/test.c</code>&nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Sets rwx for owner, rw for group and everyone</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chown owner user-file</code> &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Change ownership of the file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chown&nbsp;owner-user:owner-group file_name </code>&nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Change owner and group owner of the file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>chown owner-user:owner-group directory</code> &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Change owner and group owner of the directory</span></td>
</tr>
</tbody>
</table>

### 7. Network

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="641"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ip addr show</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays IP addresses and all the network interfaces</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ip address add 192.168.0.1/24 dev eth0</code>&nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Assigns IP address 192.168.0.1 to interface eth0</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ifconfig&nbsp;</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays IP addresses of all network interfaces</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ping&nbsp; host</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">ping command sends an ICMP echo request to establish a connection to server / PC</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>whois domain</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Retrieves more information about a domain name</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>dig domain</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Retrieves DNS information about the domain</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>dig -x host&nbsp;</code> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Performs reverse lookup on a domain</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>host google.com&nbsp;</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Performs an IP lookup for the domain name</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>hostname -i</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays local IP address</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>wget file_name</code>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Downloads a file from an online source</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>netstat -pnltu</code>&nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays all active listening ports</span></td>
</tr>
</tbody>
</table>

### 8. Compression/Archives

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="641"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>tar -cf home.tar home&lt;:code&gt;</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Creates archive file called 'home.tar' from file 'home'</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>tar -xf files.tar</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Extract archive file 'files.tar'</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>tar -zcvf home.tar.gz source-folder</code>&nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Creates gzipped tar archive file from the source folder</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>gzip file</code>&nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Compression a file with .gz extension</span></td>
</tr>
</tbody>
</table>

### 9. Install Packages

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="641"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rpm -i pkg_name.rpm</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Install an rpm package</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rpm -e pkg_name</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Removes an rpm package</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>dnf install pkg_name</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Install package using dnf utility</span></td>
</tr>
</tbody>
</table>

### 10. Install Source (Compilation)

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="1086"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>./configure</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Checks your system for the required software needed to build the program. It will build the Makefile containing the instructions required to effectively build the project</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>make</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">It reads the Makefile to compile the program with the required operations. The process may take some time, depending on your system and the size of the program</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>make install</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">The command installs the binaries in the default/modified paths after the compilation</span></td>
</tr>
</tbody>
</table>

### 11. Search

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="370"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>grep 'pattern' files</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Search for a given pattern in files</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>grep -r pattern dir</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Search recursively for a pattern in a given directory</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>locate file</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Find all instances of the file</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>find /home/ -name "index"&nbsp;</code> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Find file names that begin with 'index' in /home folder</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>find /home -size +10000k</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Find files greater than 10000k in the home folder</span></td>
</tr>
</tbody>
</table>

### 12. Login

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="370"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ssh user@host</code> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Securely connect to host as user</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ssh -p port_number user@host&nbsp;</code> &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Securely connect to host using a specified port</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>ssh host</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Securely connect to the system via SSH default port 22</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>telnet host</code>&nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Connect to host via telnet default port 23</span></td>
</tr>
</tbody>
</table>

### 13. File Transfer

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="370"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>scp file1.txt server2/tmp</code>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Securely copy file1.txt to server2 in /tmp directory</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>rsync -a /home/apps&nbsp; /backup/</code>&nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Synchronize contents in /home/apps directory with /backup&nbsp; directory</span></td>
</tr>
</tbody>
</table>

### 14. Disk Usage

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="370"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>df&nbsp; -h</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays free space on mounted systems</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>df&nbsp; -i&nbsp;</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays free inodes on filesystems</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>fdisk&nbsp; -l</code>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Shows disk partitions, sizes, and types</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>du&nbsp; -sh</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays disk usage in the current directory in a human-readable format</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>findmnt</code> &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Displays target mount point for all filesystems</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>mount device-path mount-point</code></span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Mount a device</span></td>
</tr>
</tbody>
</table>

### 15. Directory Traverse

<table border="0" cellspacing="0">
<colgroup width="318"></colgroup>
<colgroup width="370"></colgroup>
<tbody>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cd ..</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Move up one level in the directory tree structure</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cd</code>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; </span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Change directory to $HOME directory</span></td>
</tr>
<tr>
<td align="left" height="20"><span style="font-family: Liberation Serif; font-size: medium;"><code>cd /test</code>&nbsp;</span></td>
<td align="left"><span style="font-family: Liberation Serif; font-size: medium;">Change directory to /test directory</span></td>
</tr>
</tbody>
</table>














