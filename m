From: Christian Balzer <chibi@gol.com>
Subject: MD Raid10 recovery results in "attempt to access beyond end of
 device"
Date: Fri, 22 Jun 2012 16:06:32 +0900
Message-ID: <20120622160632.7dfbbb9d@batzmaru.gol.ad.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello,

the basics first:
Debian Squeeze, custom 3.2.18 kernel.

The Raid(s) in question are:
---
Personalities : [raid1] [raid10] 
md4 : active raid10 sdd1[0] sdb4[5](S) sdl1[4] sdk1[3] sdj1[2] sdi1[1]
      3662836224 blocks super 1.2 512K chunks 2 near-copies [5/5] [UUUUU]
      
md3 : active raid10 sdh1[7] sdc1[0] sda4[5](S) sdg1[3] sdf1[2] sde1[6]
      3662836224 blocks super 1.2 512K chunks 2 near-copies [5/4] [UUUU_]
      [=====>...............]  recovery = 28.3% (415962368/1465134592) finish=326.2min speed=53590K/sec
---

Drives sda to sdd are on nVidia MCP55 and sde to sdl on SAS1068E, sdc to
sdl are identical 1.5TB Seagates (about 2 years old, recycled from the
previous incarnation of these machines) with a single partition spanning
the whole drive like this:
---
Disk /dev/sdc: 1500.3 GB, 1500301910016 bytes
255 heads, 63 sectors/track, 182401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      182401  1465136001   fd  Linux raid autodetect
---

sda and sdb are new 2TB Hitachi drives, partitioned like this:
---
Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000d53b0

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1       31124   249999360   fd  Linux raid autodetect
/dev/sda2           31124       46686   124999680   fd  Linux raid autodetect
/dev/sda3           46686       50576    31246425   fd  Linux raid autodetect
/dev/sda4           50576      243201  1547265543+  fd  Linux raid autodetect
---

So the idea is to have 5 drives per each of the two Raid10s and one spare
on that (intentionally over-sized) fourth partition of the bigger OS
disks.

Some weeks ago a drive failed on the twin (identical everything, DRBD
replication of those 2 RAIDs) of the machine in question and everything
went according to the book, spare took over and things got rebuild, I
replaced the failed drive (sdi) later:
---
md4 : active raid10 sdi1[6](S) sdd1[0] sdb4[5] sdl1[4] sdk1[3] sdj1[2]
      3662836224 blocks super 1.2 512K chunks 2 near-copies [5/5] [UUUUU]
---

Two days ago drive sdh on the machine that's having issues failed:
---
Jun 20 18:22:39 borg03b kernel: [1383395.448043] sd 8:0:3:0: Device offlined - not ready after error recovery
Jun 20 18:22:39 borg03b kernel: [1383395.448135] sd 8:0:3:0: rejecting I/O to offline device
Jun 20 18:22:39 borg03b kernel: [1383395.452063] end_request: I/O error, dev sdh, sector 71
Jun 20 18:22:39 borg03b kernel: [1383395.452063] md: super_written gets error=-5, uptodate=0
Jun 20 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Disk failure on sdh1, disabling device.
Jun 20 18:22:39 borg03b kernel: [1383395.452063] md/raid10:md3: Operation continuing on 4 devices.
Jun 20 18:22:39 borg03b kernel: [1383395.527178] RAID10 conf printout:
Jun 20 18:22:39 borg03b kernel: [1383395.527181]  --- wd:4 rd:5
Jun 20 18:22:39 borg03b kernel: [1383395.527184]  disk 0, wo:0, o:1, dev:sdc1
Jun 20 18:22:39 borg03b kernel: [1383395.527186]  disk 1, wo:0, o:1, dev:sde1
Jun 20 18:22:39 borg03b kernel: [1383395.527189]  disk 2, wo:0, o:1, dev:sdf1
Jun 20 18:22:39 borg03b kernel: [1383395.527191]  disk 3, wo:0, o:1, dev:sdg1
Jun 20 18:22:39 borg03b kernel: [1383395.527193]  disk 4, wo:1, o:0, dev:sdh1
Jun 20 18:22:39 borg03b kernel: [1383395.568037] RAID10 conf printout:
Jun 20 18:22:39 borg03b kernel: [1383395.568040]  --- wd:4 rd:5
Jun 20 18:22:39 borg03b kernel: [1383395.568042]  disk 0, wo:0, o:1, dev:sdc1
Jun 20 18:22:39 borg03b kernel: [1383395.568045]  disk 1, wo:0, o:1, dev:sde1
Jun 20 18:22:39 borg03b kernel: [1383395.568047]  disk 2, wo:0, o:1, dev:sdf1
Jun 20 18:22:39 borg03b kernel: [1383395.568049]  disk 3, wo:0, o:1, dev:sdg1
Jun 20 18:22:39 borg03b kernel: [1383395.568060] RAID10 conf printout:
Jun 20 18:22:39 borg03b kernel: [1383395.568061]  --- wd:4 rd:5
Jun 20 18:22:39 borg03b kernel: [1383395.568063]  disk 0, wo:0, o:1, dev:sdc1
Jun 20 18:22:39 borg03b kernel: [1383395.568065]  disk 1, wo:0, o:1, dev:sde1
Jun 20 18:22:39 borg03b kernel: [1383395.568068]  disk 2, wo:0, o:1, dev:sdf1
Jun 20 18:22:39 borg03b kernel: [1383395.568070]  disk 3, wo:0, o:1, dev:sdg1
Jun 20 18:22:39 borg03b kernel: [1383395.568072]  disk 4, wo:1, o:1, dev:sda4
Jun 20 18:22:39 borg03b kernel: [1383395.568135] md: recovery of RAID array md3
Jun 20 18:22:39 borg03b kernel: [1383395.568139] md: minimum _guaranteed_  speed: 20000 KB/sec/disk.
Jun 20 18:22:39 borg03b kernel: [1383395.568142] md: using maximum available idle IO bandwidth (but not more than 500000 KB/sec) for recovery.
Jun 20 18:22:39 borg03b kernel: [1383395.568155] md: using 128k window, over a total of 1465134592k.
---

