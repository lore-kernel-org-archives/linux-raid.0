From: Jens Laas <jens.laas@data.slu.se>
Subject: possible logic bug in raid5.c
Date: Fri, 1 Jun 2007 10:31:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706011012150.7173@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jens.laas@data.slu.se
List-Id: linux-raid.ids


Hello!

It appears to me that raid5 assumes the number of raid_disks (in=20
conf-raid_disks for example) to directly map to the rdev list in mddev.

This is not always the case. We encountered the problem when we had one=
=20
"ghost" device in this list. Maybe this can be triggered some other way=
=20
too.

Example:
in run() in raid5.c

when counting working_disks:

        ITERATE_RDEV(mddev,rdev,tmp) {
                 raid_disk =3D rdev->raid_disk;
                 if (raid_disk >=3D conf->raid_disks
                     || raid_disk < 0)
                         continue;

If there are more disks in mddev's list than conf->raid_disks this loop
will ignore the tail of the list.

The test "if (raid_disk >=3D conf->raid_disks" makes sure that in our c=
ase=20
the "ghost" disk is tested (and not added) and the following disk (whic=
h=20
is a working raid disk) is ignored.

Without being familiar with the code I think it should either make sure=
=20
that "ghost" devices cannot be added or that the above kind of tests ar=
e=20
changed.

In our "ghost"-disk case this is what mdadm reports:
(some parts of output deleted)
$ mdadm --detail /dev/md0
    Raid Devices : 4
   Total Devices : 4
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

     Number   Major   Minor   RaidDevice State
        0       8       33        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1
        2       8       65        2      active sync   /dev/sde1
        3       0        0        3      removed
        4       8       81        4      active sync   /dev/sdf1

This is how it looks like in /sys:
# ls -l /sys/block/md0/md/
total 0
-rw-r--r-- 1 root root 4096 Jun  1 10:27 array_state
--w------- 1 root root 4096 Jun  1 10:27 bitmap_set_bits
-rw-r--r-- 1 root root 4096 Jun  1 10:27 chunk_size
-rw-r--r-- 1 root root 4096 Jun  1 10:27 component_size
drwxr-xr-x 2 root root    0 Jun  1 09:47 dev-sdc1
drwxr-xr-x 2 root root    0 Jun  1 02:27 dev-sdd1
drwxr-xr-x 2 root root    0 Jun  1 02:27 dev-sde1
drwxr-xr-x 2 root root    0 Jun  1 02:27 dev-sdf1
-rw-r--r-- 1 root root 4096 Jun  1 10:27 layout
-rw-r--r-- 1 root root 4096 Jun  1 10:27 level
-rw-r--r-- 1 root root 4096 Jun  1 10:27 metadata_version
-r--r--r-- 1 root root 4096 Jun  1 10:27 mismatch_cnt
--w------- 1 root root 4096 Jun  1 10:27 new_dev
-rw-r--r-- 1 root root 4096 Jun  1 10:27 raid_disks
lrwxrwxrwx 1 root root    0 Jun  1 10:27 rd0 ->=20
=2E./../../block/md0/md/dev-sdc1
lrwxrwxrwx 1 root root    0 Jun  1 10:27 rd1 ->=20
=2E./../../block/md0/md/dev-sdd1
lrwxrwxrwx 1 root root    0 Jun  1 10:27 rd2 ->=20
=2E./../../block/md0/md/dev-sde1
lrwxrwxrwx 1 root root    0 Jun  1 10:27 rd4 ->=20
=2E./../../block/md0/md/dev-sdf1

Cheers,
Jens L=E5=E5s

-----------------------------------------------------------------------
     'In theory, there is no difference between theory and practice.
      But, in practice, there is.'
-----------------------------------------------------------------------
     Jens L=E5=E5s                              Email: jens.laas@data.s=
lu.se
     Department of Computer Services, SLU   Phone: +46 18 67 35 15
     Vindbrov=E4gen 1
     P.O. Box 7079
     S-750 07 Uppsala
     SWEDEN
-----------------------------------------------------------------------
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
