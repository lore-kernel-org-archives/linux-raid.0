From: Colin Snover <linux-raid@zetafleet.com>
Subject: RAID6 --grow won't restart after disk failure
Date: Wed, 01 Aug 2007 18:09:52 -0500
Message-ID: <46B112C0.8040509@zetafleet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've recently set up a fileserver with 6 disks in a RAID-6 configuration
and was going in to add a seventh using --grow. I started the grow using
mdadm --grow /dev/md0 -n 7 and the critical section passed successfully.
The grow started to reshape the array, but due to some power problems,
one of the disks that was part of the original array dropped off. In
order to take care of the power issues the array was temporarily
stopped. The reshape was 4% done at this point. Once the power issues
were taken care of, I restarted the array. It came back online, clean
and degraded, but the reshape did not start, nor did a rebuild of the
failed disk begin. I've done a lot of Googling to try to figure out how
to resolve this problem but have come up empty-handed. One thing I tried
doing as part of fixing the problem was to re-add the two "removed"
disks, /dev/sda1 and /dev/sdk1, since initially they weren't part of the
array any more. I also tried zeroing the superblock on /dev/sda1, before
re-adding it again later, so if something looks funny about it below,
that's why.

I've done some reading through the linux-raid list and have included
some commonly requested information below. I apologise if it's too much,
or wrong.

So, here's the situation, as it stands:

# cat /proc/mdstat # BEFORE array restart
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active raid6 sdk1[7](F) sda1[8](F) sdf1[5] sde1[4] sdd1[3] sdc1[2]
sdb1[1]
      1953053696 blocks super 0.91 level 6, 64k chunk, algorithm 2 [7/5]
[_UUUUU_]
      [>....................]  reshape =  3.2% (15914752/488263424)
finish=987.5min speed=7970K/sec

unused devices: <none>

# cat /proc/mdstat # AFTER array restart
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : active(auto-read-only) raid6 sdb1[1] sdf1[5] sde1[4] sdd1[3] sdc1[2]
      1953053696 blocks super 0.91 level 6, 64k chunk, algorithm 2 [7/5]
[_UUUUU_]

unused devices: <none>

# mdadm --detail --scan --verbose # BEFORE array restart
ARRAY /dev/md0 level=raid6 num-devices=7
UUID=55121b1f:275da62c:f819f310:fb79f5e4
  
devices=/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdk1

# mdadm --detail --scan # AFTER array restart
ARRAY /dev/md0 level=raid6 num-devices=7 spares=1
UUID=55121b1f:275da62c:f819f310:fb79f5e4

# mdadm --detail /dev/md0 # BEFORE array restart
/dev/md0:
        Version : 00.91.03
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
     Array Size : 1953053696 (1862.58 GiB 1999.93 GB)
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Aug  1 23:38:45 2007
          State : clean, degraded, recovering
 Active Devices : 5
Working Devices : 5
 Failed Devices : 2
  Spare Devices : 0

     Chunk Size : 64K

 Reshape Status : 4% complete
  Delta Devices : 1, (6->7)

           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
         Events : 0.15650

    Number   Major   Minor   RaidDevice State
       8       8        1        0      faulty spare rebuilding   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       7       8      161        6      faulty spare rebuilding   /dev/sdk1

# mdadm --detail /dev/md0 # AFTER array restart
/dev/md0:
        Version : 00.91.03
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
     Array Size : 1953053696 (1862.58 GiB 1999.93 GB)
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean, degraded
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

     Chunk Size : 64K

  Delta Devices : 1, (6->7)

           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
         Events : 0.16128

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       17        1      active sync   /dev/sdb1
       2       8       33        2      active sync   /dev/sdc1
       3       8       49        3      active sync   /dev/sdd1
       4       8       65        4      active sync   /dev/sde1
       5       8       81        5      active sync   /dev/sdf1
       6       0        0        6      removed

       7       8        1        -      spare   /dev/sda1

# mdadm -E /dev/sd[a-f]1 # AFTER array restart
/dev/sda1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : d1c26233 - correct
         Events : 0.16128

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8        1        7      spare   /dev/sda1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8        1        7      spare   /dev/sda1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : d1c2623d - correct
         Events : 0.16128

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8        1        7      spare   /dev/sda1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : d1c2624f - correct
         Events : 0.16128

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8        1        7      spare   /dev/sda1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : d1c26261 - correct
         Events : 0.16128

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8        1        7      spare   /dev/sda1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : d1c26273 - correct
         Events : 0.16128

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8        1        7      spare   /dev/sda1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:44:15 2007
          State : clean
 Active Devices : 5
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 1
       Checksum : d1c26285 - correct
         Events : 0.16128

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       81        5      active sync   /dev/sdf1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8        1        7      spare   /dev/sda1

