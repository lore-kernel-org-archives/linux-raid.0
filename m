From: "Kenn" <kenn@kenn.us>
Subject: (unknown)
Date: Sun, 25 Sep 2011 21:23:31 -0700
Message-ID: <09f356fa46129bd08dd45752c0f736de.squirrel@www.maxstr.com>
Reply-To: kenn@kenn.us
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

I have a raid5 array that had a drive drop out, and resilvered the wrong
drive when I put it back in, corrupting and destroying the raid.  I
stopped the array at less than 1% resilvering and I'm in the process of
making a dd-copy of the drive to recover the files.

(1) Is there anything diagnostic I can contribute to add more
wrong-drive-resilvering protection to mdadm?  I have the command history
showing everything I did, I have the five drives available for reading
sectors, I haven't touched anything yet.

(2) Can I suggest improvements into resilvering?  Can I contribute code to
implement them?  Such as resilver from the end of the drive back to the
front, so if you notice the wrong drive resilvering, you can stop and not
lose the MBR and the directory format structure that's stored in the first
few sectors?  I'd also like to take a look at adding a raid mode where
there's checksum in every stripe block so the system can detect corrupted
disks and not resilver.  I'd also like to add a raid option where a
resilvering need will be reported by email and needs to be started
manually.  All to prevent what happened to me from happening again.

Thanks for your time.

Kenn Frank

P.S.  Setup:

# uname -a
Linux teresa 2.6.26-2-686 #1 SMP Sat Jun 11 14:54:10 UTC 2011 i686 GNU/Linux

# mdadm --version
mdadm - v2.6.7.2 - 14th November 2008

# mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90
  Creation Time : Thu Sep 22 16:23:50 2011
     Raid Level : raid5
     Array Size : 2930287616 (2794.54 GiB 3000.61 GB)
  Used Dev Size : 732571904 (698.64 GiB 750.15 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Sep 22 20:19:09 2011
          State : clean, degraded
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : ed1e6357:74e32684:47f7b12e:9c2b2218 (local to host teresa)
         Events : 0.6

    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      56        1        1      active sync   /dev/hdi1
       2       0        0        2      removed
       3      57        1        3      active sync   /dev/hdk1
       4      34        1        4      active sync   /dev/hdg1



