From: Stephan van Hienen <raid@a2000.nu>
Subject: 15 * 180gb in raid5 gives 299.49 GiB ?
Date: Thu, 6 Feb 2003 01:20:14 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0302060059210.6169@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

kernel 2.4.20 / mdadm 1.0.0

[root@storage root]# mdadm -C /dev/md0  -l 5 --raid-devices 15 /dev/sdb1
/dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 /dev/sdi1
/dev/hda1 /dev/hdc1 /dev/hde1 /dev/hdi1 /dev/hdk1 /dev/hdm1 /dev/hdo1
mdadm: /dev/sdb1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sdc1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sdd1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sde1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sdf1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sdg1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sdh1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/sdi1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hda1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hdc1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hde1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hdi1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hdk1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hdm1 appear to be part of a raid array:
    level=5 devices=14 ctime=Thu Feb  6 01:04:35 2003
mdadm: /dev/hdo1 appears to contain an ext2fs file system
    size=314041600K  mtime=Thu Feb  6 00:59:13 2003
mdadm: /dev/hdo1 appear to be part of a raid array:
    level=5 devices=15 ctime=Thu Feb  6 00:54:20 2003
Continue creating array? y
mdadm: array /dev/md0 started.
[root@storage root]# cat /proc/mdstat
Personalities : [raid0] [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdo1[15] hdm1[13] hdk1[12] hdi1[11] hde1[10] hdc1[9]
hda1[8] sdi1[7] sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
      -1833441152 blocks level 5, 64k chunk, algorithm 2 [15/14]
[UUUUUUUUUUUUUU_]
      [>....................]  recovery =  0.0% (43072/175823296)
finish=203.9min speed=14357K/sec
unused devices: <none>

mdadm -D /dev/md0 :

[root@storage root]# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Thu Feb  6 01:08:46 2003
     Raid Level : raid5
     Array Size : 314042496 (299.49 GiB 321.57 GB)
    Device Size : 175823296 (167.67 GiB 180.04 GB)
   Raid Devices : 15
  Total Devices : 16
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Feb  6 01:08:46 2003
          State : dirty, no-errors
 Active Devices : 14
Working Devices : 15
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8       97        5      active sync   /dev/sdg1
       6       8      113        6      active sync   /dev/sdh1
       7       8      129        7      active sync   /dev/sdi1
       8       3        1        8      active sync   /dev/hda1
       9      22        1        9      active sync   /dev/hdc1
      10      33        1       10      active sync   /dev/hde1
      11      56        1       11      active sync   /dev/hdi1
      12      57        1       12      active sync   /dev/hdk1
      13      88        1       13      active sync   /dev/hdm1
      14       0        0       14      faulty
      15      89        1       15        /dev/hdo1
           UUID : ce36d72b:378c2ab6:3b7a43c2:184c1cf0

dmesg output :

[root@storage root]# dmesg
md: bind<sdb1,1>
md: bind<sdc1,2>
md: bind<sdd1,3>
md: bind<sde1,4>
md: bind<sdf1,5>
md: bind<sdg1,6>
md: bind<sdh1,7>
md: bind<sdi1,8>
md: bind<hda1,9>
md: bind<hdc1,10>
md: bind<hde1,11>
md: bind<hdi1,12>
md: bind<hdk1,13>
md: bind<hdm1,14>
md: bind<hdo1,15>
md: hdo1's event counter: 00000000
md: hdm1's event counter: 00000000
md: hdk1's event counter: 00000000
md: hdi1's event counter: 00000000
md: hde1's event counter: 00000000
md: hdc1's event counter: 00000000
md: hda1's event counter: 00000000
md: sdi1's event counter: 00000000
md: sdh1's event counter: 00000000
md: sdg1's event counter: 00000000
md: sdf1's event counter: 00000000
md: sde1's event counter: 00000000
md: sdd1's event counter: 00000000
md: sdc1's event counter: 00000000
md: sdb1's event counter: 00000000
md0: max total readahead window set to 3584k
md0: 14 data-disks, max readahead per data-disk: 256k
raid5: spare disk hdo1
raid5: device hdm1 operational as raid disk 13
raid5: device hdk1 operational as raid disk 12
raid5: device hdi1 operational as raid disk 11
raid5: device hde1 operational as raid disk 10
raid5: device hdc1 operational as raid disk 9
raid5: device hda1 operational as raid disk 8
raid5: device sdi1 operational as raid disk 7
raid5: device sdh1 operational as raid disk 6
raid5: device sdg1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sde1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: device sdb1 operational as raid disk 0
raid5: md0, not all disks are operational -- trying to recover array
raid5: allocated 15867kB for md0
raid5: raid level 5 set md0 active with 14 out of 15 devices, algorithm 2
RAID5 conf printout:
 --- rd:15 wd:14 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdg1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdh1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdi1
 disk 8, s:0, o:1, n:8 rd:8 us:1 dev:hda1
 disk 9, s:0, o:1, n:9 rd:9 us:1 dev:hdc1
 disk 10, s:0, o:1, n:10 rd:10 us:1 dev:hde1
 disk 11, s:0, o:1, n:11 rd:11 us:1 dev:hdi1
 disk 12, s:0, o:1, n:12 rd:12 us:1 dev:hdk1
 disk 13, s:0, o:1, n:13 rd:13 us:1 dev:hdm1
 disk 14, s:0, o:0, n:14 rd:14 us:1 dev:[dev 00:00]
RAID5 conf printout:
md: recovery thread got woken up ...
md0: resyncing spare disk hdo1 to replace failed disk
RAID5 conf printout:
 --- rd:15 wd:14 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdg1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdh1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdi1
 disk 8, s:0, o:1, n:8 rd:8 us:1 dev:hda1
 disk 9, s:0, o:1, n:9 rd:9 us:1 dev:hdc1
 disk 10, s:0, o:1, n:10 rd:10 us:1 dev:hde1
 disk 11, s:0, o:1, n:11 rd:11 us:1 dev:hdi1
 disk 12, s:0, o:1, n:12 rd:12 us:1 dev:hdk1
 disk 13, s:0, o:1, n:13 rd:13 us:1 dev:hdm1
 disk 14, s:0, o:0, n:14 rd:14 us:1 dev:[dev 00:00]
RAID5 conf printout:
 --- rd:15 wd:14 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdg1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdh1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdi1
 disk 8, s:0, o:1, n:8 rd:8 us:1 dev:hda1
 disk 9, s:0, o:1, n:9 rd:9 us:1 dev:hdc1
 disk 10, s:0, o:1, n:10 rd:10 us:1 dev:hde1
 disk 11, s:0, o:1, n:11 rd:11 us:1 dev:hdi1
 disk 12, s:0, o:1, n:12 rd:12 us:1 dev:hdk1
 disk 13, s:0, o:1, n:13 rd:13 us:1 dev:hdm1
 disk 14, s:0, o:0, n:14 rd:14 us:1 dev:[dev 00:00]
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000
KB/sec) for reconstruction.
md: using 124k window, over a total of 175823296 blocks.
 --- rd:15 wd:14 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sdb1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdc1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdd1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sde1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sdf1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdg1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdh1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdi1
 disk 8, s:0, o:1, n:8 rd:8 us:1 dev:hda1
 disk 9, s:0, o:1, n:9 rd:9 us:1 dev:hdc1
 disk 10, s:0, o:1, n:10 rd:10 us:1 dev:hde1
 disk 11, s:0, o:1, n:11 rd:11 us:1 dev:hdi1
 disk 12, s:0, o:1, n:12 rd:12 us:1 dev:hdk1
 disk 13, s:0, o:1, n:13 rd:13 us:1 dev:hdm1
 disk 14, s:0, o:0, n:14 rd:14 us:1 dev:[dev 00:00]
