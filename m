From: David Greaves <david@dgreaves.com>
Subject: BUG: mdadm --fail makes the kernel lose count (was Re: raid5 won't
 resync)
Date: Tue, 31 Aug 2004 10:22:40 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41344360.8060206@dgreaves.com>
References: <200408310408.i7V48p307444@watkins-home.com> <Pine.LNX.4.58.0408310401070.1949@web1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0408310401070.1949@web1.mmaero.com>
To: Jon Lewis <jlewis@lewis.org>, neilb@cse.unsw.edu.au
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org, aaron@america.com
List-Id: linux-raid.ids

Neil
copied you as I think there's a bug in resync behaviour (kernel.org 2.6.6)

Summary: No data loss. A resync in progress doesn't stop when mdadm 
fails the resyncing device and the kernel loses count.
When complete
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdd1[3] sdc1[1] sdb1[2] sda1[0] hdb1[4]
      980446208 blocks level 5, 128k chunk, algorithm 2 [5/4] [UUUUU]

That should be [5/5] shouldn't it?

Apologies if this is known and fixed in a later kernel.

Jon Lewis wrote:

>Since the recovery had stopped making progress, I decided to fail the
>drive it had brought in as the spare with mdadm /dev/md2 -f /dev/sdf1.
>That worked as expected.  mdadm /dev/md2 -r /dev/sdf1 seems to have hung.
>It's in state D and I can't terminate it.  Trying to add a new spare,
>mdadm can't get a lock on /dev/md2 because the previous one is stuck.
>
>I suspect at this point, we're going to have to just reboot again.
>  
>
Jon,
Since I had a similar problem (manually 'failing' a device during resync 
- I have a 5 device RAID5 - no spares)
I thought I'd ask if you noticed anything like this at all?


David
PS full story, messages etc below

Whilst having my own problems the other day I had the following odd 
behaviour:

