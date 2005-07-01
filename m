From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: raid0 low performance
Date: Fri, 01 Jul 2005 09:10:35 -0400
Message-ID: <1120223435.5507.33.camel@localhost.localdomain>
References: <1120184148.5521.21.camel@localhost.localdomain>
	 <42C4AA31.8040307@dtbb.net>
	 <50513.168.91.5.7.1120186660.squirrel@localhost>
	 <1120221664.5507.25.camel@localhost.localdomain>
	 <49052.10.0.15.208.1120222485.squirrel@postal2>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m/82GUNXjniwnAFADc8i"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49052.10.0.15.208.1120222485.squirrel@postal2>
Sender: linux-raid-owner@vger.kernel.org
To: John Madden <jmadden@ivytech.edu>
Cc: Tyler <pml@dtbb.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-m/82GUNXjniwnAFADc8i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2005-07-01 at 07:54 -0500, John Madden wrote:
> > which one? i can not find. :P could u tell me? thx
>=20
> lspci -vv
thx. cool flag. i use lspci all the time but never find that -vv stuff.
so from now on every command i will add a -vvvvvvv. :P


> > but my friend run same code on a 3ware 4 disk raid0 and get 140MB
> > easily.
> >
> > similar box, P4 2.8G 1G ram. supermicro board.
>=20
> Then I agree with the other reply -- suspect that Marvel controller or it=
s driver
> is at fault.  Can you borrow your friend's controller? :)
>=20
he has oracle on it. run a test like that already take a long time and
some beers. :P


> John
>=20
>=20
>=20
>=20
>=20

--=-m/82GUNXjniwnAFADc8i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCxUDLSYbkL5BnVYoRAmmrAKCHvG9oNFfwXLtMnBONkEzpz55giACbBdGX
AvrVtuCftmh3UffBaYzgWKs=
=O0C5
-----END PGP SIGNATURE-----

--=-m/82GUNXjniwnAFADc8i--

