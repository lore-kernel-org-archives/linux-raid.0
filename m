From: Santiago DIEZ <santiago.diez@caoba.fr>
Subject: Impossibly level change request for RAID1
Date: Wed, 15 Nov 2017 17:52:32 +0100
Message-ID: <CAJh8RqV84uXJ9hV4uSAK-GsnN=FP4fT-S0VNNkSVOay5xZqt8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I started by mistake a raid as RAID1 with 5 disks when my desire was
to start it as RAID5. Technically, there is no data at all so I could
entirely recreate the raid but this is NOT what I want. I'm taking
this opportunity as an exercise to change a raid level.

The initial state of the raid is:
md9 : active raid1 sda9[0] sdb9[1] sdc9[2] sdd9[3] sde9[4]
      5846755328 blocks super 1.2 [5/5] [UUUUU]
      bitmap: 0/44 pages [0KB], 65536KB chunk

# I tried to change the level with:
mdadm /dev/md9 --grow --level=5
# But got the error :
mdadm: Impossibly level change request for RAID1

# I followed a howto and did:

# Fail and remove one disk and reduce the size of the raid:
mdadm /dev/md9 --fail /dev/sde9
mdadm /dev/md9 --remove /dev/sde9
mdadm /dev/md9 --remove /dev/sde9

# The status is now
/dev/md9:
        Version : 1.2
  Creation Time : Thu Aug 31 13:21:32 2017
     Raid Level : raid1
     Array Size : 5846755328 (5575.90 GiB 5987.08 GB)
  Used Dev Size : 5846755328 (5575.90 GiB 5987.08 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Nov 15 16:52:42 2017
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           Name : rescue.ovh.net:9
           UUID : ff7df55b:357263cd:009f3a94:89293230
         Events : 24

    Number   Major   Minor   RaidDevice State
       0       8        9        0      active sync   /dev/sda9
       1       8       25        1      active sync   /dev/sdb9
       2       8       41        2      active sync   /dev/sdc9
       3       8       57        3      active sync   /dev/sdd9



# I re-added sde9 hopping it would become spare:
mdadm /dev/md9 --add /dev/sde9

# But surprisingly, sda9 became faulty at the same time:
/dev/md9:
        Version : 1.2
  Creation Time : Thu Aug 31 13:21:32 2017
     Raid Level : raid1
     Array Size : 5846755328 (5575.90 GiB 5987.08 GB)
  Used Dev Size : 5846755328 (5575.90 GiB 5987.08 GB)
   Raid Devices : 4
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Nov 15 17:10:29 2017
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0

           Name : rescue.ovh.net:9
           UUID : ff7df55b:357263cd:009f3a94:89293230
         Events : 29

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
            <<< What's that?!!!
       1       8       25        1      active sync   /dev/sdb9
       2       8       41        2      active sync   /dev/sdc9
       3       8       57        3      active sync   /dev/sdd9
       0       8        9        -      faulty   /dev/sda9
          <<< sda9 is faulty
       4       8       73        4      active sync   /dev/sde9



# So I removed and re-added sda9 like this:
mdadm /dev/md9 --remove /dev/sda9
mdadm /dev/md9 --add /dev/sda9

# It was succesfully added as spare but I still have a weird line:
/dev/md9:
        Version : 1.2
  Creation Time : Thu Aug 31 13:21:32 2017
     Raid Level : raid1
     Array Size : 5846755328 (5575.90 GiB 5987.08 GB)
  Used Dev Size : 5846755328 (5575.90 GiB 5987.08 GB)
   Raid Devices : 4
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Nov 15 17:34:10 2017
          State : clean, degraded
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

           Name : rescue.ovh.net:9
           UUID : ff7df55b:357263cd:009f3a94:89293230
         Events : 31

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
            <<< What's that?!!!
       1       8       25        1      active sync   /dev/sdb9
       2       8       41        2      active sync   /dev/sdc9
       3       8       57        3      active sync   /dev/sdd9
       0       8        9        -      spare   /dev/sda9
       4       8       73        4      active sync   /dev/sde9



# Then I eventually tried again to change the level:
sudo mdadm /dev/md9 --grow --level=5 --raid-devices=5

# But still got the same issue:
mdadm: Impossibly level change request for RAID1



Any clue ?

Regards
-------------------------
Santiago DIEZ
Quark Systems & CAOBA
23 rue du Buisson Saint-Louis, 75010 Paris
-------------------------
