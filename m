From: Per-Ola Stenborg <per-ola@stenborg.me>
Subject: Multiple drive failure after stupid mistake. Help needed
Date: Sun, 19 Oct 2014 11:45:29 +0200
Message-ID: <54438839.9080309@stenborg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I have done something very stupid. After getting SMART warnings from one 
of my disks in a 4-disk RAID5 array I decided to be proactive and change 
the disk.
The array consists of /dev/sd[bcde]. The failing disk is /dev/sdc.

I ran fail and remove on the WRONG disk!

mdadm --manage /dev/md0 --fail /dev/sdb

/proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb[0](F) sde[4] sdd[2] sdc[1]
       5860538880 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/3] [_UUU]

mdadm --manage /dev/md0 --remove /dev/sdb

I exchanged the physical disk, the failing/right one, /dev/sdc.
When booting my server I noticed my error when the array did not come up.
I thought it was not a problem as the original /dev/sdc was readable so I
shut the server down and put the original disk back and re-added /dev/sdb

/proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdc[1] sde[4] sdd[2]
       5860538880 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/3] [_UUU]

mdadm --manage /dev/md0 --add /dev/sdb

All seemed fine and the array was rebuilding. But when almost done 
/dev/sdc failed.

Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb[0] sdc[1](F) sde[4] sdd[2]
       5860538880 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/2] [__UU]
       [===================>.]  recovery = 95.3% (1862844416/1953512960) 
finish=49.5min speed=30502K/sec

A few hours late I got:

Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb[0](S) sdc[1](F) sde[4] sdd[2]
       5860538880 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[4/2] [__UU]


After reboot I now have

/proc/mdstat
Personalities :
md0 : inactive sdd[2](S) sdb[0](S) sde[4](S) sdc[1](S)
       7814054240 blocks super 1.2

unused devices: <none>

/dev/sdb:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e3394a2b:77411a7d:a6f03a01:19f9b943
            Name : backuppc:0  (local to host backuppc)
   Creation Time : Mon Dec 19 17:43:44 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : ed574f2e:b80a509b:b8a5e5a6:3d711e05

     Update Time : Fri Oct 17 01:00:05 2014
        Checksum : 4fe90596 - correct
          Events : 5072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : spare
    Array State : ..AA ('A' == active, '.' == missing)

/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e3394a2b:77411a7d:a6f03a01:19f9b943
            Name : backuppc:0  (local to host backuppc)
   Creation Time : Mon Dec 19 17:43:44 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4ebf1b3b:6821832c:1b520e0e:d363aa4d

     Update Time : Fri Oct 17 00:04:20 2014
        Checksum : 9d9f1587 - correct
          Events : 5064

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing)

/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e3394a2b:77411a7d:a6f03a01:19f9b943
            Name : backuppc:0  (local to host backuppc)
   Creation Time : Mon Dec 19 17:43:44 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : ffe21a6e:3256c3d5:8cb68394:1172eb5d

     Update Time : Fri Oct 17 01:00:05 2014
        Checksum : 1092edcd - correct
          Events : 5072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : ..AA ('A' == active, '.' == missing)

/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : e3394a2b:77411a7d:a6f03a01:19f9b943
            Name : backuppc:0  (local to host backuppc)
   Creation Time : Mon Dec 19 17:43:44 2011
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 3907027120 (1863.02 GiB 2000.40 GB)
      Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
   Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 5ca79fb0:09f51c20:f5c8a851:310f5c2a

     Update Time : Fri Oct 17 01:00:05 2014
        Checksum : 2707008b - correct
          Events : 5072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : ..AA ('A' == active, '.' == missing)


The /dev/sdc disk is tested with spinrite, and is verified readable.
I've tried forcing an assembly without luck. Did I do it right? What 
should i do now?

*** PLEASE advice ***

And off cause I have valuable data on the array without backup...

Best regards

Per-Ola
---
