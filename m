From: Emil Grama <egrama@gmail.com>
Subject: Fwd: Data corruption after running mdadm --add
Date: Tue, 11 Dec 2012 13:28:46 +0200
Message-ID: <CAL_R8kK6KzAE57he8AGjSamcuw7PQm06aAnXhDT_MSuoArfS3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 5 devices RAID5 array. On top of this I have 4 lvm partitions
- 3 of them mounted read-only.


One device from the array failed; I stopped the system, replaced the
device with a new one, powered it on again, partitioned the new device
 and run mdadm --manage /dev/md0 --add /dev/sdc1. The rebuild started
and finished without an apparent problem, mdadm --detail reported an
array with 5 devices active and synced and data was available all the
time.

After one reboot - the array was still healthy looking, but all 4
partitions were unmountable and unrecognizable by fsck. I powered off
the system, removed the newly added disk and after poweron I
re-asswmbled the array with 4 devices using --force; the  partitions
that were mounted readonly are now mountable again and healthy looking
- the 4th is unmountable and fsck dies on it with a "too many errors"
message.


I reproduced the operation: added the 5th device, re-synced, rebooted
and again I cannot read any partition, although mdadm reports a
healthy array.

Not sure what to do here, so I would appreciate very much your help.


Regards,
Emil


Some details about the environment:

root@blackbox:~# uname -a

Linux blackbox 2.6.32-34-generic #77-Ubuntu SMP Tue Sep 13 19:40:53
UTC 2011 i686 GNU/Linux

root@blackbox:~# cat /etc/*ease

DISTRIB_ID=Ubuntu

DISTRIB_RELEASE=10.04

DISTRIB_CODENAME=lucid

DISTRIB_DESCRIPTION="Ubuntu 10.04.3 LTS"

root@blackbox:~# mdadm --version

mdadm - v2.6.7.1 - 15th October 2008







After removing the 5th device, with 3 partitions still readable.
/dev/md0 is the array with the problem, the other arrays are fine.


oot@blackbox:~# mdadm -Evvvvs

mdadm: No md superblock detected on /dev/block/252:3.

mdadm: No md superblock detected on /dev/block/252:2.

mdadm: No md superblock detected on /dev/block/252:1.

mdadm: No md superblock detected on /dev/block/252:0.

mdadm: No md superblock detected on /dev/block/9:0.

mdadm: No md superblock detected on /dev/root.

/dev/sdb3:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : 47fed9be:26bb759c:d1cf655b:887f7986 (local to host blackbox)

  Creation Time : Mon Mar  2 19:53:52 2009

     Raid Level : raid1

  Used Dev Size : 16498688 (15.73 GiB 16.89 GB)

     Array Size : 16498688 (15.73 GiB 16.89 GB)

   Raid Devices : 2

  Total Devices : 2

Preferred Minor : 2


    Update Time : Tue Dec 11 13:05:52 2012

          State : active

 Active Devices : 2

Working Devices : 2

 Failed Devices : 0

  Spare Devices : 0

       Checksum : daeaa7f - correct

         Events : 736203



      Number   Major   Minor   RaidDevice State

this     0       8       19        0      active sync   /dev/sdb3


   0     0       8       19        0      active sync   /dev/sdb3

   1     1       8        3        1      active sync   /dev/sda3

/dev/sdb2:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : b13c9dd3:48bdb22b:d1cf655b:887f7986 (local to host blackbox)

  Creation Time : Fri Feb 27 18:38:19 2009

     Raid Level : raid5

  Used Dev Size : 960156736 (915.68 GiB 983.20 GB)

     Array Size : 3840626944 (3662.71 GiB 3932.80 GB)

   Raid Devices : 5

  Total Devices : 4

Preferred Minor : 0


    Update Time : Tue Dec 11 13:00:50 2012

          State : clean

 Active Devices : 4

Working Devices : 4

 Failed Devices : 1

  Spare Devices : 0

       Checksum : d14d8967 - correct

         Events : 1508942


         Layout : left-symmetric

     Chunk Size : 64K


      Number   Major   Minor   RaidDevice State

this     0       8       18        0      active sync   /dev/sdb2


   0     0       8       18        0      active sync   /dev/sdb2

   1     1       8        2        1      active sync   /dev/sda2

   2     2       8       51        2      active sync   /dev/sdd3

   3     3       0        0        3      faulty removed

   4     4       8       32        4      active sync   /dev/sdc

mdadm: No md superblock detected on /dev/sdb1.

mdadm: No md superblock detected on /dev/sdb.

