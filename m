From: Gregory Leblanc <gleblanc@linuxweasel.com>
Subject: RE: Mirroring swap
Date: 26 Jun 2003 14:23:17 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1056662597.10690.6.camel@gregdell.example.com>
References: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BfZerInjHkpiJdHDzEV+"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.43.0306260916190.5551-100000@unicorn.drogon.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-BfZerInjHkpiJdHDzEV+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2003-06-26 at 01:30, Gordon Henderson wrote:
[snip]
> So now with important machines which had mirrored or RAIDed disk systems,
> I always put swap on a mirrored or RAID5d device.

Swap on RAID 5 is going to have pretty poor performance, in general.=20
Swap needs to be both high bandwidth and low latency, both for reading
and writing.  RAID 5 just isn't that.
	Greg.


--=-BfZerInjHkpiJdHDzEV+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA++2RFnAkVXO6fw4sRAq6bAJ98V3qMWbYJk4s3Egit7xNkyJcupQCeKfs8
UZGp7qgvgBZSZQ00xs4mD68=
=QT/q
-----END PGP SIGNATURE-----

--=-BfZerInjHkpiJdHDzEV+--

