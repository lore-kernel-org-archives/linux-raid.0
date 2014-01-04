From: Fabian Knorr <knorrfab@fim.uni-passau.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Sat, 04 Jan 2014 23:05:43 +0100
Message-ID: <1388873143.7641.20.camel@vessel>
References: <1388829881.16265.20.camel@vessel> <52C835C9.3050707@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-RzWW6OH+julSGI7+6sg8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C835C9.3050707@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-RzWW6OH+julSGI7+6sg8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi, Phil,

thank you very much for your reply.

> Side note: If you have a live spare available for a raid5, there's no
> good reason not to reshape to a raid6, and very good reasons to do so.

I was worried that RAID6 would incur a significant load on the CPU,
especially if one disk fails. The system is a single-core Intel Atom.

> Device names are not guaranteed to remain identical from one boot to
> another.  And often won't be if a removable device is plugged in at that
> time.  The linux MD driver keeps identity data in the superblock that
> makes the actual device names immaterial.
> 
> It is really important that we get a "map" of device names to drive
> serial numbers, and adjust all future operations to ensure we are
> working with the correct names.  An excerpt from "ls -l
> /dev/disk/by-id/" would do.  And you need to verify it after every boot
> until this crisis is resolved.

See the attachment "partitions". I grep'ed for raid partitions.

> 1) raid.status appears to be from *after* your --add attempts.  That
> means anything in those reports from those devices is useless.  So we
> will have to figure out what that data was.

Could it be that --add only changed the superblock of one disk,
namely /dev/sdb in file from my first e-mail?

> 2) You attempted to recreate the array.  If you left out
> "--assume-clean", your data is toast.  Please show the precise command
> line you used in your re-create attempt.  Also generate a fresh
> "raid.status" for the current situation.

The only commands I used were --add /dev/sdb, --run, --assemble --scan,
--assemble --scan --force and --stop. I didn't try to re-create it, at
least not now. Also, the timestamp from raid.status (2011) is incorrect,
the array was re-created from scratch in the summer of 2012. I can't
tell why disks other than /dev/sdb1 have an invalid superblock.

> 3) The array seems to think it's member devices were /dev/sda through
> /dev/sdh (not in that order).  Your "raid.status" has /dev/sd[abcefghi],
> suggesting a rescue usb or some such is /dev/sdd. 

Yes, that's correct.

> 4) Please describe the structure of the *content* of the array, so we
> can suggest strategies to *safely* recognize when our future attempts to
> --create --assume-clean have succeeded.  LVM?  Partitioned?  One big
> filesystem?

I'm using the array as a physical volume for LVM.

Thanks for your help.

Fabian



--=-RzWW6OH+julSGI7+6sg8
Content-Disposition: attachment; filename="uuids"
Content-Type: text/plain; name="uuids"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/dev/sda1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000549c5-01" 
/dev/sdb1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="0004ab8d-01" 
/dev/sdc1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="0003ba2a-01" 
/dev/sde1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000f04e8-01" 
/dev/sdf1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="0002f1df-01" 
/dev/sdg1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000d882d-01" 
/dev/sdh1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000658a7-01" 
/dev/sdi1: UUID="cb5a6670-1b5d-391f-edd8-d016611227ea" TYPE="linux_raid_member" PARTUUID="000d8fc8-01" 

--=-RzWW6OH+julSGI7+6sg8
Content-Disposition: attachment; filename="raid.status"
Content-Type: text/plain; name="raid.status"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/dev/sda:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:51:28 2014
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f430c2a6 - correct
         Events : 24433

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     4       8        1        4      active sync   /dev/sda1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 8
Preferred Minor : 0

    Update Time : Sun Oct 27 15:00:43 2013
          State : active
 Active Devices : 7
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 1
       Checksum : f3d95119 - correct
         Events : 24319

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     4       8       17        4      active sync   /dev/sdb1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8       17        4      active sync   /dev/sdb1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
   7     7       8        1        7      spare   /dev/sda1
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sdc1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:51:28 2014
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f430c2c8 - correct
         Events : 24433

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     5       8       33        5      active sync   /dev/sdc1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
/dev/sdd:
   MBR Magic : aa55
Partition[0] :      1001472 sectors at         2048 (type 83)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:51:28 2014
          State : active
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f430c2da - correct
         Events : 24433

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     6       8       49        6      active sync   /dev/sdd1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       8        1        4      active sync   /dev/sda1
   5     5       8       33        5      active sync   /dev/sdc1
   6     6       8       49        6      active sync   /dev/sdd1
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f43123f2 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     0       8       65        0      active sync   /dev/sde1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdg:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f4312404 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     1       8       81        1      active sync   /dev/sdf1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdh:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f4312416 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     2       8       97        2      active sync   /dev/sdg1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdi:
   MBR Magic : aa55
Partition[0] :   3907026944 sectors at         2048 (type 83)
/dev/sdi1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : cb5a6670:1b5d391f:edd8d016:611227ea
  Creation Time : Wed Jul 13 13:47:12 2011
     Raid Level : raid5
  Used Dev Size : 1953512448 (1863.01 GiB 2000.40 GB)
     Array Size : 11721074688 (11178.09 GiB 12002.38 GB)
   Raid Devices : 7
  Total Devices : 7
Preferred Minor : 0

    Update Time : Wed Jan  1 22:55:03 2014
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 3
  Spare Devices : 0
       Checksum : f4312428 - correct
         Events : 24506

         Layout : left-symmetric
     Chunk Size : 1024K

      Number   Major   Minor   RaidDevice State
this     3       8      113        3      active sync   /dev/sdh1

   0     0       8       65        0      active sync   /dev/sde1
   1     1       8       81        1      active sync   /dev/sdf1
   2     2       8       97        2      active sync   /dev/sdg1
   3     3       8      113        3      active sync   /dev/sdh1
   4     4       0        0        4      faulty removed
   5     5       0        0        5      faulty removed
   6     6       0        0        6      faulty removed
/dev/sdj:
   MBR Magic : aa55
Partition[0] :      1069056 sectors at            0 (type 00)
Partition[1] :        63488 sectors at        95576 (type ef)
/dev/sdj1:
   MBR Magic : aa55
Partition[0] :      1069056 sectors at            0 (type 00)
Partition[1] :        63488 sectors at        95576 (type ef)
/dev/sdj2:
   MBR Magic : aa55

--=-RzWW6OH+julSGI7+6sg8--

