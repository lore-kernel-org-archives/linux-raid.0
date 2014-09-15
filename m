From: martin f krafft <madduck@madduck.net>
Subject: Re: Speeding up reading with RAID1 and --write-mostly
Date: Mon, 15 Sep 2014 09:44:50 +0200
Message-ID: <20140915074450.GA27163@fishbowl.rw.madduck.net>
References: <20140915141133.0a4da9ad@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140915141133.0a4da9ad@notabene.brown>
 <CAH3kUhGEaon77fpNm2mjRwPbNMZe9BLK3eA6LTB4xQeg0hMF-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Roberto Spadim <roberto@spadim.com.br> [2014-09-13 13:56 +0200]:
> Try a bcache or something like it

also sprach NeilBrown <neilb@suse.de> [2014-09-15 06:11 +0200]:
> It is a persistent cache though.

Oh cool, and it optimises writing too, I'll definitely will check it
out, thank you!

> But I suspect you will find that SD cards aren't really fast
> enough for your needs.  It wouldn't hurt to experiment on just an
> SD card and see how it performs.

Sure, and this will be much easier to set up. However, even my cheap
camera SD outperforms my rotational disk, especially with dmcrypt=E2=80=A6

--=20
@martinkrafft | http://madduck.net/ | http://two.sentenc.es/
=20
an egg has the shortest sex-life of all: if gets laid once; it gets
eaten once. it also has to come in a box with 11 others, and the
only person who will sit on its face is its mother.
=20
spamtraps: madduck.bogus@madduck.net

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQLvBAEBCgDZBQJUFpjvwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xDsT
EACnuM5bwzNvyUJc7DLhWlMDkda+F9GhErExCSIanyFqVHB8/DO2EkAg/+oJHIS0
0++Gyj0jdeLIKxcgZHmXzkhIJJEIPGbwBs5XimNyO2xRauOtrdd/LRbiwFOorE1M
X/yMruj8SISoDilAu6Y4eNtV+5l+3fhah3ZFUg4UU0mQCWVQLZ0VRYA+efx5sdNE
iTODR10QOATy1/Jbqhe0Jl2L3JtUsh3d1mKEL7ENbnzh/Ud73LIblKV910E2UP8P
cMbFEyZbXE4XjvbH2xXaR9SgypPulPaK97DEHrCXfrUSGBpRf3jlzoGTEBxOhRaa
jqiHE14mkx2xqi1Ierw/bQq8vEubwQDpyOKXcx0FUyBQ9WaJvKG/s9S3F/5dpT6S
uJ2V5oR2z3PMIaFzQJAoN6ZoM6Tvq19hTus5meJ7seg+RRkLE9U1kD+qMfrSyqJP
WgGPJ8e0tuDdHC6iBNlr4lOYI+2B5sxfp4vtlmxApN7H+3yfdxhAf7J4NzFPmIBq
Gkhjk2pys0FxDTSwZhKTon5pvNqMkrovoAeoeaQW5u03wKavnMdo6kTKWdWsfdZQ
Ucwt3JthNT8aXVY+qgog/KnHCbcq5T46TDKsS8grvVbkLtm4fw8iddZZ3oNjTpaS
4vkzLlkAMpKndp7XeixMy2GFSPU8s7vtgZUqF7j2H2CP+A==
=Iz+r
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--

