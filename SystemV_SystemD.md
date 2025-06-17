### The Difference Between System V and SystemD

<img src="/img/Systemd_components.svg_-e1575613465448.png">

* One of the most fundamental distinctions in modern Linux systems is whether they use SystemV or Systemd. Here are the main differences between the two.

  * SystemV is older, and goes all the way back to original Unix.

  * SystemD is the new system that many distros are moving to.

  * SystemD was designed to provide faster booting, better dependency management, and much more.

  * SystemD handles startup processes through .service files.

  * SystemV handles startup processes through shell scripts in /etc/init*.

* Indicators

  * If you’re starting and stopping things using systemctl restart sshd, etc, you’re on a SystemD system.

  * If you’re starting and stopping things using /etc/init.d/sshd start, etc, you’re on a SystemV system.  

SysVinit is a much older system to manage service startup during the boot process in a Linux system. SysVinit has been around since basically forever.

In SysVinit, there's a first program to run after the kernel is loaded. That program is called init. Init does a few thing, one of which is to load a series of scripts that start various system services, like networking, the ssh daemon, things like that.

The problem with SysVinit is that it takes careful tuning. Say you have an Network Filesystem (NFS) client that you want to run on startup. Well, NFS doesn't make sense to run before networking is working. So you have to make sure it waits to start until networking is already working.

The way SysVinit does this is by setting a strict order for services to start in. Every service is assigned a priority number and init starts the services in sequence by priority. If you need to make sure your service starts after networking, you have to manually assign a later priority to your service. And that has to be done by someone (usually the package maintainers) for every single service running on your computer.

It's just a heck of a lot of work.

Meanwhile Systemd is dependency based. When you define and configure a Systemd service, you define it's dependencies. Our hypothetical NFS service from earlier has a dependency on networking.

This has a few advantages. Number one is that now you can start services in parallel. The only thing required to start a service is that its dependencies must already be started. You can start NFS, ssh, samba, all at the same time, because they don't interact with each other in any way. That makes boot times a lot faster.

You could do this with some tweaks to SysVinit too, but it was really never considered feasible. It would require far too much manual configuration by package maintainers to consider all the possible variables.

Number two is that you can start services on demand. You don't need an ssh daemon running until something requests access to it. So why not wait until a client tries to open a connection to your server to start the service? That also reduces boot times, especially on desktop systems which can set a high priority on getting the GUI up and running faster, and leave all the background services to start up as needed.

There are other advantages too. Systemd adds the ability to have system logs going back all the way to boot, unlike the current system where syslogd only starts very late in the process. Systemd also adds the ability to manage services by groups, rather than individually. But the two points above are the fundamental structural differences between Systemd and SysVinit.