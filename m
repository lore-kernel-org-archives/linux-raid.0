From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: RAID1 (drive isn't detecting on boot)
Date: Thu, 30 Jan 2003 08:39:51 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D5B7@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Eric Drew Hollins' <gte275e@mail.gatech.edu>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You need to include your kernel version.  

Apparently you are running ok on hdg1 in degraded mode, but hde1 has an
invalid superblock magic.
You should be able to reconstruct the superblock on hde1 by using mdadm,
then resync.

Andy

-----Original Message-----
From: Eric Drew Hollins [mailto:gte275e@mail.gatech.edu] 
Sent: Thursday, January 30, 2003 11:30 AM
To: Linux RAID Mailing List
Subject: RAID1 (drive isn't detecting on boot)


Ok, I have a RAID1 set up on identical Maxtor 60GB drives.  They were
working
the other day, but not now.  Here is the message that I get when I boot up:

md: raid1 personality registered as nr 3
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
 [events: 00000000]
md: invalid raid superblock magic on hde1
md: hde1 has invalid sb, not importing!
md: could not import hde1!
 [events: 00000022]
md: autorun ...
md: considering hdg1 ...
md:  adding hdg1 ...
md: created md0
md: bind<hdg1,1>
md: running: <hdg1>
md: hdg1's event counter: 00000022
md: RAID level 1 does not need chunksize! Continuing anyway.
md0: max total readahead window set to 124k
md0: 1 data-disks, max readahead per data-disk: 124k
raid1: device hdg1 operational as mirror 1
raid1: md0, not all disks are operational -- trying to recover array
raid1: raid set md0 active with 1 out of 2 mirrors
md: updating md0 RAID superblock on device
md: hdg1 [events: 00000023]<6>(write) hdg1's sb offset: 58463872
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: ... autorun DONE.

Any ideas?  If you need more info, just let me know.  Thanks.




**** Eric Drew Hollins ****
**** Georgia Institute of Technology ****
**** 336198 GT Station, Atlanta, GA 30332 ****
**** W: http://jastermereel.org ****
**** C: 404.312.0685 ****


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
