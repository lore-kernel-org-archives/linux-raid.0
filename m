From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 16:05:36 +0100
Message-ID: <4B854040.5080603@xunil.at>
References: <4B853DB7.1060406@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B853DB7.1060406@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 24.02.2010 15:54, schrieb Stefan G. Weichinger:

> What to try?
> 
> This is a crucial server and I feel a lot of pressure.
> Rebuilding that raid would mean a lot of restore-work etc.
> So I would really appreciate a goo advice here.

Followup:

--examine shows different statii for the four partitions:


server-gentoo ~ # mdadm --examine /dev/sda4
/dev/sda4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d4b0e9c1:067357ce:2569337e:e9af8bed
  Creation Time : Tue Aug  5 14:14:16 2008
     Raid Level : raid5
  Used Dev Size : 145910272 (139.15 GiB 149.41 GB)
     Array Size : 291820544 (278.30 GiB 298.82 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 4

    Update Time : Wed Feb 24 15:33:37 2010
          State : active
 Active Devices : 2
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 3039381e - correct
         Events : 0.13

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        4        0      active sync   /dev/sda4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       8       20        1      active sync   /dev/sdb4
   2     2       0        0        2      faulty removed
   3     3       8       52        3      spare   /dev/sdd4


server-gentoo ~ # mdadm --examine /dev/sdb4
/dev/sdb4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d4b0e9c1:067357ce:2569337e:e9af8bed
  Creation Time : Tue Aug  5 14:14:16 2008
     Raid Level : raid5
  Used Dev Size : 145910272 (139.15 GiB 149.41 GB)
     Array Size : 291820544 (278.30 GiB 298.82 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 4

    Update Time : Wed Feb 24 15:37:05 2010
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 3039393f - correct
         Events : 0.32

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       20        1      active sync   /dev/sdb4

   0     0       0        0        0      removed
   1     1       8       20        1      active sync   /dev/sdb4
   2     2       0        0        2      faulty removed
   3     3       8       52        3      spare   /dev/sdd4


server-gentoo ~ # mdadm --examine /dev/sdc4
/dev/sdc4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d4b0e9c1:067357ce:2569337e:e9af8bed
  Creation Time : Tue Aug  5 14:14:16 2008
     Raid Level : raid5
  Used Dev Size : 145910272 (139.15 GiB 149.41 GB)
     Array Size : 291820544 (278.30 GiB 298.82 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 4

    Update Time : Wed Feb 24 15:33:28 2010
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 30393836 - correct
         Events : 0.10

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       36        2      active sync   /dev/sdc4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       8       20        1      active sync   /dev/sdb4
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       8       52        3      spare   /dev/sdd4


server-gentoo ~ # mdadm --examine /dev/sdd4
/dev/sdd4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d4b0e9c1:067357ce:2569337e:e9af8bed
  Creation Time : Tue Aug  5 14:14:16 2008
     Raid Level : raid5
  Used Dev Size : 145910272 (139.15 GiB 149.41 GB)
     Array Size : 291820544 (278.30 GiB 298.82 GB)
   Raid Devices : 3
  Total Devices : 4
Preferred Minor : 4

    Update Time : Wed Feb 24 15:37:05 2010
          State : clean
 Active Devices : 1
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 3039395d - correct
         Events : 0.32

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       52        3      spare   /dev/sdd4

   0     0       0        0        0      removed
   1     1       8       20        1      active sync   /dev/sdb4
   2     2       0        0        2      faulty removed
   3     3       8       52        3      spare   /dev/sdd4



---- Does this info help?
Thanks, Stefan
