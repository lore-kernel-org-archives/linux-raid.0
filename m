From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 4/5] md: Return proper error rather than EIO.
Date: Mon, 29 Oct 2012 08:43:49 +1100
Message-ID: <20121029084349.615c1ea8@notabene.brown>
References: <201210271028260803459@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kT4Li19AbPNXVlLPKVut6vi"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201210271028260803459@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/kT4Li19AbPNXVlLPKVut6vi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Oct 2012 10:28:30 +0800 majianpeng <majianpeng@gmail.com> wrote:

> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/md/raid1.c |    4 ++--
>  drivers/md/raid5.c |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 8034fbd..e2f3783 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2799,12 +2799,12 @@ static int run(struct mddev *mddev)
>  	if (mddev->level !=3D 1) {
>  		printk(KERN_ERR "md/raid1:%s: raid level not set to mirroring (%d)\n",
>  		       mdname(mddev), mddev->level);
> -		return -EIO;
> +		return -EINVAL;
>  	}
>  	if (mddev->reshape_position !=3D MaxSector) {
>  		printk(KERN_ERR "md/raid1:%s: reshape_position set but not supported\n=
",
>  		       mdname(mddev));
> -		return -EIO;
> +		return -EINVAL;
>  	}
>  	/*
>  	 * copy the already verified devices into our private RAID1
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c5439dc..684ca76 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5088,7 +5088,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>  	    && mddev->new_level !=3D 6) {
>  		printk(KERN_ERR "md/raid:%s: raid level not set to 4/5/6 (%d)\n",
>  		       mdname(mddev), mddev->new_level);
> -		return ERR_PTR(-EIO);
> +		return ERR_PTR(-EINVAL);
>  	}
>  	if ((mddev->new_level =3D=3D 5
>  	     && !algorithm_valid_raid5(mddev->new_layout)) ||
> @@ -5096,7 +5096,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>  	     && !algorithm_valid_raid6(mddev->new_layout))) {
>  		printk(KERN_ERR "md/raid:%s: layout %d not supported\n",
>  		       mdname(mddev), mddev->new_layout);
> -		return ERR_PTR(-EIO);
> +		return ERR_PTR(-EINVAL);
>  	}
>  	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4) {
>  		printk(KERN_ERR "md/raid:%s: not enough configured devices (%d, minimu=
m 4)\n",


One doesn't just randomly change error return codes.
Maybe the current ones are "wrong", but they have been that way for many
years so they are effectively part of the API.  So they are "right" be
definition, even if they seem wrong.

NeilBrown

--Sig_/kT4Li19AbPNXVlLPKVut6vi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUI2nFTnsnt1WYoG5AQK3lA/8DgFzzIED3lEYPQAlRrBjk96Gl6g5PxZ3
XGDwPw0BUupGkToz3b35LYhMvTCDfzFsGCl+0i0Cs9pcni2TkZKnq4ugWoe038aN
RTNfN7atJyKPTrX8InRs/8siR5pvlkjq4MH3Wi0ihjV0s0yziH3OfmO7ifmb38Xk
zNIX/UKy9pXViAzzb061FTl1p8JhUeJHraSB+tL5cawi2QKwLZ4H2N8bzG/hIbwa
Delzbu51TFxOVr+D7WiczUZWFkRWRr0WJumRmkNPPQg3ljVpTOx9cENX9wVynDbi
GJgnmUuGxJSetLBunIMRaRxnliCERTNwjO1hhF62/Zo2BXHNu3clRd/bEKy80kTS
Y3g8G9d1Y8BtvpQaj8wwd5GJtjStjr3W5jDHW+puMZZ4PcAjopH8zbcxFi4oqZSH
BmEqryOUNf5Pn0bsXMYuSEAVNNei9cPFZct4piIprBEsz8nU0fJF/pBYCxFr9dna
q1wI+VwS1m4FGSzAnTMCYZIJvNqCCc+tkx+u5TLNPcPAHMLPNSpZaU4hGov4obvP
Xi5HvzokIls7aW0pVmy728uZRXV3bkaeBhKZ0hTVe5nJ7TPCJ/WHbIcVOQGMSG1/
UtpH9Ij6bQ2cjRjRUjyPZ3EFzZD6vOr2lDOU8AjNZE0iCgaZpX24gfZRUi37h0cp
9bLBk8AAHck=
=y0iD
-----END PGP SIGNATURE-----

--Sig_/kT4Li19AbPNXVlLPKVut6vi--
