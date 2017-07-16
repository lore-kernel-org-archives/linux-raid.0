From: Bogo Mipps <bogo.mipps@gmail.com>
Subject: Have I any chance of restoring my Raid6 data?
Date: Mon, 17 Jul 2017 10:14:09 +1200
Message-ID: <90ab63b9-3a4b-06fa-d66b-d212ee4ae94f@gmail.com>
Reply-To: bogo.mipps@gmail.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------F87319FD11BDA10FEB34F2B9"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------F87319FD11BDA10FEB34F2B9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Have been running a 4 disk Raid 6 setup for over two years without any 
issues, until suddenly on June 27 disks on my OpenMediaVault NAS became 
100% full, including the NFS mounted volumes in the raid set. There'd 
been major disk activity overnight, but foolishly didn't investigate.

Rsnapshot normally backs up two desktop machines onto the raid setup: 
the next morning found that one of the backup directories was not on 
raid but suddenly was on the root directory of the OMV machine, and
being a total backup (several Gb) this accounted for the 100% reading 
for the OMV/NAS machine.

The logs indicated that mdstat had discovered "dirty degraded array" 
presumably due to faulty sdb, so had withdrawn that disk, and then 
couldn't run the raid set (logs below show)

Bought a new disk and installed on July 4, and raid rebuilt overnight 
(see July 5 Rebuild finished below)

Since then I've been unable to mount or access any data. Have followed 
instructions as per Linux Raid Wiki's "Recovering a failed software 
RAID" & "RAID Recovery" , but still no success. I've attached the 
results of their suggestions in the attached log file 
"linux_raid_wiki_logs.txt".

Is there a chance of restoring my data?

P.S. This line looks ominous? <md0: detected capacity change from 
4000528203776 to 0> !!!

