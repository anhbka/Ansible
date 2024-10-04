## 100+ Linux commands cheat sheet & examples


*In this cheat sheet tutorial I have consolidated a list of Linux commands with examples and man page link to give you an overview on Linux day to day usage. We know Linux is one of the preferred choice for most of the IT domains so having basic knowledge of Linux is mandatory for everyone. I have divided the Linux commands into different section so you can choose to only concentrate on the commands which suits your domain.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">printenv</td>
<td class="column-2"><code><strong># printenv</strong></code><p></p>
<p># printenv PATH</p></td>
<td class="column-3">Displays environment variable names and values.<br>
When called with the name of an environment variable, it displays the value of that variable.</td>
<td class="column-4"><a title="man page for printenv" href="https://man7.org/linux/man-pages/man1/printenv.1.html" target="_blank" rel="noopener noreferrer">man page for printenv</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">env</td>
<td class="column-2"><code><strong># env</strong></code></td>
<td class="column-3">The env utility runs a program as a child of the current shell, allowing you to modify the environment the current shell exports to the newly created process.</td>
<td class="column-4"><a title="man page for env" href="https://man7.org/linux/man-pages/man1/env.1.html" target="_blank" rel="noopener noreferrer">man page for env</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1">export</td>
<td class="column-2"><strong><code># export TEST=deepak<br>
# env | grep TEST</code></strong><code><br>
TEST=deepak</code></td>
<td class="column-3">When you run an export command with variable names as arguments, the shell places the names (and values, if present) of those variables in the environment.</td>
<td class="column-4"><a title="man page for export" href="https://man7.org/linux/man-pages/man1/export.1p.html" target="_blank" rel="noopener noreferrer">man page for export</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-1">set</td>
<td class="column-2"><code><strong># TEST=deepak<br>
# set | grep TEST</strong><br>
TEST=deepak</code></td>
<td class="column-3">Display variables in the current shell<br>
These variables comprise shell variables (variables not in the environment) and environment variables.</td>
<td class="column-4"><a title="man page for set" href="https://man7.org/linux/man-pages/man1/set.1p.html" target="_blank" rel="noopener noreferrer">man page for set</a></td>
</tr>
</tbody>
</table>

### 1. File Management

*The commands under this section are very basic commands and must be known to every system administrator. This is definitely not the complete list of Linux commands for file management but can give you a kickstart and can cover most of the basic to complex scenarios.*


<div class="divTable-wrapper">
<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1" rowspan="4">ls</td>
<td class="column-2"><code><strong># ls</strong></code></td>
<td class="column-3">List files</td>
<td class="column-4" rowspan="4"><a title="man page of ls" href="https://man7.org/linux/man-pages/man1/ls.1.html" target="_blank" rel="noopener noreferrer">man page for ls</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-2"><code><strong># ls -l</strong></code></td>
<td class="column-3">Long list files</td>
</tr>
<tr class="row-4 even">
<td class="column-2"><code><strong># ls -la</strong></code></td>
<td class="column-3">Long list files including hidden files</td>
</tr>
<tr class="row-5 odd">
<td class="column-2"><code><strong># ls -ltr</strong></code></td>
<td class="column-3">Long list files and sort by modification time. oldest placed first.</td>
</tr>
<tr class="row-6 even">
<td class="column-1">cat</td>
<td class="column-2"><code><strong># cat FILENAME</strong></code></td>
<td class="column-3">Print the content of the provided file on the terminal</td>
<td class="column-4"><a title="man page of cat" href="https://man7.org/linux/man-pages/man1/cat.1.html" target="_blank" rel="noopener noreferrer">man page for cat</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-1">less</td>
<td class="column-2"><code><strong># less FILENAME</strong></code></td>
<td class="column-3">When you want to view a file that is longer than one screen, you can use either the&nbsp;<code>less</code>&nbsp;utility or the more utility.<br>
It will pause after displaying a screen of text<br>
You can use keyboard arrow to navigate around the file to read the text<br>
Press&nbsp;<code>q</code>&nbsp;to return to the shell</td>
<td class="column-4"><a title="man page of less" href="https://man7.org/linux/man-pages/man1/less.1.html" target="_blank" rel="noopener noreferrer">man page for less</a></td>
</tr>
<tr class="row-8 even">
<td class="column-1">more</td>
<td class="column-2"><code><strong># more FILENAME</strong></code></td>
<td class="column-3"><code>more</code>&nbsp;command is also similar to less but has few restrictions<br>
We cannot use navigation arrow from the keyboard while reading with more<br>
You must use SPACE bar to scroll through the file<br>
Press&nbsp;<code>q</code>&nbsp;to return to console</td>
<td class="column-4"><a title="man page of more" href="https://man7.org/linux/man-pages/man1/more.1.html" target="_blank" rel="noopener noreferrer">man page for more</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-1">head</td>
<td class="column-2"><code><strong># head -n 5 FILENAME</strong></code></td>
<td class="column-3">This example displays the top 5 lines of provided file<br>
By default the&nbsp;<code>head</code>&nbsp;utility displays the first ten lines of a file.</td>
<td class="column-4"><a title="man page of head" href="https://man7.org/linux/man-pages/man1/head.1.html" target="_blank" rel="noopener noreferrer">man page for head</a></td>
</tr>
<tr class="row-10 even">
<td class="column-1" rowspan="2">tail</td>
<td class="column-2"><code><strong># tail -n 5 FILENAME</strong></code></td>
<td class="column-3">This example will display the last 5 lines of the provided file<br>
By default&nbsp;<code>tail</code>&nbsp;will show the last 10 lines of the file</td>
<td class="column-4" rowspan="2"><a title="man page of tail" href="https://man7.org/linux/man-pages/man1/tail.1.html" target="_blank" rel="noopener noreferrer">man page for tail</a></td>
</tr>
<tr class="row-11 odd">
<td class="column-2"><code><strong># tail -f /var/log/messages</strong></code></td>
<td class="column-3">To continuously monitor the incoming log messages into&nbsp;<code>/var/log/messages</code>&nbsp;file in runtime</td>
</tr>
<tr class="row-12 even">
<td class="column-1">sort</td>
<td class="column-2"><code><strong># sort FILENAME</strong></code></td>
<td class="column-3">Displays a File in Order<br>
The sort utility displays the contents of a file in order by lines<br>
It does not change the original file.<br>
The&nbsp;<code>–u</code>&nbsp;option generates a sorted list in which each line is unique (no duplicates).<br>
The&nbsp;<code>–n</code>&nbsp;option puts a list of numbers in numerical order.</td>
<td class="column-4"><a title="man page of sort" href="https://man7.org/linux/man-pages/man1/sort.1.html" target="_blank" rel="noopener noreferrer">man page for sort</a></td>
</tr>
<tr class="row-13 odd">
<td class="column-1">uniq</td>
<td class="column-2"><code><strong># uniq FILENAME</strong></code></td>
<td class="column-3">The&nbsp;<code>uniq</code>&nbsp;(unique) utility displays a file, skipping adjacent duplicate lines; it does not change the original file.<br>
If a file contains a list of names and has two successive entries for the same person,&nbsp;<code>uniq</code>&nbsp;skips the extra line</td>
<td class="column-4"><a title="man page of uniq" href="https://man7.org/linux/man-pages/man1/uniq.1.html" target="_blank" rel="noopener noreferrer">man page for uniq</a></td>
</tr>
<tr class="row-14 even">
<td class="column-1" rowspan="2">file</td>
<td class="column-2"><code><strong># file FILENAME</strong></code></td>
<td class="column-3">Identifies the Contents of a File<br>
You can use the&nbsp;<code>file</code>&nbsp;utility to learn about the contents of any file on a Linux system without having to open and examine the file yourself.</td>
<td class="column-4" rowspan="2"><a title="man page of file" href="https://linux.die.net/man/1/file" target="_blank" rel="noopener noreferrer">man page for file</a></td>
</tr>
<tr class="row-15 odd">
<td class="column-2"><code><strong># file dataFile.txt</strong><br>
dataFile.txt: ASCII text</code></td>
<td class="column-3"><code>file</code>&nbsp;command identified the&nbsp;<code>dataFile.txt</code>&nbsp;type as ASCII text</td>
</tr>
<tr class="row-16 even">
<td class="column-1" rowspan="2">cp</td>
<td class="column-2"><code><strong># cp SOURCE-FILE DESTINATION-FILE</strong></code></td>
<td class="column-3">The&nbsp;<code>cp</code>&nbsp;(copy) utility makes a copy of a file.<br>
The&nbsp;<code>SOURCE-FILE</code>&nbsp;is the name of the file that&nbsp;<code>cp</code>&nbsp;will copy.<br>
The&nbsp;<code>DESTINATION-FILE</code>&nbsp;is the name&nbsp;<code>cp</code>&nbsp;assigns to the resulting (new) copy of the file.<br>
If the&nbsp;<code>DESTINATION-FILE</code>&nbsp;exists before you give a&nbsp;<code>cp</code>&nbsp;command,&nbsp;<code>cp</code>&nbsp;overwrites it.</td>
<td class="column-4" rowspan="2"><a title="man page of cp" href="https://man7.org/linux/man-pages/man1/cp.1.html" target="_blank" rel="noopener noreferrer">man page for cp</a></td>
</tr>
<tr class="row-17 odd">
<td class="column-2"><code><strong># cp /root/myfile /tmp/dir1/</strong></code></td>
<td class="column-3">This command copied&nbsp;<code>myfile</code>&nbsp;from&nbsp;<code>/root</code>&nbsp;to&nbsp;<code>/tmp/dir1</code>&nbsp;directory</td>
</tr>
<tr class="row-18 even">
<td class="column-1" rowspan="2">mv</td>
<td class="column-2"><code><strong># mv EXISTING-FILENAME NEW-FILENAME</strong></code></td>
<td class="column-3">Changes the Name of a File<br>
The&nbsp;<code>mv</code>&nbsp;(move) utility can rename a file without making a copy of it. The&nbsp;<code>mv</code>&nbsp;command line specifies an existing file and a new filename using the same syntax as&nbsp;<code>cp</code></td>
<td class="column-4" rowspan="2"><a title="man page of mv" href="https://linux.die.net/man/1/mv" target="_blank" rel="noopener noreferrer">man page for mv</a></td>
</tr>
<tr class="row-19 odd">
<td class="column-2"><code><strong># mv /root/debug.log /tmp/new_debug.log</strong></code></td>
<td class="column-3">In this example we rename the name of&nbsp;<code>debug.log</code>&nbsp;file to&nbsp;<code>new_debug.log</code>&nbsp;and also changed the location of the file from&nbsp;<code>/root/</code>&nbsp;to&nbsp;<code>/tmp</code></td>
</tr>
<tr class="row-20 even">
<td class="column-1" rowspan="2">grep</td>
<td class="column-2"><code><strong># grep STRING FILENAME</strong></code></td>
<td class="column-3">The&nbsp;<code>grep</code>&nbsp;utility searches through one or more files to see whether any contain a specified string of characters.<br>
This utility does not change the file it searches but simply displays each line that contains the string.</td>
<td class="column-4" rowspan="2"><a title="man page for grep" href="http://linuxcommand.org/lc3_man_pages/grep1.html" target="_blank" rel="noopener noreferrer">man page for grep</a></td>
</tr>
<tr class="row-21 odd">
<td class="column-2"><code><strong># grep ssh /etc/services</strong></code></td>
<td class="column-3">In this example we search for all the lines containing "ssh" in&nbsp;<code>/etc/services</code>&nbsp;file</td>
</tr>
<tr class="row-22 even">
<td class="column-1">mkdir</td>
<td class="column-2"><code><strong># mkdir DIR</strong></code></td>
<td class="column-3">Create directories</td>
<td class="column-4"><a title="man page for mkdir" href="https://linux.die.net/man/2/mkdir" target="_blank" rel="noopener noreferrer">man page for mkdir</a></td>
</tr>
<tr class="row-23 odd">
<td class="column-1">touch</td>
<td class="column-2"><code><strong># touch FILE</strong></code></td>
<td class="column-3">Create empty file</td>
<td class="column-4"><a title="man page for touch" href="https://man7.org/linux/man-pages/man1/touch.1.html" target="_blank" rel="noopener noreferrer">man page for touch</a></td>
</tr>
<tr class="row-24 even">
<td class="column-1">pwd</td>
<td class="column-2"><code><strong># pwd</strong></code></td>
<td class="column-3">present working directory</td>
<td class="column-4"><a title="man page for pwd" href="https://www.man7.org/linux/man-pages/man1/pwd.1.html" target="_blank" rel="noopener noreferrer">man page for pwd</a></td>
</tr>
</tbody>
</table>
</div>

