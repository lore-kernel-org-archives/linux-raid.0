From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 03/10 v3] raid5: add a per-stripe lock
Date: Mon, 2 Jul 2012 10:50:46 +1000
Message-ID: <20120702105046.56cd47ec@notabene.brown>
References: <20120625072447.268095276@kernel.org>
	<20120625072613.620625574@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Pf7j97__r.pkJCpp24F507m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120625072613.620625574@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/Pf7j97__r.pkJCpp24F507m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2012 15:24:50 +0800 Shaohua Li <shli@kernel.org> wrote:

> Add a per-stripe lock to protect stripe specific data, like dev->read,
> written, ... The purpose is to reduce lock contention of conf->device_loc=
k.
>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>

I had hoped to avoid having a per-stripe lock again, but it does look like =
it
is needed.
However I don't like the way you have split up these three patches - it mak=
es
them a little hard to review.

I would like to see one patch which converts the bi_phys_segments access to
be atomic and also removes all the spin_lock calls that were just for
protecting that.

Then another patch which adds the new stripe_lock, clearly documenting
exactly what is protects (not just "like dev->read" but an explicit list)
and also removes any spin_lock of device_lock that is no longer needed.

Then I could see what is being added and what is being removed all in the o=
ne
patch and I can be sure that they balance.

Thanks,
NeilBrown