===============Jun 27 16:52:21 keruru kernel: [ 2.912440] md: md0 stopped.
Jun 27 16:52:21 keruru kernel: [ 2.922315] md: bind<sdb>
Jun 27 16:52:21 keruru kernel: [ 2.922508] md: bind<sdc>
Jun 27 16:52:21 keruru kernel: [ 2.922643] md: bind<sde>
Jun 27 16:52:21 keruru kernel: [ 2.922777] md: bind<sdd>
Jun 27 16:52:21 keruru kernel: [ 2.922808] md: kicking non-fresh sdb 
from array!
Jun 27 16:52:21 keruru kernel: [ 2.922820] md: unbind<sdb>
Jun 27 16:52:21 keruru kernel: [ 2.927107] md: export_rdev(sdb)
Jun 27 16:52:21 keruru kernel: [ 2.994973] raid6: sse2x1 588 MB/s
Jun 27 16:52:21 keruru kernel: [ 3.062926] raid6: sse2x2 1395 MB/s
Jun 27 16:52:21 keruru kernel: [ 3.130841] raid6: sse2x4 2397 MB/s
Jun 27 16:52:21 keruru kernel: [ 3.130844] raid6: using algorithm sse2x4 
(2397 MB/s)
Jun 27 16:52:21 keruru kernel: [ 3.130846] raid6: using ssse3x2 recovery 
algorithm
Jun 27 16:52:21 keruru kernel: [ 3.130866] Switched to clocksource tsc
Jun 27 16:52:21 keruru kernel: [ 3.131227] xor: automatically using best 
checksumming function:
Jun 27 16:52:21 keruru kernel: [ 3.170797] avx : 6164.000 MB/sec
Jun 27 16:52:21 keruru kernel: [ 3.171121] async_tx: api initialized (async)
Jun 27 16:52:21 keruru kernel: [ 3.172809] md: raid6 personality 
registered for level 6
Jun 27 16:52:21 keruru kernel: [ 3.172812] md: raid5 personality 
registered for level 5
Jun 27 16:52:21 keruru kernel: [ 3.172815] md: raid4 personality 
registered for level 4
Jun 27 16:52:21 keruru kernel: [ 3.173218] md/raid:md0: not clean -- 
starting background reconstruction
Jun 27 16:52:21 keruru kernel: [ 3.173236] md/raid:md0: device sdd 
operational as raid disk 1
Jun 27 16:52:21 keruru kernel: [ 3.173239] md/raid:md0: device sde 
operational as raid disk 3
Jun 27 16:52:21 keruru kernel: [ 3.173242] md/raid:md0: device sdc 
operational as raid disk 2
Jun 27 16:52:21 keruru kernel: [ 3.173706] md/raid:md0: allocated 0kB
Jun 27 16:52:21 keruru kernel: [ 3.173745] md/raid:md0: cannot start 
dirty degraded array.
Jun 27 16:52:21 keruru kernel: [ 3.173811] RAID conf printout:
Jun 27 16:52:21 keruru kernel: [ 3.173814] --- level:6 rd:4 wd:3
Jun 27 16:52:21 keruru kernel: [ 3.173816] disk 1, o:1, dev:sdd
Jun 27 16:52:21 keruru kernel: [ 3.173818] disk 2, o:1, dev:sdc
Jun 27 16:52:21 keruru kernel: [ 3.173820] disk 3, o:1, dev:sde
Jun 27 16:52:21 keruru kernel: [ 3.174025] md/raid:md0: failed to run 
raid set.
Jun 27 16:52:21 keruru kernel: [ 3.174071] md: pers->run() failed ...
===============
New disk added - sdb
===============
Jul 5 21:06:18 keruru mdadm[2497]: RebuildFinished event detected on md 
device /dev/md0, component device mismatches found: 1847058224 (on raid 
level 6)
Jul 6 09:45:52 keruru kernel: [ 1195.390879] raid6: sse2x1 249 MB/s
Jul 6 09:45:52 keruru kernel: [ 1195.458735] raid6: sse2x2 476 MB/s
Jul 6 09:45:52 keruru kernel: [ 1195.526632] raid6: sse2x4 839 MB/s
Jul 6 09:45:52 keruru kernel: [ 1195.526638] raid6: using algorithm 
sse2x4 (839 MB/s)
Jul 6 09:45:52 keruru kernel: [ 1195.526644] raid6: using ssse3x2 
recovery algorithm
Jul 6 09:45:52 keruru kernel: [ 1195.578970] md: raid6 personality 
registered for level 6
Jul 6 09:45:52 keruru kernel: [ 1195.578980] md: raid5 personality 
registered for level 5
Jul 6 09:45:52 keruru kernel: [ 1195.578985] md: raid4 personality 
registered for level 4
Jul 6 09:45:52 keruru kernel: [ 1195.580003] md/raid:md0: device sdb 
operational as raid disk 0
Jul 6 09:45:52 keruru kernel: [ 1195.580012] md/raid:md0: device sde 
operational as raid disk 3
Jul 6 09:45:52 keruru kernel: [ 1195.580018] md/raid:md0: device sdd 
operational as raid disk 2
Jul 6 09:45:52 keruru kernel: [ 1195.580025] md/raid:md0: device sdc 
operational as raid disk 1
Jul 6 09:45:52 keruru kernel: [ 1195.581091] md/raid:md0: allocated 0kB
Jul 6 09:45:52 keruru kernel: [ 1195.581180] md/raid:md0: raid level 6 
active with 4 out of 4 devices, algorithm 2
Jul 6 09:52:30 keruru kernel: [ 4.186106] raid6: sse2x1 602 MB/s
Jul 6 09:52:30 keruru kernel: [ 4.254006] raid6: sse2x2 906 MB/s
Jul 6 09:52:30 keruru kernel: [ 4.186106] raid6: sse2x1 602 MB/s
Jul 6 09:52:30 keruru kernel: [ 4.254006] raid6: sse2x2 906 MB/s
Jul 6 09:52:30 keruru kernel: [ 4.321957] raid6: sse2x4 1130 MB/s
Jul 6 09:52:30 keruru kernel: [ 4.321964] raid6: using algorithm sse2x4 
(1130 MB/s)
Jul 6 09:52:30 keruru kernel: [ 4.321967] raid6: using ssse3x2 recovery 
algorithm
Jul 6 09:52:30 keruru kernel: [ 4.368478] md: raid6 personality 
registered for level 6
Jul 6 09:52:30 keruru kernel: [ 4.368486] md: raid5 personality 
registered for level 5
Jul 6 09:52:30 keruru kernel: [ 4.368490] md: raid4 personality 
registered for level 4
Jul 6 09:52:30 keruru kernel: [ 4.369179] md/raid:md0: device sdb 
operational as raid disk 0
Jul 6 09:52:30 keruru kernel: [ 4.369185] md/raid:md0: device sde 
operational as raid disk 3
Jul 6 09:52:30 keruru kernel: [ 4.369189] md/raid:md0: device sdd 
operational as raid disk 2
Jul 6 09:52:30 keruru kernel: [ 4.369194] md/raid:md0: device sdc 
operational as raid disk 1
Jul 6 09:52:30 keruru kernel: [ 4.369974] md/raid:md0: allocated 0kB
Jul 6 09:52:30 keruru kernel: [ 4.372062] md/raid:md0: raid level 6 
active with 4 out of 4 devices, algorithm 2
Jul 6 12:56:15 keruru kernel: [ 4.442184] raid6: sse2x1 739 MB/s
Jul 6 12:56:15 keruru kernel: [ 4.510060] raid6: sse2x2 1480 MB/s
Jul 6 12:56:15 keruru kernel: [ 4.577985] raid6: sse2x4 1605 MB/s
Jul 6 12:56:15 keruru kernel: [ 4.577993] raid6: using algorithm sse2x4 
(1605 MB/s)
Jul 6 12:56:15 keruru kernel: [ 4.577997] raid6: using ssse3x2 recovery 
algorithm
Jul 6 12:56:15 keruru kernel: [ 4.622570] md: raid6 personality 
registered for level 6
Jul 6 12:56:15 keruru kernel: [ 4.622577] md: raid5 personality 
registered for level 5
Jul 6 12:56:15 keruru kernel: [ 4.622580] md: raid4 personality 
registered for level 4
Jul 6 12:56:15 keruru kernel: [ 4.623261] md/raid:md0: device sdb 
operational as raid disk 0
Jul 6 12:56:15 keruru kernel: [ 4.623266] md/raid:md0: device sde 
operational as raid disk 3
Jul 6 12:56:15 keruru kernel: [ 4.623269] md/raid:md0: device sdd 
operational as raid disk 2
Jul 6 12:56:15 keruru kernel: [ 4.623273] md/raid:md0: device sdc 
operational as raid disk 1
Jul 6 12:56:15 keruru kernel: [ 4.624064] md/raid:md0: allocated 0kB
Jul 6 12:56:15 keruru kernel: [ 4.624131] md/raid:md0: raid level 6 
active with 4 out of 4 devices, algorithm 2
Jul 6 16:54:43 keruru kernel: [14401.858429] md/raid:md0: device sdb 
operational as raid disk 0
Jul 6 16:54:43 keruru kernel: [14401.858442] md/raid:md0: device sde 
operational as raid disk 3
Jul 6 16:54:43 keruru kernel: [14401.858449] md/raid:md0: device sdd 
operational as raid disk 2
Jul 6 16:54:43 keruru kernel: [14401.858455] md/raid:md0: device sdc 
operational as raid disk 1
Jul 6 16:54:43 keruru kernel: [14401.859915] md/raid:md0: allocated 0kB
Jul 6 16:54:43 keruru kernel: [14401.860000] md/raid:md0: raid level 6 
active with 4 out of 4 devices, algorithm 2

