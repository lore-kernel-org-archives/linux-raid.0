From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: endianness of Linux kernel RAID
Date: Wed, 03 Aug 2005 11:50:05 -0700
Message-ID: <1123095005.14126.69.camel@seki.nac.uci.edu>
References: <20050803120656.GA16696@anthropohedron.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Z3uspIrL8kBC4EY0qTkT"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050803120656.GA16696@anthropohedron.net>
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


--=-Z3uspIrL8kBC4EY0qTkT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


I don't have time to fix this by a long stretch, but I do have a web
page that talks about endianness issues, including ways of avoiding
painting yourself into a corner with them:

http://dcs.nac.uci.edu/~strombrg/converting-binary.html

The section at the top about architecture-neutral formats is probably
most relevant to this discussion - more so than the conversion programs.

As far as fixing up the mess, it'd probably be best to have some sort of
RAID usage option that would allow:

1) byte swap all endian-dependent integers on reads and writes - EG
little to big, or big to little (the operation is typically its own
inverse)

2) use a canonical format (best for use at creation time) that will
always store byte-sex dependent integers the same way, irrespective of
what sort of platform one is on

It might also not hurt to, at the same time,  make sure that integer
size (say, 32 bits vs 64 bits) isn't an issue.

I'm actually a bit discouraged that more projects aren't just using some
sort of canonical, arbitrary-precision integer format, to eliminate
these issues for good.  Granted, disk space isn't growing fast enough at
current speed to exceed a 128 bit integer anytime soon, but you never
know if there's going to be a big leap in disk capacity someday.  IMO,
this is the ideal long-term solution to this sort of problem.

On Wed, 2005-08-03 at 08:07 -0400, Gregory Seidman wrote:
> It turns out that if one uses the kernel (2.4.x-2.6.x) RAID support (RAID=
5,
> anyway, since that's all I've tested), the RAID'd disks cannot be moved t=
o
> another system with a different endianness. I don't know how hard that
> would be to fix, but it did mean that when my ancient Mac clone I was usi=
ng
> as a server died I couldn't bring the RAID over to my spare x86 Linux box=
;
> I had to dedicate other hardware (my dual G4 that I had been happily usin=
g
> with OS X) to the task instead.
>=20
> Unfortunately, I haven't gotten into kernel development and, therefore, d=
o
> not have the necessary expertise to fix it. Is anyone here interested in
> this issue?
>=20
> --Greg
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-Z3uspIrL8kBC4EY0qTkT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBC8RHdo0feVm00f/8RAj1xAJ9OEbGwUOyLm4ewAcMNwyNsrBCtrACfW0aI
OQFSHYzxyH2tBLcPGRDz3x4=
=BSdi
-----END PGP SIGNATURE-----

--=-Z3uspIrL8kBC4EY0qTkT--

