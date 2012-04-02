From: NeilBrown <neilb@suse.de>
Subject: Re: md/raid1:!conf->r1buf_pool is unlikely in function  
 sync_request.
Date: Mon, 2 Apr 2012 11:00:25 +1000
Message-ID: <20120402110025.3b2a112f@notabene.brown>
References: <201203281924252189178@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5Dk7nrHGbuXLLbnb9gZzu9O"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203281924252189178@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/5Dk7nrHGbuXLLbnb9gZzu9O
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Mar 2012 19:24:29 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 7f9446682f64e28106dd52cd12bdf74a19fb4015 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Wed, 28 Mar 2012 19:20:07 +0800
> Subject: [PATCH] md/raid1:!conf->r1buf_pool is unlikely in function
>  sync_request.
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a40a20..943b3b3 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2246,7 +2246,7 @@ static sector_t sync_request(struct mddev *mddev, s=
ector_t sector_nr, int *skipp
>  	int good_sectors =3D RESYNC_SECTORS;
>  	int min_bad =3D 0; /* number of sectors that are bad in all devices */
> =20
> -	if (!conf->r1buf_pool)
> +	if (unlikely(!conf->r1buf_pool))
>  		if (init_resync(conf))
>  			return 0;
> =20

Hi,
 I'm really happy that you are reviewing the md patches and even finding so=
me
 bugs.  However I find the stream of occasional tiny patches somewhat
 distracting.

 Also I find micro-optimisation like this fairly pointless.  You should only
 really use unlikely() when it will make a real difference to performance,
 and this change won't

 So I won't apply this patch.
 I'll keep looking though the others you have sent since but in future I
 would prefer it if you collected together little patches like this and send
 them as a group.

 If and when you find genuine bugs, feel free to send them straight away.

Thanks,
NeilBrown

--Sig_/5Dk7nrHGbuXLLbnb9gZzu9O
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT3j6KTnsnt1WYoG5AQKHfhAAiCfbsA+HjRc7XEY9Om5HLjg59SpgHQne
S9disRhS+VhGkQuytKQ5Mr1n+YaQ1DqmwnuqS9Ivv/O1ISezyX27b5I74WPgKRnQ
DojQXh/9iORnYUYgXjpW0d+IYIm783VG5Xy2Zo1SctjXmNDuhzTGp4x2iyRkPEaK
WKBQdBSspfSQp7UQg0RmJq8Lrf3gnR5U4W1OpeE12Put+1yEW7Knoos2hfqvt75m
SKwynotnAibsCplOFJjraPG7vU0Lvbvq8jJ4yc1Rs6cCriWg4Yz/zBagoyJ6NIw4
10KsZNhugeqV/uht67j2zvQkoNXOU0M/5CWHFqIgRtBzZn8bIV1T+yjODuyNDL/F
g16i+KCMCeFzY8hZozp8AvMOXn+flp9/UpbngO1DtMib/HYlxjDs6FoSr/bash1o
XiejP5v69T31Gwoa/hv3bs7bkv+tzbqB4DJ7nD6gUAlGPdLSar1a6/RFjfKuuZ+R
Qcvao30QDhVrZiNUajibeQRNsM0EJKq4GHNbf5nOCk9QOjcT506Dy3p435DdIiOn
oEj/ErkS1yx/8f5oql38ArRJbs3xoVz7JRvl8vmjdDU566M4Uxm0LlGeFSW7QeQS
x6UM3MsmsUDyzcBunzH0EiLmMU+xnlXZ2NC5cMokc9FMB6HLpiuxJWreQ9dryBCv
qqecy4VOygQ=
=eKno
-----END PGP SIGNATURE-----

--Sig_/5Dk7nrHGbuXLLbnb9gZzu9O--