> ---
>  drivers/md/raid5.c |   17 +++++++++++++++++
>  drivers/md/raid5.h |    1 +
>  2 files changed, 18 insertions(+)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-25 14:36:57.280096788 +0800
> +++ linux/drivers/md/raid5.c	2012-06-25 14:37:13.651888057 +0800
> @@ -751,6 +751,7 @@ static void ops_complete_biofill(void *s
> =20
>  	/* clear completed biofills */
>  	spin_lock_irq(&conf->device_lock);
> +	spin_lock(&sh->stripe_lock);
>  	for (i =3D sh->disks; i--; ) {
>  		struct r5dev *dev =3D &sh->dev[i];
> =20
> @@ -776,6 +777,7 @@ static void ops_complete_biofill(void *s
>  			}
>  		}
>  	}
> +	spin_unlock(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
>  	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
> =20
> @@ -800,8 +802,10 @@ static void ops_run_biofill(struct strip
>  		if (test_bit(R5_Wantfill, &dev->flags)) {
>  			struct bio *rbi;
>  			spin_lock_irq(&conf->device_lock);
> +			spin_lock(&sh->stripe_lock);
>  			dev->read =3D rbi =3D dev->toread;
>  			dev->toread =3D NULL;
> +			spin_unlock(&sh->stripe_lock);
>  			spin_unlock_irq(&conf->device_lock);
>  			while (rbi && rbi->bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
> @@ -1139,10 +1143,12 @@ ops_run_biodrain(struct stripe_head *sh,
>  			struct bio *wbi;
> =20
>  			spin_lock_irq(&sh->raid_conf->device_lock);
> +			spin_lock(&sh->stripe_lock);
>  			chosen =3D dev->towrite;
>  			dev->towrite =3D NULL;
>  			BUG_ON(dev->written);
>  			wbi =3D dev->written =3D chosen;
> +			spin_unlock(&sh->stripe_lock);
>  			spin_unlock_irq(&sh->raid_conf->device_lock);
> =20
>  			while (wbi && wbi->bi_sector <
> @@ -1448,6 +1454,8 @@ static int grow_one_stripe(struct r5conf
>  	init_waitqueue_head(&sh->ops.wait_for_ops);
>  	#endif
> =20
> +	spin_lock_init(&sh->stripe_lock);
> +
>  	if (grow_buffers(sh)) {
>  		shrink_buffers(sh);
>  		kmem_cache_free(conf->slab_cache, sh);
> @@ -2329,6 +2337,7 @@ static int add_stripe_bio(struct stripe_
> =20
> =20
>  	spin_lock_irq(&conf->device_lock);
> +	spin_lock(&sh->stripe_lock);
>  	if (forwrite) {
>  		bip =3D &sh->dev[dd_idx].towrite;
>  		if (*bip =3D=3D NULL && sh->dev[dd_idx].written =3D=3D NULL)
> @@ -2362,6 +2371,7 @@ static int add_stripe_bio(struct stripe_
>  		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS)
>  			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
>  	}
> +	spin_unlock(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
> =20
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> @@ -2378,6 +2388,7 @@ static int add_stripe_bio(struct stripe_
> =20
>   overlap:
>  	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
> +	spin_unlock(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
>  	return 0;
>  }
> @@ -2429,6 +2440,7 @@ handle_failed_stripe(struct r5conf *conf
>  			}
>  		}
>  		spin_lock_irq(&conf->device_lock);
> +		spin_lock(&sh->stripe_lock);
>  		/* fail all writes first */
>  		bi =3D sh->dev[i].towrite;
>  		sh->dev[i].towrite =3D NULL;
> @@ -2490,6 +2502,7 @@ handle_failed_stripe(struct r5conf *conf
>  				bi =3D nextbi;
>  			}
>  		}
> +		spin_unlock(&sh->stripe_lock);
>  		spin_unlock_irq(&conf->device_lock);
>  		if (bitmap_end)
>  			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> @@ -2697,6 +2710,7 @@ static void handle_stripe_clean_event(st
>  				int bitmap_end =3D 0;
>  				pr_debug("Return write for disc %d\n", i);
>  				spin_lock_irq(&conf->device_lock);
> +				spin_lock(&sh->stripe_lock);
>  				wbi =3D dev->written;
>  				dev->written =3D NULL;
>  				while (wbi && wbi->bi_sector <
> @@ -2711,6 +2725,7 @@ static void handle_stripe_clean_event(st
>  				}
>  				if (dev->towrite =3D=3D NULL)
>  					bitmap_end =3D 1;
> +				spin_unlock(&sh->stripe_lock);
>  				spin_unlock_irq(&conf->device_lock);
>  				if (bitmap_end)
>  					bitmap_endwrite(conf->mddev->bitmap,
> @@ -3170,6 +3185,7 @@ static void analyse_stripe(struct stripe
>  	/* Now to look around and see what can be done */
>  	rcu_read_lock();
>  	spin_lock_irq(&conf->device_lock);
> +	spin_lock(&sh->stripe_lock);
>  	for (i=3Ddisks; i--; ) {
>  		struct md_rdev *rdev;
>  		sector_t first_bad;
> @@ -3315,6 +3331,7 @@ static void analyse_stripe(struct stripe
>  				do_recovery =3D 1;
>  		}
>  	}
> +	spin_unlock(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
>  	if (test_bit(STRIPE_SYNCING, &sh->state)) {
>  		/* If there is a failed device being replaced,
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2012-06-25 14:36:13.940638627 +0800
> +++ linux/drivers/md/raid5.h	2012-06-25 14:37:13.651888057 +0800
> @@ -210,6 +210,7 @@ struct stripe_head {
>  	int			disks;		/* disks in stripe */
>  	enum check_states	check_state;
>  	enum reconstruct_states reconstruct_state;
> +	spinlock_t		stripe_lock;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target


--Sig_/Pf7j97__r.pkJCpp24F507m
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/DwZjnsnt1WYoG5AQJ/ARAAuQtgPKGFI7mWPhTyWp1cfUwetB+ixsja
rtdyB0jgzxc4tldyHAVh1pBOtH/3sZOP92mBErelN1MXiESf6AyYWqSNqrMf2eAP
qg0n2B3cehKVn9VfYdr7ykgJcMPBfXUklq1CKa3GdU4uhO575ZjtS7acLZZ/DUQB
bXCMWM9GM5gy3PtuF9gfyXdZbit06Fw197fcIfc0j0pOSg8OTkfnQoKY43ebxvKh
hNMmRL+/cQoAnfLwAjV5vjJl5Xe+y5U/T2Q8wmnCez2KzwwcTl3Wj9J/OOu2LoT7
xxDH1+/cPGI9MLBVx6MPy2Wc/8JM6IOBOyaJbG075iwtPRhsI1eBEHOTy2+KLK4G
tCN4HzNh96IqwENRJMH/ZTG7cHfUuRF9LTWdZHq2VJTN8jfzRTgq2SPcMGxgCW5G
VviyLOTCYmKUapxscXAokNFQZE8/YCzu9ortsozb4H6GFv5pZCsqGSg6RcVtc/AW
9kV+I6wwBCUoS1j2/XrSjzTKjqdqHV4k+9nBfrKDixSTR/KDIiciVjruADSaYSxs
zKPkau1najnIfsK28+VfwlPc+dl451ZRhDKEag4H+oR5TkHqeXHSymbAGAxUvQO0
Hp4ZHZWAMBFY8GoF9dkmSqD/SxDtOe82kt/JI9QjchZEm/oiamJxVZV8nb+d+rfP
tUOuRB+P+Ng=
=klR2
-----END PGP SIGNATURE-----

--Sig_/Pf7j97__r.pkJCpp24F507m--
