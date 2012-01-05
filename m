From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: implications of partitioning and raid
Date: Thu, 5 Jan 2012 16:12:17 +0000
Message-ID: <20120105161217.GA23196@cthulhu.home.robinhill.me.uk>
References: <1325778034.4777.44.camel@hermosa.lnx.copansys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1325778034.4777.44.camel@hermosa.lnx.copansys.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter W. Morreale" <morreale@sgi.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 05, 2012 at 08:40:34AM -0700, Peter W. Morreale wrote:

>=20
> I'm wondering what the implications are for having multiple raid sets on
> a partitioned disk wrt to disk failures.=20
>=20
> For example, suppose I create two partitions on a set of disks and
> create raid sets on those partitions.  Further, not all raid sets
> reference the same disks.  IOW, md0 references disks 1 and 2, and md1
> references disk 1 and 3.  (overly simplistic for discussion purposes)
>=20
> Assume a portion of disk 1 goes 'bad' (localized within one of those
> partitions), is noticed by md and a rebuild is warranted. =20
>=20
> What is the behavior? =20
>=20
Any failure will only affect the single array member where the error
occurred. In most cases this is due to a catastrophic disk failure
though, so will also occur on other partitions of the disk (and the
arrays using them) as well.

> Will both raid sets start a rebuild?  Or only the affected raid set?
>=20
> IOW, would there be two rebuild tasks, one for each raid set?  Or a
> single rebuild that encompasses all raid sets (within the same raid
> level, of course) on the disk in question?=20
>=20
Rebuild processes are per raid set, but only one rebuild will be done at
a time using the same disk (so if disk 1 fails and is replaced, then
there's separate rebuilds pending for md0 and md1, but only one will run
at a time).

> What I am getting at is whether there would be any advantage to
> partitioning disks for failure purposes.  =20
>=20
There's an advantage in being able to prioritise the rebuilds (so I can
rebuild the array containing / before that containing /opt for example)
and there's some cases where there's a transient failure (a write error
causes the array member to be failed, but testing shows up no errors) in
which case it reduces the rebuild time as only a single array needs to
be rebuilt. The latter is pretty rare though, unless you have other
underlying problems (such as power issues or poor quality I/O
chipsets/drivers).

HTH,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk8Fy+AACgkQShxCyD40xBIY4ACfXtbHO1TdBlu6+1ohbBUbqeZ2
e7wAn2pS7s1d4JALhE6DYLmbCS0weW4l
=OCKq
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
