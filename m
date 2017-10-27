From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: mount(2) system call failed: Structure needs cleaning?
Date: Thu, 26 Oct 2017 19:32:43 -0500
Message-ID: <021c3df6-536c-73bc-84e2-281d4bd8099d@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

  After my success yesterday in starting an array from a failed system to get
a few of the reaming hylafax/avantfax files from the drive, I decided to start
the array again and make sure there was nothing else I needed to recover from
the drive. I can't get it to mount today, mount says:

# mount /dev/md126 /mnt/af/
mount: /mnt/af: mount(2) system call failed: Structure needs cleaning.

  Huh? Yesterday, when I was done with the fax file recovery, I unplugged the
usb cable attaching the drive to the computer, but did so before I had stopped
the drive. So I plugged it back in and stopped it, then unplugged it again.
All seemed OK.

  However, when I tried to create/start the array as I did yesterday, I
noticed this time mdadm created the array with Version=1.2 instead of the
original Version=1.0. It also didn't list the bitmap as internal. Strange.

  So rather then messing with it further, I stopped the array, and went back
to the original mdadm -D information to create the array as it was before.
This is the original array detail:

# mdadm -D /dev/md126
/dev/md126:
        Version : 1.0
  Creation Time : Thu Aug 21 01:43:22 2008
     Raid Level : raid1
     Array Size : 20972752 (20.00 GiB 21.48 GB)
  Used Dev Size : 20972752 (20.00 GiB 21.48 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Oct 20 15:55:58 2017
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : 1
           UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
         Events : 19154344

    Number   Major   Minor   RaidDevice State
       0       8       69        0      active sync   /dev/sde5
       -       0        0        1      removed

  So to create the array again I used:

# mdadm --verbose --create /dev/md126 --level=1 --raid-devices=2 \
--metadata=1.0 --bitmap=internal -o \
--uuid=e45cfbeb:77c2b93b:43d3d214:390d0f25 /dev/sdf5 missing

  After creating the array, things look OK, but there is a 16-bytes difference
in the array size and logically, the 'Creation Time' has changed, as well as
the 'Name' field:

# mdadm -D /dev/md126
/dev/md126:
        Version : 1.0
  Creation Time : Thu Oct 26 19:07:26 2017
     Raid Level : raid1
     Array Size : 20972736 (20.00 GiB 21.48 GB)
  Used Dev Size : 20972736 (20.00 GiB 21.48 GB)
   Raid Devices : 2
  Total Devices : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Oct 26 19:07:26 2017
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           Name : valkyrie:126  (local to host valkyrie)
           UUID : e45cfbeb:77c2b93b:43d3d214:390d0f25
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       85        0      active sync   /dev/sdf5
       -       0        0        1      removed


  So, now I really am stumped (and I didn't solve it during the time I was
writing this e-mail -- this time :). Did something break when I unplugged it
without first stopping it yesterday? Is the 16-byte difference in size what it
considers dirty?

  The logs from trying to mount it say there is an overlap with the superblock:

Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): mounting ext3 file system
using the ext4 subsystem
Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): ext4_check_descriptors:
Block bitmap for group 0 overlaps superblock
Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): ext4_check_descriptors:
Inode bitmap for group 0 overlaps superblock
Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): ext4_check_descriptors:
Inode table for group 0 overlaps superblock
Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): ext4_check_descriptors:
Block bitmap for group 1 overlaps superblock
Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): ext4_check_descriptors:
Block bitmap for group 1 not in group (block 0)!
Oct 26 19:26:04 valkyrie kernel: EXT4-fs (md126): group descriptors corrupted!

  So I'm a bit stuck. Did I corrupt everything when I created the array
without specifying the version 1.0? (I still have the other drive in the array
-- untouched), but as for this array, is there anything I can do to fix what
the log messages are complaining about and mount it again?

  When I get the motherboard back from getting a new set of shiny capacitors,
I had planned on just leaving this drive disconnected, failing it in the
array, and then attempting a re-add (or at this point, is there another way I
should try and pair it back with the saved drive to make sure it doesn't
corrupt the good one?

  Sigh... I knew that usb cable rig was just asking for trouble...

-- 
David C. Rankin, J.D.,P.E.
