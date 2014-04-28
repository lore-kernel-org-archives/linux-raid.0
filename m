From: NeilBrown <neilb@suse.de>
Subject: Re: [RFC]raid5: add an option to avoid copy data from bio to stripe
 cache
Date: Mon, 28 Apr 2014 17:06:28 +1000
Message-ID: <20140428170628.5587b6a1@notabene.brown>
References: <20140428065841.GA28726@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P1BpAZYeRO5dhkr=o65N7fE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140428065841.GA28726@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/P1BpAZYeRO5dhkr=o65N7fE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Apr 2014 14:58:41 +0800 Shaohua Li <shli@kernel.org> wrote:

>=20
> The stripe cache has two goals:
> 1. cache data, so next time if data can be found in stripe cache, disk ac=
cess
> can be avoided.
> 2. stable data. data is copied from bio to stripe cache and calculated pa=
rity.
> data written to disk is from stripe cache, so if upper layer changes bio =
data,
> data written to disk isn't impacted.
>=20
> In my environment, I can guarantee 2 will not happen. For 1, it's not com=
mon
> too. block plug mechanism will dispatch a bunch of sequentail small reque=
sts
> together. And since I'm using SSD, I'm using small chunk size. It's rare =
case
> stripe cache is really useful.
>=20
> So I'd like to avoid the copy from bio to stripe cache and it's very help=
ful
> for performance. In my 1M randwrite tests, avoid the copy can increase the
> performance more than 30%.
>=20
> Of course, this shouldn't be enabled by default, so I added an option to
> control it.

I'm happy to avoid copying when we know that we can.

I'm not really happy about using a sysfs attribute to control it.

How do you guarantee that '2' won't happen?

BTW I don't see '1' as important.  The stripe cache is really for gathering
writes together to increase the chance of full-stripe writes, and for
handling synchronisation between IO and resync/reshape/etc. The copying is
primarily for stability.

Thanks,

NeilBrown


