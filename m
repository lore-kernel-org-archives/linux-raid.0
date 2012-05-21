From: NeilBrown <neilb@suse.de>
Subject: Re: Check / Automatic repair
Date: Mon, 21 May 2012 21:36:07 +1000
Message-ID: <20120521213607.340acdd2@notabene.brown>
References: <CAFYuN7qTy5Apj265N6PiyvbU5QmS7=ry+ofi=vHjzDfsf7uh5g@mail.gmail.com>
	<20120521201538.1fbac51b@notabene.brown>
	<CAFYuN7pu=gCR_cV45t2NRnw5TcUbfOouq=Ug5wP70+X8hLqYQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ES0YK_JWEEZ.OiQTE+O0K65"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFYuN7pu=gCR_cV45t2NRnw5TcUbfOouq=Ug5wP70+X8hLqYQw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Fabien Bourigault <dradge@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ES0YK_JWEEZ.OiQTE+O0K65
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 May 2012 13:25:42 +0200 Fabien Bourigault <dradge@gmail.com> wro=
te:

> So, what really happens if I do :
>=20
> echo "check" > /sys/block/md0/md/sync_action
>=20
> or :
>=20
> echo "repair" > /sys/block/md0/md/sync_action
>=20
> ?

"man md"

look for "SCRUBBING AND MISMATCHES"

NeilBrown

--Sig_/ES0YK_JWEEZ.OiQTE+O0K65
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7oopznsnt1WYoG5AQLPsA/+Kp3SXVy4U+2jmQ7HEPYxuPADgUO0La88
SGyLmP8yPxAS5pJvyKF+AcvW19NAxd5E3Yt3cu0WIJw1yEPlsKXf/UKO65dAkY2R
Ujg/r3Wbj34oi35zrFlX92rEVDu8zlnwY57+Qx+1YmcoiNNwnM0D2sSRdWXEc+Dk
HVBAY2Ofrrf0B4y1Hs9gZ5132hx/9J4WqR+cfaqc448YBLffsbKqHH0uOE6p5yUt
IP9mM44U2GwDLp4bA7XriSj/iqA0EneAvtjJbcp/OZDfXL7/G0Gdz5ILvqXmJEFJ
JbOanreRXgTy0e5l4cISYiMJpCOW1k7tPu6J+qEkJYQeFS3cSU0c+fuvhJTjg+pt
PXTiCpunSKy+MmjU27yemWQK5X2s5ZUJd0AJCGJL2VfBZDUivP/rWgDXAnCfZ+9q
3Pe/q3U2U5wR29T/u8ERoywyNFoTtjxGNE6YEyxagLeLYJ64NksObNVBOGrTv2Ft
ZoXmAexlpycxSKKAf0GUhbWgycbhp66uS24iah2Vk+/xlnxhBMawit82QrAO4lgU
0F2fOCoyGxJicmvzDAHjbgGSdDK6FDIyqvY87SBmtNtcXCcSWJfeCJTJf8W3PEt0
V6AleNBj33iqtIP7BRIYFHOcKwawjDt+mvF0Ts0TLPzQ1HL9QKUOLkRHB4s3hUjq
luPxgf+AZz4=
=qWpC
-----END PGP SIGNATURE-----

--Sig_/ES0YK_JWEEZ.OiQTE+O0K65--
