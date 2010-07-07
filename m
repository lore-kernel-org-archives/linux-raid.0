From: Sebastian Reichel <elektranox@gmail.com>
Subject: Re: power outage while raid5->raid6 was in progress
Date: Thu, 8 Jul 2010 01:13:16 +0200
Message-ID: <20100707231316.GA6496@earth.universe>
References: <20100707204110.GB1207@earth.universe>
 <20100708084450.7abb19d8@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100708084450.7abb19d8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2010 at 08:44:50AM +1000, Neil Brown wrote:
> On Wed, 7 Jul 2010 22:41:10 +0200
> Sebastian Reichel <elektranox@gmail.com> wrote:
>=20
> > Hi,
> >=20
> > I have some problems with my raid. I tried updating from 5 disks raid5 =
to 8 disks
> > raid6 as described on http://neil.brown.name/blog/20090817000931#2. The=
 command I
> > used was: mdadm --grow /dev/md0 --level=3D6 --raid-disk=3D8
> >=20
> > While the rebuild was in progress my system hung, so I had to force pow=
er down it.
> > After rebooting the system I reassembled the raid. You can see the resu=
lting mess
> > below. How can I recover from this state?
>=20
> Please report the output of
>=20
>   mdadm -E /dev/sd[efghijkl]1
>=20
> then I'll see what can be done.

thank you for having a look at it :)

root@mars ~ # mdadm -E /dev/sd[efghijkl]1
/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439feb9 - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       65        1      active sync   /dev/sde1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439fecd - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       81        6      spare   /dev/sdf1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439fedf - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       97        7      spare   /dev/sdg1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdh1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439fef1 - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8      113        8      spare   /dev/sdh1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdi1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439feff - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8      129        4      active sync   /dev/sdi1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdj1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439ff0d - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8      145        3      active sync   /dev/sdj1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdk1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Tue Jul  6 23:37:42 2010
          State : clean
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4449160f - correct
         Events : 991518

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8      161        0      active sync   /dev/sdk1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1
/dev/sdl1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : a1eb26ff:0d33b804:1c7aa044:e01dc78c (local to host mars)
  Creation Time : Fri Apr  9 19:24:51 2010
     Raid Level : raid6
  Used Dev Size : 1465135936 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543744 (5589.05 GiB 6001.20 GB)
   Raid Devices : 6
  Total Devices : 8
Preferred Minor : 0

    Update Time : Wed Jul  7 00:21:00 2010
          State : active
 Active Devices : 5
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 3
       Checksum : 4439ff2b - correct
         Events : 991519

         Layout : left-symmetric-6
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8      177        2      active sync   /dev/sdl1

   0     0       8      161        0      active sync   /dev/sdk1
   1     1       8       65        1      active sync   /dev/sde1
   2     2       8      177        2      active sync   /dev/sdl1
   3     3       8      145        3      active sync   /dev/sdj1
   4     4       8      129        4      active sync   /dev/sdi1
   5     5       0        0        5      faulty removed
   6     6       8       81        6      spare   /dev/sdf1
   7     7       8       97        7      spare   /dev/sdg1
   8     8       8      113        8      spare   /dev/sdh1

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAkw1CgwACgkQH0JwilpTmKh5nwCfcDKXRTBpOp/to36+A9VSBe2b
o5wAl3apO3ayoSfbduqPUUgHvnbvI6g=
=nf9z
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
