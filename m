From: Andrew Falgout <andrew.falgout@gmail.com>
Subject: mismatch_cnt and Raid6
Date: Thu, 21 Apr 2011 08:00:39 -0500
Message-ID: <4DB02A77.8000902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got an error last week from a new raid6 array about a mismatch_cnt.  I 
did some reading online, performed a repair action on the array, 
performed a check action, and checked for the mismatch_cnt again.  The 
number was greatly reduced, but it was still there.  According to mdadm, 
everything appears to be working fine.  All the drives are passing short 
tests on smartctl.

What is mismatch_cnt really?  Should I even be concerned about this?  
The array is giving me 25-30MB/sec performance on an sshfs mount over 
the network.  With a local copy I can see speeds of 50 to 60MB/sec.

Thanks,
Andrew Falgout

-----> inserting boring details here <-----------
==> checked for mismatch_cnt
cat /sys/block/md1/md/mismatch_cnt
7752
==> performed the repair this way:
echo "repair" >/sys/block/md1/md/sync_action
==> performed the check this way:
echo "check" >/sys/block/md1/md/sync_action
==> Array Details
Array Details as follows:
/dev/md1:
         Version : 1.2
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
      Array Size : 7814047744 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
    Raid Devices : 6
   Total Devices : 6
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Thu Apr 21 07:35:08 2011
           State : active
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
            UUID : df03c833:90129ffd:123abdca:6b30c319
          Events : 75072

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       81        1      active sync   /dev/sdf1
        2       8       97        2      active sync   /dev/sdg1
        3       8      113        3      active sync   /dev/sdh1
        4       8      129        4      active sync   /dev/sdi1
        5       8      145        5      active sync   /dev/sdj1

Disk Details:
/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : df03c833:90129ffd:123abdca:6b30c319
            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
      Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 6735ec05:80890fa1:86e03b80:1f5de847

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr 21 07:45:17 2011
        Checksum : 99fdeb3f - correct
          Events : 75072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : df03c833:90129ffd:123abdca:6b30c319
            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
      Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : e18ce851:efc426b3:cadca5f9:df898fa7

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr 21 07:45:17 2011
        Checksum : d122a72e - correct
          Events : 75072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdg1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : df03c833:90129ffd:123abdca:6b30c319
            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
      Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 4cff4ab7:8e7c4312:1445828a:f0be7e89

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr 21 07:45:17 2011
        Checksum : 86d6e94 - correct
          Events : 75072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdh1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : df03c833:90129ffd:123abdca:6b30c319
            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
      Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 05a949c4:ab94a3f4:ae25fe55:8034dbfb

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr 21 07:45:17 2011
        Checksum : 35a48696 - correct
          Events : 75072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdi1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : df03c833:90129ffd:123abdca:6b30c319
            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
      Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : ff0881e7:7e22804f:d0b57eb7:60872ff0

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr 21 07:45:17 2011
        Checksum : 98d5766 - correct
          Events : 75072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : AAAAAA ('A' == active, '.' == missing)
/dev/sdj1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : df03c833:90129ffd:123abdca:6b30c319
            Name : nas.falgout.lan:1  (local to host nas.falgout.lan)
   Creation Time : Fri Mar 25 20:16:33 2011
      Raid Level : raid6
    Raid Devices : 6

  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
      Array Size : 15628095488 (7452.06 GiB 8001.58 GB)
   Used Dev Size : 3907023872 (1863.01 GiB 2000.40 GB)
     Data Offset : 2048 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 9a200b64:483f52d0:a3d97d13:39ff95be

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr 21 07:45:17 2011
        Checksum : 314f2777 - correct
          Events : 75072

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 5
    Array State : AAAAAA ('A' == active, '.' == missing)
