From: Jure =?UTF-8?Q?Pe=C3=A8ar?= <pegasus@nerv.eu.org>
Subject: something with superblocks ... ?
Date: Sat, 21 Aug 2004 12:08:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040821120827.521233ff.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

there was some talk recently about certain raid devices not being assem=
bled
properly. I also have such situation, so this might shed some light int=
o
this.

What i have is a raid0 array made of 14 mirrors. All were configured at=
 the
same time in exactly the same way, same tools etc. That's why this is
interesting.
Partitions are type 83 and there is a script that takes care of assembl=
ing
devices in order on boot. The script uses mdadm --assemble /dev/mdX --u=
uid
<uuid>.

But after every boot, /dev/md9 comes up as:

md9 : active raid1 sdi1[0]
      35842944 blocks [2/1] [U_]

The missing component is sdw1.

So here's what mdadm 1.2 says about the disks in question:

# mdadm -Q /dev/md9
/dev/md9: 34.18GiB raid1 2 devices, 0 spares. Use mdadm --detail for mo=
re
detail.
/dev/md9: device 4 in 14 device active raid0 md19.  Use mdadm --examine=
 for
more detail.

# mdadm -D /dev/md9
/dev/md9:
        Version : 00.90.00
  Creation Time : Mon Apr 28 16:46:07 2003
     Raid Level : raid1
     Array Size : 35842944 (34.18 GiB 36.70 GB)
    Device Size : 35842944 (34.18 GiB 36.70 GB)
   Raid Devices : 2
  Total Devices : 0
Preferred Minor : 9
    Persistence : Superblock is persistent

    Update Time : Sat Aug 21 02:06:04 2004
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : -1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       0        0        1      faulty removed
           UUID : 5f68a534:97eb094d:bcc5de8d:225eb1f7
         Events : 0.214

# mdadm -Q /dev/sdi1
/dev/sdi1: is not an md array
/dev/sdi1: device 0 in 2 device active raid1 md9.  Use mdadm --examine =
for
more detail.

# mdadm -Q /dev/sdw1
/dev/sdw1: is not an md array
/dev/sdw1: device 1 in 2 device mismatch raid1 md9.  Use mdadm --examin=
e for
more detail.

# mdadm -E /dev/sdi1
/dev/sdi1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5f68a534:97eb094d:bcc5de8d:225eb1f7
  Creation Time : Mon Apr 28 16:46:07 2003
     Raid Level : raid1
    Device Size : 35842944 (34.18 GiB 36.70 GB)
   Raid Devices : 2
  Total Devices : 0
Preferred Minor : 9

    Update Time : Sat Aug 21 02:06:04 2004
          State : dirty, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : -1
  Spare Devices : 0
       Checksum : 19b4cf3 - correct
         Events : 0.214


      Number   Major   Minor   RaidDevice State
this     0       8      129        0      active sync   /dev/sdi1
   0     0       8      129        0      active sync   /dev/sdi1
   1     1       0        0        1      faulty removed

# mdadm -E /dev/sdw1
/dev/sdw1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 5f68a534:97eb094d:bcc5de8d:225eb1f7
  Creation Time : Mon Apr 28 16:46:07 2003
     Raid Level : raid1
    Device Size : 35842944 (34.18 GiB 36.70 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 9

    Update Time : Tue Apr 20 20:28:11 2004
          State : dirty, no-errors
 Active Devices : 2
Working Devices : 2
 Failed Devices : -1
  Spare Devices : 0
       Checksum : fa277e - correct
         Events : 0.213


      Number   Major   Minor   RaidDevice State
this     1      65       97        1      active sync   /dev/sdw1
   0     0       8      129        0      active sync   /dev/sdi1
   1     1      65       97        1      active sync   /dev/sdw1


There are obvious some differences ... beggining with mdadm -Q for sdw1
saying it is a 'mismatch raid1' and continuing with the contents of the
superblocks on the two disks.=20

I'm interested in theoires how this might have happened and in suggesti=
ons
on how to fix it. Is mdadm -U the right thing here?


--=20

Jure Pe=C4=8Dar
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
