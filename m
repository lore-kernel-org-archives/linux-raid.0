From: Falk Husemann <josen@paketsequenz.de>
Subject: Recreate failed raid5 with no superblocks in place
Date: Sun, 10 May 2009 14:06:12 +0200
Message-ID: <88C04460-91C2-4322-AC91-6FB2B1E5E872@paketsequenz.de>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Falk Husemann <josen@paketsequenz.de>
List-Id: linux-raid.ids

Hello linux-raid list,

this is the first time I really need support for anything in  
connection with linux for some years. I hope you can help a fellow  
enthusiast.

I've got a six disk Software-RAID5 running with XFS on top here. It  
contains:

/dev/sda1
/dev/sdb1
/dev/sdc1
/dev/sdd1
/dev/sde1
/dev/sdf1

Normally it runs just like it should, but every 3-6 month dust gets  
onto the connectors and one or more disks fail temporarly. This time  
it was /dev/sdf1. What was done to recreate the Arrray?

1. Hot remote/add (+force) /dev/sdf1
2. Recreate the Array
3. Zero the superblocks and then recreate the array

Essentially I tried:

<snip>
haven:~# mdadm --verbose --create /dev/md0 --level 5 --raid-devices=6 / 
dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 64K
mdadm: /dev/sda1 appears to be part of a raid array:
     level=raid5 devices=6 ctime=Sat May  9 22:14:18 2009
mdadm: /dev/sdb1 appears to be part of a raid array:
     level=raid5 devices=6 ctime=Sun May 10 13:32:35 2009
mdadm: /dev/sdc1 appears to be part of a raid array:
     level=raid5 devices=6 ctime=Sun May 10 13:32:35 2009
mdadm: /dev/sdd1 appears to be part of a raid array:
     level=raid5 devices=6 ctime=Sun May 10 13:32:35 2009
mdadm: /dev/sde1 appears to be part of a raid array:
     level=raid5 devices=6 ctime=Sun May 10 13:32:35 2009
mdadm: /dev/sdf1 appears to be part of a raid array:
     level=raid5 devices=6 ctime=Sun May 10 13:32:35 2009
mdadm: size set to 976759936K
Continue creating array? yes
mdadm: array /dev/md0 started.
</snap>

And then I get:

<snip>
haven:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid5 sdf1[6](S) sde1[4] sdd1[3] sdc1[2]  
sdb1[1] sda1[0]
       4883799680 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]

unused devices: <none>
</snap>

I also tried prior:
mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/ 
sdd1 /dev/sde1 /dev/sdf1

Not to mention it holds a lot of data with a great personal value.

I'm fairly sure that I created the array with just the command line  
written above (and this order of devices too). Only uncertainness is,  
if I created it with sd[a-f]1 and to what order this regex expands  
(but I guess it sda1 ... sdf1 too).

Please, if there is anything I can try to get the data back, please  
tell me. Would be great help!


To me it looks as if the RAID5 gets build the wrong way. When booting  
up the server it shows an encrypted disk password prompt. When the  
RAID5 was experimented with prior to let it run in "production" it was  
such an encrypted volume and had one spare.

So in my opinion it's a matter of getting the RAID5 recreated with six  
disks, no spare. Then recheck the xfs fs and there we go. Or what do  
you think? Problem is, I don't know how :-(

Here is the data I got from examine:

<snip>
/dev/sda1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b07570b0 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
/dev/sdb1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b07570c2 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
/dev/sdc1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b07570d4 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
/dev/sdd1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b07570e6 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
/dev/sde1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b07570f8 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
/dev/sdf1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b0757106 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     6       8       81        6      spare   /dev/sdf1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b07570f8 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
/dev/sdf1:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 5800a2d8:4866b760:9329eeb4:05722987 (local to host  
haven)
   Creation Time : Sun May 10 13:54:10 2009
      Raid Level : raid5
   Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
      Array Size : 4883799680 (4657.55 GiB 5001.01 GB)
    Raid Devices : 6
   Total Devices : 7
Preferred Minor : 0

     Update Time : Sun May 10 13:54:10 2009
           State : clean
  Active Devices : 5
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 1
        Checksum : b0757106 - correct
          Events : 1

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     6       8       81        6      spare   /dev/sdf1

    0     0       8        1        0      active sync   /dev/sda1
    1     1       8       17        1      active sync   /dev/sdb1
    2     2       8       33        2      active sync   /dev/sdc1
    3     3       8       49        3      active sync   /dev/sdd1
    4     4       8       65        4      active sync   /dev/sde1
    5     5       0        0        5      faulty
    6     6       8       81        6      spare   /dev/sdf1
<snap>


In excess I got these errors before I tried to recreate/zero  
superblocks:

<snip>
haven:~# mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/ 
sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1
mdadm: forcing event count in /dev/sdc1(0) from 903339 upto 903342
mdadm: forcing event count in /dev/sdb1(1) from 903339 upto 903342
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

haven:~# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md0 : inactive sdc1[0] sde1[4] sdd1[3] sda1[2] sdb1[1]
       4883799680 blocks

unused devices: <none>
</snap>

I'd appreciate ANY help.

Greets,
Falk
