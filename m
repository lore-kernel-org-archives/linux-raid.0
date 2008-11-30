From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: array always resyncs on boot
Date: Sat, 29 Nov 2008 20:23:55 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811292015010.7720@p34.internal.lan>
References: <4931B2C5.5060403@openhardware.net> <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan> <4931E75D.5080905@openhardware.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4931E75D.5080905@openhardware.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Walsh <tom@openhardware.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 29 Nov 2008, Tom Walsh wrote:

> Justin Piszcz wrote:
>>

[ .. snip .. ]

From your dmesg, you need to figure out why it is assembling only 5
out of the 6 disks, is it kicking a non-fresh one out of the array, or..?

> md: bind<sdc5>
> md: raid10 personality registered for level 10
> raid10: raid set md0 active with 5 out of 6 devices
> md: bind<sdd5>
> RAID10 conf printout:


> dmesg (/var/log/messages as well) are mysteriously quiet about why the resync 
> was initiated, they merely state that it is being done.  That what is driving 
> me nuts, no log info.  This is an ICH10 system board (Gigabyte GA-EP43-DS3L),
            ^^^^^^^^^^^ (see below)

> the other board was Asus P5N-T Deluxe, also an ICH10 chipset.  This is the 
> dmesg output from the recent Gigabyte board boot (and resync):
>
> Linux version 2.6.27.7 (root@localhost) (gcc version 4.3.2 (GCC) ) #1 SMP Sat 
> Nov 29 10:14:42 EST 2008
> Command line: BOOT_IMAGE=linux root=801 quiet
                                           ^^^^^

Remove quiet from the command line, reboot, and hopefully it will tell you 
why it kicked the drive out of the array, it should say "non-fresh drive" 
kicking from array or something similar.  The next thing would be upon 
reboot is it possible the drives are not syncing/the raid is not shutting 
down properly(?)--

1. Remove quiet from the boot options (in lilo.conf or grub.conf)
2. Send an updated e-mail with the boot message.
3. Try to capture all of the dmesg/syslog when you shutdown and send that 
as well.


Also see below, are all of these drives on the -SAME- controller?
http://www.newegg.com/Product/Product.aspx?Item=N82E16813128347

I see the mobo has 6 sata ports- they are all connected to the ICH10 6 ports
at the bottom of the board- right? e.g. You're not using any additional SATA
add-in card..?

Also see below, DISK 4 is missing (/dev/sdd) you should reboot or check your
logs and see if its /dev/sdd every time, also print the output of:

smartctl -a /dev/sda
smartctl -a /dev/sdb
smartctl -a /dev/sdc
smartctl -a /dev/sdd
smartctl -a /dev/sde
smartctl -a /dev/sdf

> ACPI: Processor [CPU3] (supports 8 throttling states)
> md: bind<sdf5>
# DISK 6
> md: bind<sde5>
# DISK 5
> md: bind<sdb5>
# DISK 2
> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> HDA Intel 0000:00:1b.0: setting latency timer to 64
> md: bind<sda5>
# DISK 1
> md: bind<sdc5>
# DISK 3
> md: raid10 personality registered for level 10
> raid10: raid set md0 active with 5 out of 6 devices
> md: bind<sdd5>
> RAID10 conf printout:
> --- wd:5 rd:6
> disk 0, wo:0, o:1, dev:sda5
> disk 1, wo:0, o:1, dev:sdb5
> disk 2, wo:0, o:1, dev:sdc5
> disk 3, wo:1, o:1, dev:sdd5
> disk 4, wo:0, o:1, dev:sde5
> disk 5, wo:0, o:1, dev:sdf5
> md: recovery of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000 
> KB/sec) for recovery.
> md: using 128k window, over a total of 20980736 blocks.
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
> dm-devel@redhat.com
> EXT3 FS on sda1, internal journal
> loop: module loaded
> Adding 1959920k swap on /dev/sda2.  Priority:-1 extents:1 across:1959920k
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> r8169: eth0: link up
> r8169: eth0: link up
> NET: Registered protocol family 17
> eth0: no IPv6 routers present
> md: md0: recovery done.
> RAID10 conf printout:
> --- wd:6 rd:6
> disk 0, wo:0, o:1, dev:sda5
> disk 1, wo:0, o:1, dev:sdb5
> disk 2, wo:0, o:1, dev:sdc5
> disk 3, wo:0, o:1, dev:sdd5
> disk 4, wo:0, o:1, dev:sde5
> disk 5, wo:0, o:1, dev:sdf5
>

