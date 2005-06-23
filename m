From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: More tales of horror from the linux (HW) raid crypt
Date: Thu, 23 Jun 2005 08:31:47 -0400
Message-ID: <1119529907.5503.1.camel@localhost.localdomain>
References: <200506230305.j5N35u222988@www.watkins-home.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U0tS4vXuYy1zmmFYuvIG"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506230305.j5N35u222988@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: bdameron@pivotlink.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-U0tS4vXuYy1zmmFYuvIG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2005-06-22 at 23:05 -0400, Guy wrote:
> > -----Original Message-----
> > >
> > > > will this 24 port card itself will be a bottleneck?
> > > >
> > > > ming
> > >
> > > Since the card is PCI-X the only bottleneck on it might be the Proces=
sor
> > since
> > > it is shared with all 24 ports. But I do not know for sure without
> > testing it.
> > > I personally am going to stick with the new 16 port version. Which is=
 a
> > PCI-
> > > Express card and has twice the CPU power. Since there are so many
> > spindles it
> > > should be pretty darn fast. And remember that even tho the drives are
> > 150MBps
> > > they realistically only do about 25-30MBps.
> >=20
> > the problem here is taht each HD can stably deliver 25-30MBps while the
> > PCI-x will not arrive that high if have 16 or 24 ports. i do not have a
> > chance to try out though. those bus at most arrive 70-80% the claimed
> > peak # :P
>=20
> Maybe my math is wrong...
> But 24 disks at 30 MB/s is 720 MB/s, that is about 68.2% of the PCI-X
> bandwidth of 1056 MB/s.
yes, u math is better.

>=20
> Also, 30 MB/s assumes sequential disk access.  That does not occur in the
> real world.  Only during testing.  IMO
yes, only during test. but what if people build raid5 base on it, this
is probably what people do. and then a disk fail? then a full disk
sequential access becomes normal. and disk fail in 24 disk is not so
uncommon.

>=20
> Guy
>=20
> >=20


--=-U0tS4vXuYy1zmmFYuvIG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCuquySYbkL5BnVYoRAjsvAJ9f6ghLfwA0h/9ABEAJUXTPbLVqggCfejNP
WYUnTniaqHMHwpjmpUmYVGs=
=/kKi
-----END PGP SIGNATURE-----

--=-U0tS4vXuYy1zmmFYuvIG--

