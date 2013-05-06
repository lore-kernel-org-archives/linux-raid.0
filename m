From: Ricky <rickyorbixx@gmail.com>
Subject: Successfully recovered Raid5 no longer boots
Date: Tue, 7 May 2013 00:35:10 +0100
Message-ID: <CALzQTgJZ0t018RAYvymP7=Po6-2N6RdiP=qgdojnMri_4mKzaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everybody,

First time posting to this list, so please forgive any oversights with
etiquette and missing information and such.

I've not long recovered a Raid-5 array compromising of 4 disks with 2
failing (not failed) disks, with a 1-by-1 swap-out of new matching
disks. I did this with a live CD and the data was totally fine,
mountable, no issues at all.

Then I go to boot it back up, and kernel output shows that only 2 of the
4 disks could be brought up and the raid could naturally not be brought
online, resulting in obvious failure. I panic, go back to the live CD,
but nope, the raid is totally fine according to all the output.

I spoke to a friendly person on freenode's ##linux who suggested
checking if all disks including the new ones were using the 0.9
superblock that my older disks were, I jumped the gun a bit and decided
to upgrade them all to 1.0, only to find the kernel of the system on
disk did not have a version of md that supports that new superblock, so
I downgraded it. I performed this by offlining the array and recreating
it based on the output of --detail but specifically passing the
superblock parameter, as per your Wiki instructions, still no good
however. Didn't mess up the recreation as the partition still totally
accessible via the live CD.

It's at this point that I'm stuck, I've no idea what to do next and hope
you can advise. Details below:

System: CentOS 5.9, kernel 2.6.34.6

mdadm --examine /dev/sd*2
/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
localhost)
  Creation Time : Mon May  6 23:45:15 2013
     Raid Level : raid5
  Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
     Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  6 23:47:24 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bdf0c5f1 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        2        0      active sync   /dev/sda2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
localhost)
  Creation Time : Mon May  6 23:45:15 2013
     Raid Level : raid5
  Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
     Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  6 23:47:24 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bdf0c603 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdc2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
localhost)
  Creation Time : Mon May  6 23:45:15 2013
     Raid Level : raid5
  Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
     Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  6 23:47:24 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bdf0c615 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       34        2      active sync   /dev/sdc2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2
/dev/sdd2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
localhost)
  Creation Time : Mon May  6 23:45:15 2013
     Raid Level : raid5
  Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
     Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Mon May  6 23:47:24 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : bdf0c627 - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       50        3      active sync   /dev/sdd2

   0     0       8        2        0      active sync   /dev/sda2
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8       34        2      active sync   /dev/sdc2
   3     3       8       50        3      active sync   /dev/sdd2

mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Mon May  6 23:45:15 2013
     Raid Level : raid5
     Array Size : 4387537728 (4184.28 GiB 4492.84 GB)
  Used Dev Size : 1462512576 (1394.76 GiB 1497.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon May  6 23:47:24 2013
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 06dc023e:47dbfdaa:a4d2adc2:26fd5302 (local to host
localhost)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2

Many thanks in advance for any advice you have,
Ricky Burgin