linux_raid_wiki_logs.txt

root@keruru:/var/log# mdadm --examine /dev/sd[bedc] >> raid.status
root@keruru:/var/log# cat raid.status
/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
            Name : keruru:0  (local to host keruru)
   Creation Time : Fri Jun 30 15:42:27 2017
      Raid Level : raid6
    Raid Devices : 4

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 79e4933f:dfe5923f:5ba03ae7:3efe38eb

     Update Time : Wed Jul  5 21:06:18 2017
        Checksum : 9ff2b025 - correct
          Events : 119

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing)
/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
            Name : keruru:0  (local to host keruru)
   Creation Time : Fri Jun 30 15:42:27 2017
      Raid Level : raid6
    Raid Devices : 4

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : f1e1a946:711886a6:2604780f:8eba4a2d

     Update Time : Wed Jul  5 21:06:18 2017
        Checksum : 784b0046 - correct
          Events : 119

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
            Name : keruru:0  (local to host keruru)
   Creation Time : Fri Jun 30 15:42:27 2017
      Raid Level : raid6
    Raid Devices : 4

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : cf3bc8a7:9feed87d:945d8e77:08f7f32d

     Update Time : Wed Jul  5 21:06:18 2017
        Checksum : 197bc63c - correct
          Events : 119

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : b1e6af5d:e5848ebe:63727445:2ab99719
            Name : keruru:0  (local to host keruru)
   Creation Time : Fri Jun 30 15:42:27 2017
      Raid Level : raid6
    Raid Devices : 4

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 3906765824 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b3323d81:279b7c7b:a0c534ed:46d0e6fc

     Update Time : Wed Jul  5 21:06:18 2017
        Checksum : 352daaf4 - correct
          Events : 119

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing)
================
root@keruru:/var/log# mdadm --examine /dev/sd[bedc] | egrep 'Event|/dev/sd'
/dev/sdb:
          Events : 119
/dev/sdc:
          Events : 119
/dev/sdd:
          Events : 119
/dev/sde:
          Events : 119
===============
root@keruru:/var/log# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
root@keruru:/var/log# mdadm --assemble --force /dev/md0 /dev/sdb 
/dev/sde /dev/sdd /dev/sdc
mdadm: /dev/md0 has been started with 4 drives.
root@keruru:/var/log# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid6 sdb[4] sde[3] sdd[2] sdc[1]
       3906765824 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[4/4] [UUUU]

unused devices: <none>
===============
root@keruru:/var/log# grep Role raid.status
    Device Role : Active device 0
    Device Role : Active device 1
    Device Role : Active device 2
    Device Role : Active device 3
===============
root@keruru:/var/log# grep Used raid.status
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
   Used Dev Size : 3906765824 (1862.89 GiB 2000.26 GB)
===============
root@keruru:/var/log# mdadm --create --assume-clean --level=6 
--raid-devices=4 --size=1953382912 /dev/md0 /dev/sdb /dev/sde /dev/sdd 
/dev/sdc
mdadm: /dev/sdb appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
mdadm: partition table exists on /dev/sdb but will be lost or
        meaningless after creating array
mdadm: /dev/sde appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
mdadm: /dev/sdd appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
mdadm: /dev/sdc appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
Continue creating array? n
mdadm: create aborted.
===============
root@keruru:/var/log# mdadm --create --assume-clean --level=6 
--raid-devices=4 --size=1953382912 /dev/md0 /dev/sdb /dev/sde /dev/sdd 
/dev/sdc
mdadm: /dev/sdb appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
mdadm: partition table exists on /dev/sdb but will be lost or
        meaningless after creating array
mdadm: /dev/sde appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
mdadm: /dev/sdd appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
mdadm: /dev/sdc appears to be part of a raid array:
     level=raid6 devices=4 ctime=Fri Jun 30 15:42:27 2017
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
===============
root@keruru:/# mount -t ext4 /dev/md0 /mnt/md0
mount: wrong fs type, bad option, bad superblock on /dev/md0,
        missing codepage or helper program, or other error
        In some cases useful info is found in syslog - try
        dmesg | tail  or so
