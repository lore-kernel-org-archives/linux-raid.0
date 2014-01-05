From: NeilBrown <neilb@suse.de>
Subject: Re: Recovering an Array with inconsistent Superblocks
Date: Mon, 6 Jan 2014 10:50:11 +1100
Message-ID: <20140106105011.3e58bbdc@notabene.brown>
References: <1388829881.16265.20.camel@vessel>
	<52C835C9.3050707@turmel.org>
	<1388873143.7641.20.camel@vessel>
	<52C8C433.5030403@turmel.org>
	<1388912870.3591.4.camel@vessel>
	<20140105205612.093276ef@notabene.brown>
	<1388918703.3591.20.camel@vessel>
	<52C9A399.5040802@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1br2WafW90.Eji2/xp2bGth"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52C9A399.5040802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Fabian Knorr <knorrfab@fim.uni-passau.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1br2WafW90.Eji2/xp2bGth
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 05 Jan 2014 13:25:29 -0500 Phil Turmel <philip@turmel.org> wrote:

> Hi Fabian,
>=20
> I see good news to greet me this morning!
>=20
> On 01/05/2014 05:45 AM, Fabian Knorr wrote:
> > $ cat /proc/mdstat=20
> > Personalities : [raid6] [raid5] [raid4]=20
> > md127 : active (auto-read-only) raid5 sde1[6] sdh1[2] sdi1[3] sdb1[4] s=
dg1[1] sdc1[5] sdf1[0]
> >       11721074688 blocks level 5, 1024k chunk, algorithm 2 [7/7] [UUUUU=
UU]
> >         resync=3DPENDING
>=20
> Auto-read-only will switch to read-write as soon as you actually write
> anything to the array.  Which will also kick off the resync.

You can also "mdadm --readwrite /dev/md127" to allow resync to continue.


> Long term, consider creating a new array with metadata type 1.x so you
> can use a bitmap.  If you ever have an event like this, where one or
> more devices are disconnected then reconnected, it'll greatly shorten
> the recovery time.

While I would encourage the use for 1.x metadata, you don't strictly need it
for a bitmap.  0.90 metadata supports bitmaps too, though it is slightly le=
ss
flexibly in the granularity of the bitmap (not that you would probably
notice).

NeilBrown


--Sig_/1br2WafW90.Eji2/xp2bGth
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUsnvsznsnt1WYoG5AQIqbw/8CGQFvd6cGLKHIS394iFShVGL9p33OgC7
l+yfv/Pv+D7uXPxHSY1lrTzKXNbKZMLQ6H2NVjL0YkRHNBxbT/xwEvxM+iqP5dU6
U8L9c9Bbx74P9mKB3Y8nuFwzHR8L6tJQRv55N2a8lG2IFes+zgwcIA1OBxFOxauM
TvqeQaQG0I5hmOb4EITkuuCQQfnLJ0hRsZgp+Xo3PJmUmMCL4Tm2eG5S3LNNcvXU
jAjt9aTEjrmE10KrNeltGtCXPp5ohyg9QhtDbckG+QWOL97j8gWgFjsP9nbQcDjM
WzHZF+UKkHNnkJV/Nvamuazz17XhJlIvNLQqLS4F3HakjP2ZydcCOb9Ywkv9Xto4
x5WDApS1pKFH+nhc9rp0U+D7dI6D/FmkDIWRZ3A05SXXFey9QWkSWwz0657F8I5B
n99LzlFIByQmZ+NU5zcT+3tPYpE9mcLt1cGogKDZJz1LoMTQoPUPQbPmtGlbpvBY
thyfCfHx9AcCYdMFEYtKrw5dVyMkR+oN4Yuk0jdCf9+g4YZ/icsXSwU0CmB08BU4
6KcUpLWnSwCX57KPqLSjKg0V6pFvo07oxpwA4v57JbucYJ1Fnw3XTXbEJDBAbiUU
Jdd4gD9whtlEaR7A6XhNW5MD/qGxXJVHAOKuDqo/jk48avwOvtUYRqPPZNTZVkV6
EPoDynXfdG4=
=HrnK
-----END PGP SIGNATURE-----

--Sig_/1br2WafW90.Eji2/xp2bGth--
