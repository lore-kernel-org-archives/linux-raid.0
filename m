From: Steve Lorimer <steve.lorimer@gmail.com>
Subject: "not enough operational devices (2/4 failed)" Can I recover?
Date: Tue, 27 May 2014 05:54:26 -0400
Message-ID: <CAE-NPOiJ7=u1OJ8sHQS3zu4UU9a-bWEL+2PQ7Qa7PdLHCE4bMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

Looking for some advice please.

My raid array failed today. I'm a total raid noob, so I'm really not
sure what the right thing to do is, and am worried I'll unnecessarily
lose data.

I had to boot using a Live CD in order to get this information, so not
sure if some valuable information is missing.

Here are results from running some commands listed on the
RAID_recovery page of the raid wiki

$ dmesg | grep raid

[  185.301031] raid6: int64x1   1675 MB/s
[  185.318020] raid6: int64x2   2171 MB/s
[  185.335017] raid6: int64x4   1511 MB/s
[  185.352039] raid6: int64x8   1425 MB/s
[  185.369003] raid6: sse2x1    3851 MB/s
[  185.386012] raid6: sse2x2    4746 MB/s
[  185.403004] raid6: sse2x4    6378 MB/s
[  185.403006] raid6: using algorithm sse2x4 (6378 MB/s)
[  185.681200] md: raid6 personality registered for level 6
[  185.681203] md: raid5 personality registered for level 5
[  185.681205] md: raid4 personality registered for level 4
[  185.681519] md/raid:md127: device sdb1 operational as raid disk 2
[  185.681521] md/raid:md127: device sdc1 operational as raid disk 0
[  185.682031] md/raid:md127: allocated 4312kB
[  185.682077] md/raid:md127: not enough operational devices (2/4 failed)
[  185.682386] md/raid:md127: failed to run raid set.

$ mdadm --examine /dev/sd[a-z]1

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4dc53f9d:f0c55279:a9cb9592:a59607c9
           Name : NAS:0
  Creation Time : Sat Sep 10 12:37:59 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027053 (1863.02 GiB 2000.40 GB)
     Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e8369dbc:bf591efa:f0ccc359:9d164ec8

    Update Time : Tue May 27 04:54:37 2014
       Checksum : a17a88c0 - correct
         Events : 1026050

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : A.A. ('A' == active, '.' == missing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4dc53f9d:f0c55279:a9cb9592:a59607c9
           Name : NAS:0
  Creation Time : Sat Sep 10 12:37:59 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027053 (1863.02 GiB 2000.40 GB)
     Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 78221e11:02acc1c8:c4eb01bf:f0852cbe

    Update Time : Tue May 27 04:54:37 2014
       Checksum : 1fbb54b8 - correct
         Events : 1026050

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : A.A. ('A' == active, '.' == missing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4dc53f9d:f0c55279:a9cb9592:a59607c9
           Name : NAS:0
  Creation Time : Sat Sep 10 12:37:59 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027053 (1863.02 GiB 2000.40 GB)
     Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : fd282483:d2647838:f6b9897e:c216616c

    Update Time : Mon Oct  7 04:21:22 2013
       Checksum : 6df566b8 - correct
         Events : 32621

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 4dc53f9d:f0c55279:a9cb9592:a59607c9
           Name : NAS:0
  Creation Time : Sat Sep 10 12:37:59 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027053 (1863.02 GiB 2000.40 GB)
     Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e84657dd:0882a7c8:5918b191:2fc3da02

    Update Time : Tue May 27 04:46:12 2014
       Checksum : 33ab6fe - correct
         Events : 1026039

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing)

$ mdadm --examine /dev/sd[a-z]1 | egrep 'Event|/dev/sd'

/dev/sdb1:
         Events : 1026050
/dev/sdc1:
         Events : 1026050
/dev/sdd1:
         Events : 32621
/dev/sde1:
         Events : 1026039

Any and all advice greatly appreciated.

TIA
Steve
