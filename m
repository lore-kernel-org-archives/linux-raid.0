From: Roman Mamedov <rm@romanrm.ru>
Subject: Wrong count of devices in /proc/mdstat after "want_replacement"
Date: Tue, 18 Sep 2012 11:04:36 +0600
Message-ID: <20120918110436.0215e5ec@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/2Tf5GnW_TX/65wXc1HMNczp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2Tf5GnW_TX/65wXc1HMNczp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Summary:

After removing a disk via "want_replacement", disk count in /proc/mdstat is
wrong ("[5/4]", not "[5/5]" as it should be).

More details below:

----

# mdadm --add /dev/md0 /dev/sdb1=20
mdadm: added /dev/sdb1

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed May 25 00:07:38 2011
     Raid Level : raid5
     Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
  Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
   Raid Devices : 5
  Total Devices : 6
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Sep 18 01:01:38 2012
          State : active=20
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 64K

           Name : avdeb:0  (local to host avdeb)
           UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
         Events : 14135

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       6       8       33        1      active sync   /dev/sdc1
       3       8       81        2      active sync   /dev/sdf1
       4       8       49        3      active sync   /dev/sdd1
       5       8       97        4      active sync   /dev/sdg1

       7       8       17        -      spare   /dev/sdb1

# echo want_replacement > /sys/block/md0/md/dev-sde1/state=20

// It's rebuilding:

# cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : active raid5 sdb1[7](R) sde1[0] sdg1[5] sdd1[4] sdf1[3] sdc1[6]
      3907003136 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/5] [UU=
UUU]
      [>....................]  recovery =3D  0.1% (1724936/976750784) finis=
h=3D150.7min speed=3D107808K/sec
      bitmap: 0/4 pages [0KB], 131072KB chunk

// Rebuild finished:

# cat /proc/mdstat=20
md0 : active raid5 sdb1[7] sde1[0](F) sdg1[5] sdd1[4] sdf1[3] sdc1[6]
      3907003136 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4] [UU=
UUU]
      bitmap: 0/4 pages [0KB], 131072KB chunk

# mdadm --detail /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Wed May 25 00:07:38 2011
     Raid Level : raid5
     Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
  Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
   Raid Devices : 5
  Total Devices : 6
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Sep 18 04:46:14 2012
          State : active=20
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : avdeb:0  (local to host avdeb)
           UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
         Events : 14231

    Number   Major   Minor   RaidDevice State
       7       8       17        0      active sync   /dev/sdb1
       6       8       33        1      active sync   /dev/sdc1
       3       8       81        2      active sync   /dev/sdf1
       4       8       49        3      active sync   /dev/sdd1
       5       8       97        4      active sync   /dev/sdg1

       0       8       65        -      faulty spare   /dev/sde1

// Removing sde1:

# mdadm --remove /dev/md0 /dev/sde1=20
mdadm: hot removed /dev/sde1 from /dev/md0

// Removed ok:

# mdadm --detail /dev/md0=20
/dev/md0:
        Version : 1.2
  Creation Time : Wed May 25 00:07:38 2011
     Raid Level : raid5
     Array Size : 3907003136 (3726.01 GiB 4000.77 GB)
  Used Dev Size : 976750784 (931.50 GiB 1000.19 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Sep 18 08:49:24 2012
          State : active=20
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : avdeb:0  (local to host avdeb)
           UUID : b99961fb:ed1f76c8:ec2dad31:6db45332
         Events : 14234

    Number   Major   Minor   RaidDevice State
       7       8       17        0      active sync   /dev/sdb1
       6       8       33        1      active sync   /dev/sdc1
       3       8       81        2      active sync   /dev/sdf1
       4       8       49        3      active sync   /dev/sdd1
       5       8       97        4      active sync   /dev/sdg1

// In the end /proc/mdstat shows "[5/4]", not "[5/5]":

# cat /proc/mdstat=20
md0 : active raid5 sdb1[7] sdg1[5] sdd1[4] sdf1[3] sdc1[6]
      3907003136 blocks super 1.2 level 5, 64k chunk, algorithm 2 [5/4] [UU=
UUU]
      bitmap: 0/4 pages [0KB], 131072KB chunk

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/2Tf5GnW_TX/65wXc1HMNczp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBYAOQACgkQTLKSvz+PZwhp1QCcCZlmSpf2pCfk0RyHvLct9yzs
bl4An2SRtyAQucx6iRKa59JtjG/f9FXF
=UKT5
-----END PGP SIGNATURE-----

--Sig_/2Tf5GnW_TX/65wXc1HMNczp--
