From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid10:using conf->chunk_mask instead "chunk_secotrs
 - 1"
Date: Tue, 17 Apr 2012 19:11:42 +1000
Message-ID: <20120417191142.11beb19a@notabene.brown>
References: <201204171649462965325@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_=fqP.U9vyKURSga6.HI4r5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201204171649462965325@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/_=fqP.U9vyKURSga6.HI4r5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Apr 2012 16:49:50 +0800 "majianpeng" <majianpeng@gmail.com> wrot=
e:

> >From 2c637bca4e50e87f7b4e6b3abce27f8cd935fd92 Mon Sep 17 00:00:00 2001
> From: majianpeng <majianpeng@gmail.com>
> Date: Tue, 17 Apr 2012 16:47:07 +0800
> Subject: [PATCH] md/raid10:using conf->chunk_mask instead "chunk_secotrs -
>  1".
>=20
>=20
> Signed-off-by: majianpeng <majianpeng@gmail.com>
> ---
>  drivers/md/raid10.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c8dbb84..5734d92 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -601,7 +601,7 @@ static int raid10_mergeable_bvec(struct request_queue=
 *q,
>  	unsigned int bio_sectors =3D bvm->bi_size >> 9;
> =20
>  	if (conf->near_copies < conf->raid_disks) {
> -		max =3D (chunk_sectors - ((sector & (chunk_sectors - 1))
> +		max =3D (chunk_sectors - ((sector & conf->chunk_mask)
>  					+ bio_sectors)) << 9;
>  		if (max < 0)
>  			/* bio_add cannot handle a negative return */


Doesn't apply to latest code (in for-next).

And are you sure that it is actually an improvement?  'chunk_sectors' is
probably in a register, conf->chunk_mask is not.

I really am not interested in micro-optimisations like this (as I have said
before).

An please try to fix up your mailing process so that patch doesn't have
duplicate headers.

NeilBrown

--Sig_/_=fqP.U9vyKURSga6.HI4r5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT40zzjnsnt1WYoG5AQKDlBAAlvJqbNZBEX9Am5JgB5id4C8i82gN/G26
NUXZ5qxe63oZ7d/0xlzrI+pHMg3NbxmwNllNokb7Xds5q6UVCmyddvPWH7geU4DI
kuhgmwU9r6bkRJ/o40KeSDgqOhAj2cIxDem/Cm9SdG0aHa/eMBQa0t3Q61evBnXG
HRasI5rHeMonJXinkIY83srSN3PF0HM1RQ1LdclSLJ//y9DzgmdzwNaCKuazlN+M
oULlT6pQ4VyHVD6qCMr7gYkcce+PGizdijqBfFupL1BaxKkSzjZ8lwQKie/3Af85
4X+F13TNSehEWypvOG8Tt/nui9Izljym0J53p5W6SN+phsU5WUJvBMqVRF60LiCd
NZgffVUCSxrG0jgtB6UwiM0nNh4wgA8kB8ZSbQDpcMZEWAUXbALNplPFzVLtFB9O
SBtHoCDHv+G/oe2mOk914+mF6ozDwTK6JlIAhnDX3KgB7gLDdoDW+dCUg12ivIvO
/c1VGvr5oIBQxcPIhBpk7bBEtdWQo+0G4rx20/zwQzGL0uiGcokDWdgoGOMjFWOu
dJr7HcM2n76y5szSY5GbszzY7F08U+K/c2ylS1cCzqeYp+TWXCFyQ8A2LHbeOHui
kghkehgIUFOg2jncftgWpmrcJ1Wfg+skqO4v7gSjVhHD9TIW86bgDm0Pz7SGN888
G1jvLKsW5vc=
=0UyM
-----END PGP SIGNATURE-----

--Sig_/_=fqP.U9vyKURSga6.HI4r5--
