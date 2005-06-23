From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: More tales of horror from the linux (HW) raid crypt
Date: Thu, 23 Jun 2005 09:19:20 -0400
Message-ID: <1119532760.5503.18.camel@localhost.localdomain>
References: <200506231303.j5ND3e224877@www.watkins-home.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JSy1JPSkxMmosPWv8NdJ"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506231303.j5ND3e224877@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: bdameron@pivotlink.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-JSy1JPSkxMmosPWv8NdJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-06-23 at 09:03 -0400, Guy wrote:
>=20
> > -----Original Message-----
> > From: Ming Zhang [mailto:mingz@ele.uri.edu]
> > Sent: Thursday, June 23, 2005 8:32 AM
> > To: Guy
> > Cc: bdameron@pivotlink.com; linux-raid@vger.kernel.org
> > Subject: RE: More tales of horror from the linux (HW) raid crypt
> >=20
> > On Wed, 2005-06-22 at 23:05 -0400, Guy wrote:
> > > > -----Original Message-----
> > > > >
> > > > > > will this 24 port card itself will be a bottleneck?
> > > > > >
> > > > > > ming
> > > > >
> > > > > Since the card is PCI-X the only bottleneck on it might be the
> > Processor
> > > > since
> > > > > it is shared with all 24 ports. But I do not know for sure withou=
t
> > > > testing it.
> > > > > I personally am going to stick with the new 16 port version. Whic=
h
> > is a
> > > > PCI-
> > > > > Express card and has twice the CPU power. Since there are so many
> > > > spindles it
> > > > > should be pretty darn fast. And remember that even tho the drives
> > are
> > > > 150MBps
> > > > > they realistically only do about 25-30MBps.
> > > >
> > > > the problem here is taht each HD can stably deliver 25-30MBps while
> > the
> > > > PCI-x will not arrive that high if have 16 or 24 ports. i do not ha=
ve
> > a
> > > > chance to try out though. those bus at most arrive 70-80% the claim=
ed
> > > > peak # :P
> > >
> > > Maybe my math is wrong...
> > > But 24 disks at 30 MB/s is 720 MB/s, that is about 68.2% of the PCI-X
> > > bandwidth of 1056 MB/s.
> > yes, u math is better.
> >=20
> > >
> > > Also, 30 MB/s assumes sequential disk access.  That does not occur in
> > the
> > > real world.  Only during testing.  IMO
> > yes, only during test. but what if people build raid5 base on it, this
> > is probably what people do. and then a disk fail? then a full disk
> > sequential access becomes normal. and disk fail in 24 disk is not so
> > uncommon.
> But, this is hardware RAID.  A re-sync would not affect the PCI bus.  All
> disk i/o related to re-building the array would be internal to the card.
> However, even if it were a software RAID card, the PCI-X would be at 68.2=
%
> load, so it should not be a problem.  If my math is correct!  :)
>=20
> Also, a single RAID5 array on 24 disks would be high risk of a double
> failure.  I think I would build 2 RAID5 arrays of 12 disks each.  Or 2 RA=
ID5
> arrays of 11 disks each, with 2 spares.
>=20
or build with raid6. but anyway, once u a disk, u will need to have a
rsync. with MD, u might try the fr5.

no money, otherwise buy one and try. :P

i think i need a 4U unit, dual amd64...

ming

> >=20
> > >
> > > Guy
> > >
> > > >
>=20
>=20

--=-JSy1JPSkxMmosPWv8NdJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCurbYSYbkL5BnVYoRAhU3AJ9Pu/ykotLKQSvGi/Rt+4W3voXC7ACbBSS5
xA8Se1PokM7PYGdwNGGpxwM=
=RcUP
-----END PGP SIGNATURE-----

--=-JSy1JPSkxMmosPWv8NdJ--

