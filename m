From: Andre Noll <maan@systemlinux.org>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Wed, 11 Jun 2008 23:06:26 +0200
Message-ID: <20080611210626.GC4981@skl-net.de>
References: <484F9A3E.7020709@rabbit.us> <20080611112319.GB4981@skl-net.de> <484FC142.9030600@rabbit.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H8ygTp4AXg6deix2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <484FC142.9030600@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--H8ygTp4AXg6deix2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14:12, Peter Rabbitson wrote:
> >Nobody really cares about the partition type these days. I usually
> >stick to the default 83 (Linux) for software raid partitions and
> >never encountered any problems.
>=20
> This is a very flawed assumption. You will be surprised how many=20
> utilities/live CDs are there in existence, which will selently attempt to=
=20
> mount/fsck a partition based solely on its type.

Well, I'd consider those utilities broken by design. If it is the
exercise is to break as few utilities/live CDs as possible, I admit
you'll have to care about partition types. It's a rather pointless
exercise IMHO though.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--H8ygTp4AXg6deix2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIUD5SWto1QDEAkw8RAjeIAJ9zDEmIztzpb/zX1f0RonEubbkNCgCeJoQF
TtmyreQdb1WjWXhc9I6GQQA=
=c6s7
-----END PGP SIGNATURE-----

--H8ygTp4AXg6deix2--