OK, spare kicked, recovery underway (from the neighbors sdg and sdc), but then:
---
Jun 21 02:29:29 borg03b kernel: [1412604.989978] attempt to access beyond end of device
Jun 21 02:29:29 borg03b kernel: [1412604.989983] sdc1: rw=0, want=2930272128, limit=2930272002
Jun 21 02:29:29 borg03b kernel: [1412604.990003] attempt to access beyond end of device
Jun 21 02:29:29 borg03b kernel: [1412604.990009] sdc1: rw=16, want=2930272008, limit=2930272002
Jun 21 02:29:29 borg03b kernel: [1412604.990013] md/raid10:md3: recovery aborted due to read error
Jun 21 02:29:29 borg03b kernel: [1412604.990025] attempt to access beyond end of device
Jun 21 02:29:29 borg03b kernel: [1412604.990028] sdc1: rw=0, want=2930272256, limit=2930272002
Jun 21 02:29:29 borg03b kernel: [1412604.990032] md: md3: recovery done.
Jun 21 02:29:29 borg03b kernel: [1412604.990035] attempt to access beyond end of device
Jun 21 02:29:29 borg03b kernel: [1412604.990038] sdc1: rw=16, want=2930272136, limit=2930272002
Jun 21 02:29:29 borg03b kernel: [1412604.990040] md/raid10:md3: recovery aborted due to read error
---

Why it would want to read data beyond the end of that device (and
partition) is a complete mystery to me, if anything was odd with this Raid
or its superblocks, surely the initial sync should have stumbled across
this as well?

After this failure the kernel goes into a log frenzy:
---
Jun 21 02:29:29 borg03b kernel: [1412605.744052] RAID10 conf printout:
Jun 21 02:29:29 borg03b kernel: [1412605.744055]  --- wd:4 rd:5
Jun 21 02:29:29 borg03b kernel: [1412605.744057]  disk 0, wo:0, o:1, dev:sdc1
Jun 21 02:29:29 borg03b kernel: [1412605.744060]  disk 1, wo:0, o:1, dev:sde1
Jun 21 02:29:29 borg03b kernel: [1412605.744062]  disk 2, wo:0, o:1, dev:sdf1
Jun 21 02:29:29 borg03b kernel: [1412605.744064]  disk 3, wo:0, o:1, dev:sdg1
---
repeating every second or so, until I "mdadm -r"ed the sda4 partition
(former spare).

On the next day I replaced the failed sdh drive with another 2TB Hitachi
(having only 1.5TB Seagates of dubious quality lying around), gave it the
same single partition size as the other drives and added it to md3.

The resync failed in the same manner:
---
Jun 21 20:59:06 borg03b kernel: [1479182.509914] attempt to access beyond end of device
Jun 21 20:59:06 borg03b kernel: [1479182.509920] sdc1: rw=0, want=2930272128, limit=2930272002
Jun 21 20:59:06 borg03b kernel: [1479182.509931] attempt to access beyond end of device
Jun 21 20:59:06 borg03b kernel: [1479182.509933] attempt to access beyond end of device
Jun 21 20:59:06 borg03b kernel: [1479182.509937] sdc1: rw=0, want=2930272256, limit=2930272002
Jun 21 20:59:06 borg03b kernel: [1479182.509942] md: md3: recovery done.
Jun 21 20:59:06 borg03b kernel: [1479182.509948] sdc1: rw=16, want=2930272008, limit=2930272002
Jun 21 20:59:06 borg03b kernel: [1479182.509952] md/raid10:md3: recovery aborted due to read error
Jun 21 20:59:06 borg03b kernel: [1479182.509963] attempt to access beyond end of device
Jun 21 20:59:06 borg03b kernel: [1479182.509965] sdc1: rw=16, want=2930272136, limit=2930272002
Jun 21 20:59:06 borg03b kernel: [1479182.509968] md/raid10:md3: recovery aborted due to read error
---

I've now scrounged up an identical 1.5TB drive and added it to the Raid
(the recovery visible in the topmost mdstat). 
If that fails as well, I'm completely lost as to what's going on, if it
succeeds though I guess we're looking at a subtle bug. 

I didn't find anything like this mentioned in the archives before, any and
all feedback would be most welcome.

Regards,

Christian
-- 
Christian Balzer        Network/Systems Engineer                
chibi@gol.com   	Global OnLine Japan/Fusion Communications
http://www.gol.com/
