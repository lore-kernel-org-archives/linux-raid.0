From: "Calvin D. Webster" <cwebster@ec.rr.com>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Tue, 21 May 2002 07:24:49 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3CEA2E81.F08127AF@ec.rr.com>
References: <CPEAKNIMKMJOCFPEOBGACECFCFAA.cwebster@ec.rr.com> <15592.56683.75251.569129@notabene.cse.unsw.edu.au>
Reply-To: cwebster@ec.rr.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> On Sunday May 19, cwebster@ec.rr.com wrote:
> > Looking for help from list members in resolving software RAID problems.
> 
> Here is the help:
>    For each device that should be part of the array (e.g. /dev/sda1)
>    run
>       mdadm --examine /dev/sda1
>    This should show you some sensible information up to the Checksum,
>    and then bad information after that.

Yup, just like you said... sensible before, nonsense after.

>    Then run
>       mdadm --examine --sparc2.2  /dev/sda1
>    This should show you the same sensible information, and then
>    sensible information after the Checksum as well.

This looks much better, but not just right. I would expect that the list
following "Chunk Size" would be close to the /etc/raidtab that was being
used prior to the Aurora upgrade when it was last working. At any rate,
the "this" device and the last device listed are definitely not correct.
I'm not sure what "this" should be, but I assume it should list
parameters for the device being queried. 

What I'm getting with "mdadm --examine --sparc2.2":

The first device listed ("this") always has a minor number of "8". Major
numbers for the "this" device on each raid drive, a through f, are
4,5,0,2,3,1, respectively. I don't know if this is random or somehow
correlates to the original raid device sequence. None of these is an
actual raid device, though.

The last device listed is always:

   5     0       5        8       33      faulty sync

The remaining devices in the middle of each list, although out of
sequence in terms of /etc/raidtab, have the correct major/minor device
numbers. To be honest, though, I don't remember if the device list in
/proc/mdstat prior to the Aurora upgrade actually matched /etc/raidtab
in terms of raid device numbers either. If I remember correctly, they
seemed to be reversed but it worked so I left it alone. I do distinctly
remember that, prior to the Aurora upgrade, all raid devices were
operational and there was no reconstruction in progress. The system was
virtually quiescent.

How should the spare drive show up in these lists? /dev/sdc1 is missing
from all the lists. Could this have been the actual spare? 

I've included below, the complete output from "mdadm --examine
--sparc2.2" for each raid device. First, I've listed the contents of
/etc/raidtab and a long listing of the actual raid devices. Please let
me know if this makes any sense to you.

Thanks for the help!

--Cal Webster

==============================================================================================

## Contents of /etc/raidtab

------------------------------------------------
#
# 'persistent' RAID5 setup, with one spare disk:
#
raiddev /dev/md0
    raid-level                5
    nr-raid-disks             5
    nr-spare-disks            1
    persistent-superblock     1
    chunk-size                128

    device                    /dev/sdb1
    raid-disk                 1
    device                    /dev/sdc1
    raid-disk                 2
    device                    /dev/sdd1
    raid-disk                 3
    device                    /dev/sde1
    raid-disk                 4
    device                    /dev/sda1
    raid-disk                 0
    device                    /dev/sdf1
    spare-disk                0
------------------------------------------------

## Raid devices:

----------------------------------------------------------------------
brw-rw----    1 root     disk       8,   1 May  5  1998 sda1
brw-rw----    1 root     disk       8,  17 May  5  1998 sdb1
brw-rw----    1 root     disk       8,  33 May  5  1998 sdc1
brw-rw----    1 root     disk       8,  49 May  5  1998 sdd1
brw-rw----    1 root     disk       8,  65 Apr 16  1999 sde1
brw-rw----    1 root     disk       8,  81 Apr 16  1999 sdf1
----------------------------------------------------------------------

----------------[ mdadm --examine --sparc2.2  /dev/sda1
]----------------

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May  6 18:41:41 2002
          State : clean, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6515abae - correct
 --- adjusting superblock for 2.2/sparc compatability ---
         Events : 0.171

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       4        8        1     
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     0       5        8       33      faulty sync

----------------[ mdadm --examine --sparc2.2  /dev/sdb1
]----------------

/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May  6 18:41:41 2002
          State : clean, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6515abbb - correct
 --- adjusting superblock for 2.2/sparc compatability ---
         Events : 0.171

         Layout : left-asymmetric
     Chunk Size : 128K


      Number   Major   Minor   RaidDevice State
this     0       0        8       17      faulty
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     0       5        8       33      faulty sync

----------------[ mdadm --examine --sparc2.2  /dev/sdc1
]----------------

/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May  6 18:41:41 2002
          State : clean, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6515abce - correct
 --- adjusting superblock for 2.2/sparc compatability ---
         Events : 0.171

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       5        8       33      faulty sync
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     0       5        8       33      faulty sync

----------------[ mdadm --examine --sparc2.2  /dev/sdd1
]----------------

/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May  6 18:41:41 2002
          State : clean, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6515abdf - correct
 --- adjusting superblock for 2.2/sparc compatability ---
         Events : 0.171

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       2        8       49      faulty active   /dev/fd0h1200
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     0       5        8       33      faulty sync

----------------[ mdadm --examine --sparc2.2  /dev/sde1
]----------------

/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May  6 18:41:41 2002
          State : clean, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6515abf1 - correct
 --- adjusting superblock for 2.2/sparc compatability ---
         Events : 0.171

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       3        8       65      sync   /dev/hda8
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     0       5        8       33      faulty sync

----------------[ mdadm --examine --sparc2.2  /dev/sdf1
]----------------

/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 494dd54f:15e7b548:90bae5c3:532ac910
  Creation Time : Thu Apr 26 12:29:38 2001
     Raid Level : raid5
    Device Size : 17681664 (16.86 GiB 18.15 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon May  6 18:41:41 2002
          State : clean, no-errors
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 6515abfd - correct
 --- adjusting superblock for 2.2/sparc compatability ---
         Events : 0.171

         Layout : left-asymmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       1        8       81      active   /dev/ram8
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     0       5        8       33      faulty sync
