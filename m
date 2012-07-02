From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 06/10 v3] raid5: reduce chance release_stripe() taking
 device_lock
Date: Mon, 2 Jul 2012 10:57:31 +1000
Message-ID: <20120702105731.2be963e6@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072641.504876596@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yYDLjjkfXcRaK8C+A.NOQsy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072641.504876596@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/yYDLjjkfXcRaK8C+A.NOQsy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:53 +0800 Shaohua Li <shli@kernel.org> wrote:

> release_stripe() is a place conf->device_lock is heavily contended. We ta=
ke the
> lock even stripe count isn't 1, which isn't required.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   73 +++++++++++++++++++++++++++++-----------------=
-------
>  1 file changed, 40 insertions(+), 33 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-25 14:37:21.000000000 +0800
> +++ linux/drivers/md/raid5.c	2012-06-25 14:38:13.899130571 +0800
> @@ -196,49 +196,56 @@ static int stripe_operations_active(stru
>  	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  }
> =20
> -static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
> +static void handle_release_stripe(struct r5conf *conf, struct stripe_hea=
d *sh)
>  {
> -	if (atomic_dec_and_test(&sh->count)) {
> -		BUG_ON(!list_empty(&sh->lru));
> -		BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
> -		if (test_bit(STRIPE_HANDLE, &sh->state)) {
> -			if (test_bit(STRIPE_DELAYED, &sh->state) &&
> -			    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> -				list_add_tail(&sh->lru, &conf->delayed_list);
> -			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
> -				   sh->bm_seq - conf->seq_write > 0)
> -				list_add_tail(&sh->lru, &conf->bitmap_list);
> -			else {
> -				clear_bit(STRIPE_DELAYED, &sh->state);
> -				clear_bit(STRIPE_BIT_DELAY, &sh->state);
> -				list_add_tail(&sh->lru, &conf->handle_list);
> -			}
> -			md_wakeup_thread(conf->mddev->thread);
> -		} else {
> -			BUG_ON(stripe_operations_active(sh));
> -			if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> -				if (atomic_dec_return(&conf->preread_active_stripes)
> -				    < IO_THRESHOLD)
> -					md_wakeup_thread(conf->mddev->thread);
> -			atomic_dec(&conf->active_stripes);
> -			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> -				list_add_tail(&sh->lru, &conf->inactive_list);
> -				wake_up(&conf->wait_for_stripe);
> -				if (conf->retry_read_aligned)
> -					md_wakeup_thread(conf->mddev->thread);
> -			}
> +	BUG_ON(!list_empty(&sh->lru));
> +	BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
> +	if (test_bit(STRIPE_HANDLE, &sh->state)) {
> +		if (test_bit(STRIPE_DELAYED, &sh->state) &&
> +		    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +			list_add_tail(&sh->lru, &conf->delayed_list);
> +		else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
> +			   sh->bm_seq - conf->seq_write > 0)
> +			list_add_tail(&sh->lru, &conf->bitmap_list);
> +		else {
> +			clear_bit(STRIPE_DELAYED, &sh->state);
> +			clear_bit(STRIPE_BIT_DELAY, &sh->state);
> +			list_add_tail(&sh->lru, &conf->handle_list);
> +		}
> +		md_wakeup_thread(conf->mddev->thread);
> +	} else {
> +		BUG_ON(stripe_operations_active(sh));
> +		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +			if (atomic_dec_return(&conf->preread_active_stripes)
> +			    < IO_THRESHOLD)
> +				md_wakeup_thread(conf->mddev->thread);
> +		atomic_dec(&conf->active_stripes);
> +		if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> +			list_add_tail(&sh->lru, &conf->inactive_list);
> +			wake_up(&conf->wait_for_stripe);
> +			if (conf->retry_read_aligned)
> +				md_wakeup_thread(conf->mddev->thread);
>  		}
>  	}
>  }
> =20
> +static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
> +{
> +	if (atomic_dec_and_test(&sh->count))
> +		handle_release_stripe(conf, sh);
> +}
> +
>  static void release_stripe(struct stripe_head *sh)
>  {
>  	struct r5conf *conf =3D sh->raid_conf;
>  	unsigned long flags;
> =20
> -	spin_lock_irqsave(&conf->device_lock, flags);
> -	__release_stripe(conf, sh);
> -	spin_unlock_irqrestore(&conf->device_lock, flags);
> +	local_irq_save(flags);
> +	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
> +		handle_release_stripe(conf, sh);
> +		spin_unlock(&conf->device_lock);
> +	}
> +	local_irq_restore(flags);
>  }
> =20
>  static inline void remove_hash(struct stripe_head *sh)


Thanks.  I've applied this patch and it should appear in my -next shortly.
I renamed "handle_release_stripe" to "do_release_stripe", partly because I
think that is more consistent with practice in Linux, but mostly because
"handle" means something else inside raid5.c and I don't want to encourage
confusion.

Thanks,
NeilBrown

--Sig_/yYDLjjkfXcRaK8C+A.NOQsy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/Dx+znsnt1WYoG5AQI12Q//f4mJ/KnvGZxXnQZUlg96w5JkD+l3xfLZ
wBOLof0UagLlI7SbAT99o5xug7C6OVyE9/n2lq9HuOtFKFbA/x+/dJ8hsIdK3NkR
WC1CgMhW10AV8s9VJNZE2XrRAKqKBixkh28ravSZIh564vdniEy+t6X8P1le/lJx
etFo6UoB8VGGVb66yWR7yT/yOBHp35kMIZHi6fbnDL6SzlOHk0IkaBEBIlytHIDz
BR0PKYSx5cDLToYyttxlHaK8AxsYM7NyrSTs2P9Ri8L3YIoBy3e6vueuhVcxuWa7
7iGaH2QY1W3MRm6s24KURPjYuSDZKNk/D3UaGppY2KJhluzzOaxmkJi9e/5Ki42/
9x5yf9J6J0faust/tZEMkQ/BqoszpA5j4s7bYmoE5K6rdJBsDv4UZj/em9uMlRVO
ka3i44P1TKwlA5O3LSWwhasQEY4ZFWmYzPfLDSIZve7mpIJvBgLwwWLAurHkivlH
ZUKB+X6CtmihwdAsT3bXIhLpB+irSM2B0BZBgPSBO3QfrtAydZMVxYvDaGhvMCke
VHMAQ8U6AYlC+bnUn/qabIxxwCbPPUvPmZZgS/KIUZg61t7W6WQgiRlC/BSekEfG
QvbXkA8xOake31V027NEon/Wy+9JD+eUIc9VV7TVr49Q+LtZLO/9c5VZ6gyLSGce
Ga1J6PThV/M=
=80pE
-----END PGP SIGNATURE-----

--Sig_/yYDLjjkfXcRaK8C+A.NOQsy--
