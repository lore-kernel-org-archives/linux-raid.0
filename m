From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: raid0 low performance
Date: Fri, 01 Jul 2005 09:17:13 -0400
Message-ID: <1120223833.5507.40.camel@localhost.localdomain>
References: <200507011255.j61CtXp10224@www.watkins-home.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-evx3O705t28/xszu4jSU"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200507011255.j61CtXp10224@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-evx3O705t28/xszu4jSU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-07-01 at 08:55 -0400, Guy wrote:
> I think you should test 2 or more disks at the same time.  This would pro=
ve
> that your system can or can't move more than about 60MB/s.


i tested and seems that 90MB/s is the max here.


if i run 2 program copy on 2 disks independently on same card, both of
them bound at 45MB/s
if i run 3 program copy on 3 disks independently on same card, both of
them bound at 27 or 28MB/s so total is still 90MB/s
if i run 2 program copy on 2 disks but one is on 4 port marvel and
another is 8 port marvel, then both of the bound at 55MB/s which is disk
limitation.

so i guess the card or bus has problem. i will check bus speed soon.



>=20
> My old P3-500 SMP can move at least 150MB/s.  But I have 3 SCSI buses and=
 3
> PCI buses.
>=20
> Guy
>=20

ming

> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Ming Zhang
> > Sent: Thursday, June 30, 2005 10:16 PM
> > To: Linux RAID
> > Subject: raid0 low performance
> >=20
> > I meet some strange low performance when run RAID0 with vanilla kernel
> > 2.4.27/2.6.11.12.
> >=20
> > My box is a 2.8G P4 and 1G RAM. 8 400GB SATA disk and A marvel 8port
> > controller. I run marvel 3.4.1 driver. I wrote a small program to write
> > device sequentially and SYNCHRONOUSLY.
> >=20
> > This is performance of 1 disk. looks fine.
> >=20
> >  1048576Bytes *     1024 :    55.466MB/s
> >   524288Bytes *     2048 :    55.830MB/s
> >   262144Bytes *     4096 :    55.782MB/s
> >   131072Bytes *     8192 :    55.567MB/s
> >    65536Bytes *    16384 :    55.926MB/s
> >    32768Bytes *    32768 :    54.344MB/s
> >    16384Bytes *    65536 :    41.415MB/s
> >     8192Bytes *    65536 :    26.499MB/s
> >     4096Bytes *    65536 :    15.110MB/s
> >     2048Bytes *    65536 :     8.422MB/s
> >     1024Bytes *    65536 :     4.318MB/s
> >=20
> > But when run 2 disk raid0, there is only 10% improvement.
> >=20
> > md3 : active raid0 sdb[1] sda[0]
> >       781422592 blocks 64k chunks
> >  1048576Bytes *     1024 :    67.300MB/s
> >   524288Bytes *     2048 :    66.796MB/s
> >   262144Bytes *     4096 :    65.728MB/s
> >   131072Bytes *     8192 :    65.017MB/s
> >    65536Bytes *    16384 :    59.223MB/s
> >    32768Bytes *    32768 :    49.766MB/s
> >    16384Bytes *    65536 :    39.162MB/s
> >     8192Bytes *    65536 :    26.386MB/s
> >     4096Bytes *    65536 :    15.084MB/s
> >     2048Bytes *    65536 :     8.383MB/s
> >     1024Bytes *    65536 :     4.303MB/s
> >=20
> > And when use 4 disks, the speed is slower!
> > md0 : active raid0 sdh[3] sdg[2] sdf[1] sde[0]
> >       1562845184 blocks 64k chunks
> >  1048576Bytes *     1024 :    58.032MB/s
> >   524288Bytes *     2048 :    56.994MB/s
> >   262144Bytes *     4096 :    58.289MB/s
> >   131072Bytes *     8192 :    65.999MB/s
> >    65536Bytes *    16384 :    59.723MB/s
> >    32768Bytes *    32768 :    50.061MB/s
> >    16384Bytes *    65536 :    38.689MB/s
> >     8192Bytes *    65536 :    26.169MB/s
> >     4096Bytes *    65536 :    15.169MB/s
> >     2048Bytes *    65536 :     8.378MB/s
> >     1024Bytes *    65536 :     4.287MB/s
> >=20
> >=20
> > Any hint on this?
> >=20
> > * I do not know how to check current PCI bus speed and I am not sure
> > whether is limited by that. It is a 64bit card but I am not sure if it
> > is run at 66MHZ. Should be, but want to check to make sure.
> > * I tested each disk and all disk performs OK.
> >=20
> >=20
> > Thanks
> >=20
> >=20
> > Ming
>=20
>=20

--=-evx3O705t28/xszu4jSU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCxUJZSYbkL5BnVYoRAjaiAJ9VVrmjfMzpD5/XL3Pu5PTt6mzj9ACfdPAB
Begy/r1v3n7G0mwbujkwfpw=
=c9lL
-----END PGP SIGNATURE-----

--=-evx3O705t28/xszu4jSU--

