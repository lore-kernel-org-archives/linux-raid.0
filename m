From: Brett King <king.br@gmail.com>
Subject: mdadm 3.1.1 / 2.6.32 - trouble reducing active devices in 13TB RAID6
Date: Wed, 13 Jan 2010 16:00:10 +1100
Message-ID: <8cf253381001122100u70560392hfe6de0e8844116e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I'm using the new mdadm-3.1.1 and kernel 2.6.32 on a 13x 1TB RAID6
array and need to reduce the number of active devices in order to
eventually decommission this array.

I'm currently unable to do this however, please see below:

array:~ # uname -a
Linux array 2.6.32-41-default #1 SMP 2009-12-11 11:05:24 -0500 x86_64
x86_64 x86_64 GNU/Linux

array:~ # mdadm -V
mdadm - v3.1.1 - 19th November 2009

array:~ # mdadm -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Apr  4 21:17:09 2008
     Raid Level : raid6
     Array Size : 10744387456 (10246.65 GiB 11002.25 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 13
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jan 13 13:43:05 2010
          State : clean
 Active Devices : 13
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 251f6c00:b15f5541:4eb0bc47:eeccb517
         Events : 0.6050151

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8      224        3      active sync   /dev/sdo
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh
       8       8      144        8      active sync   /dev/sdj
       9       8      160        9      active sync   /dev/sdk
      10       8      176       10      active sync   /dev/sdl
      11       8      192       11      active sync   /dev/sdm
      12       8      208       12      active sync   /dev/sdn
array:~ #

## Reduce array size by 1x member disk in order to verify data will
remain accessible after reducing array. There is a reiser filesystem
directly on this MD device, already resized to ~300GB below the
reduced array size:

array:~ # mdadm -G /dev/md0 --array-size 9767624960 (short size option
-Z segfaults as already discussed)

## Verify new array size is now @ sum of 10x member disks:

array:~ # mdadm -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Apr  4 21:17:09 2008
     Raid Level : raid6
     Array Size : 9767624960 (9315.13 GiB 10002.05 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 13
  Total Devices : 13
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jan 13 15:06:33 2010
          State : active
 Active Devices : 13
Working Devices : 13
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 251f6c00:b15f5541:4eb0bc47:eeccb517
         Events : 0.6050154

    Number   Major   Minor   RaidDevice State
       0       8        0        0      active sync   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8      224        3      active sync   /dev/sdo
       4       8       64        4      active sync   /dev/sde
       5       8       80        5      active sync   /dev/sdf
       6       8       96        6      active sync   /dev/sdg
       7       8      112        7      active sync   /dev/sdh
       8       8      144        8      active sync   /dev/sdj
       9       8      160        9      active sync   /dev/sdk
      10       8      176       10      active sync   /dev/sdl
      11       8      192       11      active sync   /dev/sdm
      12       8      208       12      active sync   /dev/sdn
array:~ #

## Mount / verify file checksums etc - all OK

## Attempt to reduce number of active devices in array by 1x:

array:~ # mdadm -G /dev/md0 -n 12 --backup-file /tmp/md0-backup
mdadm: this change will reduce the size of the array.
       use --grow --array-size first to truncate array.
       e.g. mdadm --grow /dev/md0 --array-size 1177690368

## The suggested value of '--array-size' here doesn't make sense; plus
when trying to reduce to a different number of active devices (e.g.
11x, invalid), this number changes:

array:~ # mdadm -G /dev/md0 -n 11 --backup-file /tmp/md0-backup
mdadm: this change will reduce the size of the array.
       use --grow --array-size first to truncate array.
       e.g. mdadm --grow /dev/md0 --array-size 200927872

## Attempting to reduce to 10x active devices (invalid) gives a
different result again:

array:~ # mdadm -G /dev/md0 -n 10 --backup-file /tmp/md0-backup
mdadm: Need to backup 5632K of critical section..
array:~ #

## However (almost) nothing happens - the backup-file does get written
however there is no rebuild initiated and the array stays the same
size.

Testing this in a VM with 128MB loopback devices works as expected and
the filesystem / data survives.

Any ideas ? I saw there was mention recently of a patch to mdadm-3.1.1
which resolves a 32-bit number affecting growing of a RAID6, could
this also be the issue here ?

Thanks in advance,
Brett.