Disk sdd1 failed (I think a single spurious bad block read)
/proc/mdstat and --detail showed it marked faulty
I mdadm-removed it from the array.
I checked it and found no errors.
I mdadm-added it and a resync started.
I realised I'd made a mistake and checked the partition and not the disk
I looked to see what was happening:
I did an mdadm --detail /dev/md0
--
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Jun  5 18:13:04 2004
     Raid Level : raid5
     Array Size : 980446208 (935.03 GiB 1003.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Aug 29 21:08:35 2004
          State : clean, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       0        0       -1      removed
       4       3       65        4      active sync   /dev/hdb1
       5       8       49        3      spare   /dev/sdd1
           UUID : 19779db7:1b41c34b:f70aa853:062c9fe5
         Events : 0.1979229
--

I mdadm-failed the device _whilst it was syncing_
The kernel reported "Operation continuing on 3 devices" (not 4)
[I thought at this point that I'd lost the lot!
The kernel not counting properly is not confidence inspiring]
at this point I had:
--
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdd1[5](F) sdc1[1] sdb1[2] sda1[0] hdb1[4]
      980446208 blocks level 5, 128k chunk, algorithm 2 [5/3] [UUU_U]
      [>....................]  recovery =  0.3% (920724/245111552) 
finish=349.5min s
--
Not nice looking at all!!!
Another  mdadm --detail /dev/md0
--
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Jun  5 18:13:04 2004
     Raid Level : raid5
     Array Size : 980446208 (935.03 GiB 1003.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Sun Aug 29 21:09:06 2004
          State : clean, degraded, recovering
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       0        0       -1      removed
       4       3       65        4      active sync   /dev/hdb1
       5       8       49        3      faulty   /dev/sdd1
           UUID : 19779db7:1b41c34b:f70aa853:062c9fe5
         Events : 0.1979246
--
Now mdadm reports the drive faulty but:
mdadm /dev/md0 --remove /dev/sdd1
mdadm: hot remove failed for /dev/sdd1: Device or resource busy

OK, fail the drive again and try and remove it.
Nope.
Oh-oh.

I figured leaving it was the safest thing at this point.
Later that night it finished.

Aug 30 01:37:55 cu kernel: md: md0: sync done.
Aug 30 01:37:55 cu kernel: RAID5 conf printout:
Aug 30 01:37:55 cu kernel:  --- rd:5 wd:3 fd:1
Aug 30 01:37:55 cu kernel:  disk 0, o:1, dev:sda1
Aug 30 01:37:55 cu kernel:  disk 1, o:1, dev:sdc1
Aug 30 01:37:55 cu kernel:  disk 2, o:1, dev:sdb1
Aug 30 01:37:55 cu kernel:  disk 3, o:0, dev:sdd1
Aug 30 01:37:55 cu kernel:  disk 4, o:1, dev:hdb1
Aug 30 01:37:55 cu kernel: RAID5 conf printout:
Aug 30 01:37:55 cu kernel:  --- rd:5 wd:3 fd:1
Aug 30 01:37:55 cu kernel:  disk 0, o:1, dev:sda1
Aug 30 01:37:55 cu kernel:  disk 1, o:1, dev:sdc1
Aug 30 01:37:55 cu kernel:  disk 2, o:1, dev:sdb1
Aug 30 01:37:55 cu kernel:  disk 3, o:0, dev:sdd1
Aug 30 01:37:55 cu kernel:  disk 4, o:1, dev:hdb1
Aug 30 01:37:55 cu kernel: RAID5 conf printout:
Aug 30 01:37:55 cu kernel:  --- rd:5 wd:3 fd:1
Aug 30 01:37:55 cu kernel:  disk 0, o:1, dev:sda1
Aug 30 01:37:55 cu kernel:  disk 1, o:1, dev:sdc1
Aug 30 01:37:55 cu kernel:  disk 2, o:1, dev:sdb1
Aug 30 01:37:55 cu kernel:  disk 4, o:1, dev:hdb1

Next morning:
# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdd1[5](F) sdc1[1] sdb1[2] sda1[0] hdb1[4]
      980446208 blocks level 5, 128k chunk, algorithm 2 [5/3] [UUU_U]

unused devices: <none>
# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Jun  5 18:13:04 2004
     Raid Level : raid5
     Array Size : 980446208 (935.03 GiB 1003.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Aug 30 08:45:35 2004
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       0        0       -1      removed
       4       3       65        4      active sync   /dev/hdb1
       5       8       49       -1      faulty   /dev/sdd1
           UUID : 19779db7:1b41c34b:f70aa853:062c9fe5
         Events : 0.1986057

I don't know why it was still (F). As if the last fail and remove were 
'queued'?


Finally I did mdadm /dev/md0 --remove /dev/sdd1

mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Jun  5 18:13:04 2004
     Raid Level : raid5
     Array Size : 980446208 (935.03 GiB 1003.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Aug 30 08:54:28 2004
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       0        0       -1      removed
       4       3       65        4      active sync   /dev/hdb1
           UUID : 19779db7:1b41c34b:f70aa853:062c9fe5
         Events : 0.1986058
cu:/var/cache/apt-cacher# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdc1[1] sdb1[2] sda1[0] hdb1[4]
      980446208 blocks level 5, 128k chunk, algorithm 2 [5/3] [UUU_U]

unused devices: <none>


mdadm /dev/md0 --add /dev/sdd1

cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdd1[5] sdc1[1] sdb1[2] sda1[0] hdb1[4]
      980446208 blocks level 5, 128k chunk, algorithm 2 [5/3] [UUU_U]
      [>....................]  recovery =  0.0% (161328/245111552) 
finish=252.9min speed=16132K/sec
unused devices: <none>


Eventually:
Aug 30 17:24:07 cu kernel: md: md0: sync done.
Aug 30 17:24:07 cu kernel: RAID5 conf printout:
Aug 30 17:24:07 cu kernel:  --- rd:5 wd:4 fd:0
Aug 30 17:24:07 cu kernel:  disk 0, o:1, dev:sda1
Aug 30 17:24:07 cu kernel:  disk 1, o:1, dev:sdc1
Aug 30 17:24:07 cu kernel:  disk 2, o:1, dev:sdb1
Aug 30 17:24:07 cu kernel:  disk 3, o:1, dev:sdd1
Aug 30 17:24:07 cu kernel:  disk 4, o:1, dev:hdb1

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sdd1[3] sdc1[1] sdb1[2] sda1[0] hdb1[4]
      980446208 blocks level 5, 128k chunk, algorithm 2 [5/4] [UUUUU]

unused devices: <none>
# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Sat Jun  5 18:13:04 2004
     Raid Level : raid5
     Array Size : 980446208 (935.03 GiB 1003.98 GB)
    Device Size : 245111552 (233.76 GiB 250.99 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Aug 30 17:24:07 2004
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       33        1      active sync   /dev/sdc1
       2       8       17        2      active sync   /dev/sdb1
       3       8       49        3      active sync   /dev/sdd1
       4       3       65        4      active sync   /dev/hdb1
           UUID : 19779db7:1b41c34b:f70aa853:062c9fe5
         Events : 0.2014548

So back to normal and happy - but I guess the md0 device needs a restart 
now which is bad.

David


