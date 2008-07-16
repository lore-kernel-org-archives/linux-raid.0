From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Thu, 17 Jul 2008 01:42:23 +1000
Message-ID: <1216222943.10437.20.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715163932.GA23164@rap.rap.dk>
	 <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com>
	 <20080715173927.GA24745@rap.rap.dk> <487D3A44.7000008@sauce.co.nz>
	 <cccedfc60807151720x62cdbb3cx2c772ac884f97fde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8EoJtZQtApFpSW+pqQhs"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807151720x62cdbb3cx2c772ac884f97fde@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Richard Scobie <richard@sauce.co.nz>, Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, thomas62186218@aol.com, linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-8EoJtZQtApFpSW+pqQhs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-15 at 19:20 -0500, Jon Nelson wrote:
> On Tue, Jul 15, 2008 at 7:01 PM, Richard Scobie <richard@sauce.co.nz> wro=
te:
> > Keld J=C3=B8rn Simonsen wrote:
> >
> >> I would actually welcome more tests with specific user profiles, like
> >> many small reads and writes for database  use, and concurrent random
> >> reading and writing to simulate the load on a server. What bonnie++ is
> >> reporting is only equential IO. This is important on work stations, bu=
t
> >> actually not on servers.
> >
> > The following is from the Bonnie++ man page:
> >
> > "There  are  two  sections  to the program's operations. The first is t=
o
> > test the IO throughput in a fashion that is designed to  simulate  some
> > types of database applications. The second is to test creation, reading=
 and
> > deleting many small files in a fashion similar to the usage patterns of
> > programs such as Squid or INN."
> >
> > So I guess the author thinks it's valid for more than sequential I/O.
> >
> > In any case, while we may be in a minority, Justin, I and a few others =
are
> > interested in sequential I/O, as we build servers required to read and =
write
> > multiple streams of uncompressed SD and HD video in realtime.
>=20
> In that case, the 'fstest' program (google for it, it's associated
> with the samba folks IIRC), might be just the ticket.

Since I was digging around, the link for future readers;
http://www.samba.org/ftp/unpacked/junkcode/fstest.c



--=-8EoJtZQtApFpSW+pqQhs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh+Ft8ACgkQsIKOrI+5WvOxZQCeIvu9VVf2EL9+x1cEepU3hjRs
PFgAoO/30+gedgMMS6E0rz/trAbIgrL3
=1aTE
-----END PGP SIGNATURE-----

--=-8EoJtZQtApFpSW+pqQhs--