>=20
> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/raid5.c |   92 +++++++++++++++++++++++++++++++++++++++++++++-=
-------
>  drivers/md/raid5.h |    4 +-
>  2 files changed, 82 insertions(+), 14 deletions(-)
>=20
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c	2014-04-28 14:02:18.025349590 +0800
> +++ linux/drivers/md/raid5.c	2014-04-28 14:02:18.009349792 +0800
> @@ -479,6 +479,7 @@ static void shrink_buffers(struct stripe
>  	int num =3D sh->raid_conf->pool_size;
> =20
>  	for (i =3D 0; i < num ; i++) {
> +		BUG_ON(sh->dev[i].page !=3D sh->dev[i].orig_page);
>  		p =3D sh->dev[i].page;
>  		if (!p)
>  			continue;
> @@ -499,6 +500,7 @@ static int grow_buffers(struct stripe_he
>  			return 1;
>  		}
>  		sh->dev[i].page =3D page;
> +		sh->dev[i].orig_page =3D page;
>  	}
>  	return 0;
>  }
> @@ -855,6 +857,9 @@ static void ops_run_io(struct stripe_hea
>  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
>  				bi->bi_rw |=3D REQ_NOMERGE;
> =20
> +			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
> +				BUG_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
> +			sh->dev[i].vec.bv_page =3D sh->dev[i].page;
>  			bi->bi_vcnt =3D 1;
>  			bi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
>  			bi->bi_io_vec[0].bv_offset =3D 0;
> @@ -899,6 +904,9 @@ static void ops_run_io(struct stripe_hea
>  			else
>  				rbi->bi_iter.bi_sector =3D (sh->sector
>  						  + rrdev->data_offset);
> +			if (test_bit(R5_SkipCopy, &sh->dev[i].flags))
> +				BUG_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
> +			sh->dev[i].rvec.bv_page =3D sh->dev[i].page;
>  			rbi->bi_vcnt =3D 1;
>  			rbi->bi_io_vec[0].bv_len =3D STRIPE_SIZE;
>  			rbi->bi_io_vec[0].bv_offset =3D 0;
> @@ -927,8 +935,9 @@ static void ops_run_io(struct stripe_hea
>  }
> =20
>  static struct dma_async_tx_descriptor *
> -async_copy_data(int frombio, struct bio *bio, struct page *page,
> -	sector_t sector, struct dma_async_tx_descriptor *tx)
> +async_copy_data(int frombio, struct bio *bio, struct page **page,
> +	sector_t sector, struct dma_async_tx_descriptor *tx,
> +	struct stripe_head *sh)
>  {
>  	struct bio_vec bvl;
>  	struct bvec_iter iter;
> @@ -965,11 +974,16 @@ async_copy_data(int frombio, struct bio
>  		if (clen > 0) {
>  			b_offset +=3D bvl.bv_offset;
>  			bio_page =3D bvl.bv_page;
> -			if (frombio)
> -				tx =3D async_memcpy(page, bio_page, page_offset,
> +			if (frombio) {
> +				if (sh->raid_conf->skip_copy &&
> +				    b_offset =3D=3D 0 && page_offset =3D=3D 0 &&
> +				    clen =3D=3D STRIPE_SIZE)
> +					*page =3D bio_page;
> +				else
> +					tx =3D async_memcpy(*page, bio_page, page_offset,
>  						  b_offset, clen, &submit);
> -			else
> -				tx =3D async_memcpy(bio_page, page, b_offset,
> +			} else
> +				tx =3D async_memcpy(bio_page, *page, b_offset,
>  						  page_offset, clen, &submit);
>  		}
>  		/* chain the operations */
> @@ -1045,8 +1059,8 @@ static void ops_run_biofill(struct strip
>  			spin_unlock_irq(&sh->stripe_lock);
>  			while (rbi && rbi->bi_iter.bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
> -				tx =3D async_copy_data(0, rbi, dev->page,
> -					dev->sector, tx);
> +				tx =3D async_copy_data(0, rbi, &dev->page,
> +					dev->sector, tx, sh);
>  				rbi =3D r5_next_bio(rbi, dev->sector);
>  			}
>  		}
> @@ -1384,6 +1398,7 @@ ops_run_biodrain(struct stripe_head *sh,
>  			BUG_ON(dev->written);
>  			wbi =3D dev->written =3D chosen;
>  			spin_unlock_irq(&sh->stripe_lock);
> +			BUG_ON(dev->page !=3D dev->orig_page);
> =20
>  			while (wbi && wbi->bi_iter.bi_sector <
>  				dev->sector + STRIPE_SECTORS) {
> @@ -1393,9 +1408,15 @@ ops_run_biodrain(struct stripe_head *sh,
>  					set_bit(R5_SyncIO, &dev->flags);
>  				if (wbi->bi_rw & REQ_DISCARD)
>  					set_bit(R5_Discard, &dev->flags);
> -				else
> -					tx =3D async_copy_data(1, wbi, dev->page,
> -						dev->sector, tx);
> +				else {
> +					tx =3D async_copy_data(1, wbi, &dev->page,
> +						dev->sector, tx, sh);
> +					if (dev->page !=3D dev->orig_page) {
> +						set_bit(R5_SkipCopy, &dev->flags);
> +						clear_bit(R5_UPTODATE, &dev->flags);
> +						clear_bit(R5_OVERWRITE, &dev->flags);
> +					}
> +				}
>  				wbi =3D r5_next_bio(wbi, dev->sector);
>  			}
>  		}
> @@ -1426,7 +1447,7 @@ static void ops_complete_reconstruct(voi
>  		struct r5dev *dev =3D &sh->dev[i];
> =20
>  		if (dev->written || i =3D=3D pd_idx || i =3D=3D qd_idx) {
> -			if (!discard)
> +			if (!discard && !test_bit(R5_SkipCopy, &dev->flags))
>  				set_bit(R5_UPTODATE, &dev->flags);
>  			if (fua)
>  				set_bit(R5_WantFUA, &dev->flags);
> @@ -2750,6 +2771,11 @@ handle_failed_stripe(struct r5conf *conf
>  		/* and fail all 'written' */
>  		bi =3D sh->dev[i].written;
>  		sh->dev[i].written =3D NULL;
> +		if (test_and_clear_bit(R5_SkipCopy, &sh->dev[i].flags)) {
> +			BUG_ON(test_bit(R5_UPTODATE, &sh->dev[i].flags));
> +			sh->dev[i].page =3D sh->dev[i].orig_page;
> +		}
> +
>  		if (bi) bitmap_end =3D 1;
>  		while (bi && bi->bi_iter.bi_sector <
>  		       sh->dev[i].sector + STRIPE_SECTORS) {
> @@ -2991,12 +3017,17 @@ static void handle_stripe_clean_event(st
>  			dev =3D &sh->dev[i];
>  			if (!test_bit(R5_LOCKED, &dev->flags) &&
>  			    (test_bit(R5_UPTODATE, &dev->flags) ||
> -			     test_bit(R5_Discard, &dev->flags))) {
> +			     test_bit(R5_Discard, &dev->flags) ||
> +			     test_bit(R5_SkipCopy, &dev->flags))) {
>  				/* We can return any write requests */
>  				struct bio *wbi, *wbi2;
>  				pr_debug("Return write for disc %d\n", i);
>  				if (test_and_clear_bit(R5_Discard, &dev->flags))
>  					clear_bit(R5_UPTODATE, &dev->flags);
> +				if (test_and_clear_bit(R5_SkipCopy, &dev->flags)) {
> +					BUG_ON(test_bit(R5_UPTODATE, &dev->flags));
> +					dev->page =3D dev->orig_page;
> +				}
>  				wbi =3D dev->written;
>  				dev->written =3D NULL;
>  				while (wbi && wbi->bi_iter.bi_sector <
> @@ -3015,6 +3046,8 @@ static void handle_stripe_clean_event(st
>  						0);
>  			} else if (test_bit(R5_Discard, &dev->flags))
>  				discard_pending =3D 1;
> +			BUG_ON(test_bit(R5_SkipCopy, &dev->flags));
> +			BUG_ON(dev->page !=3D dev->orig_page);
>  		}
>  	if (!discard_pending &&
>  	    test_bit(R5_Discard, &sh->dev[sh->pd_idx].flags)) {
> @@ -5355,6 +5388,38 @@ raid5_preread_bypass_threshold =3D __ATTR(
>  					raid5_store_preread_threshold);
> =20
>  static ssize_t
> +raid5_show_skip_copy(struct mddev *mddev, char *page)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	if (conf)
> +		return sprintf(page, "%d\n", conf->skip_copy);
> +	else
> +		return 0;
> +}
> +
> +static ssize_t
> +raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
> +{
> +	struct r5conf *conf =3D mddev->private;
> +	unsigned long new;
> +	if (len >=3D PAGE_SIZE)
> +		return -EINVAL;
> +	if (!conf)
> +		return -ENODEV;
> +
> +	if (kstrtoul(page, 10, &new))
> +		return -EINVAL;
> +	conf->skip_copy =3D new;
> +	return len;
> +}
> +
> +static struct md_sysfs_entry
> +raid5_skip_copy =3D __ATTR(skip_copy, S_IRUGO | S_IWUSR,
> +					raid5_show_skip_copy,
> +					raid5_store_skip_copy);
> +
> +
> +static ssize_t
>  stripe_cache_active_show(struct mddev *mddev, char *page)
>  {
>  	struct r5conf *conf =3D mddev->private;
> @@ -5439,6 +5504,7 @@ static struct attribute *raid5_attrs[] =3D
>  	&raid5_stripecache_active.attr,
>  	&raid5_preread_bypass_threshold.attr,
>  	&raid5_group_thread_cnt.attr,
> +	&raid5_skip_copy.attr,
>  	NULL,
>  };
>  static struct attribute_group raid5_attrs_group =3D {
> Index: linux/drivers/md/raid5.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.h	2014-04-28 14:02:18.025349590 +0800
> +++ linux/drivers/md/raid5.h	2014-04-28 14:02:18.009349792 +0800
> @@ -232,7 +232,7 @@ struct stripe_head {
>  		 */
>  		struct bio	req, rreq;
>  		struct bio_vec	vec, rvec;
> -		struct page	*page;
> +		struct page	*page, *orig_page;
>  		struct bio	*toread, *read, *towrite, *written;
>  		sector_t	sector;			/* sector of this page */
>  		unsigned long	flags;
> @@ -299,6 +299,7 @@ enum r5dev_flags {
>  			 * data in, and now is a good time to write it out.
>  			 */
>  	R5_Discard,	/* Discard the stripe */
> +	R5_SkipCopy,	/* Don't copy data from bio to stripe cache */
>  };
> =20
>  /*
> @@ -436,6 +437,7 @@ struct r5conf {
>  	atomic_t		pending_full_writes; /* full write backlog */
>  	int			bypass_count; /* bypassed prereads */
>  	int			bypass_threshold; /* preread nice */
> +	int			skip_copy; /* Don't copy data from bio to stripe cache */
>  	struct list_head	*last_hold; /* detect hold_list promotions */
> =20
>  	atomic_t		reshape_stripes; /* stripes with pending writes for reshape */


--Sig_/P1BpAZYeRO5dhkr=o65N7fE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1399Dnsnt1WYoG5AQLIBw//YHg2FYD6tQVpF0FgT9EHW0prWLw7fBT7
NUkv+HK4ewiF+1LOTn7pKaDzT7JC6ohOEAQlU6CfP8rN3m/IrBmaDstdGb9c6nPa
+eoDFjlVccP9Lv0etW06/emSNEGBgf9oVRIjsyiq2EUr6YI6VsW6/n8CqKxpnl2a
V95RY//koqDPmp8QzaeOQEPyOTqmSzufmvzCSQK4I+EatyqNKw67ohRCbLn5s4xs
ljxJeSIV5t72hffgBwIPwFGphaAubLYVPDNQMXBQtEPKQDgwMKLR7CU6vTmpwwJP
lmg/irol8JmAYyJJe/wHCQhIg2+oZXzKUD2FPplZjNOYGVlAJUTKFmcyGHEw6wnM
gSX173VjiWN+LbZJ3GLBB+hXGIC0qJ1QR1Rl/REur0WvD62inB/PX1SGc/dE3TpL
Ugyk9dyNG8UJmTnmKpx28VhwLlc2BCmaCcZ3PgVGjzJBpl4HmWM8trFL3vtu2Amx
yTBrLW/D0AGAlj+KcSqFRFXv8qLbfor1dVbZSTD2WrDmNiqfIMH6cE6GSYVymTnE
+UIJweY/i/co6g/A0W1S5KGPQaeh9wjYGl6m5XpTiX4wFN60prJnpO5EiuBxfVyU
RZ9eM7fo3FOdgeYM69jwHV7KxucjlToUjJ+L01r+hIE2xxctB4Fs0xh0gd/91m/d
CF090gYVko8=
=4Gwl
-----END PGP SIGNATURE-----

--Sig_/P1BpAZYeRO5dhkr=o65N7fE--
