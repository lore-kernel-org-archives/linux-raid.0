From: NeilBrown <neilb@suse.de>
Subject: Re: memory leak with linux-3.14.16
Date: Sat, 16 Aug 2014 20:10:27 +1000
Message-ID: <20140816201027.4cb2278a@notabene.brown>
References: <201408160840.s7G8esgf025944@portal.naev.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/mGjkJfpG8P_2+ASERT4us2M"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201408160840.s7G8esgf025944@portal.naev.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Koch <mdraid.pkoch@dfgh.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mGjkJfpG8P_2+ASERT4us2M
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 16 Aug 2014 10:40:54 +0200 mdraid.pkoch@dfgh.net (Peter Koch) wrote:

> Dear readers,
>=20
> I am shrinking my raid10-array consiting of 16 2TB disks
> to 13 disks right now. Reshaping runs for 2 hours and
> I'm constantly obervng /proc/mdstat and /proc/meminfo
>=20
> SUnreclaim is constantly growing while MemFree and
> MemAvailable are decreasing.
>=20
> Seems like linux 3.14.16 is leaking memory at a rate
> of 4GB per 1TB of reshape data.

Hmm... don't know about that bug.
Does /proc/slabinfo show some slab much bigger than the rest?

>=20
> My machine has 32GB of RAM and if I interpolate the current
> memory-values I will run out of mem at 80% of the reshape
> operation. This is exactly what happened to me with
> linux-3.14.12.

If you gracefully shutdown and reboot it should keep pick up where it left
off but with more memory free.

>=20
> Do I need linux-3.14.17 ??

The only bug I know of was fixed in 3.14.6.
I said 3.14.16 before - sorry about typo.

I'll if I can reproduce it myself some time next week.

NeilBrown



>=20
> Kind regards
>=20
> Peter Koch
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/mGjkJfpG8P_2+ASERT4us2M
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+8uEznsnt1WYoG5AQLsjw/+Nj9khByhnrO2lrCHKhAJRLFujLSMMbDl
FHuihjtTZarktl+QWAeW8HsIvkkczEUc98JoDc0juNQwJQp4kgetz35aHJ7vogpM
P3ldBzLX5zZsvHFQzueEv5l3txO5cSoy1hVgaWfyw47jQwHr/5pnPx9iW/tyz0gW
lK5V4Nb/QkCaDHf4Ydq5YErVA/JH389ye/xsXlzz8CiBIL8dZVZWtjTnq9tKON4J
1U4kYpmCHx2E3serpsIOYXmg6CzjO3/ngddY3zHPCJWDY4WmbSqt6AFECDY1I527
pmxCQ5AQLbHbThi2Lz8nGVR3KS0tEZDzZxdMWue1qi6l6s+Mdfv1TntJ9zo/FNzC
TGgUZqiBt68BlWejkh9zmf2OW1J9YBQ9DiORyEeQfOvSUGLLpOnB4AShUTU7uNlz
9hcPcozmMF3V2895lZlg7QKs5TEgKd8egSvpBdeGPCBNw6ST/bTScyeDHquuuXw5
jcQVwffXSthBR3mlwx4uhWLDRJP1Ba/lu3LIlFNPFIU6nUbY0ckY5gdUNrX+Fp9l
jD05HXMYQSubwo+gAs0UANjAm9m+PxlZGXzPbGYcKxksgWGlPIx8OUiMevu1naFO
ANbHYhz0OB3mkg/kud4YbICrdI2N7c9+X9DqC8N1zX5zJp0KxZSi504Q93RrD+Xr
Bma2tazHgsA=
=y+JS
-----END PGP SIGNATURE-----

--Sig_/mGjkJfpG8P_2+ASERT4us2M--
