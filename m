From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 09/10 v3] raid5: raid5d handle stripe in batch way
Date: Mon, 2 Jul 2012 12:32:59 +1000
Message-ID: <20120702123259.3487dbb8@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072712.004553385@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vQOC/EEWmSjOGQfYH5X4mgp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072712.004553385@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/vQOC/EEWmSjOGQfYH5X4mgp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:56 +0800 Shaohua Li <shli@kernel.org> wrote:

> Let raid5d handle stripe in batch way to reduce conf->device_lock locking.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   45 ++++++++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 13 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-25 14:38:37.378835415 +0800
> +++ linux/drivers/md/raid5.c	2012-06-25 14:38:40.150800523 +0800
> @@ -4568,6 +4568,30 @@ static int  retry_aligned_read(struct r5
>  	return handled;
>  }
> =20
> +#define MAX_STRIPE_BATCH 8
> +static int handle_active_stripes(struct r5conf *conf)
> +{
> +	struct stripe_head *batch[MAX_STRIPE_BATCH], *sh;
> +	int i, batch_size =3D 0;
> +
> +	while (batch_size < MAX_STRIPE_BATCH &&
> +			(sh =3D __get_priority_stripe(conf)) !=3D NULL)
> +		batch[batch_size++] =3D sh;
> +
> +	if (batch_size =3D=3D 0)
> +		return batch_size;
> +	spin_unlock_irq(&conf->device_lock);
> +
> +	for (i =3D 0; i < batch_size; i++)
> +		handle_stripe(batch[i]);
> +
> +	cond_resched();
> +
> +	spin_lock_irq(&conf->device_lock);
> +	for (i =3D 0; i < batch_size; i++)
> +		__release_stripe(conf, batch[i]);
> +	return batch_size;
> +}
> =20
>  /*
>   * This is our raid5 kernel thread.
> @@ -4578,7 +4602,6 @@ static int  retry_aligned_read(struct r5
>   */
>  static void raid5d(struct mddev *mddev)
>  {
> -	struct stripe_head *sh;
>  	struct r5conf *conf =3D mddev->private;
>  	int handled;
>  	struct blk_plug plug;
> @@ -4592,6 +4615,7 @@ static void raid5d(struct mddev *mddev)
>  	spin_lock_irq(&conf->device_lock);
>  	while (1) {
>  		struct bio *bio;
> +		int batch_size;
> =20
>  		if (atomic_read(&mddev->plug_cnt) =3D=3D 0 &&
>  		    !list_empty(&conf->bitmap_list)) {
> @@ -4616,21 +4640,16 @@ static void raid5d(struct mddev *mddev)
>  			handled++;
>  		}
> =20
> -		sh =3D __get_priority_stripe(conf);
> -
> -		if (!sh)
> +		batch_size =3D handle_active_stripes(conf);
> +		if (!batch_size)
>  			break;
> -		spin_unlock_irq(&conf->device_lock);
> -	=09
> -		handled++;
> -		handle_stripe(sh);
> -		release_stripe(sh);
> -		cond_resched();
> +		handled +=3D batch_size;
> =20
> -		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))
> +		if (mddev->flags & ~(1<<MD_CHANGE_PENDING)) {
> +			spin_unlock_irq(&conf->device_lock);
>  			md_check_recovery(mddev);
> -
> -		spin_lock_irq(&conf->device_lock);
> +			spin_lock_irq(&conf->device_lock);
> +		}
>  	}
>  	pr_debug("%d stripes handled\n", handled);
> =20
>=20


I've applied this patch, thanks.

NeilBrown


--Sig_/vQOC/EEWmSjOGQfYH5X4mgp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/EIWznsnt1WYoG5AQJ6ug//ZHXVtxd6f8GRqG9UewfT+r/ZnqcTgTbR
Pa1Gm6yJUBIaT/0vOdyNR1wfhrYTHrG+C7V4ToSfZiEJvWh3TL8SsoWCxRmBYgCm
KZDbj8E2t5u7oG7I1OH1nryZ4pnTpsT0Rjo0HSLUDkEGgrApGQedHmYmU0YQBvit
BmgEvrIlUKaPsr3JwLOh/Vet2ZJvBbExaKWIMyy/deHM2UKz4dOscYCYqM6ATyKp
/6clg5Igw7sp48Acpi34kAfi3XJSDuLvsnVlJvYLThY0OjCJHHpF3+B5eVxUMrpV
h4hUmG09QpxPNM+vArXxLmuUMF/ud8yEJvFYFdpNLomUZlgjdkR2LI+VNrUPD0Xs
w09z6gp0Oo8mI3VaEWX5tlW5KQXIFDfj/HYU7vFNNmy4J6MiYgnJjR9SdOCG4pnj
cy+Ng8zxRCt3OWieeMO/W/ACV25AMzUeiC5tYY2U7B2dQxAstH6M6IDcmyj+PJBk
IYOjRHXQcWmlRcZQ1Cpe1hqLMsaG85Zw3IttIuJRwbdO/2w/ljnw47JuVljVbCbY
4JBzQ+aa19PApZSm9pjOFJhyAIfK1eb217bmmmTrHYAS4funtxViBTdhuL6uNPff
sVvfXlkMqDgSAAxtGNSgCrDQmfAqvse04mMqpuS47zdK7x96/6lRvYVxjJnXZJBO
acW6pZ7XZYI=
=Q5hv
-----END PGP SIGNATURE-----

--Sig_/vQOC/EEWmSjOGQfYH5X4mgp--