### 2. Finding files and directories

*Most of the time we will end up using find command to find files and directories. But I also like which command as it gives is the path of the binary which is required at multiple events when we are required to execute a binary with complete PATH.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1" rowspan="2">which</td>
<td class="column-2"><code><strong># which PROGRAMNAME</strong></code></td>
<td class="column-3"><code>which</code>&nbsp;will print the full path of the provided&nbsp;<code>PROGRAMNAME</code>&nbsp;on&nbsp;<code>STDOUT</code><br>
It does this by searching for an executable or script in the directories listed in the environment variable&nbsp;<code>PATH</code>.</td>
<td class="column-4" rowspan="2"><a title="man page of which" href="https://linux.die.net/man/1/which" target="_blank" rel="noopener noreferrer">man page for which</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-2"><code><strong># which useradd</strong><br>
/usr/sbin/useradd</code></td>
<td class="column-3">In this example we are searching for the path of&nbsp;<code>useradd</code>&nbsp;command</td>
</tr>
<tr class="row-4 even">
<td class="column-1" rowspan="2">whereis</td>
<td class="column-2"><code><strong># whereis FILENAME</strong></code></td>
<td class="column-3"><code>whereis</code>&nbsp;attempts to locate the desired program in the standard Linux places, and in the places specified by&nbsp;<code>$PATH</code>&nbsp;and&nbsp;<code>$MANPATH</code></td>
<td class="column-4" rowspan="2"><a title="man page of whereis" href="https://linux.die.net/man/1/whereis" target="_blank" rel="noopener noreferrer">man page for whereis</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-2"><code><strong># whereis sshd</strong><br>
sshd: /usr/sbin/sshd /usr/share/man/man8/sshd.8.gz</code></td>
<td class="column-3">In this example we are searching for the path of&nbsp;<code>sshd</code>&nbsp;binary and the&nbsp;<code>man</code>&nbsp;page location for&nbsp;<code>sshd</code>&nbsp;file</td>
</tr>
<tr class="row-6 even">
<td class="column-1" rowspan="2">locate</td>
<td class="column-2"><code><strong># locate FILENAME</strong></code></td>
<td class="column-3">The&nbsp;<code>locate</code>&nbsp;utility (<code>locate</code>&nbsp;package; some distributions use&nbsp;<code>mlocate</code>) searches for files on the local system:<br>
Before you can use locate (<code>mlocate</code>), the&nbsp;<code>updatedb</code>&nbsp;utility must build or update the locate (<code>mlocate</code>) database. Typically the database is updated once a day by a cron script</td>
<td class="column-4" rowspan="2"><a title="man page of locate" href="https://man7.org/linux/man-pages/man1/locate.1.html" target="_blank" rel="noopener noreferrer">man page for locate</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-2"><code><strong># locate sshd</strong><br>
/etc/pam.d/sshd<br>
/etc/ssh/sshd_config<br>
/etc/sysconfig/sshd</code></td>
<td class="column-3">In this example we are searching for all files in your Linux server containing string&nbsp;<code>sshd</code>&nbsp;in their name</td>
</tr>
<tr class="row-8 even">
<td class="column-1" rowspan="2">find</td>
<td class="column-2"><code><strong># find PATH OPTIONS FILENAME</strong></code></td>
<td class="column-3"><code>find</code>&nbsp;command will search for file or directory based on the OPTIONS provided</td>
<td class="column-4" rowspan="2"><a title="10 find exec multiple commands examples in Linux/Unix" href="https://www.golinuxcloud.com/find-exec-multiple-commands-examples-unix/" target="_blank" rel="noopener noreferrer">find cmnd examples</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-2"><code><strong># find / -type f -name sshd</strong></code></td>
<td class="column-3">In this example we are searching for a file named&nbsp;<code>sshd</code>&nbsp;inside&nbsp;<code>/</code>&nbsp;location</td>
</tr>
</tbody>
</table>

### 3. Check User Information

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">who</td>
<td class="column-2"><code><strong># who -u</strong></code></td>
<td class="column-3">The&nbsp;<code>who</code>&nbsp;utility displays a list of users who are logged in on the local system.</td>
<td class="column-4"><a title="man page for who" href="https://man7.org/linux/man-pages/man1/who.1.html" target="_blank" rel="noopener noreferrer">man page for who</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">users</td>
<td class="column-2"><code><strong># users</strong></code></td>
<td class="column-3">Print the user names of users currently logged in to the current host<br>
It does not give much information apart from usernames</td>
<td class="column-4"><a title="man page for users" href="https://linux.die.net/man/1/users" target="_blank" rel="noopener noreferrer">man page for users</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1">last</td>
<td class="column-2"><code><strong># last -a</strong></code></td>
<td class="column-3">This command searches back through the file&nbsp;<code>/var/log/wtmp</code>&nbsp;(or the file designated by the -f flag) and displays a list of all users logged in (and out) since that file was created.</td>
<td class="column-4"><a title="man page for last" href="https://www.man7.org/linux/man-pages/man1/last.1.html" target="_blank" rel="noopener noreferrer">man page for last</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-1">finger</td>
<td class="column-2"><code><strong># finger</strong></code></td>
<td class="column-3">If no arguments are specified,&nbsp;<code>finger</code>&nbsp;will print an entry for each user currently logged into the system.</td>
<td class="column-4"><a title="man page of finger" href="https://linux.die.net/man/1/finger" target="_blank" rel="noopener noreferrer">man page for finger</a></td>
</tr>
<tr class="row-6 even">
<td class="column-1">whoami</td>
<td class="column-2"><code><strong># whoami</strong></code></td>
<td class="column-3">Print the user name associated with the current effective user ID</td>
<td class="column-4"><a title="man page for whoami" href="https://man7.org/linux/man-pages/man1/whoami.1.html" target="_blank" rel="noopener noreferrer">man page of whoami</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-1">id</td>
<td class="column-2"><code><strong># id</strong></code></td>
<td class="column-3">Print real and effective user and group IDs</td>
<td class="column-4"><a title="man page for id" href="https://man7.org/linux/man-pages/man1/id.1.html" target="_blank" rel="noopener noreferrer">man page for id</a></td>
</tr>
<tr class="row-8 even">
<td class="column-1">w</td>
<td class="column-2"><code><strong># w</strong></code></td>
<td class="column-3">The first line the&nbsp;<code>w</code>&nbsp;utility displays is the same as the output of&nbsp;<code>uptime</code>&nbsp;command. Following that line, w displays a list of the users who are logged in.</td>
<td class="column-4"></td>
</tr>
</tbody>
</table>

