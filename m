From: Roman Mamedov <rm@romanrm.net>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 2 Jul 2014 16:11:09 +0600
Message-ID: <20140702161109.70843874@natsu>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
	<20140702155224.072d09ef@natsu>
	<20140702110713.Horde.4jCzQvYRo99Ts9nRe3Oy26A@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/waWjtY5OmGhBeXQw_H0LuC_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702110713.Horde.4jCzQvYRo99Ts9nRe3Oy26A@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/waWjtY5OmGhBeXQw_H0LuC_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Jul 2014 11:07:13 +0100
Pedro Teixeira <finas@aeiou.pt> wrote:

> [88623.524481] Buffer I/O error on device md0, logical block 458227712

Ah sorry I have missed these messages quoted in the original mail. Then of
course, it is not an FS issue.

--=20
With respect,
Roman

--Sig_/waWjtY5OmGhBeXQw_H0LuC_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOz2r0ACgkQTLKSvz+PZwgfbQCfXn92Cj33B3oklR6Ev+Fyz26M
syoAn0pSJEu9njuNyUDY2+AK9e5VgZ+a
=PQ5v
-----END PGP SIGNATURE-----

--Sig_/waWjtY5OmGhBeXQw_H0LuC_--
