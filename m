From: "Jason Pfingstmann" <stclists@wearesimply.com>
Subject: Mdadm dirty, no errors?
Date: Fri, 23 Aug 2002 04:53:50 -0700 (MST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1122.68.14.247.164.1030103630.squirrel@mail.wearesimply.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had a problem recently (a few months ago) where I had some sort of power
event that went through my UPS..I had an out-of-sync raid array with 2
drives out.  I knew one drive was bad at that time, so I replaced it and
forced it to initialize (with 1 missing disk) with mdadm...well before I
got the array synced, another drived hit the dust.  I lost 400 GB of data,
but had an old backup of about 250 of it.  To make a long story short I
redid the array (created it faulty (I didn't have the money to replace
ANOTHER 80 drive after replacing 1 already).  Shortly after  we got the
data back on I got a disk to replace the second dead one.  It added it to
the array and it synced up.  I get this from cat /proc/mdstat

Personalities : [linear] [raid0] [raid1] [raid5]
read_ahead 1024 sectors
md0 : active raid5 hdd1[3] hdg1[6] hdf1[5] hde1[4] hdc1[2] hdb1[1] hda1[0]
      468888576 blocks level 5, 16k chunk, algorithm 0 [7/7] [UUUUUUU]
unused devices: <none>

and This from mdadm --detail /dev/md0  (The question is why dirty, no
errors????)


        Version : 00.90.00
  Creation Time : Sun Jul 14 12:22:29 2002
     Raid Level : raid5
     Array Size : 468888576 (447.16 GiB 480.14 GB)
    Device Size : 78148096 (74.52 GiB 80.02 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jul 22 22:53:16 2002
          State : dirty, no-errors
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-asymmetric
     Chunk Size : 16K

    Number   Major   Minor   RaidDevice State
       0       3        1        0      active sync   /dev/hda1
       1       3       65        1      active sync   /dev/hdb1
       2      22        1        2      active sync   /dev/hdc1
       3      22       65        3      active sync   /dev/hdd1
       4      33        1        4      active sync   /dev/hde1
       5      33       65        5      active sync   /dev/hdf1
       6      34        1        6      active sync   /dev/hdg1
           UUID : a069fe9b:2eed4ec9:a378a91a:c7207638

Again,  why is State:  dirty, no-errors??  Is this normal?