### 4. Check System Information

*As a sytem and Linux administrator you must be familiar with these commands. These will help you determine the type of server you are working on, such as load, cpu model, hardware model, hardware type etc. Some of the commands may be distribution specific such as hwinfo is only available in SuSE Linux while others are expected to be found on almost all distros.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">uptime</td>
<td class="column-2"><code><strong># uptime</strong></code></td>
<td class="column-3">The&nbsp;<code>uptime</code>&nbsp;utility displays a single line that includes the time of day, the period of time the computer has been running (in days, hours, and minutes), the number of users logged in, and the load average (how busy the system is). The three load average numbers represent the number of jobs waiting to run, averaged over the past 1, 5, and 15 minutes.</td>
<td class="column-4"><a title="man page of uptime" href="https://man7.org/linux/man-pages/man1/uptime.1.html" target="_blank" rel="noopener noreferrer">man page for uptime</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">free</td>
<td class="column-2"><code><strong># free -m</strong></code></td>
<td class="column-3">The&nbsp;<code>free</code>&nbsp;utility displays the amount of physical (RAM) and swap memory in the local system. It displays columns for total, used, and free memory as well as for kernel buffers.</td>
<td class="column-4"><a title="Tutorial: Beginners guide on linux memory management" href="https://www.golinuxcloud.com/tutorial-linux-memory-management-overview/" target="_blank" rel="noopener noreferrer">Linux Memory Management</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1">dmidecode</td>
<td class="column-2"><code><strong># dmidecode -t system</strong></code></td>
<td class="column-3"><code>dmidecode</code>&nbsp;is a tool for dumping a computer's DMI (some say SMBIOS) table contents in a human-readable format. This table contains a description of the system's hardware components, as well as other useful pieces of information such as serial numbers and BIOS revision</td>
<td class="column-4"><a title="man page of dmidecode" href="https://linux.die.net/man/8/dmidecode" target="_blank" rel="noopener noreferrer">man page for dmidecode</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-1">lshw</td>
<td class="column-2"><code><strong># lshw</strong></code></td>
<td class="column-3"><code>lshw</code>&nbsp;is a small tool to extract detailed information on the hardware configuration of the machine. It can report exact memory configuration, firmware version, mainboard configuration, CPU version and speed, cache configuration, bus speed, etc</td>
<td class="column-4"><a title="man page of lshw" href="https://linux.die.net/man/1/lshw" target="_blank" rel="noopener noreferrer">man page for lshw</a></td>
</tr>
<tr class="row-6 even">
<td class="column-1">hwinfo</td>
<td class="column-2"><code><strong># hwinfo</strong></code></td>
<td class="column-3"><code>hwinfo</code>&nbsp;is used to probe for the hardware present in the system. It can be used to generate a system overview log which can be later used for support. (available only with SuSE)</td>
<td class="column-4"><a title="man page of hwinfo" href="https://sarata.com/manpages/hwinfo.8.html" target="_blank" rel="noopener noreferrer">man page for hwinfo</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-1">lscpu</td>
<td class="column-2"><code><strong># lscpu</strong></code></td>
<td class="column-3"><code>lscpu</code>&nbsp;gathers CPU architecture information from sysfs,&nbsp;<code>/proc/cpuinfo</code>&nbsp;and any applicable architecture-specific libraries (e.g. librtas on Powerpc).</td>
<td class="column-4"><a title="man page of lscpu" href="https://linux.die.net/man/1/lscpu" target="_blank" rel="noopener noreferrer">man page for lscpu</a></td>
</tr>
<tr class="row-8 even">
<td class="column-1">lspci</td>
<td class="column-2"><code><strong># lspci</strong></code></td>
<td class="column-3"><code>lspci</code>&nbsp;is a utility for displaying information about PCI buses in the system and devices connected to them.</td>
<td class="column-4"><a title="man page of lspci" href="https://linux.die.net/man/8/lspci" target="_blank" rel="noopener noreferrer">man page for lspci</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-1">/proc/cpuinfo</td>
<td class="column-2"><code><strong># cat /proc/cpuinfo</strong></code></td>
<td class="column-3">Provides information about the CPU model, architecture, processors, available modules, and many more CPU related information.&nbsp;<code>lscpu</code>&nbsp;gathers information from this file,</td>
<td class="column-4"><a title="man page of lscpu" href="https://linux.die.net/man/1/lscpu" target="_blank" rel="noopener noreferrer">man page for lscpu</a></td>
</tr>
<tr class="row-10 even">
<td class="column-1">uname</td>
<td class="column-2"><code><strong># uname [OPTIONS]</strong></code></td>
<td class="column-3">Print system information</td>
<td class="column-4"><a title="man page for uname" href="https://linux.die.net/man/1/uname" target="_blank" rel="noopener noreferrer">man page for uname</a></td>
</tr>
</tbody>
</table>

### 5. Manage System Processes

*These Linux commands will help you manage the Linux processes, and will help you troubleshoot any server resource related issues. You can use these commands to monitor your server's resource such as Memory, CPU, disk IO etc.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">ps</td>
<td class="column-2"><code><strong># ps [OPTIONS]</strong></code></td>
<td class="column-3"><code>ps</code>&nbsp;displays information about a selection of the active processes. If you want a repetitive update of the selection and the displayed information, use&nbsp;<code>top</code>&nbsp;instead.</td>
<td class="column-4"><a title="man page for ps" href="https://www.man7.org/linux/man-pages/man1/ps.1.html" target="_blank" rel="noopener noreferrer">man page for ps</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">nice</td>
<td class="column-2"><code><strong># nice [OPTIONS]</strong></code></td>
<td class="column-3">Run COMMAND with an adjusted niceness, which affects process scheduling. With no COMMAND, print the current niceness. Niceness values range from -20 (most favorable to the process) to 19 (least favorable to the process).</td>
<td class="column-4"><a title="nice example" href="https://www.golinuxhub.com/2014/11/what-is-nice-and-how-to-change-priority.html" target="_blank" rel="noopener noreferrer">nice example</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1" rowspan="2">renice</td>
<td class="column-2"><code><strong># renice [OPTIONS] PID</strong></code></td>
<td class="column-3"><code>renice</code>&nbsp;alters the scheduling priority of one or more running processes. The first argument is the priority value to be used. The other arguments are interpreted as process IDs (by default), process group IDs, user IDs, or user names.</td>
<td class="column-4" rowspan="2"><a title="renice example" href="https://www.golinuxhub.com/2014/11/what-is-nice-and-how-to-change-priority.html" target="_blank" rel="noopener noreferrer">renice example</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-2"><code><strong># renice -n 15 1121</strong><br>
1121 (process ID) old priority 0, new priority 15</code></td>
<td class="column-3">In this example I have changed the nice value of PID 1121 from 0 to 15</td>
</tr>
<tr class="row-6 even">
<td class="column-1">top</td>
<td class="column-2"><code><strong># top</strong></code></td>
<td class="column-3">The&nbsp;<code>top</code>&nbsp;program provides a dynamic real-time view of a running system. It can display system summary information as well as a list of processes or threads currently being managed by the Linux kernel.</td>
<td class="column-4"><a title="top examples" href="https://www.golinuxcloud.com/check-top-memory-cpu-consuming-process-script/" target="_blank" rel="noopener noreferrer">top examples</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-1">pgrep</td>
<td class="column-2"><code><strong># pgrep [OPTIONS] PATTERN</strong></code></td>
<td class="column-3"><code>pgrep</code>&nbsp;looks through the currently running processes and lists the process IDs which match the selection criteria to stdout.</td>
<td class="column-4"><a title="man page for pgrep" href="https://linux.die.net/man/1/pgrep" target="_blank" rel="noopener noreferrer">man page for pgrep</a></td>
</tr>
<tr class="row-8 even">
<td class="column-1">pkill</td>
<td class="column-2"><code><strong># pkill [OPTIONS] PATTERN</strong></code></td>
<td class="column-3"><code>pkill</code>&nbsp;will send the specified signal (by default SIGTERM) to each process instead of listing them on stdout.</td>
<td class="column-4"><a title="man page for pkill" href="https://linux.die.net/man/1/pkill" target="_blank" rel="noopener noreferrer">man page for pkill</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-1">kill</td>
<td class="column-2"><code><strong># kill [OPTIONS] PID</strong></code></td>
<td class="column-3">The command&nbsp;<code>kill</code>&nbsp;sends the specified signal to the specified processes or process groups.</td>
<td class="column-4"><a title="man page for kill" href="https://man7.org/linux/man-pages/man2/kill.2.html" target="_blank" rel="noopener noreferrer">man page for kill</a></td>
</tr>
<tr class="row-10 even">
<td class="column-1">sar</td>
<td class="column-2"><code><strong># sar [OPTIONS]</strong></code></td>
<td class="column-3">The&nbsp;<code>sar</code>&nbsp;command writes to standard output the contents of selected cumulative activity counters in the operating system. The accounting system, based on the values in the count and interval parameters, writes information the specified number of times spaced at the specified intervals in seconds. If the interval parameter is set to zero, the&nbsp;<code>sar</code>&nbsp;command displays the average statistics for the time since the system was started.</td>
<td class="column-4"><a title="sar examples" href="https://www.golinuxhub.com/2014/02/tutorial-for-monitoring-tools-sar-and.html" target="_blank" rel="noopener noreferrer">sar examples</a></td>
</tr>
<tr class="row-11 odd">
<td class="column-1">vmstat</td>
<td class="column-2"><code><strong># vmstat [OPTIONS]</strong></code></td>
<td class="column-3"><code>vmstat</code>&nbsp;reports information about processes, memory, paging, block IO, traps, disks and cpu activity.</td>
<td class="column-4"><a title="man page for vmstat" href="https://www.man7.org/linux/man-pages/man8/vmstat.8.html" target="_blank" rel="noopener noreferrer">man page for vmstat</a></td>
</tr>
<tr class="row-12 even">
<td class="column-1">iostat</td>
<td class="column-2"><code><strong># iostat [OPTIONS]</strong></code></td>
<td class="column-3">The&nbsp;<code>iostat</code>&nbsp;command is used for monitoring system input/output device loading by observing the time the devices are active in relation to their average transfer rates.</td>
<td class="column-4"><a title="man page for iostat" href="https://linux.die.net/man/1/iostat" target="_blank" rel="noopener noreferrer">man page for iostat</a></td>
</tr>
<tr class="row-13 odd">
<td class="column-1">crond</td>
<td class="column-2"><code><strong># crond [OPTIONS]</strong></code></td>
<td class="column-3"><code>crond</code>&nbsp;daemon is used to execute scheduled commands. You can create new job using&nbsp;<code>crontab -e</code>&nbsp;and provide the time when the script should be executed and the script path</td>
<td class="column-4"><a title="crond examples" href="https://www.golinuxcloud.com/create-schedule-cron-job-shell-script-linux/" target="_blank" rel="noopener noreferrer">crond examples</a></td>
</tr>
</tbody>
</table>

