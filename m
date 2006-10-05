From: mickg <mickg@mickg.net>
Subject: mdadm RAID5 Grow
Date: Wed, 4 Oct 2006 21:26:47 -0700 (PDT)
Message-ID: <6652499.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have been trying to run: 
mdadm --grow /dev/md0 --raid-devices=6 --backup-file /backup_raid_grow
I get:
mdadm: Need to backup 1280K of critical section..
mdadm: /dev/md0: Cannot get array details from sysfs

Software versions:
mdadm version 2.5.3, kernel 2.6.17.13

Note that /dev/md0 does in fact have 6 drives, with 4+2 spares:

linux-nas:~/source/mdadm-2.5.3 # mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Mon Dec 31 20:20:05 2001
     Raid Level : raid5
     Array Size : 937681536 (894.24 GiB 960.19 GB)
    Device Size : 312560512 (298.08 GiB 320.06 GB)
   Raid Devices : 4
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Oct  5 00:24:18 2006
          State : clean
 Active Devices : 4
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 2

         Layout : left-symmetric
     Chunk Size : 128K

           UUID : 0d4e2bae:95de9dc6:4bf9f695:9e1a48be
         Events : 0.988859

    Number   Major   Minor   RaidDevice State
       0       8      209        0      active sync   /dev/sdn1
       1       8      145        1      active sync   /dev/sdj1
       2       8      129        2      active sync   /dev/sdi1
       3       8      161        3      active sync   /dev/sdk1

       4       8      192        -      spare   /dev/sdm
       5       8      176        -      spare   /dev/sdl

As I said, I am getting an error resizing the array.

Would it need to be unmounted to work properly (It is currently mounted
under lvm)?

Thank you in advance,
mickg
-- 
View this message in context: http://www.nabble.com/mdadm-RAID5-Grow-tf2386446.html#a6652499
Sent from the linux-raid mailing list archive at Nabble.com.

