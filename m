From: andrewm@cse.unsw.edu.au (Andrew Robert Mitchell)
Subject: RAID0 superblock update time inconsistency
Date: Wed, 31 Dec 2003 01:03:18 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230140318.GF28783@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've had my RAID0 array (hdb and hdd) working well for a couple of years...
until tonight. (Of course just a few hours after my large backup hard drive
(located in another machine) failed!!!)
                                                                                                                                                              
the kernel (fedora core 1 2.4.22) was accessing hdc (the ide cd-writer) when
a problem occurred with that (irq timeout, ATAPI resets, etc, etc) when I
put a cdr into it.  Soon afterwards, some hdd status timeouts occurred
(I'm guessing it was too busy trying to contact hdc)...
and ide1 reset timed-out errors
rather stuck, I shutdown -r now.
a few I/O errors occured on hdd but eventually it rebooted
On reboot, however, my raid0 was unfunctional!
                                                                                                                                                              
Dec 30 21:34:32 zazu kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Dec 30 21:34:32 zazu kernel: md: Autodetecting RAID arrays.
Dec 30 21:34:32 zazu kernel:  [events: 00000130]
Dec 30 21:34:32 zazu kernel:  [events: 000000cc]
Dec 30 21:34:32 zazu kernel: md: autorun ...
Dec 30 21:34:32 zazu kernel: md: considering hdd1 ...
Dec 30 21:34:32 zazu kernel: md:  adding hdd1 ...
Dec 30 21:34:32 zazu kernel: md:  adding hdb1 ...
Dec 30 21:34:32 zazu kernel: md: created md0
Dec 30 21:34:32 zazu kernel: md: bind<hdb1,1>
Dec 30 21:34:32 zazu kernel: md: bind<hdd1,2>
Dec 30 21:34:32 zazu kernel: md: running: <hdd1><hdb1>
Dec 30 21:34:32 zazu kernel: md: hdd1's event counter: 000000cc
Dec 30 21:34:32 zazu kernel: md: hdb1's event counter: 00000130
Dec 30 21:34:32 zazu kernel: md: superblock update time inconsistency -- using the most recent one
Dec 30 21:34:32 zazu kernel: md: freshest: hdb1
Dec 30 21:34:32 zazu kernel: md: kicking non-fresh hdd1 from array!
Dec 30 21:34:32 zazu kernel: md: unbind<hdd1,1>
Dec 30 21:34:32 zazu kernel: md: export_rdev(hdd1)
Dec 30 21:34:32 zazu kernel: md0: former device hdd1 is unavailable, removing from array!
Dec 30 21:34:32 zazu kernel: kmod: failed to exec /sbin/modprobe -s -k md-personality-2, errno = 2
Dec 30 21:34:32 zazu kernel: md: personality 2 is not loaded!
Dec 30 21:34:32 zazu kernel: md :do_md_run() returned -22
Dec 30 21:34:32 zazu kernel: md: md0 stopped.
Dec 30 21:34:32 zazu kernel: md: unbind<hdb1,0>
Dec 30 21:34:32 zazu kernel: md: export_rdev(hdb1)
Dec 30 21:34:32 zazu kernel: md: ... autorun DONE.
                                                                                                                                                              
                                                                                                                                                              
So it seems I still have 2 undead drives, but hdd is a little show with the
event counter?!? (i.e. no eents happened while the kernel coun't contact it?)
perhaps a few files should be impossible to recover but I would suspect that the
system itself should be recoverable if appropriate information can be copied
accross from hdb? Or do I need to recreate the entire array from scratch and
slightly-too-old backups-or-my-backups?
Is it possible to just copy appropriate superblock entries accross from hdb
somehow on this RAID0 system. Similar recovery methods seem possible with
RAID5 from what I read, but I cannot figure out exactly the commands to use.
(do I just call hdd as being failed in /etc/raidtab, or something like mkraid --force?)
                                                                                                                                                              
thanks in advance for any suggestions,
-- 
Andrew Mitchell    andrewm@cse.unsw.edu.au
