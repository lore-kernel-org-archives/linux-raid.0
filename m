From: Lem <l3mming@iinet.net.au>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Mon, 21 Aug 2006 18:03:45 +1000
Message-ID: <1156147425.4525.20.camel@localhost.localdomain>
References: <1155987607.7207.23.camel@localhost.localdomain>
	 <17641.25141.373827.77279@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17641.25141.373827.77279@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2006-08-21 at 17:35 +1000, Neil Brown wrote:
> On Saturday August 19, l3mming@iinet.net.au wrote:
> > Hi all,
> > 
> > I'm having a problem with my RAID5 array, here's the deal:
> > 
> > System is an AMD Athlon 64 X2 4200+ on a Gigabyte K8NS-939-Ultra
> > (nForce3 Ultra). Linux 2.6.17.7, x86_64. Debian GNU/Linux Sid, GCC 4.1.1
> > (kernel configured and compiled by hand).
> > 
> > RAID5 array created using mdadm 2.5.2. All drives are 250Gb Seagate
> > SATAs, spread across three controllers: nForce3 Ultra (motherboard),
> > Silicon Image 3124 (motherboard) and Promise SATA TX300 (PCI).
> > 
> > /dev/sda: ST3250624NS
> > /dev/sdb: ST3250624NS
> > /dev/sdc: ST3250823AS
> > /dev/sdd: ST3250624NS
> > /dev/sde: ST3250823AS
> > 
> > The array assembles and runs perfectly at boot, and continues to operate
> > without errors, and has been for a few months. It is using a version
> > 0.90 superblock. None of the devices were partitioned with fdisk, they
> > were just passed to mdadm when the array was created.
> > 
> > Recently (last week or two), I have noticed the following in dmesg:
> > 
> > SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
> > sde: Write Protect is off
> > sde: Mode Sense: 00 3a 00 00
> > SCSI device sde: drive cache: write back
> > SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
> > sde: Write Protect is off
> > sde: Mode Sense: 00 3a 00 00
> > SCSI device sde: drive cache: write back
> >  sde: sde1 sde3
> 
> This itself shouldn't be a problem.  The fact that the kernel imagines
> there are partitions shouldn't hurt as long as no-one tries to access
> them.

This is where I'm having a problem - lilo fails due to the bogus
partition table, here's the output:

# lilo
part_nowrite: read:: Input/output error

and from dmesg/syslog due to running lilo:

printk: 537 messages suppressed.
Buffer I/O error on device sde3, logical block 0
Buffer I/O error on device sde3, logical block 1
Buffer I/O error on device sde3, logical block 2
Buffer I/O error on device sde3, logical block 3
Buffer I/O error on device sde3, logical block 4
Buffer I/O error on device sde3, logical block 5
Buffer I/O error on device sde3, logical block 6
Buffer I/O error on device sde3, logical block 7
Buffer I/O error on device sde3, logical block 8
Buffer I/O error on device sde3, logical block 9


> 
> > sd 6:0:0:0: Attached scsi disk sde
> > 
> > Buffer I/O error on device sde3, logical block 1792
> > Buffer I/O error on device sde3, logical block 1793
> > Buffer I/O error on device sde3, logical block 1794
> > Buffer I/O error on device sde3, logical block 1795
> > Buffer I/O error on device sde3, logical block 1796
> > Buffer I/O error on device sde3, logical block 1797
> > Buffer I/O error on device sde3, logical block 1798
> > Buffer I/O error on device sde3, logical block 1799
> > Buffer I/O error on device sde3, logical block 1792
> > Buffer I/O error on device sde3, logical block 1793
> 
> This, on the other hand, might be a problem - though possibly only a
> small one.
> Who is trying to access sde3 I wonder.  I'm fairly sure the kernel
> wouldn't do that directly.
> 
> Maybe some 'udev' related thing is trying to be clever?

The above buffer I/O errors (logical block 1792+) occur as filesystems
are being automounted. /dev/sde* doesn't exist in /etc/fstab of course.

> Apart from these messages, is there any symptoms that cause a problem? 
> It could just be that something is reading from somewhere that doesn't
> exist, and is complaining.  So let them complain.  Who cares :-)

There's no problems with any software apart from lilo so far. fdisk
works (since it doesn't scan all block devices on startup). Gparted
might fail, though I haven't tried (it scans all block devices on
startup). And yep, sounds about right that something is reading from
somewhere that doesn't exist (the bogus partition table on /dev/sde
would suggest this is the case).

> > 
> > I'm not a software/kernel/RAID developer by any stretch of the
> > imagination, but my thoughts are that I've just been unlucky with my
> > array and that the data on there has somehow managed to look like a
> > partition table, and the kernel is trying to read it, resulting in the
> > buffer IO errors.
> 
> But these errors are necessarily a problem (I admit they look scary).
> 
> > 
> > I believe a solution to this problem would be for me to create proper
> > partitions on my RAID disks (with type fd I suspect?), and possibly use
> > a version 1.x superblock rather than 0.90.
> 
> Creation partitions and then raiding them would remove these messages.
> Also using a verions 1.1 or 1.2 superblock would (as they put the
> superblock at the start of the device instead of the end).
> 
> But is it worth the effort?

A few questions, searching for the best possible solution. I believe
this is worth the effort, else I can't run lilo without disabling the
array and removing /dev/sde from the system.

1. Is it possible to have mdadm or another tool automatically convert
the superblocks to v1.1/1.2 (and perhaps create proper partitions)?

2. If number 1 isn't possible, is it possible to convert one drive at a
time to have a proper partition table? Like this: Stop array;
fdisk /dev/sde, create partition of type fd (entire disk), save
partition table; Start array. (then I'd assume mdadm would notice
that /dev/sde has changed and possibly start a resync? - if not, and it
just works, then great!). If that works, then do every other drive, one
at a time.


Thanks for your help Neil.

> 
> NeilBrown
