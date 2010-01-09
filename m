From: =?UTF-8?Q?Micha=C5=82?= Sawicz <michal@sawicz.net>
Subject: Re: Can I skip recovery for RAID5 in this way?
Date: Sat, 09 Jan 2010 06:00:01 +0100
Message-ID: <1263013201.2304.128.camel@michal-laptop.sawicz.net>
References: <389deec71001082023h21bdb12dg548b62d12d1c6c35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vg3xdJpKTTcHy1EA+3U4"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec71001082023h21bdb12dg548b62d12d1c6c35@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-vg3xdJpKTTcHy1EA+3U4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dnia 2010-01-09, sob o godzinie 12:23 +0800, hank peng pisze:
> Please correct me if I am wrong, maybe my way is stupid.

You'd lose redundancy this way. If any of the other disks fail, there
would be not enough data to recover.

--=20
Cheers
Micha=C5=82 (Saviq) Sawicz

--=-vg3xdJpKTTcHy1EA+3U4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: To jest =?UTF-8?Q?cz=C4=99=C5=9B=C4=87?=
 =?UTF-8?Q?_wiadomo=C5=9Bci?= podpisana cyfrowo

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAktIDVEACgkQzQlUjpZYlbctlQCfWi6OZ2TWDnDd7WU0SJMaggt7
BB0AoM6KWv2hUDl48IojyeuF/PzphRNc
=+HrE
-----END PGP SIGNATURE-----

--=-vg3xdJpKTTcHy1EA+3U4--

