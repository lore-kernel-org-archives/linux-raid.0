From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Correct stride and stripe-width
Date: Tue, 10 Apr 2012 14:52:15 -0300
Message-ID: <CAGmni9pP3K75hX0HYFRfkhusfQr7T3kBnQqyTLq+k_nX2pXh-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi , i was reading about how improving raid 5 performance and lots of
places says that i must tune stride and stripe-width.
I have not chose any option during ext3 filesystem creation , but
dumpe2fs shows me:

Filesystem volume name:   RAID_DATA
RAID stride:                4096
RAID stripe width:        536870912


# mdadm --detail /dev/md1
       Version : 0.90
  Creation Time : Thu Mar 29 12:50:27 2012
     Raid Level : raid5
     Array Size : 2720559744 (2594.53 GiB 2785.85 GB)
  Used Dev Size : 1360279872 (1297.26 GiB 1392.93 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Apr 10 13:09:55 2012
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K



The  Chunk Size is : 64K and  the filesystem is built over an
encrypted partition.

So , are those stride and stripe width correct ? I think mkfs.ext3 put
those values by itself.



[]'s
Salatiel
