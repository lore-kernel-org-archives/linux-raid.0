From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 4/8] raid5: reduce chance release_stripe() taking
 device_lock
Date: Thu, 7 Jun 2012 10:50:01 +1000
Message-ID: <20120607105001.61556ca0@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080321.874560112@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SMHZK2qA=DI7IHL6EZnYoO0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080321.874560112@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/SMHZK2qA=DI7IHL6EZnYoO0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 16:01:56 +0800 Shaohua Li <shli@kernel.org> wrote:

> release_stripe() is a place conf->device_lock is heavily contended. We ta=
ke the
> lock even stripe count isn't 1, which isn't required. On the on the other=
 hand,
> decreasing count first and taking lock if count is 0 can expose races:
> 1. bewteen dec count and taking lock, another thread hits the stripe in c=
ache,
> so increase count. The stripe will be deleted from any list. In this case
> stripe count isn't 0.
> 2. between dec count and taking lock, another thread hits the stripe in c=
ache
> and release it. In this case the stripe is already in specific list. We do
> list_move to adjust its position.
> So both cases are fixable to me.

1/ Please keep this as two different entry points, one which is called with
   the lock held, which which already holds the lock.  i.e. don't add a
   'locking' flag.

2/ Use "atomic_dec_and_lock" to avoid taking the lock when not needed.

So one entry point does:
  if atomic_dec_and_lock
      common code
      unlock
while the other does
  if atomic_test_and lock
      common code

Thanks,
NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-01 13:50:56.336138112 +0800
> +++ linux/drivers/md/raid5.c	2012-06-01 14:03:17.062826938 +0800
> @@ -201,20 +201,39 @@ static int stripe_operations_active(stru
>  	       test_bit(STRIPE_COMPUTE_RUN, &sh->state);
>  }
> =20
> -static void __release_stripe(struct r5conf *conf, struct stripe_head *sh)
> +static void __release_stripe(struct r5conf *conf, struct stripe_head *sh,
> +	int locking)
>  {
> +	unsigned long uninitialized_var(flags);
> +
>  	if (atomic_dec_and_test(&sh->count)) {
> -		BUG_ON(!list_empty(&sh->lru));
> +		/*
> +		 * Before we hold device_lock, other thread can hit this stripe
> +		 * in cache. It could do:
> +		 * 1. just get_active_stripe(). The stripe count isn't 0 then.
> +		 * 2. do get_active_stripe() and follow release_stripe(). So the
> +		 * stripe might be already released and already in specific
> +		 * list. we do list_move to adjust its position in the list.
> +		 */
> +		if (locking) {
> +			spin_lock_irqsave(&conf->device_lock, flags);
> +			if (atomic_read(&sh->count) !=3D 0) {
> +				spin_unlock_irqrestore(&conf->device_lock,
> +							flags);
> +				return;
> +			}
> +		}
> +
>  		BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
>  		if (test_bit(STRIPE_HANDLE, &sh->state)) {
>  			if (test_bit(STRIPE_DELAYED, &sh->state))
> -				list_add_tail(&sh->lru, &conf->delayed_list);
> +				list_move_tail(&sh->lru, &conf->delayed_list);
>  			else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>  				   sh->bm_seq - conf->seq_write > 0)
> -				list_add_tail(&sh->lru, &conf->bitmap_list);
> +				list_move_tail(&sh->lru, &conf->bitmap_list);
>  			else {
>  				clear_bit(STRIPE_BIT_DELAY, &sh->state);
> -				list_add_tail(&sh->lru, &conf->handle_list);
> +				list_move_tail(&sh->lru, &conf->handle_list);
>  			}
>  			md_wakeup_thread(conf->mddev->thread);
>  		} else {
> @@ -225,23 +244,22 @@ static void __release_stripe(struct r5co
>  					md_wakeup_thread(conf->mddev->thread);
>  			atomic_dec(&conf->active_stripes);
>  			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
> -				list_add_tail(&sh->lru, &conf->inactive_list);
> +				list_move_tail(&sh->lru, &conf->inactive_list);
>  				wake_up(&conf->wait_for_stripe);
>  				if (conf->retry_read_aligned)
>  					md_wakeup_thread(conf->mddev->thread);
>  			}
>  		}
> +		if (locking)
> +			spin_unlock_irqrestore(&conf->device_lock, flags);
>  	}
>  }
> =20
>  static void release_stripe(struct stripe_head *sh)
>  {
>  	struct r5conf *conf =3D sh->raid_conf;
> -	unsigned long flags;
> =20
> -	spin_lock_irqsave(&conf->device_lock, flags);
> -	__release_stripe(conf, sh);
> -	spin_unlock_irqrestore(&conf->device_lock, flags);
> +	__release_stripe(conf, sh, 1);
>  }
> =20
>  static inline void remove_hash(struct stripe_head *sh)
> @@ -484,9 +502,6 @@ get_active_stripe(struct r5conf *conf, s
>  			} else {
>  				if (!test_bit(STRIPE_HANDLE, &sh->state))
>  					atomic_inc(&conf->active_stripes);
> -				if (list_empty(&sh->lru) &&
> -				    !test_bit(STRIPE_EXPANDING, &sh->state))
> -					BUG();
>  				list_del_init(&sh->lru);
>  			}
>  		}
> @@ -3672,7 +3687,7 @@ static void activate_bit_delay(struct r5
>  		struct stripe_head *sh =3D list_entry(head.next, struct stripe_head, l=
ru);
>  		list_del_init(&sh->lru);
>  		atomic_inc(&sh->count);
> -		__release_stripe(conf, sh);
> +		__release_stripe(conf, sh, 0);
>  	}
>  }
> =20


--Sig_/SMHZK2qA=DI7IHL6EZnYoO0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8/6uTnsnt1WYoG5AQJ//hAAqpsjRyD2LISgwUMOndczoNE4CNNp/2sR
sU9L+BWnVf60Si/MB1fReIAABZuFHlD1jitesVSzGwZwH59bULMUBBOkPe1WNHko
XKaMTFt2+IqK1YvXUVpRTywOVALKI6+r9/3xcmcgMy9+47VyKc10LJ+clRlTPm+s
BTULJ9W32wBg/8cPG2ndoUCi6mmp9S+NOiwR6oIgdvFIhZ/Ha41BjS8zni4GXg25
Yc9bxrNP7J48JyYvogue/38OM0Ug0W91efNfgXqGrJo1BhzdFmO830eVBG2kzeEx
xy2R4659G3Nx6OwGjrCblOzDIAoPhnLl84Psy5dFODmH1X4SUr5FZoGbYLlzfFFA
tbztfHYxx7LU70kopNxalo3X9WK/Hv9H/eYFJBv/JeLyWR9cPzBlgNp+i3PkQ3TX
JTAQsCphgYIB7gG+Nhb6OKAmeILmkAqI1TmNLc7wsXcJYUxslbuTK6JeA/+IjwZf
AlC6wCbB84RT8iMzO4Yqj7KNNvV/c3ii8Qaf3Ihaocg5FvbheOu4d5MXEMw1cFCV
rSFAgqJXxN3Nr22Sgmyw3j+dCtiush2mW0iI6xuSh4D6aX/yxm/BQyvsX9bGpCb4
hcNTk2VIYVQyQZ9+FCaSOOi4/Gx2G41P3AiRNlp38XGP/w+YcUjRuzg3El5RE7RP
bEPFiVZsj2c=
=qjBL
-----END PGP SIGNATURE-----

--Sig_/SMHZK2qA=DI7IHL6EZnYoO0--
