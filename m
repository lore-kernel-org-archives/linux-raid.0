From: Jason Gordon <fifreak@fifreak.dyndns.org>
Subject: RAID1 help
Date: Sun, 8 Jun 2003 14:56:15 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E15502AC-99E2-11D7-8B62-000393795060@fifreak.dyndns.org>
Mime-Version: 1.0 (Apple Message framework v552)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have been trying to setup software RAID 1 on a new debian based 
system for the last day and I cant seem to get it right.  I have a 
Promise Ultra ATA 66 PCI card with 2 IDE channels on it.  I have two 
identical 27.3 GB HDs hooked to this card, each on its own channel.

I followed the instructions on 
http://docman.sourceforge.net/home_html/md-raid1.html exactly but I 
also looked at various HOW-Tos.

My layout is as follows.

/dev/hde1	~26 GB 	/
/dev/hde2	~700 MB	swap

/dev/hdg has the same layout.

When I installed, /dev/hdg* was the failed disk, so I installed onto 
/dev/hde1.

With both disks detatched, the system boots properly.  With /dev/hde 
only attached, the system boots properly and reports it is in degraded 
mode.  However, with /dev/hdg attached, the system kernel panics.  Lilo 
comes up, loads, grabs the RAM disk image (from initrd) and loads that 
into memory and starts to boot.  But then it eventually somewhere in 
the boot process it kernel panics.  Here are some of the messages:

isofs_read_super: bread failed, dev=09:00, iso_blknum=16, block=32
mount: wrong fs type, bad option, bad superblock on /dev2/root, or too 
many mounted file systems
...
cramfs: wrong magic
warning: can't open /etc/mtab: no such file or directory
pivot_root: No such file or directory
/sbin/init: cannot open dev/console: no such file
Kernel panic: Attempted to kill init!

The only thing I can think to do right now is to try again with a 
slightly different layout.  Some articles had mentioned something about 
a small /boot partition.
/dev/hde1	~100 MB	/boot
/dev/hde2	~26 GB		/
/dev/hde3	~700 MB	swap

Any help, ideas suggestions, im getting pretty frustrated here.

Jason