### 6. Managing Users and Groups

*These are some of the basic Linux commands to perform user management such as create, modify, delete user or groups.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">useradd</td>
<td class="column-2"><code><strong># useradd USERNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>useradd</code>&nbsp;command creates a new user account using the values specified on the command line plus the default values from the system. Depending on command line options, the&nbsp;<code>useradd</code>&nbsp;command will update system files and may also create the new user's home directory and copy initial files.</td>
<td class="column-4"><a title="useradd examples" href="https://www.golinuxhub.com/2014/04/10-practical-examples-to-use-useradd.html" target="_blank" rel="noopener noreferrer">useradd examples</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1" rowspan="2">usermod</td>
<td class="column-2"><code><strong># usermod OPTIONS USERNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>usermod</code>&nbsp;command modifies the system account files to reflect the changes that are specified on the command line.</td>
<td class="column-4" rowspan="2"><a title="man page of usermod" href="https://linux.die.net/man/8/usermod" target="_blank" rel="noopener noreferrer">man page of usermod</a></td>
</tr>
<tr class="row-4 even">
<td class="column-2"><code><strong># usermod -G admin deepak</strong></code></td>
<td class="column-3">In this example I am adding additional group to my existing&nbsp;<code>deepak</code>&nbsp;user</td>
</tr>
<tr class="row-5 odd">
<td class="column-1">userdel</td>
<td class="column-2"><code><strong># userdel USERNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>userdel</code>&nbsp;command modifies the system account files, deleting all entries that refer to the user name&nbsp;<code>USERNAME</code>. The named user must exist</td>
<td class="column-4"><a title="man page for userdel" href="https://linux.die.net/man/8/userdel" target="_blank" rel="noopener noreferrer">man page for userdel</a></td>
</tr>
<tr class="row-6 even">
<td class="column-1">passwd</td>
<td class="column-2"><code><strong># passwd USERNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>passwd</code>&nbsp;utility is used to update user's authentication token(s).<br>
You can lock, unlock, assign passwords using&nbsp;<code>passwd</code>&nbsp;utility for any system user</td>
<td class="column-4"><a title="passwd examples" href="https://www.golinuxhub.com/2014/08/how-to-check-lock-status-of-any-user.html" target="_blank" rel="noopener noreferrer">passwd examples</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-1">groupadd</td>
<td class="column-2"><code><strong># groupadd GROUPNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>groupadd</code>&nbsp;command creates a new group account using the values specified on the command line plus the default values from the system. The new group will be entered into the system files as needed</td>
<td class="column-4"><a title="add or remove user from group" href="https://www.golinuxcloud.com/linux-add-or-remove-user-from-group/" target="_blank" rel="noopener noreferrer">add or remove user from group</a></td>
</tr>
<tr class="row-8 even">
<td class="column-1">groupdel</td>
<td class="column-2"><code><strong># groupdel GROUPNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>groupdel</code>&nbsp;command modifies the system account files, deleting all entries that refer to&nbsp;<code>GROUPNAME</code>. The named group must exist.</td>
<td class="column-4"><a title="add or remove user from group" href="https://www.golinuxcloud.com/linux-add-or-remove-user-from-group/" target="_blank" rel="noopener noreferrer">add or remove user from group</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-1" rowspan="2">groupmod</td>
<td class="column-2"><code><strong># groupmod [options] GROUPNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>groupmod</code>&nbsp;command modifies the definition of the specified&nbsp;<code>GROUP</code>&nbsp;by modifying the appropriate entry in the group database.</td>
<td class="column-4" rowspan="2"><a title="add or remove user from group" href="https://www.golinuxcloud.com/linux-add-or-remove-user-from-group/" target="_blank" rel="noopener noreferrer">add or remove user from group</a></td>
</tr>
<tr class="row-10 even">
<td class="column-2"><code><strong># groupmod -n administrator admin</strong></code></td>
<td class="column-3">In this example I am renaming the group name from admin to administrator</td>
</tr>
<tr class="row-11 odd">
<td class="column-1" rowspan="2">sudo</td>
<td class="column-2"><code><strong>$ sudo OPTIONS COMMAND</strong></code></td>
<td class="column-3"><code>sudo</code>&nbsp;allows a permitted user to execute a command as the superuser or another user, as specified by the security policy.</td>
<td class="column-4" rowspan="2"><a title="How to add user to sudoers with best practices &amp; examples" href="https://www.golinuxcloud.com/add-user-to-sudoers/" target="_blank" rel="noopener noreferrer">Add sudo permisison</a></td>
</tr>
<tr class="row-12 even">
<td class="column-2"><code><strong>$ sudo systemctl network restart</strong></code></td>
<td class="column-3">Observe the&nbsp;<code>$</code>&nbsp;sign in the beginning of the shell, it donates a normal user shell. A root user's shell will have hash (<code>#</code>)<br>
So in this example a normal user is performing network restart using sudo privilege</td>
</tr>
</tbody>
</table>

### 7. Managing Permissions

