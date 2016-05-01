From: Patrice <mailinglist@pboenig.de>
Subject: I was dump, I need help.
Date: Sun, 1 May 2016 12:38:33 +0200
Message-ID: <5725DCA9.9010901@pboenig.de>
Reply-To: Patrice <mailinglist@pboenig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It has a Debian 7 installed and a RAID 5.
Here some more Informations.

Thank you and best regards.
Patrice




root@ReadyNAS:/proc# cat mdstat
Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md1 : active raid6 sda2[0] sdc2[3] sdb2[2] sdd2[1]
       1046528 blocks super 1.2 level 6, 512k chunk, algorithm 2 [4/4] 
[UUUU]

md0 : active raid1 sda1[4] sdd1[3] sdc1[2] sdb1[5]
       4190208 blocks super 1.2 [4/4] [UUUU]

unused devices: <none>

-----------------------------------------------------------------------

/dev/sda1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2495045b:2aa5bd3c:8cff9bb5:de4e769c
            Name : 119c1bce:0  (local to host 119c1bce)
   Creation Time : Sun Apr  3 06:27:48 2016
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 8380416 (4.00 GiB 4.29 GB)
      Array Size : 4190208 (4.00 GiB 4.29 GB)
     Data Offset : 8192 sectors
    Super Offset : 8 sectors
    Unused Space : before=8104 sectors, after=0 sectors
           State : clean
     Device UUID : 5a053636:aeb9cb79:8f7f8807:8263480b

     Update Time : Sun May  1 11:29:51 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : cd6387b5 - correct
          Events : 343


    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

-----------------------------------------------------------------------

/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2495045b:2aa5bd3c:8cff9bb5:de4e769c
            Name : 119c1bce:0  (local to host 119c1bce)
   Creation Time : Sun Apr  3 06:27:48 2016
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 8380416 (4.00 GiB 4.29 GB)
      Array Size : 4190208 (4.00 GiB 4.29 GB)
     Data Offset : 8192 sectors
    Super Offset : 8 sectors
    Unused Space : before=8104 sectors, after=0 sectors
           State : clean
     Device UUID : 58b53ace:3e80e778:41c7e259:a631d7f1

     Update Time : Sun May  1 11:30:02 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 9d6d1427 - correct
          Events : 343


    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

---------------------------------------------------------------------
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2495045b:2aa5bd3c:8cff9bb5:de4e769c
            Name : 119c1bce:0  (local to host 119c1bce)
   Creation Time : Sun Apr  3 06:27:48 2016
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 8380416 (4.00 GiB 4.29 GB)
      Array Size : 4190208 (4.00 GiB 4.29 GB)
     Data Offset : 8192 sectors
    Super Offset : 8 sectors
    Unused Space : before=8104 sectors, after=0 sectors
           State : clean
     Device UUID : c92580fb:f2a7cd6a:9090dcfd:20d59709

     Update Time : Sun May  1 11:30:20 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 78531924 - correct
          Events : 343


    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

-----------------------------------------------------------------
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2495045b:2aa5bd3c:8cff9bb5:de4e769c
            Name : 119c1bce:0  (local to host 119c1bce)
   Creation Time : Sun Apr  3 06:27:48 2016
      Raid Level : raid1
    Raid Devices : 4

  Avail Dev Size : 8380416 (4.00 GiB 4.29 GB)
      Array Size : 4190208 (4.00 GiB 4.29 GB)
     Data Offset : 8192 sectors
    Super Offset : 8 sectors
    Unused Space : before=8104 sectors, after=0 sectors
           State : active
     Device UUID : 38deb03b:1d552d92:6532842d:34f5480d

     Update Time : Sun May  1 11:30:26 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 133c40ae - correct
          Events : 344


    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)






