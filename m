From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: raid0 low performance
Date: Fri, 01 Jul 2005 10:42:51 -0400
Message-ID: <1120228971.5501.19.camel@localhost.localdomain>
References: <200507011255.j61CtXp10224@www.watkins-home.com>
	 <1120223833.5507.40.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8UrDc5ueUn63GcKa4fCu"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120223833.5507.40.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-8UrDc5ueUn63GcKa4fCu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

i wrote another program to read from device and then discard.

./synctest /dev/md1
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors
md1 : active raid0 sdl[3] sdk[2] sdb[1] sda[0]
      1562845184 blocks 64k chunks

unused devices: <none>
 1048576Bytes *     1024 :   158.459MB/s
  524288Bytes *     2048 :   164.935MB/s
  262144Bytes *     4096 :   173.649MB/s
  131072Bytes *     8192 :   174.228MB/s
   65536Bytes *    16384 :   178.462MB/s
   32768Bytes *    32768 :   177.569MB/s
   16384Bytes *    65536 :   177.888MB/s
    8192Bytes *    65536 :   173.809MB/s
    4096Bytes *   131072 :   172.732MB/s
    2048Bytes *   131072 :   165.512MB/s
    1024Bytes *   131072 :   150.354MB/s


so looks like the bus is not a bottleneck here. and read ahead really
works here.

i guess the problem is r/w disparity in controller or driver.

thanks guys

ming



On Fri, 2005-07-01 at 09:17 -0400, Ming Zhang wrote:
> On Fri, 2005-07-01 at 08:55 -0400, Guy wrote:
> > I think you should test 2 or more disks at the same time.  This
> would prove
> > that your system can or can't move more than about 60MB/s.
>=20
>=20
> i tested and seems that 90MB/s is the max here.
>=20
>=20
> if i run 2 program copy on 2 disks independently on same card, both of
> them bound at 45MB/s
> if i run 3 program copy on 3 disks independently on same card, both of
> them bound at 27 or 28MB/s so total is still 90MB/s
> if i run 2 program copy on 2 disks but one is on 4 port marvel and
> another is 8 port marvel, then both of the bound at 55MB/s which is
> disk
> limitation.
>=20
> so i guess the card or bus has problem. i will check bus speed soon.
>=20
>=20

--=-8UrDc5ueUn63GcKa4fCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCxVZrSYbkL5BnVYoRAnCfAJ0Y7w2X3ISBV1vjjSeJO/3mhdJBggCbB7Ye
6uODVNOY9f6plFbf7dGcwEE=
=eHNp
-----END PGP SIGNATURE-----

--=-8UrDc5ueUn63GcKa4fCu--