===============
root@keruru:/# dmesg | tail
[448318.800806]  --- level:6 rd:4 wd:4
[448318.800812]  disk 0, o:1, dev:sdb
[448318.800817]  disk 1, o:1, dev:sde
[448318.800822]  disk 2, o:1, dev:sdd
[448318.800827]  disk 3, o:1, dev:sdc
[448318.800951] md0: detected capacity change from 0 to 4000528203776
[448318.809375]  md0: unknown partition table
[448358.704189] EXT4-fs (md0): Unrecognized mount option "\x08" or 
missing value
[448358.706680] EXT4-fs (md0): failed to parse options in superblock: \x08
[448358.706690] EXT4-fs (md0): Number of reserved GDT blocks insanely 
large: 9216
===============
Jul 11 17:23:15 keruru kernel: [447719.812775] md: export_rdev(sdd)
Jul 11 17:23:19 keruru kernel: [447724.396327] md: md0 stopped.
Jul 11 17:23:19 keruru kernel: [447724.400278] md: bind<sdc>
Jul 11 17:32:29 keruru kernel: [448273.001687] md0: detected capacity 
change from 4000528203776 to 0
Jul 11 17:32:29 keruru kernel: [448273.001714] md: md0 stopped.
Jul 11 17:32:29 keruru kernel: [448273.001729] md: unbind<sdc>
Jul 11 17:32:29 keruru kernel: [448273.022972] md: export_rdev(sdc)
Jul 11 17:32:29 keruru kernel: [448273.023143] md: unbind<sde>
Jul 11 17:32:29 keruru kernel: [448273.054889] md: export_rdev(sde)
Jul 11 17:32:29 keruru kernel: [448273.055035] md: unbind<sdd>
Jul 11 17:32:29 keruru kernel: [448273.086870] md: export_rdev(sdd)
Jul 11 17:33:14 keruru kernel: [448318.800827]  disk 3, o:1, dev:sdc
===============


--------------F87319FD11BDA10FEB34F2B9
Content-Type: text/plain; charset=UTF-8;
 name="linux_raid_wiki_logs.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="linux_raid_wiki_logs.txt"

