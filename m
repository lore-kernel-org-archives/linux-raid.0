From: Carlos Williams <carloswill@gmail.com>
Subject: Re-arranged Drives in MDADM?
Date: Thu, 28 Jan 2010 13:58:20 -0500
Message-ID: <d80f793f1001281058g60228b6bo7fc001fcfedd4487@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I new system was built today and I don't understand why the drives are
out of order. I don't think it matters but I wanted to ask here. I am
100% sure I specified /dev/sdd2 to be my spare device but when I now
check mdadm, it does not appear this way...

[root@tuna ~]# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Thu Jan 28 06:59:49 2010
     Raid Level : raid5
     Array Size : 480391552 (458.14 GiB 491.92 GB)
  Used Dev Size : 240195776 (229.07 GiB 245.96 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Jan 28 13:50:40 2010
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : c935f1cc:af72fc84:c89aa428:f91eeb1b
         Events : 0.471

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       50        2      active sync   /dev/sdd2

       3       8       34        -      spare   /dev/sdc2


As you can see it has my /dev/sdc2 instead of /dev/sdd2 as my spare.
The problem is the drives are physically labeled on the chasis and I
was wondering why it did this and also can it be fixed. Can I move
/dev/sdd2 from number '2' position to my spare and then move /dev/sdc2
as an active member of the raid? The /dev/md0 is my entire / partition
so anything that requires me stopping the RAID becomes a little
difficult.