# mdadm -E /dev/sdk1 # AFTER array restart
/dev/sdk1:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 55121b1f:275da62c:f819f310:fb79f5e4
  Creation Time : Sat Jul 21 01:35:23 2007
     Raid Level : raid6
  Used Dev Size : 488263424 (465.64 GiB 499.98 GB)
     Array Size : 2441317120 (2328.22 GiB 2499.91 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

  Reshape pos'n : 118605760 (113.11 GiB 121.45 GB)
  Delta Devices : 1 (6->7)

    Update Time : Thu Aug  2 01:43:03 2007
          State : clean
 Active Devices : 5
Working Devices : 7
 Failed Devices : 1
  Spare Devices : 2
       Checksum : d1c26343 - correct
         Events : 0.16126

     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8      161        7      spare   /dev/sdk1

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1
   5     5       8       81        5      active sync   /dev/sdf1
   6     6       0        0        6      faulty removed
   7     7       8      161        7      spare   /dev/sdk1
   8     8       8        1        8      spare   /dev/sda1

---

Relevant dmesg output:

md: bind<sdk1>
RAID5 conf printout:
 --- rd:7 wd:7
 disk 0, o:1, dev:sda1
 disk 1, o:1, dev:sdb1
 disk 2, o:1, dev:sdc1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
 disk 6, o:1, dev:sdk1
md: reshape of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for reshape.
md: using 128k window, over a total of 488263424 blocks.
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronization
completed:unit=0.
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=0.
[snip]
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronization
completed:unit=0.
3w-9xxx: scsi0: ERROR: (0x03:0x1019): Drive removed:port=0.
sd 0:0:0:0: Device not ready: <6>: Current: sense key: Not Ready
    Additional sense: Logical unit not ready, cause not reportable
end_request: I/O error, dev sda, sector 146367
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=0.
sd 0:0:0:0: Device not ready: <6>: Current: sense key: Not Ready
    Additional sense: Logical unit not ready, cause not reportable
end_request: I/O error, dev sda, sector 147647
sd 0:0:0:0: Device not ready: <6>: Current: sense key: Not Ready
    Additional sense: Logical unit not ready, cause not reportable
end_request: I/O error, dev sda, sector 147391
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=0.
sd 0:0:0:0: Device not ready: <6>: Current: sense key: Not Ready
    Additional sense: Logical unit not ready, cause not reportable
end_request: I/O error, dev sda, sector 117055
raid5: Disk failure on sda1, disabling device. Operation continuing on 6
devices
md: md0: reshape done.
3w-9xxx: scsi0: AEN: ERROR (0x04:0x001E): Unit inoperable:unit=0.
md: reshape of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for reshape.
md: using 128k window, over a total of 488263424 blocks.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001F): Unit operational:unit=0.
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=4.
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronization
completed:unit=6.
[snip]
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=4.
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronization
completed:unit=6.
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=4.
sd 0:0:6:0: Device not ready: <6>: Current: sense key: Not Ready
    Additional sense: Logical unit not ready, cause not reportable
end_request: I/O error, dev sdk, sector 976526911
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=4.
md: super_written gets error=-5, uptodate=0
raid5: Disk failure on sdk1, disabling device. Operation continuing on 5
devices
md: md0: reshape done.
md: reshape of RAID array md0
md: minimum _guaranteed_  speed: 25000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000
KB/sec) for reshape.
md: using 128k window, over a total of 488263424 blocks.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): Cache synchronization
completed:unit=6.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001F): Unit operational:unit=6.
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=4.
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=4.
3w-9xxx: scsi0: AEN: ERROR (0x04:0x003A): Drive power on reset
detected:port=4.
3w-9xxx: scsi0: AEN: WARNING (0x04:0x0019): Drive removed:port=4.
3w-9xxx: scsi0: AEN: INFO (0x04:0x001A): Drive inserted:port=4.
[snip]
md: md0 still in use.
md: md0: reshape done.
md: md0 stopped.
md: unbind<sdk1>
md: export_rdev(sdk1)
md: unbind<sda1>
md: export_rdev(sda1)
md: unbind<sdf1>
md: export_rdev(sdf1)
md: unbind<sde1>
md: export_rdev(sde1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdb1>
md: export_rdev(sdb1)
[snip]
md: bind<sda1>
md: bind<sdc1>
md: bind<sdd1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdk1>
md: bind<sdb1>
md: kicking non-fresh sdk1 from array!
md: unbind<sdk1>
md: export_rdev(sdk1)
md: kicking non-fresh sda1 from array!
md: unbind<sda1>
md: export_rdev(sda1)
raid5: reshape will continue
raid5: device sdb1 operational as raid disk 1
raid5: device sdf1 operational as raid disk 5
raid5: device sde1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: allocated 7412kB for md0
raid5: raid level 6 set md0 active with 5 out of 7 devices, algorithm 2
RAID5 conf printout:
 --- rd:7 wd:5
 disk 1, o:1, dev:sdb1
 disk 2, o:1, dev:sdc1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sde1
 disk 5, o:1, dev:sdf1
...ok start reshape thread

Thank you very much for any help you can provide.

-- 
Colin Snover
http://www.zetafleet.com