*Linux permission is a very vast topic and here I have only covered the basic commands which we use to assign/modify/remove permissions to files and directories.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1" rowspan="2">chown</td>
<td class="column-2"><code><strong># chown OPTIONS USER:GROUP TARGET</strong></code></td>
<td class="column-3"><code>chown</code>&nbsp;changes the user and/or group ownership of each given file or directory<br>
<code>USER</code>&nbsp;represents the user owner of the target file<br>
<code>GROUP</code>&nbsp;represents the group owner of the target file<br>
<code>TARGET</code>&nbsp;represents any file or directory or PATH</td>
<td class="column-4" rowspan="2"><a title="man page for chown" href="https://man7.org/linux/man-pages/man2/chown.2.html" target="_blank" rel="noopener noreferrer">man page for chown</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-2"><code><strong># chown deepak:admin /tmp/file</strong></code></td>
<td class="column-3">In this example I am assigning user owner permission to&nbsp;<code>deepak</code>, group owner permission to admin group for&nbsp;<code>/tmp/file</code></td>
</tr>
<tr class="row-4 even">
<td class="column-1" rowspan="2">chmod</td>
<td class="column-2"><code><strong># chmod PERM PATH</strong></code></td>
<td class="column-3"><code>chmod</code>&nbsp;changes the file mode bits i.e.&nbsp;<code>PERM</code>&nbsp;of each given file according to mode, which can be either a symbolic representation of changes to make, or an octal number representing the bit pattern for the new mode bits</td>
<td class="column-4" rowspan="2"><a title="man page for chmod" href="https://linux.die.net/man/1/chmod" target="_blank" rel="noopener noreferrer">man page for chmod</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-2"><code><strong># chmod 755 /tmp/dir1</strong></code></td>
<td class="column-3">In this example I am changing permission of&nbsp;<code>/tmp/dir1</code>&nbsp;to 755 i.e. full permission for user, read+execute permission for group and other users</td>
</tr>
<tr class="row-6 even">
<td class="column-1" rowspan="2">chgrp</td>
<td class="column-2"><code><strong># chgrp GROUPNAME FILE</strong></code></td>
<td class="column-3">Change group ownership of files and directories<br>
<code>GROUPNAME</code>&nbsp;represents the group to be assigned for&nbsp;<code>FILE</code></td>
<td class="column-4" rowspan="2"><a title="man page for chgrp" href="https://linux.die.net/man/1/chgrp" target="_blank" rel="noopener noreferrer">man page for chgrp</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-2"><code><strong># chgrp admin /tmp/file</strong></code></td>
<td class="column-3">In this example we are changing the group ownership to admin group for&nbsp;<code>/tmp/file</code></td>
</tr>
<tr class="row-8 even">
<td class="column-1" rowspan="2">groups</td>
<td class="column-2"><code><strong># groups USERNAME</strong></code></td>
<td class="column-3">Print group memberships for each&nbsp;<code>USERNAME</code></td>
<td class="column-4" rowspan="2"><a title="man page for groups" href="https://man7.org/linux/man-pages/man1/groups.1.html" target="_blank" rel="noopener noreferrer">man page for groups</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-2"><code><strong># groups deepak</strong><br>
deepak : deepak admin</code></td>
<td class="column-3">In this example we are checking the list of group which user&nbsp;<code>deepak</code>&nbsp;is part of.</td>
</tr>
<tr class="row-10 even">
<td class="column-1" rowspan="2">newgrp</td>
<td class="column-2"><code><strong>$ newgrp GROUPNAME</strong></code></td>
<td class="column-3">The&nbsp;<code>newgrp</code>&nbsp;command is used to change the current group ID during a login session</td>
<td class="column-4" rowspan="2"><a title="man page for newgrp" href="https://man7.org/linux/man-pages/man1/newgrp.1p.html" target="_blank" rel="noopener noreferrer">man page for newgrp</a></td>
</tr>
<tr class="row-11 odd">
<td class="column-2"><code><strong>$ id</strong><br>
uid=1001(deepak) gid=1001(deepak) groups=1001(deepak),1003(admin)</code><p></p>
<p><strong>$ newgrp admin</strong></p>
<p><strong>$ id</strong><br>
uid=1001(deepak) gid=1003(admin) groups=1003(admin),1001(deepak)</p></td>
<td class="column-3">In this example we are changing the primary group of user&nbsp;<code>deepak</code>&nbsp;to admin group</td>
</tr>
<tr class="row-12 even">
<td class="column-1" rowspan="2">setfacl</td>
<td class="column-2"><code><strong># setfacl OPTIONS FILE</strong></code></td>
<td class="column-3">This utility sets Access Control Lists (ACLs) of files and directories.<br>
It is useful to give individual permission to users and groups as&nbsp;<code>chmod</code>&nbsp;assigns permission of file level but here we have more control over each user permission</td>
<td class="column-4" rowspan="2"><a title="setfacl examples" href="https://www.golinuxhub.com/2012/10/give-individual-permission-on/" target="_blank" rel="noopener noreferrer">setfacl examples</a></td>
</tr>
<tr class="row-13 odd">
<td class="column-2"><code><strong># setfacl -m u:deepak:rx /tmp/file</strong></code></td>
<td class="column-3">In this example I am giving read and execute permission for user&nbsp;<code>deepak</code>&nbsp;for&nbsp;<code>/tmp/file</code></td>
</tr>
<tr class="row-14 even">
<td class="column-1" rowspan="2">getfacl</td>
<td class="column-2"><code><strong># getfacl FILE</strong></code></td>
<td class="column-3">For each file,&nbsp;<code>getfacl</code>&nbsp;displays the file name, owner, the group, and the Access Control List (ACL). If a directory has a default ACL,&nbsp;<code>getfacl</code>&nbsp;also displays the default ACL</td>
<td class="column-4" rowspan="2"><a title="getfacl examples" href="https://www.golinuxhub.com/2012/10/give-individual-permission-on/" target="_blank" rel="noopener noreferrer">getfacl examples</a></td>
</tr>
<tr class="row-15 odd">
<td class="column-2"><code><strong># getfacl /tmp/file</strong><br>
getfacl: Removing leading '/' from absolute path names<br>
# file: tmp/file<br>
# owner: root<br>
# group: admin<br>
user::rw-<br>
user:deepak:r-x<br>
group::r--<br>
mask::r-x<br>
other::r--</code></td>
<td class="column-3">In this example I am collecting the acl permission list from&nbsp;<code>/tmp/file</code><br>
It has the permission detail which we applied earlier with&nbsp;<code>setfacl</code></td>
</tr>
<tr class="row-16 even">
<td class="column-1" rowspan="2">chattr</td>
<td class="column-2"><code><strong># chattr OPTIONS FILE</strong></code></td>
<td class="column-3"><code>chattr</code>&nbsp;changes the file attributes on a Linux file system</td>
<td class="column-4" rowspan="2"><a title="chattr examples" href="https://www.golinuxhub.com/2012/10/increase-security-with-extended-file/" target="_blank" rel="noopener noreferrer">chattr examples</a></td>
</tr>
<tr class="row-17 odd">
<td class="column-2"><code><strong># chattr +i /tmp/file</strong></code></td>
<td class="column-3">In this example we have restricted the modification permission on&nbsp;<code>/tmp/file</code>. Now not even root user can modify the content of&nbsp;<code>/tmp/file</code><br>
To remove this permission use chattr -i /tmp/file</td>
</tr>
<tr class="row-18 even">
<td class="column-1" rowspan="2">lsattr</td>
<td class="column-2"><code><strong># lsattr FILE</strong></code></td>
<td class="column-3">list file attributes on a Linux second extended file system. By default ls command will not show the permission attributes applied by&nbsp;<code>chattr</code>&nbsp;so we must use&nbsp;<code>lsattr</code>&nbsp;to get these details</td>
<td class="column-4" rowspan="2"><a title="lsattr examples" href="https://www.golinuxhub.com/2012/10/increase-security-with-extended-file/" target="_blank" rel="noopener noreferrer">lsattr examples</a></td>
</tr>
<tr class="row-19 odd">
<td class="column-2"><code><strong># lsattr /tmp/file</strong><br>
----i---------e---- /tmp/file</code></td>
<td class="column-3">In this example we can see the "i" attribute which we added with&nbsp;<code>chattr</code>&nbsp;in the previous example<br>
The 'e' attribute indicates that the file is using extents for mapping the blocks on disk. It may not be removed using&nbsp;<code>chattr</code></td>
</tr>
</tbody>
</table>

### 8. Configure and Troubleshoot Network

*This section will help Network engineers who are new to Linux environment. I have tried to place the most used commands for network troubleshooting, we also have tcpdump, iperf, netperf and many other networking tools which are used for troubleshooting network related issues but they can get complicated hence those are not mentioned in this list.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">ifconfig</td>
<td class="column-2"><code><strong># ifconfig</strong></code></td>
<td class="column-3">This program is&nbsp;<strong>obsolete</strong>! For replacement check&nbsp;<code>ip addr</code>&nbsp;and&nbsp;<code>ip link</code>. For statistics use&nbsp;<code>ip -s link</code>.<br>
If no arguments are given,&nbsp;<code>ifconfig</code>&nbsp;displays the status of the currently active interfaces. If a single interface argument is given, it displays the status of the given interface only;</td>
<td class="column-4"><a title="man page for ifconfig" href="https://linux.die.net/man/8/ifconfig" target="_blank" rel="noopener noreferrer">man page for ifconfig</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1" rowspan="2">ip</td>
<td class="column-2"><code><strong># ip [OPTIONS]</strong></code></td>
<td class="column-3">Newer command to monitor and set IP address and other network card–related information</td>
<td class="column-4" rowspan="2"><a title="16 Linux ip command examples to configure network interfaces (cheatsheet)" href="https://www.golinuxcloud.com/linux-ip-command/" target="_blank" rel="noopener noreferrer">ip examples</a></td>
</tr>
<tr class="row-4 even">
<td class="column-2"><code><strong># ip link show</strong></code></td>
<td class="column-3">This example lists the available network device on the Linux server along with their Link status</td>
</tr>
<tr class="row-5 odd">
<td class="column-1">route</td>
<td class="column-2"><code><strong># route [OPTIONS]</strong></code></td>
<td class="column-3">This program is&nbsp;<strong>obsolete</strong>. For replacement check&nbsp;<code>ip route</code>.</td>
<td class="column-4"><a title="16 Linux ip command examples to configure network interfaces (cheatsheet)" href="https://www.golinuxcloud.com/linux-ip-command/" target="_blank" rel="noopener noreferrer">ip route examples</a></td>
</tr>
<tr class="row-6 even">
<td class="column-1" rowspan="2">ip route</td>
<td class="column-2"><code><strong># ip route [OPTIONS]</strong></code></td>
<td class="column-3">Manipulate route entries in the kernel routing tables keep information about paths to other networked nodes.</td>
<td class="column-4" rowspan="2"><a title="16 Linux ip command examples to configure network interfaces (cheatsheet)" href="https://www.golinuxcloud.com/linux-ip-command/" target="_blank" rel="noopener noreferrer">ip route examples</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-2"><code><strong># ip route show</strong></code></td>
<td class="column-3">In this example we are printing the configured routes on the Linux server from the routing table</td>
</tr>
<tr class="row-8 even">
<td class="column-1" rowspan="2">ethtool</td>
<td class="column-2"><code><strong># ethtool [OPTIONS] DEVICE</strong></code></td>
<td class="column-3">query or control network driver and hardware settings</td>
<td class="column-4" rowspan="2"><a title="man page for ethtool" href="https://man7.org/linux/man-pages/man8/ethtool.8.html" target="_blank" rel="noopener noreferrer">man page for ethtool</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-2"><code><strong># ethtool -i eth0</strong></code></td>
<td class="column-3">In this example we are printing the interface details for&nbsp;<code>eth0</code>. The&nbsp;<a title="How to disable consistent network device naming in Linux" href="https://www.golinuxhub.com/2017/09/how-to-disable-consistent-network/" target="_blank" rel="noopener noreferrer">interface name</a>&nbsp;may vary based on the environment and configuration.</td>
</tr>
<tr class="row-10 even">
<td class="column-1" rowspan="2">ping</td>
<td class="column-2"><code><strong># ping OPTIONS DESTINATION</strong></code></td>
<td class="column-3"><code>ping</code>&nbsp;is used to check the connectivity of remote computers</td>
<td class="column-4" rowspan="2"><a title="man page for ping" href="https://linux.die.net/man/8/ping" target="_blank" rel="noopener noreferrer">man page for ping</a></td>
</tr>
<tr class="row-11 odd">
<td class="column-2"><code><strong># ping 192.168.0.100</strong></code></td>
<td class="column-3">In this example we are testing the connectivity between localhost and&nbsp;<code>192.168.0.100</code>&nbsp;server</td>
</tr>
<tr class="row-12 even">
<td class="column-1" rowspan="2">traceroute</td>
<td class="column-2"><code><strong># traceroute HOST</strong></code></td>
<td class="column-3">Utility that helps you analyzing reachability of hosts on the network.<br>
In most cases it is possible that due to firewall you may not get the list of hops towards the destination</td>
<td class="column-4" rowspan="2"><a title="man page for traceroute" href="https://linux.die.net/man/8/traceroute" target="_blank" rel="noopener noreferrer">man page for traceroute</a></td>
</tr>
<tr class="row-13 odd">
<td class="column-2"><code><strong># traceroute 192.168.0.100</strong></code></td>
<td class="column-3">In this example we are checking the route used to connect&nbsp;<code>192.168.0.100</code></td>
</tr>
<tr class="row-14 even">
<td class="column-1">nmap</td>
<td class="column-2"><code><strong># nmap OPTIONS HOST</strong></code></td>
<td class="column-3">Utility that helps you check which services are offered by an other host<br>
It is used to check the list of open ports on destination server</td>
<td class="column-4"><a title="man page for nmap" href="https://linux.die.net/man/1/nmap" target="_blank" rel="noopener noreferrer">man page for nmap</a></td>
</tr>
<tr class="row-15 odd">
<td class="column-1" rowspan="2">netstat</td>
<td class="column-2"><code><strong># netstat [OPTIONS]</strong></code></td>
<td class="column-3">Utility that helps you find out which services are offered by the local host<br>
It will give you a list of ports which are used by different system services and any service from the network</td>
<td class="column-4" rowspan="2"><a title="man page for netstat" href="https://man7.org/linux/man-pages/man8/netstat.8.html" target="_blank" rel="noopener noreferrer">man page for netstat</a></td>
</tr>
<tr class="row-16 even">
<td class="column-2"><code><strong># netstat -tunlp</strong></code></td>
<td class="column-3">In this example I am listing the listening TCP and UDP protocols on my Linux server</td>
</tr>
<tr class="row-17 odd">
<td class="column-1">nmcli</td>
<td class="column-2"><code><strong># nmcli [OPTIONS]</strong></code></td>
<td class="column-3"><code>nmcli</code>&nbsp;is a command-line tool for controlling NetworkManager and reporting network status.</td>
<td class="column-4"><a title="27 nmcli command examples (cheatsheet), compare nm-settings with if-cfg file" href="https://www.golinuxcloud.com/nmcli-command-examples-cheatsheet-centos-rhel/" target="_blank" rel="noopener noreferrer">nmcli examples</a></td>
</tr>
<tr class="row-18 even">
<td class="column-1">nmtui</td>
<td class="column-2"><code><strong># nmtui</strong></code></td>
<td class="column-3"><code>nmtui</code>&nbsp;is a curses‐based TUI application for interacting with NetworkManager<br>
It is a graphical alternative to nmcli</td>
<td class="column-4"><a title="How to configure bridged network in virt-manager (CentOS / RHEL 7)" href="https://www.golinuxcloud.com/how-to-configure-network-bridge-nmtui-linux/" target="_blank" rel="noopener noreferrer">nmtui examples</a></td>
</tr>
<tr class="row-19 odd">
<td class="column-1">ss</td>
<td class="column-2"><code><strong># ss [OPTIONS]</strong></code></td>
<td class="column-3"><code>ss&nbsp;</code>is used to dump socket statistics. It allows showing information similar to&nbsp;<code>netstat</code>. It can display more TCP and state information than other tools.<br>
When no option is used ss displays a list of open non-listening sockets (e.g. TCP/UNIX/UDP) that have established connection</td>
<td class="column-4"><a title="man page for ss" href="https://man7.org/linux/man-pages/man8/ss.8.html" target="_blank" rel="noopener noreferrer">man page for ss</a></td>
</tr>
</tbody>
</table>

