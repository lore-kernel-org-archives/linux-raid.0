From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID-6 horizontal grow
Date: Fri, 10 Apr 2009 22:58:33 +0100
Message-ID: <20090410215833.GF21242@cthulhu.home.robinhill.me.uk>
References: <20090410215435.GA10451@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E7i4zwmWs5DOuDSH"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090410215435.GA10451@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--E7i4zwmWs5DOuDSH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Apr 10, 2009 at 11:54:35PM +0200, Piergiorgio Sartor wrote:

> Hi all,
>=20
> is it possible to grow a RAID-6, not by adding
> more drives, but by extending the partions which
> are composing the array?
>=20
> In other words, let's say I've "n" partitions of
> "x" GB forming a RAID-6 array. After some time I
> increase the size of each partition to "y" GB, of
> course y > x.
> Is it then possible to use the complete space
> growing the array?
> How?
>=20
Yes - "mdadm --grow --size=3Dmax /dev/mdX".  You'll also need to grow the
filesystem afterwards of course.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--E7i4zwmWs5DOuDSH
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAknfwQgACgkQShxCyD40xBLJjwCbBUFBRTUbOxOHhRDVphQqg0hr
GUEAoJ9uytjMZv6USLBY+Lk5HdHBubaK
=FvXr
-----END PGP SIGNATURE-----

--E7i4zwmWs5DOuDSH--
