From: George Rapp <george.rapp@gmail.com>
Subject: Fedora 20 RAID 6 errors on rebuild / check / repair
Date: Wed, 23 Jul 2014 22:29:41 -0400
Message-ID: <CAF-KpgZ+8pPp62CN5p4rkwSk0nSv_JdkXGLnUWMaDEj2MmVcGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi -

I have a Fedora 20 media server / MythTV backend utilizing a HighPoint
RocketRAID 2720SGL controller (Amazon product link:
http://is.gd/yqo2i1). The server performs fine under normal (minimal)
read-write operations, but during any high-I/O operations (rebuild
after mdadm --add, RAID check initiated by "echo check >
/sys/block/md6/md/sync_action" or "echo repair > ..."), I get sporadic
errors and poor performance on my RAID 6 array, /dev/md6.

Wondering if there is anything I can tweak to make my configuration
more stable. The inability to check or repair this RAID device has me
nervous.

The problems seem to start when I see the following error message in
/var/log/syslog:

> Jul 22 21:23:37 backend3 kernel: [95876.375990] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> Jul 22 21:23:37 backend3 kernel: [95876.376153] ata5.00: failed command: READ DMA
> Jul 22 21:23:37 backend3 kernel: [95876.376284] ata5.00: cmd c8/00:08:40:11:81/00:00:00:00:00/e3 tag 11 dma 4096 in
> Jul 22 21:23:37 backend3 kernel: [95876.376284]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
> Jul 22 21:23:37 backend3 kernel: [95876.376750] ata5.00: status: { DRDY }
> Jul 22 21:23:37 backend3 kernel: [95876.376874] ata5: hard resetting link
> Jul 22 21:23:37 backend3 kernel: ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> Jul 22 21:23:37 backend3 kernel: ata5.00: failed command: READ DMA
> Jul 22 21:23:37 backend3 kernel: ata5.00: cmd c8/00:08:40:11:81/00:00:00:00:00/e3 tag 11 dma 4096 in
>          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
> Jul 22 21:23:37 backend3 kernel: ata5.00: status: { DRDY }
> Jul 22 21:23:37 backend3 kernel: ata5: hard resetting link
> Jul 22 21:23:40 backend3 kernel: [95878.742281] ata5.00: configured for UDMA/133
> Jul 22 21:23:40 backend3 kernel: [95878.742413] ata5.00: device reported invalid CHS sector 0
> Jul 22 21:23:40 backend3 kernel: [95878.742542] ata5: EH complete
> Jul 22 21:23:40 backend3 kernel: ata5.00: configured for UDMA/133
> Jul 22 21:23:40 backend3 kernel: ata5.00: device reported invalid CHS sector 0
> Jul 22 21:23:40 backend3 kernel: ata5: EH complete


I thought the problem might be caused by NCQ being enabled -- previous
iterations of this error included the string 'ncq', like this:

> ata7.00: cmd 60/00:00:68:4b:75/03:00:04:00:00/40 tag 0 ncq 393216 in
>          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)


so I disabled NCQ by adding "libata.force=noncq" to my kernel boot
parameters. However, it didn't help, as I still get the "...frozen"
errors. (I have young children, so any error message that includes the
word "Frozen" makes me twitchy ... 8^)

Right now, I'm attempting to rebuild the degraded RAID 6 array after
swapping out a disk that was getting an increasing number of these
errors:

> Device: /dev/sdf [SAT], 35 Currently unreadable (pending) sectors


I started the rebuild on Monday night in single-user mode via

> # mdadm --manage /dev/md6 --add /dev/sdf1


(my other partitions are /dev/sd[bcde]4, but I only created a single
partition on the new disk, to see if reliability would be better by
placing my RAID partition on the first partition rather than the last)

At first, the rebuild was supposed to take 4.3 days. I Googled around
and found a couple of speed optimization techniques, which I applied:

> # sysctl -w dev.raid.speed_limit_max=100000
>
> # cd /sys/block/md6/md
> # echo 16384 > stripe_cache_size


This initially sped up the resync speed to 68-70000K/sec, until I hit
the first "exception Emask" error like the one I described above --
now the speed has dropped to 30K/sec, and the rebuild is scheduled to
last 439 more days! I don't know if I should just mark the new device
as failed and stop the sync, or let it keep grinding and hope it
speeds up.

Any pointers or tips appreciated. I've been running Linux software
RAID for 4-5 years, but this is the first time I've experienced this
kind of trouble.

More data on my system:


[root@backend3 gwr]# uname -a
Linux backend3 3.14.4-200.fc20.i686+PAE #1 SMP Tue May 13 14:03:12 UTC
2014 i686 i686 i386 GNU/Linux

[root@backend3 gwr]# mdadm --version
mdadm - v3.3 - 3rd September 2013

[root@backend3 log]# mdadm --detail /dev/md6
/dev/md6:
        Version : 1.2
  Creation Time : Sun Apr 24 17:31:27 2011
     Raid Level : raid6
     Array Size : 5756723712 (5490.04 GiB 5894.89 GB)
  Used Dev Size : 1918907904 (1830.01 GiB 1964.96 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Jul 23 22:15:05 2014
          State : active, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 512K

 Rebuild Status : 39% complete

           Name : backend3:md4
           UUID : 894bc20e:b9479ac9:7bfce54f:0ac12dd9
         Events : 1659380

    Number   Major   Minor   RaidDevice State
       0       8       36        0      active sync   /dev/sdc4
       1       8       20        1      active sync   /dev/sdb4
       5       8       68        2      active sync   /dev/sde4
       4       8       52        3      active sync   /dev/sdd4
       6       8       81        4      spare rebuilding   /dev/sdf1

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
Work: george.rapp -- at -- hp.com (or) george.rapp.ctr -- at -- dfas.mil

A wise and frugal government, which shall restrain men from injuring
one another, which shall leave them otherwise free to regulate their
own pursuits of industry and improvement, and shall not take from the
mouth of labor the bread it has earned. This is the sum of
good government... - Thomas Jefferson, First Inaugural Address
