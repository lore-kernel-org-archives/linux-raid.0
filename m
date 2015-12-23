From: Wolfgang Draxinger <wdraxinger.maillist@draxit.de>
Subject: Recreating RAID-5 after SATA controller failure and botched
 auto-assemble
Date: Wed, 23 Dec 2015 10:58:27 +0100
Message-ID: <20151223105827.55498cb1@narfi.yggdrasil.draxit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Just before anyone tells me off: I've got a Backup of my
important data; however there was a bunch of stuff on the RAID that I
didn't backup because it was not irreplaceable (mostly music, movies I
converted from DVDs, conference recordings, stuff like that), and I'd
like to save the hassle of procuring all that stuff again.

A little bit of backstory: Temperatures this summer were brutal. So
brutal that the controller hardware in my NAS experienced severe
failure (the HDDs of the RAID are apparently fine, at least there have
been no issues copying them onto a scratch disk, SMART doesn't show up
either). The main symptom is, that after connecting a disk it takes
only a couple of minutes before the SATA link will drop and the disk
get kicked from the set of block devices. Since there's a hotspare
the RAID would autorebuild on that, but the formerly dropped disk
would reappear. Then the spare might drop during autorebuild. And so
on. When I finally realized what was going on I pulled the plug hard,
but the damage was done.

That was 6 months ago. With the holidays being here I thought, I'd
finally have a look at the whole mess. First thing was to copy the
contents of 4 of the 5 drives to a single drive that could hold them
(it was short of 60MB to hold the last disk); but then I figured, that
for getting the whole thing into a read-only state that should suffice.

Here's the examine results for the superblocks (/dev/sdb is the large
disk to which I copied the original RAID disks, /dev/sdd is the one
original disk that didn't fit). Now the strange thing is, that these
are superblocks of two different arrays. I dimly remember, that back in
2008 I first created a test array to check the hardware before tearing
it down and creating the proper array. I've been using that 4 + 1 hot
spare configuration ever since, so the superblock UUID 42e59462... is
the one I'm probably after. However *all* of the disks participated in
that array, yet that other UUID superblock shows up.

Now I'd be only half surprised if the Creation or Update Time of the
UUID=13667845... superblock would say 2015, because then I'd blame the
botched attempts on rebuilding in that failure loop on it (you can see
that in the Update Time of the 42e59462) BTW.

What's going on there?

/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 13667845:511c4be5:16e52af0:0ac6a895
  Creation Time : Sat Oct 25 08:34:03 2008
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 1953524992 (1863.03 GiB 2000.41 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sat Oct 25 08:34:17 2008
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fbc116d1 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        0        0      active sync   /dev/sda

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       16        2      active sync   /dev/sdb
   
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 42e59462:04b3a9b6:b1e97ac7:394f85ec
  Creation Time : Sat Oct 25 08:52:56 2008
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sat Jul 11 19:27:56 2015
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : b4e50c1d - correct
         Events : 670769

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8        0        2      active sync   /dev/sda

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        0        2      active sync   /dev/sda
   3     3       0        0        3      faulty removed

/dev/sdb3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 42e59462:04b3a9b6:b1e97ac7:394f85ec
  Creation Time : Sat Oct 25 08:52:56 2008
     Raid Level : raid5
  Used Dev Size : 976759936 (931.51 GiB 1000.20 GB)
     Array Size : 2930279808 (2794.53 GiB 3000.61 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sat Jul 11 18:29:02 2015
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : b4ef3a8f - correct
         Events : 670757

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       48        3      active sync   /dev/sdd

   0     0       0        0        0      removed
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8        0        2      active sync   /dev/sda
   3     3       8       48        3      active sync   /dev/sdd
   4     4       8       33        4      spare

/dev/sdb4:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 13667845:511c4be5:16e52af0:0ac6a895
  Creation Time : Sat Oct 25 08:34:03 2008
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 1953524992 (1863.03 GiB 2000.41 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sat Oct 25 08:34:17 2008
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fbc116e5 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       16        2      active sync   /dev/sdb

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       16        2      active sync   /dev/sdb

/dev/sdd:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 13667845:511c4be5:16e52af0:0ac6a895
  Creation Time : Sat Oct 25 08:34:03 2008
     Raid Level : raid5
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
     Array Size : 1953524992 (1863.03 GiB 2000.41 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Sat Oct 25 08:34:17 2008
          State : active
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : fbc116f3 - correct
         Events : 3

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       32        1      active sync   /dev/sdc

   0     0       8        0        0      active sync   /dev/sda
   1     1       8       32        1      active sync   /dev/sdc
   2     2       8       16        2      active sync   /dev/sdb

Anyway, I'd appreciate if anyone knew how I could read-only assemble
the disks into an array that resembles the 42e59462... configuration to
see if I can pull anything useful from it. There are a few things on
it (hopefully left) that I'd like to extract, if possible.


Cheers,

Wolfgang
