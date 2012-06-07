From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 7/8] raid5: raid5d handle stripe in batch way
Date: Thu, 7 Jun 2012 11:32:39 +1000
Message-ID: <20120607113239.6a64b64d@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080344.262680737@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/OAfx0JnZS2O7NZslZrFRz.q"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080344.262680737@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/OAfx0JnZS2O7NZslZrFRz.q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 16:01:59 +0800 Shaohua Li <shli@kernel.org> wrote:

> Let raid5d handle stripe in batch way to reduce conf->device_lock locking.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

I like this.
I don't think it justifies a separate function.

#define MAX_STRIPE_BATCH 8
struct stripe_head *batch[MAX_STRIPE_BATCH]
int batch_size =3D 0;

...

while (batch_size < MAX_STRPE_BATCH &&
       (sh =3D __get_priority_stripe(conf)) !=3D NULL)
     batch[batch_size++] =3D sh;

spin_unlock(&conf->device_lock);
if (batch_size =3D=3D 0)
     break;

handled +=3D batch_size;

for (i =3D 0; i < batch_size; i++)
     handle_stripe(batch[i]);
cond_resched();
if (....) md_check_recovery(mddev);

spin_lock_irq(&conf->lock);
for (i =3D 0; i < batch_size; i++)
     __release_stripe(batch[i]);


something like that?

Thanks,
NeilBrown



> ---
>  drivers/md/raid5.c |   35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-01 14:34:03.987606911 +0800
> +++ linux/drivers/md/raid5.c	2012-06-01 14:49:26.388010973 +0800
> @@ -4585,6 +4585,22 @@ static int  retry_aligned_read(struct r5
>  	return handled;
>  }
> =20
> +static int __get_stripe_batch(struct r5conf *conf,
> +		struct stripe_head_batch *batch)
> +{
> +	struct stripe_head *sh;
> +
> +	batch->count =3D 0;
> +	do {
> +		sh =3D __get_priority_stripe(conf);
> +		if (sh) {
> +			batch->stripes[batch->count] =3D sh;
> +			batch->count++;
> +		}
> +	} while (sh && batch->count < MAX_STRIPE_BATCH);
> +
> +	return batch->count;
> +}
> =20
>  /*
>   * This is our raid5 kernel thread.
> @@ -4595,10 +4611,10 @@ static int  retry_aligned_read(struct r5
>   */
>  static void raid5d(struct mddev *mddev)
>  {
> -	struct stripe_head *sh;
>  	struct r5conf *conf =3D mddev->private;
> -	int handled;
> +	int handled, i;
>  	struct blk_plug plug;
> +	struct stripe_head_batch batch;
> =20
>  	pr_debug("+++ raid5d active\n");
> =20
> @@ -4633,15 +4649,16 @@ static void raid5d(struct mddev *mddev)
>  			handled++;
>  		}
> =20
> -		sh =3D __get_priority_stripe(conf);
> -
> -		if (!sh)
> +		if (!__get_stripe_batch(conf, &batch))
>  			break;
>  		spin_unlock_irq(&conf->device_lock);
> -	=09
> -		handled++;
> -		handle_stripe(sh);
> -		release_stripe(sh);
> +
> +		for (i =3D 0; i < batch.count; i++) {
> +			handled++;
> +			handle_stripe(batch.stripes[i]);
> +		}
> +
> +		release_stripe_flush_batch(&batch);
>  		cond_resched();
> =20
>  		if (mddev->flags & ~(1<<MD_CHANGE_PENDING))


--Sig_/OAfx0JnZS2O7NZslZrFRz.q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT9AEtznsnt1WYoG5AQIbyw//Q8Iph+pNwyi/6q/p/ICoZgd/OcTHSrhW
WZdi8HptrQdvsGELg1Wucnh5tRQ25OFZOA8bxfQOLrsqUiXGM56txhQgbF83+SkX
Mz57sexF1RAYwRxrXE3IOGkBPtI1ye+CM+ho4LB0s7zBXi3ahEUewOju2nXnerVT
noIf8pdDHWSOKaDFiYJ9BRL6tFpwgEaMxWlbb0G35ahJeJdQFUDEuWdTsr+0Gpnv
fLPOngDfagFqrbVXALe+LepxeO9wkJmsqv11QSZBAU12CIJo6bZ8NMG6Fme/SEGC
YP2ocMpR01BUULiQr9oTWyeWRlBINYbXjgibI0P95AzCrEUoOSB60LTbtXM9lNfJ
+3OoRcKoUyqCb70GOAsYNxAxmX9rFTvtEEeYc47Cqg/zJKjKgiWuocs3AXpFZU5N
EgU+K+dH4dXiQV/fMCDYHWz5wg8Cy+BInPfe1Y6BhuNYxJK7O1TovGsP8bINWRfA
3cuHgsesb8ZTOWS2qjoULQ2uimpszHcp7OoYoL3yPYIW2Ot5LBeiuKVjZnkcnmG+
Wsofy76WmMBF9fJh98CyXm49Li1wlgmXcRejWe/r70SmyBfHmSinkYh3CT0pDlI7
KSPgqvXeyBZQkKyplm3kQwc+Jj+lUvqPTGVwtIMRDuaHTVpSjndX0/qoBNDnOteq
pKwl+ALl9Fg=
=pvl2
-----END PGP SIGNATURE-----

--Sig_/OAfx0JnZS2O7NZslZrFRz.q--
