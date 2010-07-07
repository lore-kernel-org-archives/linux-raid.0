From: Sebastian Reichel <elektranox@gmail.com>
Subject: power outage while raid5->raid6 was in progress
Date: Wed, 7 Jul 2010 22:41:10 +0200
Message-ID: <20100707204110.GB1207@earth.universe>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I have some problems with my raid. I tried updating from 5 disks raid5 to 8=
 disks
raid6 as described on http://neil.brown.name/blog/20090817000931#2. The com=
mand I
used was: mdadm --grow /dev/md0 --level=3D6 --raid-disk=3D8

While the rebuild was in progress my system hung, so I had to force power d=
own it.
After rebooting the system I reassembled the raid. You can see the resultin=
g mess
below. How can I recover from this state?

root@mars ~ # mdadm -Af /dev/md0
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
root@mars ~ # cat /proc/mdstat=20
Personalities : [raid6] [raid5] [raid4]=20
md0 : inactive sdk1[0] sdh1[8](S) sdg1[7](S) sdf1[6](S) sdi1[4] sdj1[3] sdl=
1[2] sde1[1]
      11721087488 blocks
      =20
md1 : active raid5 sdb1[0] sdd1[2] sdc1[1]
      1953519872 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
     =20
unused devices: <none>
root@mars ~ # mdadm -D /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Jul  7 00:21:00 2010
          State : active, degraded, Not Started
 Active Devices : 5
Working Devices : 8
 Failed Devices : 0
  Spare Devices : 3

         Layout : left-symmetric-6
     Chunk Size : 64K

           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
         Events : 0.991518

    Number   Major   Minor   RaidDevice State
       0       8      161        0      active sync   /dev/sdk1
       1       8       65        1      active sync   /dev/sde1
       2       8      177        2      active sync   /dev/sdl1
       3       8      145        3      active sync   /dev/sdj1
       4       8      129        4      active sync   /dev/sdi1
       5       0        0        5      removed

       6       8       81        -      spare   /dev/sdf1
       7       8       97        -      spare   /dev/sdg1
       8       8      113        -      spare   /dev/sdh1
root@mars ~ # dmesg | tail -n 30
[ 7896.306100] md: bind<sde1>
[ 7896.306240] md: bind<sdl1>
[ 7896.306368] md: bind<sdj1>
[ 7896.306495] md: bind<sdi1>
[ 7896.306666] md: bind<sdf1>
[ 7896.306795] md: bind<sdg1>
[ 7896.306921] md: bind<sdh1>
[ 7896.307048] md: bind<sdk1>
[ 7896.308745] raid5: md0 is not clean -- starting background reconstruction
[ 7896.308763] raid5: device sdk1 operational as raid disk 0
[ 7896.308765] raid5: device sdi1 operational as raid disk 4
[ 7896.308768] raid5: device sdj1 operational as raid disk 3
[ 7896.308770] raid5: device sdl1 operational as raid disk 2
[ 7896.308772] raid5: device sde1 operational as raid disk 1
[ 7896.309420] raid5: allocated 6386kB for md0
[ 7896.309465] 0: w=3D1 pa=3D0 pr=3D6 m=3D2 a=3D18 r=3D6 op1=3D0 op2=3D0
[ 7896.309468] 4: w=3D2 pa=3D0 pr=3D6 m=3D2 a=3D18 r=3D6 op1=3D0 op2=3D0
[ 7896.309471] 3: w=3D3 pa=3D0 pr=3D6 m=3D2 a=3D18 r=3D6 op1=3D0 op2=3D0
[ 7896.309473] 2: w=3D4 pa=3D0 pr=3D6 m=3D2 a=3D18 r=3D6 op1=3D0 op2=3D0
[ 7896.309476] 1: w=3D5 pa=3D0 pr=3D6 m=3D2 a=3D18 r=3D6 op1=3D0 op2=3D0
[ 7896.309478] raid5: cannot start dirty degraded array for md0
[ 7896.309503] RAID5 conf printout:
[ 7896.309504]  --- rd:6 wd:5
[ 7896.309506]  disk 0, o:1, dev:sdk1
[ 7896.309508]  disk 1, o:1, dev:sde1
[ 7896.309510]  disk 2, o:1, dev:sdl1
[ 7896.309512]  disk 3, o:1, dev:sdj1
[ 7896.309514]  disk 4, o:1, dev:sdi1
[ 7896.309956] raid5: failed to run raid set md0
[ 7896.309970] md: pers->run() failed ...
root@mars ~ # uname -a
Linux mars 2.6.34-1-amd64 #1 SMP Sun Jun 6 22:29:25 UTC 2010 x86_64 GNU/Lin=
ux
root@mars ~ # mdadm --version
mdadm - v3.1.2 - 10th March 2010

-- Sebastian

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw05mYACgkQH0JwilpTmKgJswCcD/ahHX2gBENEo+mh736YWm+/
CUoAn2CmoukXmSSN6Zmhb4y9JHAins86
=HwtY
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