### 9. Managing Partitions and Logical Volumes.

*One of the primary roles of system administrator would be to configure partitions, storage layouts in the Linux server. Here you can get the list of most used Linux commands for managing partitions and file systems.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">df</td>
<td class="column-2"><code><strong># df [OPTIONS]</strong></code></td>
<td class="column-3">Report file system disk space usage<br>
If no file name is given, the space available on all currently mounted file systems is shown</td>
<td class="column-4"><a title="man page for df" href="http://linuxcommand.org/lc3_man_pages/df1.html" target="_blank" rel="noopener noreferrer">man page for df</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">fdisk</td>
<td class="column-2"><code><strong># fdisk [OPTIONS] DEVICE</strong></code></td>
<td class="column-3"><code>fdisk</code>&nbsp;is interactive program for creation and manipulation of partition tables. It understands GPT, MBR, Sun, SGI and BSD partition tables</td>
<td class="column-4"><a title="Create partition using fdisk command" href="https://www.golinuxcloud.com/configure-software-linear-raid-linux/#Partitioning_with_fdisk" target="_blank" rel="noopener noreferrer">fdisk example</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1">cfdisk</td>
<td class="column-2"><code><strong># cfdisk [OPTIONS] DEVICE</strong></code></td>
<td class="column-3">Display or manipulate a disk partition table</td>
<td class="column-4"><a title="man page for cfdisk" href="https://linux.die.net/man/8/cfdisk" target="_blank" rel="noopener noreferrer">man page for cfdisk</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-1">parted</td>
<td class="column-2"><code><strong># parted</strong></code></td>
<td class="column-3"><code>parted</code>&nbsp;is a program to manipulate disk partitions. It supports multiple partition table formats, including MS-DOS and GPT.</td>
<td class="column-4"><a title="Modify filesystem using parted command" href="https://www.golinuxcloud.com/extend-resize-primary-partition-non-lvm-linux/#Method_1_Change_size_of_partition_using_parted_CLI_utility" target="_blank" rel="noopener noreferrer">parted example</a></td>
</tr>
<tr class="row-6 even">
<td class="column-1" rowspan="2">pvcreate</td>
<td class="column-2"><code><strong># pvcreate [OPTIONS] DEVICE</strong></code></td>
<td class="column-3">Create LVM Physical Volume</td>
<td class="column-4" rowspan="2"><a title="Create Physical Volume" href="https://www.golinuxcloud.com/recover-lvm2-partition-restore-vg-pv-metadata/#Create_Physical_Volume" target="_blank" rel="noopener noreferrer">pvcreate example</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-2"><code><strong># pvcreate /dev/sda</strong></code></td>
<td class="column-3">In this example we are creating a physical volume using&nbsp;<code>/dev/sda</code>&nbsp;device</td>
</tr>
<tr class="row-8 even">
<td class="column-1">pvdisplay</td>
<td class="column-2"><code><strong># pvdisplay DEVICE</strong></code></td>
<td class="column-3">It shows the attributes of PVs, like size, physical extent size, space used for the VG descriptor area, etc</td>
<td class="column-4"><a title="man page for pvdisplay" href="https://man7.org/linux/man-pages/man8/pvdisplay.8.html" target="_blank" rel="noopener noreferrer">man page for pvdisplay</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-1">pvs</td>
<td class="column-2"><code><strong># pvs</strong></code></td>
<td class="column-3">Display information about physical volumes<br>
This can be used as an alternative to&nbsp;<code>pvdisplay</code>&nbsp;to display limited information of available physical volumes</td>
<td class="column-4"><a title="man page for pvs" href="https://man7.org/linux/man-pages/man8/pvs.8.html" target="_blank" rel="noopener noreferrer">man page for pvs</a></td>
</tr>
<tr class="row-10 even">
<td class="column-1" rowspan="2">vgcreate</td>
<td class="column-2"><code><strong># vgcreate [OPTIONS]</strong></code></td>
<td class="column-3">It creates a new Volume Group on block devices (physical volume)</td>
<td class="column-4" rowspan="2"><a title="Create Volume Group" href="https://www.golinuxcloud.com/recover-lvm2-partition-restore-vg-pv-metadata/#Create_Volume_Group" target="_blank" rel="noopener noreferrer">vgcreate example</a></td>
</tr>
<tr class="row-11 odd">
<td class="column-2"><code><strong># vgcreate test_vg /dev/sda</strong></code></td>
<td class="column-3">In this example we are create a new volume group "test_vg" by adding&nbsp;<code>/dev/sda</code><br>
Here&nbsp;<code>/dev/sda</code>&nbsp;is a new physical volume, you cannot use any existing device used by other logical volumes</td>
</tr>
<tr class="row-12 even">
<td class="column-1">vgdisplay</td>
<td class="column-2"><code><strong># vgdisplay DEVICE</strong></code></td>
<td class="column-3"><code>vgdisplay</code>&nbsp;shows the attributes of VGs, and the associated PVs and LVs</td>
<td class="column-4"><a title="man page for vgdisplay" href="https://linux.die.net/man/8/vgdisplay" target="_blank" rel="noopener noreferrer">man page for vgdisplay</a></td>
</tr>
<tr class="row-13 odd">
<td class="column-1">vgs</td>
<td class="column-2"><code><strong># vgs</strong></code></td>
<td class="column-3">Display information about Volume Groups<br>
This can be used as an alternative to&nbsp;<code>vgdisplay</code>&nbsp;to display limited information of available volume groups</td>
<td class="column-4"><a title="man page for vgs" href="https://man7.org/linux/man-pages/man8/vgs.8.html" target="_blank" rel="noopener noreferrer">man page for vgs</a></td>
</tr>
<tr class="row-14 even">
<td class="column-1" rowspan="2">lvcreate</td>
<td class="column-2"><code><strong># lvcreate [OPTIONS]</strong></code></td>
<td class="column-3">This is used to create logical volumes</td>
<td class="column-4" rowspan="2"><a title="Create Logical Volume" href="https://www.golinuxcloud.com/recover-lvm2-partition-restore-vg-pv-metadata/#Create_Logical_Volume" target="_blank" rel="noopener noreferrer">lvcreate example</a></td>
</tr>
<tr class="row-15 odd">
<td class="column-2"><code><strong># lvcreate -L 1G -n test_lv1 test_vg</strong></code></td>
<td class="column-3">In this example I am creating a logical volume&nbsp;<code>test_lv1</code>&nbsp;of size 1GB under&nbsp;<code>test_vg</code>&nbsp;volume group</td>
</tr>
<tr class="row-16 even">
<td class="column-1">lvdisplay</td>
<td class="column-2"><code><strong># lvdisplay DEVICE</strong></code></td>
<td class="column-3">Display information about a logical volume</td>
<td class="column-4"><a title="man page for lvdisplay" href="https://man7.org/linux/man-pages/man8/lvdisplay.8.html" target="_blank" rel="noopener noreferrer">man page for lvdisplay</a></td>
</tr>
<tr class="row-17 odd">
<td class="column-1">lvs</td>
<td class="column-2"><code><strong># lvs</strong></code></td>
<td class="column-3">Display information about logical volumes in shorter output compared to&nbsp;<code>lvdisplay</code>&nbsp;command. You can use this as an alternative to&nbsp;<code>lvdisplay</code></td>
<td class="column-4"><a title="man page for lvs" href="https://man7.org/linux/man-pages/man8/lvs.8.html" target="_blank" rel="noopener noreferrer">man page for lvs</a></td>
</tr>
<tr class="row-18 even">
<td class="column-1">pvscan</td>
<td class="column-2"><code><strong># pvscan [OPTIONS]</strong></code></td>
<td class="column-3">Scans storage devices for the presence of LVM physical volumes.<br>
It is used when a new physical volume metadata is not loaded and a&nbsp;<code>pvscan</code>&nbsp;can load the metadata of all the available PV</td>
<td class="column-4"><a title="pvscan example" href="https://www.golinuxcloud.com/fix-pvs-shows-unknown-device-redhat-linux/" target="_blank" rel="noopener noreferrer">pvscan example</a></td>
</tr>
<tr class="row-19 odd">
<td class="column-1">vgscan</td>
<td class="column-2"><code><strong># vgscan [OPTIONS]</strong></code></td>
<td class="column-3">Scans storage devices for the presence of LVM volume groups.<br>
It can be used when any VG metadata is not visible and&nbsp;<code>vgscan</code>&nbsp;can scan the available VG</td>
<td class="column-4"><a title="man page for vgscan" href="https://linux.die.net/man/8/vgscan" target="_blank" rel="noopener noreferrer">man page for vgscan</a></td>
</tr>
<tr class="row-20 even">
<td class="column-1">lvscan</td>
<td class="column-2"><code><strong># lvscan [OPTIONS]</strong></code></td>
<td class="column-3">Scans storage devices for the presence of LVM logical volumes.<br>
It can be used when any LV metadata is not visible and&nbsp;<code>lvscan</code>&nbsp;can scan the available LV</td>
<td class="column-4"><a title="man page for lvscan" href="https://linux.die.net/man/8/lvscan" target="_blank" rel="noopener noreferrer">man page for lvscan</a></td>
</tr>
<tr class="row-21 odd">
<td class="column-1" rowspan="2">vgchange</td>
<td class="column-2"><code><strong># vgchange [OPTIONS]</strong></code></td>
<td class="column-3">Changes the status from LVM volume groups and the volumes in it from active to inactive and vice versa</td>
<td class="column-4" rowspan="2"><a title="Activate Volume group" href="https://www.golinuxcloud.com/recover-lvm2-partition-restore-vg-pv-metadata/#Step_4_Activate_the_Volume_Group" target="_blank" rel="noopener noreferrer">vgchange example</a></td>
</tr>
<tr class="row-22 even">
<td class="column-2"><code><strong># vgchange -ay</strong></code></td>
<td class="column-3">In this example we are activating all the available volume groups. To deactivate all volume groups use&nbsp;<code>vgchange -an</code></td>
</tr>
<tr class="row-23 odd">
<td class="column-1">e2fsck</td>
<td class="column-2"><code><strong># e2fsck [OPTIONS]</strong></code></td>
<td class="column-3">check a Linux ext2/ext3/ext4 file system<br>
We cannot perform a check on a mounted file system so normally this is performed during reboot or in single user mode</td>
<td class="column-4"><a title="e2fsck example" href="https://www.golinuxcloud.com/e2fsck-repair-filesystem-in-rescue-mode-ext4/" target="_blank" rel="noopener noreferrer">e2fsck example</a></td>
</tr>
<tr class="row-24 even">
<td class="column-1">tune2fs</td>
<td class="column-2"><code><strong># tune2fs [OPTIONS] DEVICE</strong></code></td>
<td class="column-3"><code>tune2fs</code>&nbsp;allows the system administrator to adjust various tunable filesystem parameters on Linux ext2, ext3, or ext4 filesystems.</td>
<td class="column-4"><a title="How to force file system check on boot: systemd-fsck RHEL/CentOS 7/8" href="https://www.golinuxcloud.com/force-file-system-check-on-boot-systemd-fsck/" target="_blank" rel="noopener noreferrer">tune2fs example</a></td>
</tr>
<tr class="row-25 odd">
<td class="column-1">dumpe2fs</td>
<td class="column-2"><code><strong># dumpe2fs [OPTIONS] DEVICE</strong></code></td>
<td class="column-3">prints the super block and blocks group information for the filesystem present on device.</td>
<td class="column-4"><a title="man page for dumpe2fs" href="https://linux.die.net/man/8/dumpe2fs" target="_blank" rel="noopener noreferrer">man page for dumpe2fs</a></td>
</tr>
<tr class="row-26 even">
<td class="column-1">mkfs.</td>
<td class="column-2"><code><strong># mkfs.ext4<br>
# mkfs.xfs</strong></code></td>
<td class="column-3"><code>mkfs</code>&nbsp;is used to build a Linux filesystem on a device, usually a hard disk partition. The device argument is either the device name (e.g. /dev/hda1, /dev/sdb2), or a regular file that shall contain the filesystem.</td>
<td class="column-4"><a title="How to create filesystem on a Linux partition or logical volume" href="https://www.golinuxcloud.com/create-filesystem-partition-linux-lvm/" target="_blank" rel="noopener noreferrer">create filesystem</a></td>
</tr>
<tr class="row-27 odd">
<td class="column-1">lvextend</td>
<td class="column-2"><code><strong># lvextend OPTIONS</strong></code></td>
<td class="column-3">Add space to a logical volume</td>
<td class="column-4"><a title="5 easy steps to resize root LVM partition in RHEL/CentOS 7/8 Linux" href="https://www.golinuxcloud.com/resize-root-lvm-partition-extend-shrink-rhel/" target="_blank" rel="noopener noreferrer">lvextend example</a></td>
</tr>
<tr class="row-28 even">
<td class="column-1">vgextend</td>
<td class="column-2"><code><strong># vgextend VGNAME PV</strong></code></td>
<td class="column-3">Add physical volumes to a volume group</td>
<td class="column-4"><a title="vgextend example" href="https://www.golinuxcloud.com/linux-move-directory-to-another-partition/" target="_blank" rel="noopener noreferrer">vgextend example</a></td>
</tr>
<tr class="row-29 odd">
<td class="column-1">resize2fs</td>
<td class="column-2"><code><strong># resize2fs DEVICE</strong></code></td>
<td class="column-3">The&nbsp;<code>resize2fs</code>&nbsp;program will resize ext2, ext3, or ext4 file systems. It can be used to enlarge or shrink an unmounted file system located on device</td>
<td class="column-4"><a title="resize2fs example" href="https://www.golinuxcloud.com/extend-resize-primary-partition-non-lvm-linux/" target="_blank" rel="noopener noreferrer">resize2fs example</a></td>
</tr>
<tr class="row-30 even">
<td class="column-1">lsscsi</td>
<td class="column-2"><code><strong># lsscsi [OPTIONS]</strong></code></td>
<td class="column-3">list attached SCSI devices (or hosts)</td>
<td class="column-4"><a title="man page for lsscsi" href="https://linux.die.net/man/8/lsscsi" target="_blank" rel="noopener noreferrer">man page for lsscsi</a></td>
</tr>
<tr class="row-31 odd">
<td class="column-1">lsblk</td>
<td class="column-2"><code><strong># lsblk</strong></code></td>
<td class="column-3">lsblk lists information about all available or the specified block devices. The lsblk command reads the sysfs filesystem and udev db to gather information</td>
<td class="column-4"><a title="man page for lsblk" href="https://linux.die.net/man/8/lsblk" target="_blank" rel="noopener noreferrer">man page for lsblk</a></td>
</tr>
<tr class="row-32 even">
<td class="column-1">blkid</td>
<td class="column-2"><code><strong># blkid</strong></code></td>
<td class="column-3">It prints the UUID valud of all the connected storage device. You can use this UUID to identify the storage device instead of using the physical name</td>
<td class="column-4"><a title="man page for blkid" href="https://linux.die.net/man/8/blkid" target="_blank" rel="noopener noreferrer">man page for blkid</a></td>
</tr>
</tbody>
</table>

