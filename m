From: Hal Vaughan <hal@thresholddigital.com>
Subject: Restoring a RAID 5
Date: Tue, 17 Oct 2006 19:08:27 -0400
Message-ID: <200610171908.27505.hal@thresholddigital.com>
Reply-To: hal@thresholddigital.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would expect this question to be answered in the FAQ, but the site 
seems to be down.  At least I can't get to it now.  I'm sure this is 
simple, but I want to be sure I get it right the first time and don't 
mess up the data.

I have a system with 5 drives: a system/boot drive and a RAID5  composed 
of 3 active drives and a spare (formated in ext3).  The boot/system 
drive died on me the other day and I've restored it, re-installing 
Debian Sarge.  The RAID drives were not effected by the failure.

Now that the system is up and running, I want to restore the RAID.   
I've been searching and tried:

mdadm --examine --scan /dev/hde /dev/hdf /dev/hdg /dev/hdh

and got:

ARRAY /dev/md0 level=raid5 num-devices=3 
UUID=d6fd4af2:5e5d0da2:9dec7c5f:ad60c25d
   devices=/dev/hdf

I'm a little puzzled by this, since I created the drive specifying hde 
first, and would expect mdadm to find that drive and not hdf.  It also 
finds only that one drive and does not seem to see hde or hdg as part 
of the RAID.

When I tried 

mdadm --examine /dev/hdf

I got:

/dev/hdf:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d6fd4af2:5e5d0da2:9dec7c5f:ad60c25d
  Creation Time : Fri Dec  9 12:41:00 2005
     Raid Level : raid5
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 0

    Update Time : Fri Dec  9 15:44:21 2005
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : ba586641 - correct
         Events : 0.82

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3      34       64        3      spare   /dev/hdh

   0     0      33        0        0      active sync   /dev/hde
   1     1      33       64        1      active sync   /dev/hdf
   2     2      34        0        2      active sync   /dev/hdg
   3     3      34       64        3      spare   /dev/hdh

That made me feel better, since it shows me that at least mdadm "knows", 
somehow, the structure and all the disks in the RAID.

When I type the same for any other drive, I get (depending on the drive 
letter):

mdadm: No super block found on /dev/hdg (Expected magic a92b4efc, got 
00000000)

Is this correct?  Is there only one superblock and not one per drive?  
(I may have misunderstood that.)

I thought, from the man page, that I could type:

mdadm --assemble --scan and have it assemble the RAID again, but that 
doesn't.  I've tried a few combinations, but nothing seems to work.  I 
get errors and it seems I need to include info in the config file to 
make it work.

I've seen a fair number of tutorials on setting up RAID drives, but 
almost nothing on restoring one that exists.  I guess this would be 
treated the same as if I were moving it from one computer to another.  
I've found some info on this in the archives of this list, but nothing 
that actually addressed this issue (I'm still searching, though).

Before anyone asks about backups, I don't have an exact backup (don't 
yet have the space and equipment), but I can restore the data.  Doing 
so will take time and I'd really like to know how to take care of this 
so if it happens in the future with a drive I need restored quickly, 
I'll be sure to know how to handle it.

I feel like I'm being lazy asking this outright, but should there be 
just a single command using --scan and --assemble and a few options 
that will rebuild this and mount it as md0?

Thanks for any help on this -- and if anyone knows of a mirror of the 
FAQ, I'd like the link since I can't get the original site to load.

Hal
