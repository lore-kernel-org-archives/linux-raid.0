From: David Greaves <david@dgreaves.com>
Subject: How should a raid array fail? shall we count the ways...
Date: Fri, 04 Jun 2004 21:54:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40C0E18E.2070903@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Summary:
If I fault a device on a raid5 array it goes->degraded
If I fault another it's dead. But:
a) mdadm --detail says: State : clean, degraded although I suspect it 
should have automatically stopped.
Then either
b1) adding another device results in a sync loop
b2) if the array is mounted then it can't be stopped and a reboot is needed

I hope this is useful - please tell me if I'm being dim...

So here's my array:
(yep, I got my disk :) )

cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun  4 20:43:43 2004
     Raid Level : raid5
     Array Size : 2939520 (2.80 GiB 3.01 GB)
    Device Size : 979840 (956.88 MiB 1003.36 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun  4 20:44:40 2004
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
           UUID : e95ff7de:36d3f438:0a021fa4:b473a6e2
         Events : 0.2

cu:~# mdadm /dev/md0 -f /dev/sda1
mdadm: set /dev/sda1 faulty in /dev/md0

cu:~# mdadm --detail /dev/md0
/dev/md0:
<snip>
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
<snip>
    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1

       4       8        1       -1      faulty   /dev/sda1


################################################
Failure a) --detail is somewhat optimistic :)

cu:~# mdadm /dev/md0 -f /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0
cu:~# mdadm --detail /dev/md0
/dev/md0:
<snip>
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
<snip>
    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1       0        0       -1      removed
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1

       4       8       17       -1      faulty   /dev/sdb1
       5       8        1       -1      faulty   /dev/sda1



################################################
Failure b1) failed 2 devices, now add one

cu:~# mdadm /dev/md0 -a /dev/sda2
mdadm: hot added /dev/sda2

dmesg starts printing:
Jun  4 22:10:21 cu kernel: md: syncing RAID array md0
Jun  4 22:10:21 cu kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Jun  4 22:10:21 cu kernel: md: using maximum available idle IO bandwith 
(but not more than 200000 KB/sec) for reconstruction.
Jun  4 22:10:21 cu kernel: md: using 128k window, over a total of 979840 
blocks.
Jun  4 22:10:21 cu kernel: md: md0: sync done.
Jun  4 22:10:21 cu kernel: md: syncing RAID array md0
Jun  4 22:10:21 cu kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Jun  4 22:10:21 cu kernel: md: using maximum available idle IO bandwith 
(but not more than 200000 KB/sec) for reconstruction.
Jun  4 22:10:21 cu kernel: md: using 128k window, over a total of 979840 
blocks.
Jun  4 22:10:21 cu kernel: md: md0: sync done.
Jun  4 22:10:21 cu kernel: md: syncing RAID array md0
...
over and over *very* quickly


cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun  4 22:03:22 2004
     Raid Level : raid5
     Array Size : 2939520 (2.80 GiB 3.01 GB)
    Device Size : 979840 (956.88 MiB 1003.36 MB)
   Raid Devices : 4
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun  4 22:10:40 2004
          State : clean, degraded
 Active Devices : 2
Working Devices : 3
 Failed Devices : 2
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       0        0       -1      removed
       1       0        0       -1      removed
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1

       4       8        2        0      spare   /dev/sda2
       5       8       17       -1      faulty   /dev/sdb1
       6       8        1       -1      faulty   /dev/sda1
           UUID : 76cd1aba:ae9bb374:8ddc1702:a7e9631e
         Events : 0.903
cu:~# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid6]
md0 : active raid5 sda2[4] sdd1[3] sdc1[2] sdb1[5](F) sda1[6](F)
      2939520 blocks level 5, 128k chunk, algorithm 2 [4/2] [__UU]

unused devices: <none>
cu:~#

################################################
Failure b2) filesystem was mounted before either disk failed. After 2nd 
failure:

cu:~# mount /dev/md0 /huge
cu:~# mdadm /dev/md0 -f /dev/sdd1
mdadm: set /dev/sdd1 faulty in /dev/md0
cu:~# mdadm /dev/md0 -f /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md0

cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun  4 22:47:36 2004
     Raid Level : raid5
     Array Size : 2939520 (2.80 GiB 3.01 GB)
    Device Size : 979840 (956.88 MiB 1003.36 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun  4 22:49:16 2004
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0       -1      removed
       2       8       33        2      active sync   /dev/sdc1
       3       0        0       -1      removed

       4       8       49       -1      faulty   /dev/sdd1
       5       8       17       -1      faulty   /dev/sdb1
           UUID : 15fa81ab:806e18a2:acfefe4f:b644647d
         Events : 0.13

cu:~# mdadm --stop /dev/md0
mdadm: fail to stop array /dev/md0: Device or resource busy
cu:~# umount /huge

Message from syslogd@cu at Fri Jun  4 22:49:38 2004 ...
cu kernel: journal-601, buffer write failed
Segmentation fault
cu:~# umount /huge
umount: /dev/md0: not mounted
umount: /dev/md0: not mounted
cu:~# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Fri Jun  4 22:47:36 2004
     Raid Level : raid5
     Array Size : 2939520 (2.80 GiB 3.01 GB)
    Device Size : 979840 (956.88 MiB 1003.36 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Jun  4 22:49:38 2004
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       0        0       -1      removed
       2       8       33        2      active sync   /dev/sdc1
       3       0        0       -1      removed

       4       8       49       -1      faulty   /dev/sdd1
       5       8       17       -1      faulty   /dev/sdb1
           UUID : 15fa81ab:806e18a2:acfefe4f:b644647d
         Events : 0.15
cu:~# mdadm --stop /dev/md0
mdadm: fail to stop array /dev/md0: Device or resource busy
cu:~# mount
/dev/hda2 on / type xfs (rw)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
devpts on /dev/pts type devpts (rw,gid=5,mode=620)
/dev/hda1 on /boot type ext3 (rw)
usbfs on /proc/bus/usb type usbfs (rw)
cu:(pid1404) on /net type nfs 
(intr,rw,port=1023,timeo=8,retrans=110,indirect,map=/usr/share/am-utils/amd.net)

cu:~# mdadm --stop /dev/md0
mdadm: fail to stop array /dev/md0: Device or resource busy
cu:~#

BTW, No mdadm is following the array.




I know that if you hit your head against a brick wall and it hurts you 
should stop but I thought this behaviour was worth reporting :)


David


