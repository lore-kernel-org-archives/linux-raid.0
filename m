From: Michael Welsh Duggan <md5i@cs.cmu.edu>
Subject: RAID reconstruction problems
Date: Mon, 01 Sep 2003 23:04:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87wucrnb63.fsf@cs.cmu.edu>
Reply-To: Michael Duggan <md5i@sei.cmu.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=

I currently have two small Software RAIDs, a RAID 1 for my root
partition, and a RAID 5 for my usr partition.  One of the disks in the
arrays died, and I threw in a new disk in with the intention of
rebuilding the arrays.

The rebuilds failed, but in an extremely strange fashion.  Monitoring
/proc/mdstat, it seems that the rebuilds are going just fine.  When
they finish however, /proc/mdstat includes the new disk, but also
declares it invalid.  The system continues running in degraded mode.

When I run this from the root console, I get some messages from the
raid subsystem, including full debugging output.  I have not yet
figured out how to capture this output in order to include in this
message, but I did write down a part of one attempt (this was by hand,
so there may be small inconsistancies):

RAID5 conf printout
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target1/lun0/part3
 disk 1, s:0, o:0, n:0 rd:0 us:0 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus1/target0/lun0/part3
md: bug in file raid5.c, line 1901

Here is some output from my system.  If any more information would be
useful, or anyone thinks I should try something else, please let me
know.  I would like to get out of my currently degraded state!


--=-=-=
Content-Disposition: attachment
Content-Description: Output from my system

maru:/# uname -a
Linux maru 2.4.21 #3 Fri Aug 29 13:14:01 EDT 2003 i686 GNU/Linux
maru:/# cat ~md5i/dmesg-raid
md: raid1 personality registered as nr 3
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :  1841.200 MB/sec
   32regs    :   935.600 MB/sec
   pIII_sse  :  2052.000 MB/sec
   pII_mmx   :  2247.600 MB/sec
   p5_mmx    :  2383.200 MB/sec
