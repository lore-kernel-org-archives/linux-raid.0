From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: Software RAID Stopped Working With Aurora Kernel
Date: Tue, 21 May 2002 11:30:01 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAEENACPAA.kc130iseo@coastalnet.com>
References: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Neil Brown
> Sent: Tuesday, May 21, 2002 6:10 AM
> To: cwebster@ec.rr.com
> Cc: linux-raid
> Subject: Re: Software RAID Stopped Working With Aurora Kernel
>

Before I could react, Tom Callaway had applied the patch and placed a
rebuilt binary rpm on the Aurora site.

This looks much more like normal. The device sequence, by raid device
number, looks right now. The reason it doesn't match /etc/raidtab exactly is
because I conducted failure/fail-over tests after placing this RAID in
service. The tests involved rendering one, then two of the devices
inoperable (/dev/sdc1) and verify that the raid would pick-up the spare
(/dev/sdf1) on the first failure and run in degraded mode following the
second. After bringing the simulated failures back on-line I didn't bother
to re-order the devices.

I've again appended the output from "mdadm --examine --sparc2.2" for each
device to the end of this message for your reference.

Just a couple of questions before I proceed:

1. Is there anything I need to change in "/etc/raidtab"?
	- Should it match the actual configuration?
	- Differences between raidtools 0.90-6 and 1.00.2-1.3

2. Will the "Version" number in the superblock automatically be updated when
I start the RAID?


Thank you very much for seeing this through with me!

--Cal Webster

P.S. You need not cc: my email address. I'm a list member so I get duplicate
messages.

==================
Things to do next:
==================

## Update the superblock:

mdadm --examine --sparc2.2update /dev/sda1

## Re-check after updating:

mdadm --examine --sparc2.2 /dev/sda1

## Assemble the array (use raid device order):
## Only assemble active devices, not spare.

mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdf1 /dev/sdd1 /dev/sde1

## Start the RAID

raidstart /dev/md0

## Verify that raid is running

cat /proc/mdstat

## Verify that data is intact

=================================================================
--------[ mdadm --examine --sparc2.2  /dev/sda1 ]--------

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
this     4       8        1        0      active sync   /dev/sda1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     5       8       33        5        /dev/sdc1

--------[ mdadm --examine --sparc2.2  /dev/sdb1 ]--------

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
this     0       8       17        1      active sync   /dev/sdb1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     5       8       33        5        /dev/sdc1

--------[ mdadm --examine --sparc2.2  /dev/sdc1 ]--------

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
this     5       8       33        5        /dev/sdc1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     5       8       33        5        /dev/sdc1

--------[ mdadm --examine --sparc2.2  /dev/sdd1 ]--------

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
this     2       8       49        3      active sync   /dev/sdd1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     5       8       33        5        /dev/sdc1

--------[ mdadm --examine --sparc2.2  /dev/sde1 ]--------

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
this     3       8       65        4      active sync   /dev/sde1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     5       8       33        5        /dev/sdc1

--------[ mdadm --examine --sparc2.2  /dev/sdf1 ]--------

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
this     1       8       81        2      active sync   /dev/sdf1
   0     0       8       17        1      active sync   /dev/sdb1
   1     1       8       81        2      active sync   /dev/sdf1
   2     2       8       49        3      active sync   /dev/sdd1
   3     3       8       65        4      active sync   /dev/sde1
   4     4       8        1        0      active sync   /dev/sda1
   5     5       8       33        5        /dev/sdc1

=================================================================

