From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Multipath problems with 2.6.8.1
Date: Thu, 9 Sep 2004 11:59:10 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409091559.i89FxF332735@watkins-home.com>
References: <41407793.3060105@corenetworks.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41407793.3060105@corenetworks.es>
To: =?iso-8859-1?Q?'Jaime_Pe=F1alba'?= <jpenalba@corenetworks.es>, linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Somehow you confused it!  And me.

You used multipath and spare, but only listed 2 devices.
I don't think a multipath array can have a spare disk.

Are you sure the 2 paths point to the same disk?

I have never user multipath, so I am just guessing.

If you have no data you need to save yet, try this:
mdadm --create /dev/md0 --force --level multipath /dev/sdb1 /dev/sdd1
or
mdadm --create /dev/md0 --force --level multipath --raid-devices=3D2 /d=
ev/sdb1
/dev/sdd1

Guy

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jaime Pe=F1alba
Sent: Thursday, September 09, 2004 11:33 AM
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
Subject: Multipath problems with 2.6.8.1

Hi,

Im having some troubles with multipath on a 2.6.8.1 linux kernel.

Im using 2 QLogic 2344 connected to the SAN, i think that my problem is=
=20
related to superblocks, because when i create a new multipath device, i=
t=20
writes the superblock for both disks and really is the same disk trough=
t=20
two paths. I have else tried to disable persistent superblock, but mdad=
m=20
doesnt support multipath with the build mode.

Im doing it like this

1) Start the md
apache1:~/soft/mdadm-1.7.0# mdadm --create /dev/md0 --force --level=20
multipath --raid-devices=3D1 /dev/sdb1 --spare-devices=3D1 /dev/sdd1
mdadm: array /dev/md0 started.

apache1:~/soft/mdadm-1.7.0# cat /proc/mdstat
Personalities : [multipath]
md0 : active multipath sdd1[1] sdb1[0]
      4882304 blocks [1/1] [U]
    =20
unused devices: <none>

This is ok and runs fine, But superblock is only at /dev/sdd1, so no=20
remount would be possible, or i think so...

apache1:~/soft/mdadm-1.7.0# mdadm -E /dev/sdb1
mdadm: No super block found on /dev/sdb1 (Expected magic a92b4efc, got=20
00000000)

apache1:~/soft/mdadm-1.7.0# mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : af3395fd:fac2b820:2ca7083c:612864e0
  Creation Time : Thu Sep  9 17:20:43 2004
     Raid Level : multipath
    Device Size : 4882304 (4.66 GiB 5.00 GB)
   Raid Devices : 1
  Total Devices : 2
Preferred Minor : 0

    Update Time : Thu Sep  9 17:20:43 2004
          State : dirty
 Active Devices : 1
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 1
       Checksum : 63bc7489 - correct
         Events : 0.36


      Number   Major   Minor   RaidDevice State
this     1       8       49        1      spare   /dev/sdd1
   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       49        1      spare   /dev/sdd1



2) Stop the md
apache1:~/soft/mdadm-1.7.0# mdadm -S /dev/md0


3) Start the md again
apache1:~/soft/mdadm-1.7.0# mdadm --assemble /dev/md0=20
--uuid=3Daf3395fd:fac2b820:2ca7083c:612864e0 /dev/sdb1 /dev/sdd1
mdadm: no RAID superblock on /dev/sdb1
mdadm: /dev/sdb1 has wrong uuid.
mdadm: /dev/md0 has been started with 1 drive.


apache1:~/soft/mdadm-1.7.0# cat /proc/mdstat
Personalities : [multipath]
md0 : active multipath sdd1[0]
      4882304 blocks [1/1] [U]
    =20
unused devices: <none>

Now things arent working very well....

apache1:~/soft/mdadm-1.7.0# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.01
  Creation Time : Thu Sep  9 17:20:43 2004
     Raid Level : multipath
     Array Size : 4882304 (4.66 GiB 5.00 GB)
   Raid Devices : 1
  Total Devices : 1
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Sep  9 17:26:21 2004
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/sdd1
           UUID : af3395fd:fac2b820:2ca7083c:612864e0
         Events : 0.37


I would appreciate very much any help with this.

Thanks,
Jaime.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
