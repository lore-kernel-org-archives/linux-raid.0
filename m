From: NeilBrown <neilb@suse.de>
Subject: Re: Reason for md raid 01 blksize limited to 4 KiB?
Date: Tue, 29 May 2012 20:25:59 +1000
Message-ID: <20120529202559.6aa7fd49@notabene.brown>
References: <4FBA0047.5050208@profitbricks.com>
	<20120522092817.1b5946b8@notabene.brown>
	<4FBF7CAD.7000307@profitbricks.com>
	<20120528140505.6eb49b26@notabene.brown>
	<4FC49733.9050905@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dXcR_WiMuKUQeuGCIvu4USC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FC49733.9050905@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dXcR_WiMuKUQeuGCIvu4USC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 May 2012 11:30:27 +0200 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> On 28/05/12 06:05, NeilBrown wrote:
> > What do you mean by "doesn't work"?  Returns errors? crashes? hangs? ki=
lls
> > you cat?
> >=20
>=20
> dd with oflag=3Ddirect returned an IO error.

Odd.  Updating mdadm shouldn't affect that.

>=20
> > It works for me.
> >=20
> > When I use 32K direct writes to a RAID1, both underlying RAID0 arrays s=
ee
> > 64-sector writes.
> >=20
> > (when I do normal buffered writes I see 8-sector writes which seems odd,
> >  but clearly md/RAID1 is allowing large writes through)
> >=20
>=20
> Now, I've updated mdadm to version 3.2.5 and it works like you've
> described it. Thanks for your help! But the buffered IO is what matters.
> 4k isn't enough there. Please inform me about changes which increase the
> size in buffered IO. I'll have a look at this, too.

I don't know.  I'd have to dive into the code and look around and put a few
printks in to see what is happening.

NeilBrown

--Sig_/dXcR_WiMuKUQeuGCIvu4USC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8SkNznsnt1WYoG5AQKxsxAAlJ5eeTo/cYmoXOYjNu3Iwdcs9lG/ZFOR
qVTcN0+GEl6TG9U8Bye4+WDv6fz/JMMWtF9XbY7hWNVx0Js/tbGZDA3w0LsCTaoi
RDsLAUqmImX22eJ8XaQNKyrk3F2WcgEgD1sZ3oG51ZgDmKA1lDdd5LMTmv6bx/Lk
QOelimqDrIldM8AiWJG5wPasDaaamsRI2+ORAAg1fe6mTLEeCVyl6Zt88OzxnXUw
loZZAN0VVY4dV4/+yXupG3UAp45/dnFuqt5Oi5s5hm3tbnVzL5+poGCegzGGYOvL
6wN6dWCAfhno7ypAQ3cvLxHqxoeoEqGxzHoLXwdB2DSeLKJcKKJtE15ec9+xAyGA
1T0PWZw2TRVY3NtiSbBwBW6WQ8uHlviDREMZdtxR3tsl1oQjF05l8p5ngW8zkOYY
qJS71q/UZwhdYiZv1O7TFTSK3BLkMzY/fpTPzh+0HqvwvnUAiqkbzhD7ZN+rLKt8
MOU6tah4S4kCsYU7cbireQ0ZFmBaooOwEy3Urr/1XIKzQsshUgVxJxyRv2jpF+2a
M/lgEAFV3pfTO5NNGUeV9Fm7pQyJgydR0insoolehuFjb253PHOdcoxv/jZQmj3n
L++hkOlmun/7q9KB3BZNS9rm0XPiQiNu1/qUrw/m+HVAPZoD2TQT/wjAsfBhXWCs
kkVIWwzHGRU=
=p5gE
-----END PGP SIGNATURE-----

--Sig_/dXcR_WiMuKUQeuGCIvu4USC--
