From: Rick Bragg <lists@gmnet.net>
Subject: RE: fsck problems.  Can't restore raid
Date: Sun, 27 Dec 2009 13:41:25 -0500
Message-ID: <1261939285.10448.3328.camel@vibe>
References: <07.C2.04641.40BF63B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <07.C2.04641.40BF63B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks again Leslie,  I threaded my responses below.

On Sun, 2009-12-27 at 00:13 -0600, Leslie Rhorer wrote:
> > # mdadm --examine /dev/sdb1
> > mdadm: No md superblock detected on /dev/sdb1.
> > 
> > (Does this mean that sdb1 is bad? or is that OK?)
> 
> 	It doesn't necessarily mean the drive is bad, but the superblock is
> gone.  Are you having mdadm monitor your array(s) and send informational
> messages to you upon RAID events?  If not, then what may have happened is
> you lost the superblock on sdb1 and at some other time - before or after -
> lost the sda drive.  Once both events had taken place, your array is toast.
Right, I need to set up monitoring...

> 
> 	All may not be lost, however.  First of all, take care when
> re-arranging not to lose track of which drive was which at the outset.  In
> fact, other than the sda drive, you might be best served not to move
> anything.  Take special care if the system re-assigns drive letters, as it
> can easily do.
So should I just "move" the A drive? and try to fire it back up?

> 
> 	When you created your array, one of the steps you should have taken
> was to put the drive configuration into /etc/mdadm.conf.  In particular, you
> may need to attempt to re-create the array by mimicking the original command
> used to create the array, basically zeroing out the superblocks and starting
> again from scratch.  If you do it correctly, and are careful, it may be
> possible to recover the array.  Note, however, the array parameters must
> match the original configuration exactly, including the role each drive
> plays in the array.  If you get them out of line, you can really destroy all
> the data.
> 
> 	What are the contents of /etc/mdadm.conf?
> 

mdadm.conf contains this:
ARRAY /dev/md0 level=raid10 num-devices=4 UUID=3d93e545:c8d5baec:24e6b15c:676eb40f

So, by re-creating, do you mean I should try to run the "mdadm --create"
command again the same way I did back when I created the array
originally? Will that wipe out my data?



Also, here is my output from smart tests:  Does this shed any more light
on anything?  I'm not sure what the "Remaining" and "LifeTime" fiends
mean...

# smartctl -l selftest /dev/sda
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Standard Inquiry (36 bytes) failed [No such device]
Retrying with a 64 byte Standard Inquiry
Standard Inquiry (64 bytes) failed [No such device]
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.


# smartctl -l selftest /dev/sdb
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%      7963         543357



# smartctl -l selftest /dev/sdc
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      7964         -


# smartctl -l selftest /dev/sdd
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF READ SMART DATA SECTION ===
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      7965         -





This is strange, now I am getting info from mdadm --examine that is
different than before...

# mdadm --examine /dev/sda
mdadm: No md superblock detected on /dev/sda.

# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3d93e545:c8d5baec:24e6b15c:676eb40f (local to host
smoke)
  Creation Time : Wed Jan 28 14:58:49 2009
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Thu Dec 24 19:25:40 2009
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : edcd7fb8 - correct
         Events : 1131433

         Layout : near=2, far=1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1



# mdadm --examine /dev/sdb
mdadm: No md superblock detected on /dev/sdb.

# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3d93e545:c8d5baec:24e6b15c:676eb40f (local to host
smoke)
  Creation Time : Wed Jan 28 14:58:49 2009
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Dec 16 15:33:13 2009
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : edc67464 - correct
         Events : 687460

         Layout : near=2, far=1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1



# mdadm --examine /dev/sdc
mdadm: No md superblock detected on /dev/sdc.

# mdadm --examine /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3d93e545:c8d5baec:24e6b15c:676eb40f (local to host
smoke)
  Creation Time : Wed Jan 28 14:58:49 2009
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Thu Dec 24 19:25:58 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : eddec3ad - correct
         Events : 1131438

         Layout : near=2, far=1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1



# mdadm --examine /dev/sdd
mdadm: No md superblock detected on /dev/sdd.

# mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 3d93e545:c8d5baec:24e6b15c:676eb40f (local to host
smoke)
  Creation Time : Wed Jan 28 14:58:49 2009
     Raid Level : raid10
  Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
     Array Size : 976767872 (931.52 GiB 1000.21 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Thu Dec 24 19:25:58 2009
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : eddec3bf - correct
         Events : 1131438

         Layout : near=2, far=1
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1



Thanks again for all your help!
Rick