md: updating md0 RAID superblock on device
md: hdo1 [events: 00000001]<6>(write) hdo1's sb offset: 175823296
md: hdm1 [events: 00000001]<6>(write) hdm1's sb offset: 175823296
md: hdk1 [events: 00000001]<6>(write) hdk1's sb offset: 175823296
md: hdi1 [events: 00000001]<6>(write) hdi1's sb offset: 175823296
md: hde1 [events: 00000001]<6>(write) hde1's sb offset: 175823296
md: hdc1 [events: 00000001]<6>(write) hdc1's sb offset: 175823296
md: hda1 [events: 00000001]<6>(write) hda1's sb offset: 175823296
md: sdi1 [events: 00000001]<6>(write) sdi1's sb offset: 175823296
md: sdh1 [events: 00000001]<6>(write) sdh1's sb offset: 175823296
md: sdg1 [events: 00000001]<6>(write) sdg1's sb offset: 175823296
md: sdf1 [events: 00000001]<6>(write) sdf1's sb offset: 175823296
md: sde1 [events: 00000001]<6>(write) sde1's sb offset: 175823296
md: sdd1 [events: 00000001]<6>(write) sdd1's sb offset: 175823296
md: sdc1 [events: 00000001]<6>(write) sdc1's sb offset: 175823296
md: sdb1 [events: 00000001]<6>(write) sdb1's sb offset: 175823296

also trying to create filesystem :

[root@storage root]# mke2fs  -b 4096 -R stride=32 -j -m 0 /dev/md0
mke2fs 1.27 (8-Mar-2002)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
39256064 inodes, 78510624 blocks
0 blocks (0.00%) reserved for the super user
First data block=0
2396 block groups
32768 blocks per group, 32768 fragments per group
16384 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632,
2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616

Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 28 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

[root@storage root]# mount /dev/md0 /raid/
[root@storage root]# df /raid/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md0             309115040     32828 309082212   1% /raid


with 14 devices :

    Array Size : 138219200 (131.81 GiB 141.53 GB)
    Device Size : 175823296 (167.67 GiB 180.04 GB)
   Raid Devices : 14
  Total Devices : 15

and with 13 devices :

     Array Size : 2109879552 (2012.13 GiB 2160.51 GB)
    Device Size : 175823296 (167.67 GiB 180.04 GB)
   Raid Devices : 13
  Total Devices : 14

