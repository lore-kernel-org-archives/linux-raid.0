From: "Bernd Waage" <berndman1980@gmx.de>
Subject: Degraded Raid6
Date: Wed, 12 Dec 2012 21:49:07 +0100
Message-ID: <20121212204907.248080@gmx.net>
References: <S1754985Ab2LLT4x/20121212195656Z+425@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <S1754985Ab2LLT4x/20121212195656Z+425@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I run an 8-disk raid 6 on which sporadically 2 drives dropped out, that I could just re-add when I zeroed the zuperblock beforehand. Recently, upon re-adding those 2 drives (after the zero-superblock) a third drive dropped out after 5-10 minutes of syncing. I then did a zero-superblock on the third drive and tried to re-add it - which failed.

I'm pretty much at my wits' end and stumbled upon this list. Perhaps someone of you guys can help me out. I'm running an ubuntu 12.04 box with kernel 3.3.8, so I should not be affected by the kernel-bug that popped up some time ago.

I append the output of mdadm --detail as well as mdadm --examine...


berndman@berndman:~$ sudo mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
  Used Dev Size : 1953509376 (1863.01 GiB 2000.39 GB)
   Raid Devices : 8
  Total Devices : 8
    Persistence : Superblock is persistent

    Update Time : Fri Nov 30 07:24:57 2012
          State : active, FAILED, Not Started
 Active Devices : 5
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 3

         Layout : left-symmetric
     Chunk Size : 4096K

           Name : berndman-System:0
           UUID : ef105344:6158fb94:c37cc33b:00ac2d04
         Events : 25340

    Number   Major   Minor   RaidDevice State
       0       8       81        0      active sync   /dev/sdf1
       9       8       49        1      active sync   /dev/sdd1
       2       0        0        2      removed
       3       0        0        3      removed
       4       8      129        4      active sync   /dev/sdi1
       8       8       33        5      active sync   /dev/sdc1
       6       8       17        6      active sync   /dev/sdb1
       7       0        0        7      removed

      10       8      113        -      spare   /dev/sdh1
      11       8        1        -      spare   /dev/sda1
      12       8       65        -      spare   /dev/sde1
berndman@berndman:~$







 * Documentation:  https://help.ubuntu.com/

Last login: Wed Dec 12 21:16:35 2012 from berndman-pc.local
berndman@berndman:~$ sudo mdadm --examine /dev/sdf1 /dev/sdd1 /dev/sdi1 /dev/sdc1 /dev/sdb1 /dev/sdh1 /dev/sda1 /dev/sde1
[sudo] password for berndman:
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 4792cd00:92d53de8:4d2d7438:dc86e0fd

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : dc7a3261 - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 0
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 6670d0fb:447d937f:be88f731:f6161042

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : ac85a3c6 - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 1
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 67054bcd:7e9c5380:452a8756:14dd629e

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : ffa2bfa1 - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 4
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 8722a93e:a2397924:1d28b78b:e786004e

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : f9f42193 - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 5
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b1426d37:1ebaa27c:f1eea681:1a55b574

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : 678657ff - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : Active device 6
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b80ab95e:7271c8a4:87980189:25169231

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : 7b2ede44 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : spare
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a002afcf:af02cbfc:fa09bff8:252116c7

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : 496946da - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : spare
   Array State : AA..AAA. ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : ef105344:6158fb94:c37cc33b:00ac2d04
           Name : berndman-System:0
  Creation Time : Thu Aug  4 21:32:45 2011
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 23442112512 (11178.07 GiB 12002.36 GB)
  Used Dev Size : 3907018752 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f3ff2451:d3c11122:c1e8a54a:0481d299

    Update Time : Fri Nov 30 07:24:57 2012
       Checksum : 14c941f6 - correct
         Events : 25340

         Layout : left-symmetric
     Chunk Size : 4096K

   Device Role : spare
   Array State : AA..AAA. ('A' == active, '.' == missing)




regards,
Bernd