cm9vdEBrZXJ1cnU6L3Zhci9sb2cjIG1kYWRtIC0tZXhhbWluZSAvZGV2L3NkW2JlZGNdID4+
IHJhaWQuc3RhdHVzCnJvb3RAa2VydXJ1Oi92YXIvbG9nIyBjYXQgcmFpZC5zdGF0dXMgCi9k
ZXYvc2RiOgogICAgICAgICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAx
LjIKICAgIEZlYXR1cmUgTWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGIxZTZhZjVkOmU1
ODQ4ZWJlOjYzNzI3NDQ1OjJhYjk5NzE5CiAgICAgICAgICAgTmFtZSA6IGtlcnVydTowICAo
bG9jYWwgdG8gaG9zdCBrZXJ1cnUpCiAgQ3JlYXRpb24gVGltZSA6IEZyaSBKdW4gMzAgMTU6
NDI6MjcgMjAxNwogICAgIFJhaWQgTGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA0
CgogQXZhaWwgRGV2IFNpemUgOiAzOTA2NzY3MDI0ICgxODYyLjg5IEdpQiAyMDAwLjI2IEdC
KQogICAgIEFycmF5IFNpemUgOiAzOTA2NzY1ODI0ICgzNzI1Ljc4IEdpQiA0MDAwLjUzIEdC
KQogIFVzZWQgRGV2IFNpemUgOiAzOTA2NzY1ODI0ICgxODYyLjg5IEdpQiAyMDAwLjI2IEdC
KQogICAgRGF0YSBPZmZzZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4
IHNlY3RvcnMKICAgICAgICAgIFN0YXRlIDogY2xlYW4KICAgIERldmljZSBVVUlEIDogNzll
NDkzM2Y6ZGZlNTkyM2Y6NWJhMDNhZTc6M2VmZTM4ZWIKCiAgICBVcGRhdGUgVGltZSA6IFdl
ZCBKdWwgIDUgMjE6MDY6MTggMjAxNwogICAgICAgQ2hlY2tzdW0gOiA5ZmYyYjAyNSAtIGNv
cnJlY3QKICAgICAgICAgRXZlbnRzIDogMTE5CgogICAgICAgICBMYXlvdXQgOiBsZWZ0LXN5
bW1ldHJpYwogICAgIENodW5rIFNpemUgOiA1MTJLCgogICBEZXZpY2UgUm9sZSA6IEFjdGl2
ZSBkZXZpY2UgMAogICBBcnJheSBTdGF0ZSA6IEFBQUEgKCdBJyA9PSBhY3RpdmUsICcuJyA9
PSBtaXNzaW5nKQovZGV2L3NkYzoKICAgICAgICAgIE1hZ2ljIDogYTkyYjRlZmMKICAgICAg
ICBWZXJzaW9uIDogMS4yCiAgICBGZWF0dXJlIE1hcCA6IDB4MAogICAgIEFycmF5IFVVSUQg
OiBiMWU2YWY1ZDplNTg0OGViZTo2MzcyNzQ0NToyYWI5OTcxOQogICAgICAgICAgIE5hbWUg
OiBrZXJ1cnU6MCAgKGxvY2FsIHRvIGhvc3Qga2VydXJ1KQogIENyZWF0aW9uIFRpbWUgOiBG
cmkgSnVuIDMwIDE1OjQyOjI3IDIwMTcKICAgICBSYWlkIExldmVsIDogcmFpZDYKICAgUmFp
ZCBEZXZpY2VzIDogNAoKIEF2YWlsIERldiBTaXplIDogMzkwNjc2NzAyNCAoMTg2Mi44OSBH
aUIgMjAwMC4yNiBHQikKICAgICBBcnJheSBTaXplIDogMzkwNjc2NTgyNCAoMzcyNS43OCBH
aUIgNDAwMC41MyBHQikKICBVc2VkIERldiBTaXplIDogMzkwNjc2NTgyNCAoMTg2Mi44OSBH
aUIgMjAwMC4yNiBHQikKICAgIERhdGEgT2Zmc2V0IDogMjYyMTQ0IHNlY3RvcnMKICAgU3Vw
ZXIgT2Zmc2V0IDogOCBzZWN0b3JzCiAgICAgICAgICBTdGF0ZSA6IGNsZWFuCiAgICBEZXZp
Y2UgVVVJRCA6IGYxZTFhOTQ2OjcxMTg4NmE2OjI2MDQ3ODBmOjhlYmE0YTJkCgogICAgVXBk
YXRlIFRpbWUgOiBXZWQgSnVsICA1IDIxOjA2OjE4IDIwMTcKICAgICAgIENoZWNrc3VtIDog
Nzg0YjAwNDYgLSBjb3JyZWN0CiAgICAgICAgIEV2ZW50cyA6IDExOQoKICAgICAgICAgTGF5
b3V0IDogbGVmdC1zeW1tZXRyaWMKICAgICBDaHVuayBTaXplIDogNTEySwoKICAgRGV2aWNl
IFJvbGUgOiBBY3RpdmUgZGV2aWNlIDEKICAgQXJyYXkgU3RhdGUgOiBBQUFBICgnQScgPT0g
YWN0aXZlLCAnLicgPT0gbWlzc2luZykKL2Rldi9zZGQ6CiAgICAgICAgICBNYWdpYyA6IGE5
MmI0ZWZjCiAgICAgICAgVmVyc2lvbiA6IDEuMgogICAgRmVhdHVyZSBNYXAgOiAweDAKICAg
ICBBcnJheSBVVUlEIDogYjFlNmFmNWQ6ZTU4NDhlYmU6NjM3Mjc0NDU6MmFiOTk3MTkKICAg
ICAgICAgICBOYW1lIDoga2VydXJ1OjAgIChsb2NhbCB0byBob3N0IGtlcnVydSkKICBDcmVh
dGlvbiBUaW1lIDogRnJpIEp1biAzMCAxNTo0MjoyNyAyMDE3CiAgICAgUmFpZCBMZXZlbCA6
IHJhaWQ2CiAgIFJhaWQgRGV2aWNlcyA6IDQKCiBBdmFpbCBEZXYgU2l6ZSA6IDM5MDY3Njcw
MjQgKDE4NjIuODkgR2lCIDIwMDAuMjYgR0IpCiAgICAgQXJyYXkgU2l6ZSA6IDM5MDY3NjU4
MjQgKDM3MjUuNzggR2lCIDQwMDAuNTMgR0IpCiAgVXNlZCBEZXYgU2l6ZSA6IDM5MDY3NjU4
MjQgKDE4NjIuODkgR2lCIDIwMDAuMjYgR0IpCiAgICBEYXRhIE9mZnNldCA6IDI2MjE0NCBz
ZWN0b3JzCiAgIFN1cGVyIE9mZnNldCA6IDggc2VjdG9ycwogICAgICAgICAgU3RhdGUgOiBj
bGVhbgogICAgRGV2aWNlIFVVSUQgOiBjZjNiYzhhNzo5ZmVlZDg3ZDo5NDVkOGU3NzowOGY3
ZjMyZAoKICAgIFVwZGF0ZSBUaW1lIDogV2VkIEp1bCAgNSAyMTowNjoxOCAyMDE3CiAgICAg
ICBDaGVja3N1bSA6IDE5N2JjNjNjIC0gY29ycmVjdAogICAgICAgICBFdmVudHMgOiAxMTkK
CiAgICAgICAgIExheW91dCA6IGxlZnQtc3ltbWV0cmljCiAgICAgQ2h1bmsgU2l6ZSA6IDUx
MksKCiAgIERldmljZSBSb2xlIDogQWN0aXZlIGRldmljZSAyCiAgIEFycmF5IFN0YXRlIDog
QUFBQSAoJ0EnID09IGFjdGl2ZSwgJy4nID09IG1pc3NpbmcpCi9kZXYvc2RlOgogICAgICAg
ICAgTWFnaWMgOiBhOTJiNGVmYwogICAgICAgIFZlcnNpb24gOiAxLjIKICAgIEZlYXR1cmUg
TWFwIDogMHgwCiAgICAgQXJyYXkgVVVJRCA6IGIxZTZhZjVkOmU1ODQ4ZWJlOjYzNzI3NDQ1
OjJhYjk5NzE5CiAgICAgICAgICAgTmFtZSA6IGtlcnVydTowICAobG9jYWwgdG8gaG9zdCBr
ZXJ1cnUpCiAgQ3JlYXRpb24gVGltZSA6IEZyaSBKdW4gMzAgMTU6NDI6MjcgMjAxNwogICAg
IFJhaWQgTGV2ZWwgOiByYWlkNgogICBSYWlkIERldmljZXMgOiA0CgogQXZhaWwgRGV2IFNp
emUgOiAzOTA2NzY3MDI0ICgxODYyLjg5IEdpQiAyMDAwLjI2IEdCKQogICAgIEFycmF5IFNp
emUgOiAzOTA2NzY1ODI0ICgzNzI1Ljc4IEdpQiA0MDAwLjUzIEdCKQogIFVzZWQgRGV2IFNp
emUgOiAzOTA2NzY1ODI0ICgxODYyLjg5IEdpQiAyMDAwLjI2IEdCKQogICAgRGF0YSBPZmZz
ZXQgOiAyNjIxNDQgc2VjdG9ycwogICBTdXBlciBPZmZzZXQgOiA4IHNlY3RvcnMKICAgICAg
ICAgIFN0YXRlIDogY2xlYW4KICAgIERldmljZSBVVUlEIDogYjMzMjNkODE6Mjc5YjdjN2I6
YTBjNTM0ZWQ6NDZkMGU2ZmMKCiAgICBVcGRhdGUgVGltZSA6IFdlZCBKdWwgIDUgMjE6MDY6
MTggMjAxNwogICAgICAgQ2hlY2tzdW0gOiAzNTJkYWFmNCAtIGNvcnJlY3QKICAgICAgICAg
RXZlbnRzIDogMTE5CgogICAgICAgICBMYXlvdXQgOiBsZWZ0LXN5bW1ldHJpYwogICAgIENo
dW5rIFNpemUgOiA1MTJLCgogICBEZXZpY2UgUm9sZSA6IEFjdGl2ZSBkZXZpY2UgMwogICBB
cnJheSBTdGF0ZSA6IEFBQUEgKCdBJyA9PSBhY3RpdmUsICcuJyA9PSBtaXNzaW5nKQo9PT09
PT09PT09PT09PT09CnJvb3RAa2VydXJ1Oi92YXIvbG9nIyBtZGFkbSAtLWV4YW1pbmUgL2Rl
di9zZFtiZWRjXSB8IGVncmVwICdFdmVudHwvZGV2L3NkJwovZGV2L3NkYjoKICAgICAgICAg
RXZlbnRzIDogMTE5Ci9kZXYvc2RjOgogICAgICAgICBFdmVudHMgOiAxMTkKL2Rldi9zZGQ6
CiAgICAgICAgIEV2ZW50cyA6IDExOQovZGV2L3NkZToKICAgICAgICAgRXZlbnRzIDogMTE5
Cj09PT09PT09PT09PT09PQpyb290QGtlcnVydTovdmFyL2xvZyMgbWRhZG0gLS1zdG9wIC9k
ZXYvbWQwCm1kYWRtOiBzdG9wcGVkIC9kZXYvbWQwCnJvb3RAa2VydXJ1Oi92YXIvbG9nIyBt
ZGFkbSAtLWFzc2VtYmxlIC0tZm9yY2UgL2Rldi9tZDAgL2Rldi9zZGIgL2Rldi9zZGUgL2Rl
di9zZGQgL2Rldi9zZGMKbWRhZG06IC9kZXYvbWQwIGhhcyBiZWVuIHN0YXJ0ZWQgd2l0aCA0
IGRyaXZlcy4Kcm9vdEBrZXJ1cnU6L3Zhci9sb2cjIGNhdCAvcHJvYy9tZHN0YXQgClBlcnNv
bmFsaXRpZXMgOiBbcmFpZDZdIFtyYWlkNV0gW3JhaWQ0XSAKbWQwIDogYWN0aXZlIChhdXRv
LXJlYWQtb25seSkgcmFpZDYgc2RiWzRdIHNkZVszXSBzZGRbMl0gc2RjWzFdCiAgICAgIDM5
MDY3NjU4MjQgYmxvY2tzIHN1cGVyIDEuMiBsZXZlbCA2LCA1MTJrIGNodW5rLCBhbGdvcml0
aG0gMiBbNC80XSBbVVVVVV0KICAgICAgCnVudXNlZCBkZXZpY2VzOiA8bm9uZT4KPT09PT09
PT09PT09PT09CnJvb3RAa2VydXJ1Oi92YXIvbG9nIyBncmVwIFJvbGUgcmFpZC5zdGF0dXMK
ICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDAKICAgRGV2aWNlIFJvbGUgOiBBY3Rp
dmUgZGV2aWNlIDEKICAgRGV2aWNlIFJvbGUgOiBBY3RpdmUgZGV2aWNlIDIKICAgRGV2aWNl
IFJvbGUgOiBBY3RpdmUgZGV2aWNlIDMKPT09PT09PT09PT09PT09CnJvb3RAa2VydXJ1Oi92
YXIvbG9nIyBncmVwIFVzZWQgcmFpZC5zdGF0dXMKICBVc2VkIERldiBTaXplIDogMzkwNjc2
NTgyNCAoMTg2Mi44OSBHaUIgMjAwMC4yNiBHQikKICBVc2VkIERldiBTaXplIDogMzkwNjc2
NTgyNCAoMTg2Mi44OSBHaUIgMjAwMC4yNiBHQikKICBVc2VkIERldiBTaXplIDogMzkwNjc2
NTgyNCAoMTg2Mi44OSBHaUIgMjAwMC4yNiBHQikKICBVc2VkIERldiBTaXplIDogMzkwNjc2
NTgyNCAoMTg2Mi44OSBHaUIgMjAwMC4yNiBHQikKPT09PT09PT09PT09PT09CnJvb3RAa2Vy
dXJ1Oi92YXIvbG9nIyBtZGFkbSAtLWNyZWF0ZSAtLWFzc3VtZS1jbGVhbiAtLWxldmVsPTYg
LS1yYWlkLWRldmljZXM9NCAtLXNpemU9MTk1MzM4MjkxMiAvZGV2L21kMCAvZGV2L3NkYiAv
ZGV2L3NkZSAvZGV2L3NkZCAvZGV2L3NkYwptZGFkbTogL2Rldi9zZGIgYXBwZWFycyB0byBi
ZSBwYXJ0IG9mIGEgcmFpZCBhcnJheToKICAgIGxldmVsPXJhaWQ2IGRldmljZXM9NCBjdGlt
ZT1GcmkgSnVuIDMwIDE1OjQyOjI3IDIwMTcKbWRhZG06IHBhcnRpdGlvbiB0YWJsZSBleGlz
dHMgb24gL2Rldi9zZGIgYnV0IHdpbGwgYmUgbG9zdCBvcgogICAgICAgbWVhbmluZ2xlc3Mg
YWZ0ZXIgY3JlYXRpbmcgYXJyYXkKbWRhZG06IC9kZXYvc2RlIGFwcGVhcnMgdG8gYmUgcGFy
dCBvZiBhIHJhaWQgYXJyYXk6CiAgICBsZXZlbD1yYWlkNiBkZXZpY2VzPTQgY3RpbWU9RnJp
IEp1biAzMCAxNTo0MjoyNyAyMDE3Cm1kYWRtOiAvZGV2L3NkZCBhcHBlYXJzIHRvIGJlIHBh
cnQgb2YgYSByYWlkIGFycmF5OgogICAgbGV2ZWw9cmFpZDYgZGV2aWNlcz00IGN0aW1lPUZy
aSBKdW4gMzAgMTU6NDI6MjcgMjAxNwptZGFkbTogL2Rldi9zZGMgYXBwZWFycyB0byBiZSBw
YXJ0IG9mIGEgcmFpZCBhcnJheToKICAgIGxldmVsPXJhaWQ2IGRldmljZXM9NCBjdGltZT1G
cmkgSnVuIDMwIDE1OjQyOjI3IDIwMTcKQ29udGludWUgY3JlYXRpbmcgYXJyYXk/IG4KbWRh
ZG06IGNyZWF0ZSBhYm9ydGVkLgo9PT09PT09PT09PT09PT0Kcm9vdEBrZXJ1cnU6L3Zhci9s
b2cjIG1kYWRtIC0tY3JlYXRlIC0tYXNzdW1lLWNsZWFuIC0tbGV2ZWw9NiAtLXJhaWQtZGV2
aWNlcz00IC0tc2l6ZT0xOTUzMzgyOTEyIC9kZXYvbWQwIC9kZXYvc2RiIC9kZXYvc2RlIC9k
ZXYvc2RkIC9kZXYvc2RjCm1kYWRtOiAvZGV2L3NkYiBhcHBlYXJzIHRvIGJlIHBhcnQgb2Yg
YSByYWlkIGFycmF5OgogICAgbGV2ZWw9cmFpZDYgZGV2aWNlcz00IGN0aW1lPUZyaSBKdW4g
MzAgMTU6NDI6MjcgMjAxNwptZGFkbTogcGFydGl0aW9uIHRhYmxlIGV4aXN0cyBvbiAvZGV2
L3NkYiBidXQgd2lsbCBiZSBsb3N0IG9yCiAgICAgICBtZWFuaW5nbGVzcyBhZnRlciBjcmVh
dGluZyBhcnJheQptZGFkbTogL2Rldi9zZGUgYXBwZWFycyB0byBiZSBwYXJ0IG9mIGEgcmFp
ZCBhcnJheToKICAgIGxldmVsPXJhaWQ2IGRldmljZXM9NCBjdGltZT1GcmkgSnVuIDMwIDE1
OjQyOjI3IDIwMTcKbWRhZG06IC9kZXYvc2RkIGFwcGVhcnMgdG8gYmUgcGFydCBvZiBhIHJh
aWQgYXJyYXk6CiAgICBsZXZlbD1yYWlkNiBkZXZpY2VzPTQgY3RpbWU9RnJpIEp1biAzMCAx
NTo0MjoyNyAyMDE3Cm1kYWRtOiAvZGV2L3NkYyBhcHBlYXJzIHRvIGJlIHBhcnQgb2YgYSBy
YWlkIGFycmF5OgogICAgbGV2ZWw9cmFpZDYgZGV2aWNlcz00IGN0aW1lPUZyaSBKdW4gMzAg
MTU6NDI6MjcgMjAxNwpDb250aW51ZSBjcmVhdGluZyBhcnJheT8geQptZGFkbTogRGVmYXVs
dGluZyB0byB2ZXJzaW9uIDEuMiBtZXRhZGF0YQptZGFkbTogYXJyYXkgL2Rldi9tZDAgc3Rh
cnRlZC4KPT09PT09PT09PT09PT09CnJvb3RAa2VydXJ1Oi8jIG1vdW50IC10IGV4dDQgL2Rl
di9tZDAgL21udC9tZDAKbW91bnQ6IHdyb25nIGZzIHR5cGUsIGJhZCBvcHRpb24sIGJhZCBz
dXBlcmJsb2NrIG9uIC9kZXYvbWQwLAogICAgICAgbWlzc2luZyBjb2RlcGFnZSBvciBoZWxw
ZXIgcHJvZ3JhbSwgb3Igb3RoZXIgZXJyb3IKICAgICAgIEluIHNvbWUgY2FzZXMgdXNlZnVs
IGluZm8gaXMgZm91bmQgaW4gc3lzbG9nIC0gdHJ5CiAgICAgICBkbWVzZyB8IHRhaWwgIG9y
IHNvCj09PT09PT09PT09PT09PQpyb290QGtlcnVydTovIyBkbWVzZyB8IHRhaWwKWzQ0ODMx
OC44MDA4MDZdICAtLS0gbGV2ZWw6NiByZDo0IHdkOjQKWzQ0ODMxOC44MDA4MTJdICBkaXNr
IDAsIG86MSwgZGV2OnNkYgpbNDQ4MzE4LjgwMDgxN10gIGRpc2sgMSwgbzoxLCBkZXY6c2Rl
Cls0NDgzMTguODAwODIyXSAgZGlzayAyLCBvOjEsIGRldjpzZGQKWzQ0ODMxOC44MDA4Mjdd
ICBkaXNrIDMsIG86MSwgZGV2OnNkYwpbNDQ4MzE4LjgwMDk1MV0gbWQwOiBkZXRlY3RlZCBj
YXBhY2l0eSBjaGFuZ2UgZnJvbSAwIHRvIDQwMDA1MjgyMDM3NzYKWzQ0ODMxOC44MDkzNzVd
ICBtZDA6IHVua25vd24gcGFydGl0aW9uIHRhYmxlCls0NDgzNTguNzA0MTg5XSBFWFQ0LWZz
IChtZDApOiBVbnJlY29nbml6ZWQgbW91bnQgb3B0aW9uICJceDA4IiBvciBtaXNzaW5nIHZh
bHVlCls0NDgzNTguNzA2NjgwXSBFWFQ0LWZzIChtZDApOiBmYWlsZWQgdG8gcGFyc2Ugb3B0
aW9ucyBpbiBzdXBlcmJsb2NrOiBceDA4Cls0NDgzNTguNzA2NjkwXSBFWFQ0LWZzIChtZDAp
OiBOdW1iZXIgb2YgcmVzZXJ2ZWQgR0RUIGJsb2NrcyBpbnNhbmVseSBsYXJnZTogOTIxNgo9
PT09PT09PT09PT09PT0gCkp1bCAxMSAxNzoyMzoxNSBrZXJ1cnUga2VybmVsOiBbNDQ3NzE5
LjgxMjc3NV0gbWQ6IGV4cG9ydF9yZGV2KHNkZCkKSnVsIDExIDE3OjIzOjE5IGtlcnVydSBr
ZXJuZWw6IFs0NDc3MjQuMzk2MzI3XSBtZDogbWQwIHN0b3BwZWQuCkp1bCAxMSAxNzoyMzox
OSBrZXJ1cnUga2VybmVsOiBbNDQ3NzI0LjQwMDI3OF0gbWQ6IGJpbmQ8c2RjPgpKdWwgMTEg
MTc6MzI6Mjkga2VydXJ1IGtlcm5lbDogWzQ0ODI3My4wMDE2ODddIG1kMDogZGV0ZWN0ZWQg
Y2FwYWNpdHkgY2hhbmdlIGZyb20gNDAwMDUyODIwMzc3NiB0byAwCkp1bCAxMSAxNzozMjoy
OSBrZXJ1cnUga2VybmVsOiBbNDQ4MjczLjAwMTcxNF0gbWQ6IG1kMCBzdG9wcGVkLgpKdWwg
MTEgMTc6MzI6Mjkga2VydXJ1IGtlcm5lbDogWzQ0ODI3My4wMDE3MjldIG1kOiB1bmJpbmQ8
c2RjPgpKdWwgMTEgMTc6MzI6Mjkga2VydXJ1IGtlcm5lbDogWzQ0ODI3My4wMjI5NzJdIG1k
OiBleHBvcnRfcmRldihzZGMpCkp1bCAxMSAxNzozMjoyOSBrZXJ1cnUga2VybmVsOiBbNDQ4
MjczLjAyMzE0M10gbWQ6IHVuYmluZDxzZGU+Ckp1bCAxMSAxNzozMjoyOSBrZXJ1cnUga2Vy
bmVsOiBbNDQ4MjczLjA1NDg4OV0gbWQ6IGV4cG9ydF9yZGV2KHNkZSkKSnVsIDExIDE3OjMy
OjI5IGtlcnVydSBrZXJuZWw6IFs0NDgyNzMuMDU1MDM1XSBtZDogdW5iaW5kPHNkZD4KSnVs
IDExIDE3OjMyOjI5IGtlcnVydSBrZXJuZWw6IFs0NDgyNzMuMDg2ODcwXSBtZDogZXhwb3J0
X3JkZXYoc2RkKQpKdWwgMTEgMTc6MzM6MTQga2VydXJ1IGtlcm5lbDogWzQ0ODMxOC44MDA4
MjddICBkaXNrIDMsIG86MSwgZGV2OnNkYwo9PT09PT09PT09PT09PT0KCg==
--------------F87319FD11BDA10FEB34F2B9--
