From: NeilBrown <neilb@suse.de>
Subject: Re: [patch 1/8] raid5: add a per-stripe lock
Date: Thu, 7 Jun 2012 10:54:10 +1000
Message-ID: <20120607105410.415d9fe6@notabene.brown>
References: <20120604080152.098975870@kernel.org>
	<20120604080300.519377228@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/d6QZL2sANDQT_u/avVBSJTh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120604080300.519377228@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

--Sig_/d6QZL2sANDQT_u/avVBSJTh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 04 Jun 2012 16:01:53 +0800 Shaohua Li <shli@kernel.org> wrote:

> Add a per-stripe lock to protect stripe specific data, like dev->read,
> written, ... The purpose is to reduce lock contention of conf->device_loc=
k.

I'm not convinced that you need to add a lock.
I am convinced that if you do add one you need to explain exactly what it is
protecting.

The STRIPE_ACTIVE bit serves as a lock and ensures that only one process can
be in handle_stripe at a time.
So I don't think dev->read actually needs any protection (though I haven't
checked thoroughly).

I think the only things that device_lock protects are things shared by
multiple stripes, so adding a per-stripe spinlock isn't going to help remove
device_lock.

Thanks,
NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   17 +++++++++++++++++
>  drivers/md/raid5.h |    1 +
>  2 files changed, 18 insertions(+)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2012-06-01 13:38:54.705210229 +0800
> +++ linux/drivers/md/raid5.c	2012-06-01 13:43:05.594056130 +0800
> @@ -749,6 +749,7 @@ static void ops_complete_biofill(void *s
> =20
>  	/* clear completed biofills */
>  	spin_lock_irq(&conf->device_lock);
> +	spin_lock_irq(&sh->stripe_lock);
>  	for (i =3D sh->disks; i--; ) {
>  		struct r5dev *dev =3D &sh->dev[i];
> =20
> @@ -774,6 +775,7 @@ static void ops_complete_biofill(void *s
>  			}
>  		}
>  	}
> +	spin_unlock_irq(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
>  	clear_bit(STRIPE_BIOFILL_RUN, &sh->state);
> =20
> @@ -798,8 +800,10 @@ static void ops_run_biofill(struct strip
>  		if (test_bit(R5_Wantfill, &dev->flags)) {
>  			struct bio *rbi;
>  			spin_lock_irq(&conf->device_lock);
> +			spin_lock_irq(&sh->stripe_lock);
>  			dev->read =3D rbi =3D dev->toread;
>  			dev->toread =3D NULL;
> +			spin_unlock_irq(&sh->stripe_lock);
>  			spin_unlock_irq(&conf->device_lock);
>  			while (rbi && rbi->bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
> @@ -1137,10 +1141,12 @@ ops_run_biodrain(struct stripe_head *sh,
>  			struct bio *wbi;
> =20
>  			spin_lock_irq(&sh->raid_conf->device_lock);
> +			spin_lock_irq(&sh->stripe_lock);
>  			chosen =3D dev->towrite;
>  			dev->towrite =3D NULL;
>  			BUG_ON(dev->written);
>  			wbi =3D dev->written =3D chosen;
> +			spin_unlock_irq(&sh->stripe_lock);
>  			spin_unlock_irq(&sh->raid_conf->device_lock);
> =20
>  			while (wbi && wbi->bi_sector <
> @@ -1446,6 +1452,8 @@ static int grow_one_stripe(struct r5conf
>  	init_waitqueue_head(&sh->ops.wait_for_ops);
>  	#endif
> =20
> +	spin_lock_init(&sh->stripe_lock);
> +
>  	if (grow_buffers(sh)) {
>  		shrink_buffers(sh);
>  		kmem_cache_free(conf->slab_cache, sh);
> @@ -2327,6 +2335,7 @@ static int add_stripe_bio(struct stripe_
> =20
> =20
>  	spin_lock_irq(&conf->device_lock);
> +	spin_lock_irq(&sh->stripe_lock);
>  	if (forwrite) {
>  		bip =3D &sh->dev[dd_idx].towrite;
>  		if (*bip =3D=3D NULL && sh->dev[dd_idx].written =3D=3D NULL)
> @@ -2360,6 +2369,7 @@ static int add_stripe_bio(struct stripe_
>  		if (sector >=3D sh->dev[dd_idx].sector + STRIPE_SECTORS)
>  			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
>  	}
> +	spin_unlock_irq(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
> =20
>  	pr_debug("added bi b#%llu to stripe s#%llu, disk %d.\n",
> @@ -2376,6 +2386,7 @@ static int add_stripe_bio(struct stripe_
> =20
>   overlap:
>  	set_bit(R5_Overlap, &sh->dev[dd_idx].flags);
> +	spin_unlock_irq(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
>  	return 0;
>  }
> @@ -2427,6 +2438,7 @@ handle_failed_stripe(struct r5conf *conf
>  			}
>  		}
>  		spin_lock_irq(&conf->device_lock);
> +		spin_lock_irq(&sh->stripe_lock);
>  		/* fail all writes first */
>  		bi =3D sh->dev[i].towrite;
>  		sh->dev[i].towrite =3D NULL;
> @@ -2488,6 +2500,7 @@ handle_failed_stripe(struct r5conf *conf
>  				bi =3D nextbi;
>  			}
>  		}
> +		spin_unlock_irq(&sh->stripe_lock);
>  		spin_unlock_irq(&conf->device_lock);
>  		if (bitmap_end)
>  			bitmap_endwrite(conf->mddev->bitmap, sh->sector,
> @@ -2695,6 +2708,7 @@ static void handle_stripe_clean_event(st
>  				int bitmap_end =3D 0;
>  				pr_debug("Return write for disc %d\n", i);
>  				spin_lock_irq(&conf->device_lock);
> +				spin_lock_irq(&sh->stripe_lock);
>  				wbi =3D dev->written;
>  				dev->written =3D NULL;
>  				while (wbi && wbi->bi_sector <
> @@ -2709,6 +2723,7 @@ static void handle_stripe_clean_event(st
>  				}
>  				if (dev->towrite =3D=3D NULL)
>  					bitmap_end =3D 1;
> +				spin_unlock_irq(&sh->stripe_lock);
>  				spin_unlock_irq(&conf->device_lock);
>  				if (bitmap_end)
>  					bitmap_endwrite(conf->mddev->bitmap,
> @@ -3168,6 +3183,7 @@ static void analyse_stripe(struct stripe
>  	/* Now to look around and see what can be done */
>  	rcu_read_lock();
>  	spin_lock_irq(&conf->device_lock);
> +	spin_lock_irq(&sh->stripe_lock);
>  	for (i=3Ddisks; i--; ) {
>  		struct md_rdev *rdev;
>  		sector_t first_bad;
> @@ -3313,6 +3329,7 @@ static void analyse_stripe(struct stripe
>  				do_recovery =3D 1;
>  		}
>  	}
> +	spin_unlock_irq(&sh->stripe_lock);
>  	spin_unlock_irq(&conf->device_lock);
>  	if (test_bit(STRIPE_SYNCING, &sh->state)) {
>  		/* If there is a failed device being replaced,
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2012-06-01 13:38:54.717210079 +0800
> +++ linux/drivers/md/raid5.h	2012-06-01 13:44:19.229127709 +0800
> @@ -210,6 +210,7 @@ struct stripe_head {
>  	int			disks;		/* disks in stripe */
>  	enum check_states	check_state;
>  	enum reconstruct_states reconstruct_state;
> +	spinlock_t		stripe_lock;
>  	/**
>  	 * struct stripe_operations
>  	 * @target - STRIPE_OP_COMPUTE_BLK target


--Sig_/d6QZL2sANDQT_u/avVBSJTh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT8/7sjnsnt1WYoG5AQIGxhAAtgVU6JDZ3jd5GkOik98y/WFLaBYq+ohr
eoLVUjKpQPzu8ISz2lPXbQUtHwX9wvxlr0KK798Y1jptf/cPUYfZW6F1OC/sgxU4
Q0mpjVQyWHmaZjAP27qfmh2UceRUR2NtkA90glODzegef6z+pYXMH+qQVqcCZ+4D
yKir4VSHuwasjLdlA+xVFtOChvKP20Q/Bh0WJNbs3yrSI0+aTTXmkB/qZYcMjwIm
fPNWBi5+AXxg4RhCK4NwpFWpBFvmfmLUIGB3v41t5Qvub0NdkVz5WYKUS/znakj9
CDx2DvGSAfJwFwSdniz34SCI7USrEnU35KqHTETdc+LovfoZ5c+NyZYPF3WvEjra
q/Q0JDHXNDM8cNXnPERP6C+c03kL4YbLalaTTnSQqDZqJcvH+VpDwTwCInIGeQYz
JczHWKsQ/Oqq/SD+VggcNNIsmbtKXCWmn5WImytzOJPM4uzZn1nI7dCO/ehzFAy8
cMGZlUAoe/kcs0hS5d5xFmk5o2qJh7kvyMajDXpdyzMGhl5uddIuwyxeZ8hTtLPU
Kx8zcyvJWUfTstw3+/16pIs8p77xgkWeUVeEPlV1zTrqQPcDaHDzb4NyfU75NmTG
QD1ckHy9w47Lzhj5C1apcc616bltz9WrgtQh1ZopTCXRTUSd2oxI0z394SkQYqL7
n+5CMTgDj1o=
=IEqA
-----END PGP SIGNATURE-----

--Sig_/d6QZL2sANDQT_u/avVBSJTh--