### 10. Managing RPM and Software Repositories

*With package manager such as yum, dnf, apt-get, the life of a system administrator becomes very easy. You can easily install, update, remove packages, upgrade server operating system and much more using these commands.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">rpm</td>
<td class="column-2"><code><strong># rpm [OPTIONS] FILE</strong></code></td>
<td class="column-3">RPM Package Manager which can be used to build, install, query, verify, update, and erase individual software packages.</td>
<td class="column-4"><a title="man page for rpm" href="https://linux.die.net/man/8/rpm" target="_blank" rel="noopener noreferrer">man page for rpm</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">yum</td>
<td class="column-2"><code><strong># yum [OPTIONS] FILE</strong></code></td>
<td class="column-3"><code>yum</code>&nbsp;is short abbreviation for Yellow Dog Updater Modified.<br>
It is obsolete now and is replaced by dnf in most recent Linux distributions.<br>
YUM is a package manager for RPM-based Linux distributions</td>
<td class="column-4"><a title="yum examples" href="https://www.golinuxcloud.com/yum-install-specific-version/" target="_blank" rel="noopener noreferrer">yum examples</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1">yumdownloader</td>
<td class="column-2"><code><strong># yumdownloader [OPTIONS]</strong></code></td>
<td class="column-3">Allows you to download packages from a repository to your system without installing them</td>
<td class="column-4"><a title="yumdownloader examples" href="https://www.golinuxcloud.com/download-rpm-package-and-all-dependencies-centos/" target="_blank" rel="noopener noreferrer">yumdownloader examples</a></td>
</tr>
<tr class="row-5 odd">
<td class="column-1">zypper</td>
<td class="column-2"><code><strong># zypper [OPTIONS] FILE</strong></code></td>
<td class="column-3">Package management utility in the SUSE works. Works more or less the same as yum.<br>
The handling of repository is slightly different with&nbsp;<code>zypper</code>&nbsp;compared to&nbsp;<code>yum</code></td>
<td class="column-4"><a title="zypper examples" href="https://www.golinuxhub.com/2018/06/how-to-configure-local-custom-repo-zypper-sles.html" target="_blank" rel="noopener noreferrer">zypper examples</a></td>
</tr>
<tr class="row-6 even">
<td class="column-1">apt-get</td>
<td class="column-2"><code><strong># apt-get [OPTIONS] FILE</strong></code></td>
<td class="column-3">Ubuntu/Debian package management utility. Does a great job in installing and updating software.</td>
<td class="column-4"><a title="man page for apt-get" href="https://linux.die.net/man/8/apt-get" target="_blank" rel="noopener noreferrer">man page for apt-get</a></td>
</tr>
<tr class="row-7 odd">
<td class="column-1">apt-cache</td>
<td class="column-2"><code><strong># apt-cache [OPTIONS] FILE</strong></code></td>
<td class="column-3">Tool that allows you to search for packages in the locally cached index files</td>
<td class="column-4"><a title="man page for apt-cache" href="https://linux.die.net/man/8/apt-cache" target="_blank" rel="noopener noreferrer">man page for apt-cache</a></td>
</tr>
<tr class="row-8 even">
<td class="column-1">dpkg</td>
<td class="column-2"><code><strong># dpkg [OPTIONS] ACTION</strong></code></td>
<td class="column-3">Original Debian package management utility, which has been made more or less obsolete by&nbsp;<code>apt-get</code></td>
<td class="column-4"><a title="man page for dpkg" href="https://man7.org/linux/man-pages/man1/dpkg.1.html" target="_blank" rel="noopener noreferrer">man page for dpkg</a></td>
</tr>
<tr class="row-9 odd">
<td class="column-1">dpkg-scanpackages</td>
<td class="column-2"><code><strong># dpkg-scanpackages [OPTIONS]</strong></code></td>
<td class="column-3">Tool that allows you to convert a directory containing .deb packages into a repository.</td>
<td class="column-4"><a title="man page for dpkg-scanpackages" href="https://linux.die.net/man/1/dpkg-scanpackages" target="_blank" rel="noopener noreferrer">man page for dpkg-scanpackages</a></td>
</tr>
<tr class="row-10 even">
<td class="column-1">dnf</td>
<td class="column-2"><code><strong># dnf [OPTIONS]</strong></code></td>
<td class="column-3">DNF is the next upcoming major version of YUM, a package manager for RPM-based Linux distributions.</td>
<td class="column-4"><a title="dnf examples" href="https://www.golinuxcloud.com/install-epel-repo-in-rhel-8-centos-dnf-yum/" target="_blank" rel="noopener noreferrer">dnf examples</a></td>
</tr>
<tr class="row-11 odd">
<td class="column-1">createrepo</td>
<td class="column-2"><code><strong># createrepo [OPTIONS] PATH</strong></code></td>
<td class="column-3"><code>createrepo</code>&nbsp;is a program that creates a&nbsp;<code>repomd</code>&nbsp;(xml-based rpm metadata) repository from a set of rpms.</td>
<td class="column-4"><a title="createrepo examples" href="https://www.golinuxcloud.com/error-populating-transaction-retrying-rhel-7/" target="_blank" rel="noopener noreferrer">createrepo examples</a></td>
</tr>
<tr class="row-12 even">
<td class="column-1">repoquery</td>
<td class="column-2"><code><strong># repoquery [OPTIONS]</strong></code></td>
<td class="column-3">This is part of&nbsp;<code>yum-utils</code>, Searches the available DNF repositories for selected packages and displays the requested information about them</td>
<td class="column-4"><a title="repoquery examples" href="https://www.golinuxcloud.com/download-rpm-package-and-all-dependencies-centos/" target="_blank" rel="noopener noreferrer">repoquery examples</a></td>
</tr>
<tr class="row-13 odd">
<td class="column-1">repotrack</td>
<td class="column-2"><code><strong># repotrack [OPTIONS]</strong></code></td>
<td class="column-3">This is part of&nbsp;<code>yum-utils</code>, track packages and its dependencies and download them</td>
<td class="column-4"><a title="repotrack examples" href="https://www.golinuxcloud.com/download-rpm-package-and-all-dependencies-centos/" target="_blank" rel="noopener noreferrer">repotrack examples</a></td>
</tr>
<tr class="row-14 even">
<td class="column-1">reposync</td>
<td class="column-2"><code><strong># reposync [OPTIONS]</strong></code></td>
<td class="column-3">Synchronize packages of a remote DNF or YUM repository to a local directory.</td>
<td class="column-4"><a title="reposync examples" href="https://www.golinuxcloud.com/how-to-download-entire-repository-from-centos-rhel-7-for-offline-use/" target="_blank" rel="noopener noreferrer">reposync examples</a></td>
</tr>
<tr class="row-15 odd">
<td class="column-1">subscription-manager</td>
<td class="column-2"><code><strong># subscription-manager [OPTIONS]</strong></code></td>
<td class="column-3">Registers systems to a subscription management service and then attaches and manages subscriptions for software products</td>
<td class="column-4"><a title="subscription-manager examples" href="https://www.golinuxcloud.com/how-to-download-entire-repository-from-centos-rhel-7-for-offline-use/" target="_blank" rel="noopener noreferrer">subscription-manager examples</a></td>
</tr>
</tbody>
</table>

