From: Ben Martin <monkeyiq@users.sourceforge.net>
Subject: Re: Benchmarks: Linux Kernel RAID vs a Hardware RAID setup
Date: Wed, 16 Jul 2008 14:06:59 +1000
Message-ID: <1216181219.5633.372.camel@sam.localdomain>
References: <1216130769.5633.318.camel@sam.localdomain>
	 <20080715163932.GA23164@rap.rap.dk>
	 <8CAB4B2168C7183-B68-AD2@webmail-ng19.sysops.aol.com>
	 <20080715173927.GA24745@rap.rap.dk> <487D3A44.7000008@sauce.co.nz>
	 <cccedfc60807151720x62cdbb3cx2c772ac884f97fde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h3I388Odc1tgC0jVVmij"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60807151720x62cdbb3cx2c772ac884f97fde@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Richard Scobie <richard@sauce.co.nz>, Keld =?ISO-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, thomas62186218@aol.com, linux-raid@vger.kernel.org, Ben Martin <monkeyiq@users.sourceforge.net>
List-Id: linux-raid.ids


--=-h3I388Odc1tgC0jVVmij
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
> > interested in sequential I/O, as we build servers required to read
> and write
> > multiple streams of uncompressed SD and HD video in realtime.
>=20
> In that case, the 'fstest' program (google for it, it's associated
> with the samba folks IIRC), might be just the ticket.
> You specify the number of children (real children, not threads), the
> number of files each child will open, populate, verify, and then
> delete, the size of the files, and a few other options. It very nicely
> simulates a set of totally greedy I/O intensive processes.
>=20

I was thinking of benchmarks at a higher level too.=20

fstest and fio seem like good candidates for making a configuration that
tests performance that can be easily run on another system without much
setup required.

A few other ideas I had were using postal for simulating a mail server
env and doing "something" with PostgreSQL. The latter is really a fairly
large can of worms because you would need to lock down the various RAID
caches, read aheads (which might actually adversely effect performance
if the kernel second guesses PG badly), the pg configuration (eg, its
caching settings) and of course where the base tables and indexes landed
on disk.

If anyone has pointers for testing PG performance on RAID I'd love to
hear about them either on / off list.


--=-h3I388Odc1tgC0jVVmij
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkh9c+MACgkQsIKOrI+5WvOK3ACgktmydUrAhPlXei/17dSHegxV
lXIAn0W5piKkAnYG9k3LooVbYhy4zrec
=cIW0
-----END PGP SIGNATURE-----

--=-h3I388Odc1tgC0jVVmij--

