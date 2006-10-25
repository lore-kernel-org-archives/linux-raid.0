From: greg@enjellic.com
Subject: RAID5 refuses to accept replacement drive.
Date: Wed, 25 Oct 2006 11:52:05 -0500
Message-ID: <200610251652.k9PGq5tt032608@wind.enjellic.com>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Good morning to everyone, hope everyone's day is going well.

Neil, I sent this to your SUSE address a week ago but it may have
gotten trapped in a SPAM filter or lost in the shuffle.

I've used MD based RAID since it first existed.  First time I've run
into a situation like this.

Environment:
	Kernel: 2.4.33.3
	MDADM:  2.4.1/2.5.3
	MD:	Three drive RAID5 (md3)

A 'silent' disk failure was experienced in a SCSI hot-swap chassis
during a yearly system upgrade.  Machine failed to boot until 'nobd'
directive was given to LILO.  Drive was mechanically dead but
electrically alive.

Drives were shuffled to get the machine operational.  The machine came
up with md3 degraded.  The md3 device refuses to accept a replacement
partition using the following syntax:

mdadm --manage /dev/md3 -a /dev/sde1

No output from mdadm, nothing in the logfiles.  Tail end of strace is
as follows:

open("/dev/md3", O_RDWR)                = 3
fstat64(0x3, 0xbffff8fc)                = 0
ioctl(3, 0x800c0910, 0xbffff9f8)        = 0
_exit(0)                                = ?

I 'zeroed' the superblock on /dev/sde1 to make sure there was nothing
to interfere.  No change in behavior.

I know the 2.4 kernels are not in vogue but this is from a group of
machines which are expected to run a year at a time.  Stability and
known behavior are the foremost goals.

Details on the MD device and component drives are included below.

We've handled a lot of MD failures, first time anything like this has
happened.  I feel like there is probably a 'brown paper bag' solution
to this but I can't see it.

Thoughts?

Greg

---------------------------------------------------------------------------
/dev/md3:
        Version : 00.90.00
  Creation Time : Fri Jun 23 19:51:43 2006
     Raid Level : raid5
     Array Size : 5269120 (5.03 GiB 5.40 GB)
    Device Size : 2634560 (2.51 GiB 2.70 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Wed Oct 11 04:33:06 2006
          State : active, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : cdd418a1:4bc3da6b:1ec17a15:e73ecadd
         Events : 0.25

    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
       1       0        0        1      removed
       2       8       33        2      active sync   /dev/sdc1
---------------------------------------------------------------------------


Details for raid device 0:

---------------------------------------------------------------------------
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : cdd418a1:4bc3da6b:1ec17a15:e73ecadd
  Creation Time : Fri Jun 23 19:51:43 2006
     Raid Level : raid5
    Device Size : 2634560 (2.51 GiB 2.70 GB)
     Array Size : 5269120 (5.03 GiB 5.40 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3

    Update Time : Wed Oct 11 04:33:06 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 52b602d5 - correct
         Events : 0.25

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
---------------------------------------------------------------------------


Details for RAID device 2:

---------------------------------------------------------------------------
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : cdd418a1:4bc3da6b:1ec17a15:e73ecadd
  Creation Time : Fri Jun 23 19:51:43 2006
     Raid Level : raid5
    Device Size : 2634560 (2.51 GiB 2.70 GB)
     Array Size : 5269120 (5.03 GiB 5.40 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 3

    Update Time : Wed Oct 11 04:33:06 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 52b602c9 - correct
         Events : 0.25

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       0        0        1      faulty removed
   2     2       8       33        2      active sync   /dev/sdc1
---------------------------------------------------------------------------

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"We restored the user's real .pinerc from backup but another of our users
must still be missing those cows."
                                -- Malcolm Beattie
