From: Another Sillyname <anothersname@googlemail.com>
Subject: Couldn't remove rebuilding drive from RAID5 rebuild, now can't add
 new drive to array?
Date: Thu, 11 Aug 2011 14:48:29 +0100
Message-ID: <CAOS+5GES654yyRPYkvSC-r5q+4n-vXwph33v_6Bf51xANRcnJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID5 array consisting of 4 drives that recently had a problem.

One of the drives 'removed' itself from the array and when I added it
back it started the background rebuilding I expected, however I then
noticed from smartctl that the drive was showing 'imminent failure'
due to 3300+ reallocated sector errors.

At this stage I decided I wanted to pull the drive before it finished
the rebuild and replace it.

However after I stopped the array using:-

mdadm --stop /dev/md126

I was unable to put that drive into fail status

mdadm --fail /dev/sdj1

No Such Device

At this stage I decided to leave the array offline till I had a
replacement drive available to slot in.

I now have the replacement drive and as I was unable to either fail or
remove the offending drive I decided to do a physical pull of the
drive, reboot the machine to show the drive remove and then a second
reboot with the new blank drive available.

This seems to have partially worked in that

mdadm -D /dev/md126
/dev/md126:
        Version : 1.2
  Creation Time : Sat Aug  6 01:24:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512960 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sun Aug  7 05:23:45 2011
          State : active, degraded, Not Started
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : MY_NEW_RAID
           UUID : herro_this_isnt_needed
         Events : 36003

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       0        0        1      removed
       2       8      161        2      active sync   /dev/sdk1
       3       8      177        3      active sync   /dev/sdl1

Which is what I expected to see.

However I cannot add the replacement drive into the array.

~ >:mdadm --add /dev/md126 /dev/sdj1
mdadm: add new device failed for /dev/sdj1 as 4: Invalid argument

~ >:mdadm --add --force /dev/md126 /dev/sdj1
mdadm: set device faulty failed for /dev/sdj1:  No such device

~ >:mdadm --re-add /dev/md126 /dev/sdj1
mdadm: --re-add for /dev/sdj1 to /dev/md126 is not possible

and even more confusingly

~ >:mdadm -E /dev/sdj1
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : not needed
           Name : My_NEW_RAID
  Creation Time : Sat Aug  6 01:24:12 2011
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3907027053 (1863.02 GiB 2000.40 GB)
     Array Size : 11721077760 (5589.05 GiB 6001.19 GB)
  Used Dev Size : 3907025920 (1863.02 GiB 2000.40 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : not needed

    Update Time : Sun Aug  7 05:23:45 2011
       Checksum : 6172254 - correct
         Events : 0

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AAAA ('A' == active, '.' == missing)


Could someone possibly point me in the right direction as to what I'm
doing wrong?

Thanks in advance.
