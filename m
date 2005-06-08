From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: active/active vs active/passive?
Date: Wed, 08 Jun 2005 11:28:11 -0700
Message-ID: <1118255291.15459.164.camel@seki.nac.uci.edu>
References: <1118189397.15459.108.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-toF+iGpaj+8gxaX9W5R3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1118189397.15459.108.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


--=-toF+iGpaj+8gxaX9W5R3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2005-06-07 at 17:09 -0700, Dan Stromberg wrote:
> The lecturer at the recent NG storage talk at Usenix in Anaheim,
> indicated that it was best to avoid "active/active" and get
> "active/passive" instead.
>=20
> Does anyone:
>=20
> 1) Know what these things mean?
>=20
> 2) Know why active/passive might be preferred over active/active?
>=20
> If I had to guess, I'd say that active/active means that n servers are
> all watching n-1 others to decide when they should jump to life, while
> in active/passive perhaps 1 server is primary, and the passive nodes
> only monitor that 1 server.  Maybe?  Just a totally wild guess based on
> next to nothing.  :)

I think I found a relevant context.  Say you have two RAID controllers
per "Storage Brick", the latter apparently being a dual-ported way of
accessing a SATA or FC disk.  Does active/active mean they'll send data
at the disk in question via both ports?

Thanks!


--=-toF+iGpaj+8gxaX9W5R3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQBCpzi7o0feVm00f/8RAonLAKChEbQIWhQjQlDEw16XiS9d1Xga9wCfSLbj
0GZ9BryAMGDu75ylqCw16pw=
=bwIe
-----END PGP SIGNATURE-----

--=-toF+iGpaj+8gxaX9W5R3--

