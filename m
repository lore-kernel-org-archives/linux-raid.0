From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: raid0 low performance
Date: Mon, 04 Jul 2005 20:26:56 -0400
Message-ID: <1120523217.5459.20.camel@localhost.localdomain>
References: <Pine.LNX.4.44.0507042009340.16047-100000@coffee.psychology.mcmaster.ca>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n7HVKEHe8G1a5Zlh1tRr"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0507042009340.16047-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-n7HVKEHe8G1a5Zlh1tRr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2005-07-04 at 20:13 -0400, Mark Hahn wrote:
> > # ./lspci -vv -d 11ab:
> > 02:01.0 Class 0100: 11ab:5081 (rev 03)
> >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> > ParErr- Stepping- SERR- FastB2B-
> >         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbo=
rt-
> > <TAbort- <MAbort- >SERR- <PERR-
> >         Latency: 32, cache line size 08
>=20
> latency 32 is quite low; this parameter effects how long the device
> can hold onto the bus.  try
> 	setpci -s 02:01.0 latency_timer=3D80

thanks a lot for this and i will test it tomorrow.

> and see whether it improves things.  I'm unclear on whether a bridged dev=
ice
> also needs the bridge's latency setting changed.
>=20
> >         Latency: 32, cache line size 08
>=20
> also low.  I'm guessing that your bios is tuned for desktop use - some au=
dio
> setups need low latency settings.
>=20
yes, i guess so, the only drawback of this box is that i am using a
entry level server box. so its chipset is quite weak and the setting i
left as default.


Ming


--=-n7HVKEHe8G1a5Zlh1tRr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCydPQSYbkL5BnVYoRAkviAJ0R3O/j+qpc4nICngNxVYNS5Eu6SgCfS2Og
xLsXD+clgc95TSFhcgmPk1I=
=J6SS
-----END PGP SIGNATURE-----

--=-n7HVKEHe8G1a5Zlh1tRr--

