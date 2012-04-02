From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:Fix a logic bug in fix_sync_read_error().
Date: Mon, 2 Apr 2012 12:05:24 +1000
Message-ID: <20120402120524.45156163@notabene.brown>
References: <201203311037586565381@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WmNTZVPiK2LK1z=WfqW8fi+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203311037586565381@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/WmNTZVPiK2LK1z=WfqW8fi+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Mar 2012 10:38:01 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> >From 0fe15c8e1bd5e46234d37573f3322312d8da325d Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Sat, 31 Mar 2012 10:27:33 +0800
> Subject: [PATCH] md/raid1:Fix a logic bug in fix_sync_read_error().=20
> If  d=3D=3Dread_disk && success =3D=3D 1 and then break, so d =3D
>  read_disk. When exec this judgement: >>start =3D d; >>/*
>  write it back and re-read */ >>while (d !=3D
>  r1_bio->read_disk) { Because d =3D=3D read_disk,so write and
>  re-add did not exec.

That is correct, and that is how it should be.

If we get a read error, then try again and get a successful read, then there
is nothing more that we need to do.  No need to write or anything.

So: current code is correct.

Thanks,
NeilBrown


>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..3a133ff 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1618,7 +1618,6 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
>  						 bio->bi_io_vec[idx].bv_page,
>  						 READ, false)) {
>  					success =3D 1;
> -					break;
>  				}
>  			}
>  			d++;


--Sig_/WmNTZVPiK2LK1z=WfqW8fi+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3kJZDnsnt1WYoG5AQIPwhAAi+ue3ew0qAOSCUsSBd5X7ihFhqXUQ8A5
swqy2vq3CzMePEENr1eQ3m6h/X25ZRosCyX+CEyszcOKD9OSAB11C5r97GiNg7pe
UJ85pVoZ0wVijv9vU5clLZWcvHX2eSC8tFXg+H2YchrXnCVNK2HynycMzsKg1eAs
+IEsYsKFcfwCNN3C7wGKAQDiFspF0PdUGAb/tmaprE/u+18YVo0jGwKXnihZQv5F
UY29zGHPViMgh/42oSPYhXTxH+umC928h/Fx4WljdMT+K/wM79wb9d8vHMmy27eP
wTq0gKTfkO0K6c7SzI8RVLSXkxoi1NxEl+76BlxEfjzLHHVZdTVEjL1bYx8pR7xf
9nAvXF3hw7HAS4C+3F1ZueWwA9/7J7QOpJTtZTYXJCeRiXvhXBWcWTggkf/CAI2X
rULHYQXAIHnVlQHzDWzYXQZMxHP0pwU2UIo0QgpcgCv9QJ6e2tOx07G2YMXaNDBg
NQAZvLy65dlC08nCQOEeJNoTpfgbQtInVDsiXntAZlFJEnJYRtEm4vWfur0vNlko
zL1nj1iUtTun8BxHE5vEr335iXxXeFirlqFuBPraDd6TFslNCd5697OSA2hgvURI
OzKNcS2hPCkc0VXoVeSdnQOB5c+SZxY3PgIWQ98vzBgUa49EvRKtqJX/b/VjdUa1
/9n7UUNMVAY=
=NmcW
-----END PGP SIGNATURE-----

--Sig_/WmNTZVPiK2LK1z=WfqW8fi+--
