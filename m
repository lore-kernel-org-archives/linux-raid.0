From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Growing a 3-way mirrors RAID10
Date: Sun, 12 Jan 2020 09:24:03 +0100
Message-ID: <CAJH6TXgQtbxU4Pe9PxvKUyEYsU6-na+5JNvtCHC1jqTmNLcVYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm trying to test a setup that I need in a couple of days.
a 3way mirrored RAID10, so i'm using a n3 layout.

i'm starting with just 3 disks, these 3 would be mirrored together, obviously:

sudo mdadm --create /dev/md0 --level=10 --layout=n3 --raid-devices=3
/dev/loop17 /dev/loop18 /dev/loop19
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Jan 12 09:13:37 2020
        Raid Level : raid10
        Array Size : 100352 (98.00 MiB 102.76 MB)
     Used Dev Size : 100352 (98.00 MiB 102.76 MB)
      Raid Devices : 3
     Total Devices : 3
       Persistence : Superblock is persistent

       Update Time : Sun Jan 12 09:13:37 2020
             State : clean
    Active Devices : 3
   Working Devices : 3
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=3
        Chunk Size : 512K

Consistency Policy : resync

              Name : ale-XPS13-9333:0  (local to host ale-XPS13-9333)
              UUID : 5b0e8009:7df3ed1a:a56e9edb:aff8f7c3
            Events : 17

    Number   Major   Minor   RaidDevice State
       0       7       17        0      active sync set-A   /dev/loop17
       1       7       18        1      active sync set-B   /dev/loop18
       2       7       19        2      active sync set-C   /dev/loop19


The array looks good to me, but why used dev size is equal to array size ?
In a 3way mirror it should be 3 times the array size.

Anyway, let's add 3 disks more:

$ sudo mdadm --add /dev/md0 /dev/loop20 /dev/loop21 /dev/loop22
mdadm: added /dev/loop20
mdadm: added /dev/loop21
mdadm: added /dev/loop22

$ sudo mdadm --grow /dev/md0 --raid-devices=6

$ sudo mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Jan 12 09:13:37 2020
        Raid Level : raid10
        Array Size : 200704 (196.00 MiB 205.52 MB)
     Used Dev Size : 100352 (98.00 MiB 102.76 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Sun Jan 12 09:19:19 2020
             State : clean, resyncing
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : near=3
        Chunk Size : 512K

Consistency Policy : resync

     Resync Status : 74% complete

              Name : ale-XPS13-9333:0  (local to host ale-XPS13-9333)
              UUID : 5b0e8009:7df3ed1a:a56e9edb:aff8f7c3
            Events : 33

    Number   Major   Minor   RaidDevice State
       0       7       17        0      active sync set-A   /dev/loop17
       1       7       18        1      active sync set-B   /dev/loop18
       2       7       19        2      active sync set-C   /dev/loop19
       5       7       22        3      active sync set-A   /dev/loop22
       4       7       21        4      active sync set-B   /dev/loop21
       3       7       20        5      active sync set-C   /dev/loop20


Now array size is doubled, but used dev is still the same.
Is this normal ? Is this the right procedure to grow from a 3way
mirrors raid10 to a 3way mirrors raid10 with 6 disks ?

Other question: set-A, set-B, set-C means that disk on set-A is
replicated on set-B and set-C, right ? So I can't remove more than 2
disks (set-B and set-C, in example) but i can remove set-A from the
first line and set-B and set-C from the last two lines, as they are on
different mirrors.

Is possible to have a better output ? A RAID1+0 output is much easier
to understand, because I know that I can't remove multiple disks from
a single RAID1 subset.
