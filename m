From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Stupid question regarding RAID-1 access pattern
Date: Wed, 6 Jan 2010 21:37:23 +0000
Message-ID: <20100106213723.GA12318@cthulhu.home.robinhill.me.uk>
References: <4B44EB58.2090400@northarc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B44EB58.2090400@northarc.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jan 06, 2010 at 02:58:16PM -0500, Curt Hartung wrote:

> Tried to ferret out the answer to this myself and so far so bad.
>=20
> This just 'popped in there' while I was optimizing something completely=
=20
> different... in a RAID-1, writes have to be mirrored of course, thats=20
> what RAID-1 is, but for reads, could they not be sped up by a=20
> significant amount if a storage pattern was chosen such that large=20
> blocks of data were "striped" in an in-order/out-of-order scheme? In=20
> other words, store all the data on both drives, but in huge (2x cache=20
> size) -ish blocks that might allow 50% of a given [large] access to come=
=20
> from each drive, with trivial [smaller] reads always coming from one or=
=20
> the other chosen at random.
>=20
> Downside, I know, is that the data would be organized ina  way only the=
=20
> raid subsystem would understand, so the niceness of pulling a mirrored=20
> drive out of service and it being a literal copy of the otehr drive=20
> would be lost, but for such a speedup I'd be willing to pay the price of=
=20
> always having to access it as a failed set (worst case) through the=20
> md-daemon.
>=20
> Am I off into the weeds?
I doubt this would help much really.  If you're reading sequential data
then it's pretty much as quick to keep reading as to seek to the next
chunk.  If you want a performance and are prepared to throw out strict
RAID1 compatibility then RAID10-f2 may be better suited.  It still
provides the same redundancy but improves read performance by striping
(there's some slowdown on writes but not much).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAktFApEACgkQShxCyD40xBLhfgCfVlHXBcf3FVWNJRgH/CLmwtob
J08AoJwQBtEIRkPwnwWcn2IuQoEy6Bfm
=Ft7x
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
