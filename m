From: NeilBrown <neilb@suse.de>
Subject: Re: Failed Array Rebuild advice Please
Date: Wed, 11 Apr 2012 14:43:02 +1000
Message-ID: <20120411144302.35f13f3d@notabene.brown>
References: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com>
	<20120411090219.78392784@notabene.brown>
	<1334117647.68845.YahooMailNeo@web125505.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wgS42eNisE7U+HoV14BFgl6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334117647.68845.YahooMailNeo@web125505.mail.ne1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/wgS42eNisE7U+HoV14BFgl6
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Apr 2012 21:14:07 -0700 (PDT) jahammonds prost
<gmitch64@yahoo.com> wrote:

> One other question as the badblocks progresses.
> =A0
> >=A0 It will then recovery both devices in parallel.
>=20
> How many additional devices can be done at the same time? I presume that =
I am going to have to=A0replace the 2 failed devices before I try and grow =
the array by adding 3 additional drives? I so, how many=A0additional drives=
 can be rebuilt concurrently with a grow? Could I add 5 devices and not see=
 too much of a performance hit? Or would it be more sensible to add them on=
e at a time?
>=20

I think it is best to recover, and then reshape later.  I cannot promise th=
at
doing them both at once will work .... it might but I have a feeling that
there might be problems.

Adding three additional drives at once should work well enough in terms of
performance.
However I would only do it if I were very very confident of the drives.
If you hit bad blocks you start losing drives, and if you have 3 drives that
you haven't used before, the chance of losing them all during the reshape -
while still small - becomes a little too high for comfort.

But if you have run heavy bad-blocks tests on them all and they appear to
work, then adding 3 drives at once should be fine.

NeilBrown

--Sig_/wgS42eNisE7U+HoV14BFgl6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4UL1jnsnt1WYoG5AQIecxAAsfag+VeyagH7ss3d4ACcOyy1/QuVwyTw
TNh4rLuV2UhwP83VinBxhKeKBgahiGX8q6EBeHVElFy/whRFKATxtPKZZnhD8i5V
NWOrMLkoYVKyan/9q3RVg5AFYtVRHNHnPzcduoOZDwPXfU3+NwzBGVF7hCeyZVqM
vMoYKcx393IVHhWq0mDN+BNniwX0kD1uREiUYTBBJXyL7Qvnxxqkk7GSnXqVgmNQ
qyYzu6I2J8jUWjxPQh/xtbUxyg4BlbPXuhyYAiyQN23FYdNXHVIW96NnkZ3Ph+hX
yad2pH3aNbcM6zQLQIlRR0jCb+Y7xOUUyBYngsPCMheOOxhjKKWfpyMlpGQbs+8C
QYbcZo1BcuiyVmeqRUf6HmnsXdrBL377o5ttK3ZFVMMsJiVjj7uRk2lIwVvclzZE
tGGETTPzu8n6T83QClFs66CzF/Eyi8olukEOz8lh4a/THqVO9XCcN5HcO+dIueMa
Xwowd4wCRhhxbFQ8B5YZHfmtRXXGIGN89NJ+bU7RV3MdYVJtgY+Yxtcy3/akBvGZ
rCVUdS8Qu29q89bqAw3CCQ0FBJmUI0LieoL9y1O6Lp/waWBf8M6ail7uClyTIsUO
V1us0tT2kpeIF6hh5BV5+6EZtJRs2oTT534KWnN5gVdnSu5V57pRzaS2yu/W6TTq
i/mbLLBIOGY=
=lm/W
-----END PGP SIGNATURE-----

--Sig_/wgS42eNisE7U+HoV14BFgl6--