### 11. Manage logging

*Now you know about most of the Linux commands to manager different areas of Linux server but you must be familiar of how logging works in Linux? This may vary based on different distribution, with old distros we used syslog-ng for logging but now almost all major distros have moved to rsyslog solution.*

<table class="divTable">
<thead>
<tr class="row-1 odd">
<th class="column-1">Command</th>
<th class="column-2">Example/Syntax</th>
<th class="column-3">Comments</th>
<th class="column-4">For more details</th>
</tr>
</thead>
<tbody class="row-hover">
<tr class="row-2 even">
<td class="column-1">logger</td>
<td class="column-2"><code><strong># logger [OPTIONS] MESSAGE</strong></code></td>
<td class="column-3"><code>logger</code>&nbsp;makes entries in the system log.<br>
When the optional message argument is present, it is written to the log.</td>
<td class="column-4"><a title="logger examples" href="https://www.golinuxcloud.com/systemd-journald-how-logging-works-rhel-7/" target="_blank" rel="noopener noreferrer">logger examples</a></td>
</tr>
<tr class="row-3 odd">
<td class="column-1">logrotate</td>
<td class="column-2"><code><strong># logrotate [OPTIONS]</strong></code></td>
<td class="column-3">Command that helps you to prevent log files from growing too big and rotate them after a certain amount of time or once a given size has been reached</td>
<td class="column-4"><a title="logrotate examples" href="https://www.golinuxcloud.com/systemd-journald-how-logging-works-rhel-7/" target="_blank" rel="noopener noreferrer">logrotate examples</a></td>
</tr>
<tr class="row-4 even">
<td class="column-1">journalctl</td>
<td class="column-2"><code><strong># journalctl [OPTIONS]</strong></code></td>
<td class="column-3"><code>journalctl</code>&nbsp;may be used to query the contents of the systemd journal as written by systemd-journald.service</td>
<td class="column-4"><a title="journalctl examples" href="https://www.golinuxcloud.com/view-logs-using-journalctl-filter-journald/" target="_blank" rel="noopener noreferrer">journalctl examples</a></td>
</tr>
</tbody>
</table>

### * Conclusion

*In this cheat sheet tutorial I have tried to consolidate most used Linux commands by different types of experts across IT domains. I am yet to add commands for many other scenarios such as Managing Linux services, archiving, firewall etc but that would just make this tutorial infinite long. I may write another article based on the response I get on this one, even writers need motivation. So that I know people are reading and loving this cheat sheet then I may decide to spend some more time to write about the remaining Linux commands in another tutorial.*
