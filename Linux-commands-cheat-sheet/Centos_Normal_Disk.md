## Content

If you are new to installing CentOS 7 on either bare metal or in a VM, one thing to be aware of is that if you select the default partitioning scheme (how the OS sections out the disc space) CentOS 7 will put most the space in /home instead of root ( / ) or /opt. For an example, if you have an 100GB disc, the OS would likely partition 50GB for /home (users) and around ~50 GB for root and boot. As an application, SMx installations on top of the OS will, by default, be put in /opt, meaning of the 100GB disc, you would only have 50GB allowance for SMx. You might want more (or less) for your instance, and this article shows how to establish partitions.

Note that Calix is not requiring partition of discs in any particular fashion; that decision is up to the System Administrator, with several ways to achieve the goal dependent on each environment. Calix only requires that the OS provides the SMx application *at least* the minimum space requirements declared in the product documentation.

If you have never manually partitioned a disc before, this article will a help get you going. For this example, I have created a VM in ESXi with 8 CPU's, 32GB of RAM, and a 250GB virtual disc. I am using CentOS 7 with minimal install. (Using the full install means you will get a GUI which will use more resources, but some may find helpful; the GUI is of course completely optional). You can substitute other hypervisors out there for VMware ESXi; it just seems the most common at this time of writing the article. This article will not go over things like RAID configurations for bare metal servers or more advanced partitioning schemes.

I am assuming you have inserted the CentOS 7 iso in the virtual drive of the VM or put the Disc in the CD Tray of the bare metal server and you are booting to the CentOS 7 installer. You should see the below screen in either the ESXi/vSphere console or on the monitor if this is bare metal.

PROCEDURE

<img src="/Note/img/cent1.png">

<img src="/Note/img/cent2.png">

<img src="/Note/img/cent3.png">

<img src="/Note/img/cent4.png">

<img src="/Note/img/cent5.png">

<img src="/Note/img/cent6.png">

<img src="/Note/img/cent7.png">

<img src="/Note/img/cent8.png">

```
/boot partition with ~500MB of space
swap (LVM) partition of 32GB of space (as we have 32GB of RAM)
set the remaining disc space for root ( / ) of type LVM.
```
If you are happy with the way things look, click Done and review the changes, and then begin the installation.
