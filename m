From: NeilBrown <neilb@suse.de>
Subject: Re: [BISECT] Kernel panic, RIP bitmap_create
Date: Fri, 4 May 2012 16:47:38 +1000
Message-ID: <20120504164738.3ddf4073@notabene.brown>
References: <CAOOwNtJhFa67EFTs5AdgSHzFseBr9xJGTsaEOyYnaYYNCeUMAQ@mail.gmail.com>
	<CAOOwNt+wjMU9+Dzrr3+d3dwML2_Q_CgT4X5OgiKvPA_bBoTYcg@mail.gmail.com>
	<20120503155850.2900067d@notabene.brown>
	<CAOOwNtK0xKg9E=gS46GR8uDVvjPqqL7+FbufY2d7iuW7yZgVwQ@mail.gmail.com>
	<20120503165030.7e45c25b@notabene.brown>
	<CAOOwNtKko_db_wtqYOiGScq0ZOMbMK1L9DhDnm1geWhsQmLWNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.0+N6IB6jys3Ig7gIzbv7Nb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOOwNtKko_db_wtqYOiGScq0ZOMbMK1L9DhDnm1geWhsQmLWNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Newman <siliconfiend@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.0+N6IB6jys3Ig7gIzbv7Nb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 3 May 2012 23:37:38 -0700 Karl Newman <siliconfiend@gmail.com> wrot=
e:


> Somehow gmail marked this email as read, too, so I missed it. Anyway,
> that did it! With this patch applied I can successfully boot! I tested
> the offending commit by itself first with the all-zeros uuid patch
> applied and confirmed the bug was still present, then applied this
> patch and the bug was gone. I also applied this patch to 3.4-rc5 and
> confirmed that it was still good.

Thanks - and good news.

I'd still like to know how this bug manages to cause a crash (I create an
array that have identical "mdadm -E" and "mdadm -X" output on an x86_64
machine, and couldn't make it crash).

I'll add a Reported-by: and Tested-by: for you and submit to Linus shortly.


>=20
> Thank you for your help on this issue, and thank you for your work as
> a kernel developer and supporting this crucial component.

A pleasure - specially when I get to work with helpful and responsive
people :-)

NeilBrown


>=20
> Sincerely,
>=20
> Karl Newman


--Sig_/.0+N6IB6jys3Ig7gIzbv7Nb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6N7ijnsnt1WYoG5AQIC7A//YpbUR6diimzeqW/nYi+vVQGZckUp9IUI
SbGtHZkelDYw8VF1gHV9wJ2K27k2fMiZtYLj5i17EMSpJhFJzTX7UvWXQAP03c49
GDtTN+J6jfuXBqtmi7qZNjQ2Ukc+antdNwcsVh9Pm3TQV6Dvzyg9Ugw+NyaypupN
mHjxeca4A9mPfw+/LVkQX958agUXtT7nK3l9yH64BSQU7ycdjjhjea3SZ452us+T
mprlDNtMZf/+HyYNGk6qM4xcLvgs2wouA7ZPFPlV6ijurLn/kTj3BxR4JJAdudLZ
bQ9Wtc+YWPD6uWGz1SW5yFzhg/cftqzECyIH++jx57DwcKdewnezPlMIuLZWGS8y
Uv8A/G3Tcd2uVYe5kWfW/XUA8alkU1ydyJS6YUl/XefkrFbxwEwA1+G2gwMa/MGU
gYstKhKl5nsyehx5R182QETSb+hAW9SDsR2ditrs9M982eKJS8wloLhpi2PAeAEl
4YDST+e4jc4zsI9HaWvmTqcSODpBVSDS9PaQoRpqJKyHvl/F5AoaAoOSFIKfejPe
MqkktfA5W5yZBumRjlyB90rOf0zdSoJIKKziDunRhsvWPhuZpgZf1DvsgY04RnjK
TawUu3Zsp0OrYbTlq7wnXrmefsAZxcReJvBu9UZK8EoIZo3ur+kzWW8tudoYOGja
5wPYIWSb4L0=
=AJY/
-----END PGP SIGNATURE-----

--Sig_/.0+N6IB6jys3Ig7gIzbv7Nb--
