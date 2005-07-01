From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: raid0 low performance
Date: Fri, 01 Jul 2005 08:41:03 -0400
Message-ID: <1120221664.5507.25.camel@localhost.localdomain>
References: <1120184148.5521.21.camel@localhost.localdomain>
	 <42C4AA31.8040307@dtbb.net>
	 <50513.168.91.5.7.1120186660.squirrel@localhost>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FkLP+zqjyHi8j5Y1mmxu"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50513.168.91.5.7.1120186660.squirrel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: John Madden <jmadden@ivytech.edu>
Cc: Tyler <pml@dtbb.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-FkLP+zqjyHi8j5Y1mmxu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2005-06-30 at 21:57 -0500, John Madden wrote:
> > useage during the tests?  even PCI 32bit, 33mhz should be able to hit
> > 133 Mbytes per second I believe.  What are you writing *from* ? dev/zer=
o
>=20
> ~127MB/s is the theoretical bus speed of PCI/33.  Actual throughput is mu=
ch less
> than that, of course.
>=20
> But you're not on a 33MHz bus, you should be at at least 66MHz (and info =
in /proc
which one? i can not find. :P could u tell me? thx


> should tell you).  Given the lack of performance increase though, I'm gue=
ssing
> you're either pegging the bus or the CPU, not yet the throughput of the k=
ernel
> itself.  Does the program block in disk wait when running?
yes, it write synchronously. so it is wait.


but my friend run same code on a 3ware 4 disk raid0 and get 140MB
easily.

similar box, P4 2.8G 1G ram. supermicro board.


>=20
> John
>=20
> (Go Rams)
>=20
>=20
>=20

--=-FkLP+zqjyHi8j5Y1mmxu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCxTnfSYbkL5BnVYoRAt5kAJ4r1i7mUee3jkISxQdPDZ2urt4JtgCfXV00
Aj5urWVujGWYBfFW201YJYU=
=gy45
-----END PGP SIGNATURE-----

--=-FkLP+zqjyHi8j5Y1mmxu--

