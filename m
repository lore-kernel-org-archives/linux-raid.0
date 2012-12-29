From: Ciprian Dorin Craciun <ciprian.craciun@gmail.com>
Subject: Adding a fresh drive to a degraded RAID1 (not as spare but instead of
 a "removed" device)
Date: Sat, 29 Dec 2012 22:52:16 +0200
Message-ID: <CA+Tk8fzcugVx1OoMnut4Dg8OEEmLNeFQj0qSNu8hrsrwENuJCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

    Hello all!

    Although I've done this a couple of times before, I don't know
what I'm doing wrong here, but I can't add a device to a degraded
RAID1...

    My guess is that it's either from the feature "mix" or something
else that escapes me...
    * I use LVM2 as MD members; (this worked before, thus I would exclude this;)
    * I use "write intent bitmap";
    * I use "write mostly"; (this has also worked before...)

    Here are my commands:
    * I create the degraded MD device:
~~~~
mdadm \
    --verbose \
    --create \
    /dev/md/raid \
    --level=raid1 \
    --metadata=1.0 \
    --raid-devices=3 \
    --spare-devices=0 \
    --write-behind=1024 \
    --bitmap=internal \
    --bitmap-chunk=1M \
    --name=raid-device \
    --auto=md \
    /dev/mapper/raid-member-1 \
    missing \
    missing
~~~~
    * I then create an Ext2 file system and fill it;
    * I then intend to add a new device to the mirror:
~~~~
mdadm \
    --verbose \
    --manage \
    /dev/md/raid \
    --add \
    --write-mostly \
    /dev/mapper/raid-member-2
~~~~

    Unfortunately the `raid-member-2` appears as faulty and refuses to
be added... Initially this disk was all `0x00`... But I've also tried
to "zero" the superblock. (The block device is writable because I can
zero it...)
~~~~
mdadm \
    --zero-superblock \
    --metadata=1.0 \
    /dev/mapper/raid-member-2
~~~~

    The output of query gives:
~~~~
        Version : 1.0
  Creation Time : Sat Dec 29 15:44:26 2012
     Raid Level : raid1
     Array Size : 67108736 (64.00 GiB 68.72 GB)
  Used Dev Size : 67108736 (64.00 GiB 68.72 GB)
   Raid Devices : 3
  Total Devices : 2
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Sat Dec 29 22:56:15 2012
          State : active, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0

           Name : ...
           UUID : ...
         Events : 591

    Number   Major   Minor   RaidDevice State
       0     254        0        0      active sync   /dev/dm-0
       1       0        0        1      removed
       2       0        0        2      removed

       3     254        1        -      faulty writemostly spare   /dev/dm-1
~~~~

    I'm just lost... :)

    Thanks for the help,
    Ciprian.