/dev/sdc:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : b13c9dd3:48bdb22b:d1cf655b:887f7986 (local to host blackbox)

  Creation Time : Fri Feb 27 18:38:19 2009

     Raid Level : raid5

  Used Dev Size : 960156736 (915.68 GiB 983.20 GB)

     Array Size : 3840626944 (3662.71 GiB 3932.80 GB)

   Raid Devices : 5

  Total Devices : 4

Preferred Minor : 0


    Update Time : Tue Dec 11 13:00:50 2012

          State : clean

 Active Devices : 4

Working Devices : 4

 Failed Devices : 1

  Spare Devices : 0

       Checksum : d14d897d - correct

         Events : 1508942


         Layout : left-symmetric

     Chunk Size : 64K


      Number   Major   Minor   RaidDevice State

this     4       8       32        4      active sync   /dev/sdc


   0     0       8       18        0      active sync   /dev/sdb2

   1     1       8        2        1      active sync   /dev/sda2

   2     2       8       51        2      active sync   /dev/sdd3

   3     3       0        0        3      faulty removed

   4     4       8       32        4      active sync   /dev/sdc

/dev/sdd3:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : b13c9dd3:48bdb22b:d1cf655b:887f7986 (local to host blackbox)

  Creation Time : Fri Feb 27 18:38:19 2009

     Raid Level : raid5

  Used Dev Size : 960156736 (915.68 GiB 983.20 GB)

     Array Size : 3840626944 (3662.71 GiB 3932.80 GB)

   Raid Devices : 5

  Total Devices : 4

Preferred Minor : 0


    Update Time : Tue Dec 11 13:00:50 2012

          State : clean

 Active Devices : 4

Working Devices : 4

 Failed Devices : 1

  Spare Devices : 0

       Checksum : d14d898c - correct

         Events : 1508942


         Layout : left-symmetric

     Chunk Size : 64K


      Number   Major   Minor   RaidDevice State

this     2       8       51        2      active sync   /dev/sdd3


   0     0       8       18        0      active sync   /dev/sdb2

   1     1       8        2        1      active sync   /dev/sda2

   2     2       8       51        2      active sync   /dev/sdd3

   3     3       0        0        3      faulty removed

   4     4       8       32        4      active sync   /dev/sdc

mdadm: No md superblock detected on /dev/sdd2.

mdadm: No md superblock detected on /dev/sdd1.

mdadm: No md superblock detected on /dev/sdd.

/dev/sda3:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : 47fed9be:26bb759c:d1cf655b:887f7986 (local to host blackbox)

  Creation Time : Mon Mar  2 19:53:52 2009

     Raid Level : raid1

  Used Dev Size : 16498688 (15.73 GiB 16.89 GB)

     Array Size : 16498688 (15.73 GiB 16.89 GB)

   Raid Devices : 2

  Total Devices : 2

Preferred Minor : 2


    Update Time : Tue Dec 11 13:05:52 2012

          State : clean

 Active Devices : 2

Working Devices : 2

 Failed Devices : 0

  Spare Devices : 0

       Checksum : db9e63b - correct

         Events : 736202



      Number   Major   Minor   RaidDevice State

this     1       8        3        1      active sync   /dev/sda3


   0     0       8       19        0      active sync   /dev/sdb3

   1     1       8        3        1      active sync   /dev/sda3

/dev/sda2:

          Magic : a92b4efc

        Version : 00.90.00

           UUID : b13c9dd3:48bdb22b:d1cf655b:887f7986 (local to host blackbox)

  Creation Time : Fri Feb 27 18:38:19 2009

     Raid Level : raid5

  Used Dev Size : 960156736 (915.68 GiB 983.20 GB)

     Array Size : 3840626944 (3662.71 GiB 3932.80 GB)

   Raid Devices : 5

  Total Devices : 4

Preferred Minor : 0


    Update Time : Tue Dec 11 13:00:50 2012

          State : clean

 Active Devices : 4

Working Devices : 4

 Failed Devices : 1

  Spare Devices : 0

       Checksum : d14d8959 - correct

         Events : 1508942


         Layout : left-symmetric

     Chunk Size : 64K


      Number   Major   Minor   RaidDevice State

this     1       8        2        1      active sync   /dev/sda2


   0     0       8       18        0      active sync   /dev/sdb2

   1     1       8        2        1      active sync   /dev/sda2

   2     2       8       51        2      active sync   /dev/sdd3

   3     3       0        0        3      faulty removed

   4     4       8       32        4      active sync   /dev/sdc

mdadm: No md superblock detected on /dev/sda1.

mdadm: No md superblock detected on /dev/sda.
