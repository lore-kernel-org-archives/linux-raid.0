From: Guillaume Paumier <guillaume.paumier@gmail.com>
Subject: Re: Guidance on reshape stuck at 0% after --grow
Date: Sun, 27 Sep 2015 16:53:41 -0700
Message-ID: <CAKWBTuEZAFD4PGyvTfCnm7Vhaz2dMfA=fCxkHXhFk9ai9uxkMQ@mail.gmail.com>
References: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
	<alpine.DEB.2.02.1509221224470.8750@uplift.swm.pp.se>
	<CAKWBTuG2AngM6joiODt15Qe+HAXfF6OnJVD-HNuNKikfyv-6MQ@mail.gmail.com>
	<5602EB5E.6010703@youngman.org.uk>
	<CAKWBTuFTANRTWP692hf9Et_8GPvx=uLvYowKRCLdhQPMqhCKKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKWBTuFTANRTWP692hf9Et_8GPvx=uLvYowKRCLdhQPMqhCKKg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

After a discussion on IRC, I rebooted the machine to boot using
SystemRescueCD, in order to see if a newer version would work better.

It didn't, but after rebooting into the regular OS of the machine, the
array was assembled. It's still not running, though:

mdadm -D gives the following output:


___________________________________________

# mdadm -D /dev/md0

---------------------------------------------------------------------------

/dev/md0:
        Version : 1.0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
  Used Dev Size : -1
   Raid Devices : 8
  Total Devices : 9
    Persistence : Superblock is persistent

    Update Time : Tue Sep 22 13:25:43 2015
          State : active, Not Started
 Active Devices : 9
Working Devices : 9
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

  Delta Devices : -1, (9->8)

           Name : (redacted):0
           UUID : eea59047:120a0365:353da182:6787e030
         Events : 35500

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       8       97        2      active sync   /dev/sdg1
       3       8      113        3      active sync   /dev/sdh1
       4       8      129        4      active sync   /dev/sdi1
       5       8      145        5      active sync   /dev/sdj1
       7       8       81        6      active sync   /dev/sdf1
       6       8       65        7      active sync   /dev/sde1

       8       8       17        8      active sync   /dev/sdb1
___________________________________________




Note that "Raid Devices : 8", "Total Devices : 9" but /dev/sdb1 is
still listed as RaidDevice #8 (i.e. the 9th device) and in "active
sync". I'm not sure how this works.


dmesg still indicates that the reshape can't proceed:

___________________________________________

# dmesg | grep md

---------------------------------------------------------------------------

[    4.366341] md: bind<sdg1>
[    4.368685] md: bind<sdd1>
[    4.370618] md: bind<sdf1>
[    4.387630] md: bind<sdh1>
[    4.392266] md: bind<sdc1>
[    4.397084] md: bind<sdb1>
[    4.411668] md: bind<sdj1>
[    4.453465] md: bind<sde1>
[    4.489803] md: bind<sdi1>
[   39.129640] md: raid6 personality registered for level 6
[   39.129643] md: raid5 personality registered for level 5
[   39.129644] md: raid4 personality registered for level 4
[   39.133609] md/raid:md0: reshape_position too early for
auto-recovery - aborting.
[   39.133613] md: pers->run() failed ...
___________________________________________


At this point, I'm wondering if it would help to remove sdb1 from the
array. Does that sound like a good idea? If so, should I attempt to
"fail" it and format it? Or try to shrink to 8 devices instead of 9?



For reference:
___________________________________________

mdadm --examine /dev/sd[b-j]1

-------------------------------------------------------------------------------

mdadm --examine /dev/sd[b-j]1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033128 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : bde6e5ab:5f4a56e9:10ad82fc:301d477b

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
  Bad Block Log : 512 entries available at offset -8 sectors
       Checksum : 283907e0 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 8
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : e1b689b5:b4a2c5a7:56057b69:a9101af0

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : d20f7c1e - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 0
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 1d8e74d3:9abd37f8:f2cf0ab8:02fdcfd6

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : 75b22537 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 1
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : ddf17d3d:ea944bfb:6886cc91:3366f55f

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : 45b67ff2 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 7
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 38675f59:ea412b1f:67d6ed9a:a33fc5dd

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : c68cbbd - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 6
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : b24758e6:042412c5:9b5a3c06:f167aedf

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : ac803ace - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 2
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 00e47d82:b49c3905:3ed961fe:40a5f259

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : fb370bbe - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 3
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : a7e34040:fa12382f:c2ef3d85:9c95b1d0

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : e093888c - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 4
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.0
    Feature Map : 0x5
     Array UUID : eea59047:120a0365:353da182:6787e030
           Name : (redacted):0
  Creation Time : Thu Aug  1 12:23:07 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 7814033136 (3726.02 GiB 4000.78 GB)
     Array Size : 23442098688 (22356.13 GiB 24004.71 GB)
  Used Dev Size : 7814032896 (3726.02 GiB 4000.78 GB)
   Super Offset : 7814033392 sectors
   Unused Space : before=0 sectors, after=480 sectors
          State : clean
    Device UUID : 9d89c55d:9f4a2181:6b87922f:0681d580

Internal Bitmap : -16 sectors from superblock
  Reshape pos'n : 0
  Delta Devices : -1 (9->8)

    Update Time : Tue Sep 22 13:25:43 2015
       Checksum : aa79f183 - correct
         Events : 35500

         Layout : left-symmetric
     Chunk Size : 128K

   Device Role : Active device 5
   Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

___________________________________________

-- 
Guillaume Paumier
