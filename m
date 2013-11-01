From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC] md raid resync counter
Date: Sat, 2 Nov 2013 10:48:08 +1100
Message-ID: <20131102104808.47834bdc@notabene.brown>
References: <5273A5BC.5060109@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ilyJVRklCD5u.xmyO4irZAe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5273A5BC.5060109@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ilyJVRklCD5u.xmyO4irZAe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 01 Nov 2013 13:59:40 +0100 Jack Wang <xjtuwjp@gmail.com> wrote:

> Hi Neil and all,
>=20
> Is there anyway to know:
>=20
> 1. How often does a raid start to resync?

Look at your logs?

> 2. How many bytes did it resync?

Look at "mismatch_cnt" in sysfs (and multiply by 512).

NeilBrown


>=20
> If not, for the first one, I think we cound add field into mddev like
> resync_counter, increase when resync done, and annother field into
> md_rdev to track how many bytes synced to the outdated disk?
>=20
> Regards,
> Jack


--Sig_/ilyJVRklCD5u.xmyO4irZAe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnQ9uDnsnt1WYoG5AQLMPxAAuYvAdwGv/v5sMkJfYdEKWORuzEJNixy9
ngveHOYLGMbTi9gerIQa7iluhJ6oCYMbbhj5V2RlejEvzJZi+BRnUJeJ9nNIFTkd
bADi6tTCoS4S10d+5wtOrEkuV1LuXXxbxWNcjjG46G/IO1Fj8tCbbMO9eC6uf0Py
mihUjK1xL/mIhSFQMWxlRMOYm8+/KUd738QruSL8wjgWS2Djvk2yrkA0RNotjrc+
Rf4GG/LJVhe5lR4998pQr54i/Gut/QeeWeSRGbiTdKGOqtRGhc2b5YyST+fvJNUr
jupSiZpUbJjLW85O0RE9rBTRxF1MohhrLSHFxLae5Xd4nn5H6SZLi0x2383m1buV
6IJwQCNyHWZuj1ZJdo+wu3NAeq38zfozakgBVpxm6RGN5EyaNvviR6X/TN8t0q4x
GiFjrG0stTWODJ8eYLac6s3Ke0Vp1FpLNDxzBiJep4VXWIXs4VDF0DwwLiFOw7BW
wlUEfBoq93V5/CC2B4cKPs6qX4OJYYc74oryabh4xmUu6ph/D4ZjJ3/cYw5Xj8NM
/YYtGcwE70j4jd8o9lQSE8zvG/BcSRjG3V1RPY2qGHZZqdr+PEVswP0t2NtLGn2o
zqbythk75TBl6J4z1XeAWNVmOBXdfqnkjlqmyEs7dz/iY5egJBAS0HVWdiAN5eUm
nQBbegWn82I=
=cYdP
-----END PGP SIGNATURE-----

--Sig_/ilyJVRklCD5u.xmyO4irZAe--