raid5: using function: pIII_sse (2052.000 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
 [events: 00000198]
 [events: 00000008]
 [events: 00000196]
 [events: 000000f3]
 [events: 00000086]
 [events: 00000008]
md: autorun ...
md: considering ide/host2/bus1/target0/lun0/part3 ...
md:  adding ide/host2/bus1/target0/lun0/part3 ...
md:  adding ide/host0/bus0/target1/lun0/part3 ...
md: created md0
md: bind<ide/host0/bus0/target1/lun0/part3,1>
md: bind<ide/host2/bus1/target0/lun0/part3,2>
md: running: <ide/host2/bus1/target0/lun0/part3><ide/host0/bus0/target1/lun0/part3>
md: ide/host2/bus1/target0/lun0/part3's event counter: 00000008
md: ide/host0/bus0/target1/lun0/part3's event counter: 00000008
md0: max total readahead window set to 496k
md0: 2 data-disks, max readahead per data-disk: 248k
raid5: device ide/host2/bus1/target0/lun0/part3 operational as raid disk 2
raid5: device ide/host0/bus0/target1/lun0/part3 operational as raid disk 0
raid5: md0, not all disks are operational -- trying to recover array
raid5: allocated 3284kB for md0
raid5: raid level 5 set md0 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target1/lun0/part3
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus1/target0/lun0/part3
RAID5 conf printout:
 --- rd:3 wd:2 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:ide/host0/bus0/target1/lun0/part3
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:ide/host2/bus1/target0/lun0/part3
md: updating md0 RAID superblock on device
md: ide/host2/bus1/target0/lun0/part3 [events: 00000009]<6>(write) ide/host2/bus1/target0/lun0/part3's sb offset: 53640960
md: recovery thread got woken up ...
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: ide/host0/bus0/target1/lun0/part3 [events: 00000009]<6>(write) ide/host0/bus0/target1/lun0/part3's sb offset: 53616832
md: considering ide/host2/bus1/target0/lun0/part1 ...
md:  adding ide/host2/bus1/target0/lun0/part1 ...
md:  adding ide/host0/bus1/target0/lun0/part1 ...
md:  adding ide/host0/bus0/target1/lun0/part1 ...
md: created md1
md: bind<ide/host0/bus0/target1/lun0/part1,1>
md: bind<ide/host0/bus1/target0/lun0/part1,2>
md: bind<ide/host2/bus1/target0/lun0/part1,3>
md: running: <ide/host2/bus1/target0/lun0/part1><ide/host0/bus1/target0/lun0/part1><ide/host0/bus0/target1/lun0/part1>
md: ide/host2/bus1/target0/lun0/part1's event counter: 00000086
md: ide/host0/bus1/target0/lun0/part1's event counter: 00000196
md: ide/host0/bus0/target1/lun0/part1's event counter: 00000198
md: superblock update time inconsistency -- using the most recent one
md: freshest: ide/host0/bus0/target1/lun0/part1
md: kicking non-fresh ide/host2/bus1/target0/lun0/part1 from array!
md: unbind<ide/host2/bus1/target0/lun0/part1,2>
md: export_rdev(ide/host2/bus1/target0/lun0/part1)
md: kicking non-fresh ide/host0/bus1/target0/lun0/part1 from array!
md: unbind<ide/host0/bus1/target0/lun0/part1,1>
md: export_rdev(ide/host0/bus1/target0/lun0/part1)
md1: removing former faulty ide/host0/bus1/target0/lun0/part1!
md: RAID level 1 does not need chunksize! Continuing anyway.
md1: max total readahead window set to 124k
md1: 1 data-disks, max readahead per data-disk: 124k
raid1: device ide/host0/bus0/target1/lun0/part1 operational as mirror 0
raid1: md1, not all disks are operational -- trying to recover array
raid1: raid set md1 active with 1 out of 2 mirrors
md: updating md1 RAID superblock on device
md: ide/host0/bus0/target1/lun0/part1 [events: 00000199]<6>(write) ide/host0/bus0/target1/lun0/part1's sb offset: 6144704
md: recovery thread got woken up ...
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md0: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: considering ide/host0/bus1/target0/lun0/part3 ...
md:  adding ide/host0/bus1/target0/lun0/part3 ...
md: md0 already running, cannot run ide/host0/bus1/target0/lun0/part3
md: export_rdev(ide/host0/bus1/target0/lun0/part3)
md: (ide/host0/bus1/target0/lun0/part3 was pending)
md: ... autorun DONE.
maru:/# cat /proc/mdstat 
Personalities : [raid1] [raid5] 
read_ahead 1024 sectors
md1 : active raid1 ide/host0/bus0/target1/lun0/part1[0]
      6144704 blocks [2/1] [U_]
      
md0 : active raid5 ide/host2/bus1/target0/lun0/part3[2] ide/host0/bus0/target1/lun0/part3[0]
      107233664 blocks level 5, 32k chunk, algorithm 2 [3/2] [U_U]
      
unused devices: <none>
maru:/# lsraid -A -a /dev/md0
[dev   9,   0] /dev/md0         94BF0D82.2B9C1BFB.89401B38.92B8F93B online
[dev   3,  67] /dev/ide/host0/bus0/target1/lun0/part3 94BF0D82.2B9C1BFB.89401B38.92B8F93B good
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
[dev  34,   3] /dev/ide/host2/bus1/target0/lun0/part3 94BF0D82.2B9C1BFB.89401B38.92B8F93B good

maru:/# lsraid -A -a /dev/md1
[dev   9,   1] /dev/md1         0E953226.03C91D46.CD00D52F.83A1334E online
[dev   3,  65] /dev/ide/host0/bus0/target1/lun0/part1 0E953226.03C91D46.CD00D52F.83A1334E good
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing

maru:/# cat /etc/raidtab
raiddev /dev/md0
        raid-level      5
        nr-raid-disks   3
        nr-spare-disks  0
        persistent-superblock 1
        parity-algorithm        left-symmetric
        chunk-size      32
        device          /dev/hdb3
        raid-disk       0
        device          /dev/hdc3
        raid-disk       1
        device		/dev/hdg3
        raid-disk       2

raiddev /dev/md1
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  1
        persistent-superblock 1
        chunk-size      4
        device          /dev/hdb1
        raid-disk       0
        device          /dev/hdc1
        raid-disk       1
	device		/dev/hdg1
	spare-disk	0
maru:/# ls -l /dev/hdb1
lr-xr-xr-x    1 root     root           33 Sep  1 18:29 /dev/hdb1 -> ide/host0/bus0/target1/lun0/part1
maru:/# ls -l /dev/hdc1
lr-xr-xr-x    1 root     root           33 Sep  1 18:29 /dev/hdc1 -> ide/host0/bus1/target0/lun0/part1
maru:/# ls -l /dev/hdg1
lr-xr-xr-x    1 root     root           33 Sep  1 18:29 /dev/hdg1 -> ide/host2/bus1/target0/lun0/part1
maru:/# ls -l /dev/hdb3
lr-xr-xr-x    1 root     root           33 Sep  1 18:29 /dev/hdb3 -> ide/host0/bus0/target1/lun0/part3
maru:/# ls -l /dev/hdc3
lr-xr-xr-x    1 root     root           33 Sep  1 18:29 /dev/hdc3 -> ide/host0/bus1/target0/lun0/part3
maru:/# ls -l /dev/hdg3
lr-xr-xr-x    1 root     root           33 Sep  1 18:29 /dev/hdg3 -> ide/host2/bus1/target0/lun0/part3
maru:/# raidhotadd /dev/md1 /dev/hdc1
maru:/# echo Waited for some time...
Waited for some time...
maru:/# cat /proc/mdstat
Personalities : [raid1] [raid5] 
read_ahead 1024 sectors
md1 : active raid1 ide/host0/bus1/target0/lun0/part1[2] ide/host0/bus0/target1/lun0/part1[0]
      6144704 blocks [2/1] [U_]
      
md0 : active raid5 ide/host2/bus1/target0/lun0/part3[2] ide/host0/bus0/target1/lun0/part3[0]
      107233664 blocks level 5, 32k chunk, algorithm 2 [3/2] [U_U]
      
unused devices: <none>
maru:/# 
--=-=-=


-- 
Michael Welsh Duggan
(md5i@cs.cmu.edu)

--=-=-=--
