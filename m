From: "JaniD++" <djani22@dynamicweb.hu>
Subject: where is the spare drive? :-)
Date: Mon, 2 Jan 2006 00:26:58 +0100
Message-ID: <02a801c60f2a$de619ce0$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, list,

I found something interesting when i try to create a brand new array on
brand new drives....

1. The command was:
mdadm --create /dev/md1 --level=5 --raid-devices=12 --chunk=1024 \
/dev/hda2 /dev/hdb2 /dev/hdc2 /dev/hdd2 \
/dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2 \
/dev/sde2 /dev/sdf2 /dev/sdg2 /dev/sdh2

2. The proc/mdstat:
Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
[raid10] [f
aulty]
md1 : active raid5 sdh2[12] sdg2[10] sdf2[9] sde2[8] sdd2[7] sdc2[6] sdb2[5]
sda
2[4] hdd2[3] hdc2[2] hdb2[1] hda2[0]
      2148934656 blocks level 5, 1024k chunk, algorithm 2 [12/11]
[UUUUUUUUUUU_]
      [=>...................]  recovery =  5.7% (11308928/195357696)
finish=234.
3min speed=13088K/sec

unused devices: <none>

3. The mdadm -D
/dev/md1:
        Version : 00.90.02
  Creation Time : Sat Dec 31 12:59:51 2005
     Raid Level : raid5
     Array Size : 2148934656 (2049.38 GiB 2200.51 GB)
    Device Size : 195357696 (186.31 GiB 200.05 GB)
   Raid Devices : 12
  Total Devices : 12
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sat Dec 31 12:59:51 2005
          State : clean, degraded, recovering
 Active Devices : 11
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 1024K

 Rebuild Status : 6% complete

           UUID : 03cbaf43:19a629d2:0886920c:a696f7af
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       3        2        0      active sync   /dev/hda2
       1       3       66        1      active sync   /dev/hdb2
       2      22        2        2      active sync   /dev/hdc2
       3      22       66        3      active sync   /dev/hdd2
       4       8        2        4      active sync   /dev/sda2
       5       8       18        5      active sync   /dev/sdb2
       6       8       34        6      active sync   /dev/sdc2
       7       8       50        7      active sync   /dev/sdd2
       8       8       66        8      active sync   /dev/sde2
       9       8       82        9      active sync   /dev/sdf2
      10       8       98       10      active sync   /dev/sdg2
      12       8      114       11      spare rebuilding   /dev/sdh2


4. The end of the dmesg
md: bind<hda2>
md: bind<hdb2>
md: bind<hdc2>
md: bind<hdd2>
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: bind<sdd2>
md: bind<sde2>
md: bind<sdf2>
md: bind<sdg2>
md: bind<sdh2>
raid5: device sdg2 operational as raid disk 10
raid5: device sdf2 operational as raid disk 9
raid5: device sde2 operational as raid disk 8
raid5: device sdd2 operational as raid disk 7
raid5: device sdc2 operational as raid disk 6
raid5: device sdb2 operational as raid disk 5
raid5: device sda2 operational as raid disk 4
raid5: device hdd2 operational as raid disk 3
raid5: device hdc2 operational as raid disk 2
raid5: device hdb2 operational as raid disk 1
raid5: device hda2 operational as raid disk 0
raid5: allocated 12531kB for md1
raid5: raid level 5 set md1 active with 11 out of 12 devices, algorithm 2
RAID5 conf printout:
 --- rd:12 wd:11 fd:1
 disk 0, o:1, dev:hda2
 disk 1, o:1, dev:hdb2
 disk 2, o:1, dev:hdc2
 disk 3, o:1, dev:hdd2
 disk 4, o:1, dev:sda2
 disk 5, o:1, dev:sdb2
 disk 6, o:1, dev:sdc2
 disk 7, o:1, dev:sdd2
 disk 8, o:1, dev:sde2
 disk 9, o:1, dev:sdf2
 disk 10, o:1, dev:sdg2
RAID5 conf printout:
 --- rd:12 wd:11 fd:1
 disk 0, o:1, dev:hda2
 disk 1, o:1, dev:hdb2
 disk 2, o:1, dev:hdc2
 disk 3, o:1, dev:hdd2
 disk 4, o:1, dev:sda2
 disk 5, o:1, dev:sdb2
 disk 6, o:1, dev:sdc2
 disk 7, o:1, dev:sdd2
 disk 8, o:1, dev:sde2
 disk 9, o:1, dev:sdf2
 disk 10, o:1, dev:sdg2
 disk 11, o:1, dev:sdh2
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for reconstruction.
md: using 128k window, over a total of 195357696 blocks.

5. The question

Why shows sdh2 as spare?
The MD array size is correct.
And i really can see, the all drive is reading, and sdh2 is *ONLY* writing.

Cheers,

Janos

(Happy new year! :)


