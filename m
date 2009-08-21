From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Growing raid 5: Failed to reshape
Date: Sat, 22 Aug 2009 01:01:57 +0530
Message-ID: <5c45fce80908211231v9238a12i3829ad5d1b107df5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

Here is my problem and configuration. :

I had a 3 partition raid5 cluster to which I added  a 4th disk and
tried to grow the raid5 by adding the partition on the 4th disk and
then growing it. Unfortunately since another sync task was happening
on the same disks, the operation to move the critical section did not
complete before the machine was shutdown by the UPS (in control not a
crash) due to low battery.

 Kernel: 2.6.30.4; mdadm (tried 2.6.7 and 3.0)

Now, only 1 of my 3 partitions has the superblock and the other 2 and
the 4th new one does not have anything.

Here is the output of a few mdadm commands.

$mdadm --misc --examine /dev/sdd5
/dev/sdd5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4
     Array UUID : 495f6668:f1e12d10:99520f92:7619b487
           Name : GATEWAY:raid5_280G  (local to host GATEWAY)
  Creation Time : Fri Jul 31 23:05:48 2009
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
     Array Size : 1758296832 (838.42 GiB 900.25 GB)
  Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 754ae1cf:bbee0582:f660ec89:a88800d3

  Reshape pos'n : 0
  Delta Devices : 1 (3->4)

    Update Time : Fri Aug 21 09:55:38 2009
       Checksum : e18481fb - correct
         Events : 13581

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 4 (0, failed, failed, 2, 1, 3)
   Array State : uUuu 2 failed

$mdadm --assemble --scan
mdadm: Failed to restore critical section for reshape, sorry.

I am positive that none of the actual growing steps even started so my
data 'should' be safe as long as I can recreate the superblocks,
right?

As always, appreciate the help of the open source community. Thanks!!

Thanks,
Anshuman
