From: Marc MERLIN <marc@merlins.org>
Subject: mismatch sector in range, kernel 4.13
Date: Mon, 4 Sep 2017 17:39:50 -0700
Message-ID: <20170905003950.6dtfdoxpbadxiibu@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

I've been seeing a few of these in my logs during a raid check:
[40320.212151] md6: mismatch sector in range 3581539536-3581539544
sadly I'm not finding help or documentation on what it really means.

First, I'd like to confirm a few things:
1) I have raid5, so obviously I can only recover from a single disk failure

2) if there is data corruption instead of a bad sector, the raid code won't
be able to know which of the blocks is corrupted, just that the parity doesn't add up,
unless each disk block comes with its own checksum to identify a block with corrupted data.
However, I'm assuming there is no such per disk block checksum, correct?

3) Given the above two, am I correct that the above message tells me that the parity
isn't adding up, but that given that all the blocks are readable, it's not possible to
know which drive has the corrupted block, nor how to reconstruct the data?

The part where I'm a bit confused is that I have btrfs on top, which has
per data and metadata block checksums, and all those checksums come out
fine (I did a full btrfs scrub on the entire filesystem).

Given this, what is the suggested course of action?

Thanks,
Marc



gargamel:~# mdadm --detail /dev/md6
/dev/md6:
        Version : 1.2
  Creation Time : Thu Jan 28 14:38:40 2016
     Raid Level : raid5
     Array Size : 23441555456 (22355.61 GiB 24004.15 GB)
  Used Dev Size : 5860388864 (5588.90 GiB 6001.04 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Sep  4 17:26:55 2017
          State : clean 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : gargamel.svh.merlins.org:6  (local to host gargamel.svh.merlins.org)
           UUID : 66bccdfb:afbf9683:fcf1f12e:f2af2dcb
         Events : 87756

    Number   Major   Minor   RaidDevice State
       0       8      177        0      active sync   /dev/sdl1
       1       8      145        1      active sync   /dev/sdj1
       2       8      193        2      active sync   /dev/sdm1
       3       8       49        3      active sync   /dev/sdd1
       5       8      161        4      active sync   /dev/sdk1


gargamel:~# grep md6 /var/log/kern.log |grep mismatch
[40320.212151] md6: mismatch sector in range 3581539536-3581539544
[40320.231695] md6: mismatch sector in range 3581539544-3581539552
[40320.251338] md6: mismatch sector in range 3581539552-3581539560
[40320.270153] md6: mismatch sector in range 3581539560-3581539568
[40320.289628] md6: mismatch sector in range 3581543792-3581543800
[40320.308638] md6: mismatch sector in range 3581543800-3581543808
[40320.327346] md6: mismatch sector in range 3581543808-3581543816
[40320.346031] md6: mismatch sector in range 3581543816-3581543824
[40320.364921] md6: mismatch sector in range 3581544112-3581544120
[40320.383582] md6: mismatch sector in range 3581544120-3581544128
[44366.792029] md6: mismatch sector in range 4052263120-4052263128
[44366.810807] md6: mismatch sector in range 4052263128-4052263136
[44366.829602] md6: mismatch sector in range 4052263136-4052263144
[44366.849048] md6: mismatch sector in range 4052263144-4052263152
[44366.868343] md6: mismatch sector in range 4052263152-4052263160
[44366.887095] md6: mismatch sector in range 4052263160-4052263168
[44366.905886] md6: mismatch sector in range 4052263168-4052263176
[44366.924536] md6: mismatch sector in range 4052263176-4052263184
[44366.943635] md6: mismatch sector in range 4052268304-4052268312
[44366.962304] md6: mismatch sector in range 4052268312-4052268320
[46437.934806] md6: mismatch sector in range 4289145456-4289145464
[46437.953908] md6: mismatch sector in range 4289145464-4289145472
[46437.972939] md6: mismatch sector in range 4289145472-4289145480
[46437.992566] md6: mismatch sector in range 4289145480-4289145488
[46438.011808] md6: mismatch sector in range 4289145552-4289145560
[46438.030841] md6: mismatch sector in range 4289145560-4289145568
[46438.050353] md6: mismatch sector in range 4289145568-4289145576
[46438.069512] md6: mismatch sector in range 4289145576-4289145584
[46438.088534] md6: mismatch sector in range 4289145584-4289145592
[46438.108675] md6: mismatch sector in range 4289145592-4289145600
[48571.335483] md6: mismatch sector in range 4532044784-4532044792
[48571.354544] md6: mismatch sector in range 4532044792-4532044800
[48571.373973] md6: mismatch sector in range 4532047280-4532047288
[48571.393075] md6: mismatch sector in range 4532047288-4532047296
[48571.412126] md6: mismatch sector in range 4532047296-4532047304
[48571.432009] md6: mismatch sector in range 4532047304-4532047312
[48571.470276] md6: mismatch sector in range 4532058192-4532058200
[48571.489270] md6: mismatch sector in range 4532058200-4532058208
[48571.510783] md6: mismatch sector in range 4532058208-4532058216
[48571.529813] md6: mismatch sector in range 4532058216-4532058224


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
