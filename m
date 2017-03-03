From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] md/raid5: sort bios
Date: Fri, 03 Mar 2017 14:43:49 +1100
Message-ID: <87k287m3d6.fsf@notabene.neil.brown.name>
References: <cover.1487373517.git.shli@fb.com> <01c6067566d787a815fc29aa07b36ad4dd0280f0.1487373517.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01c6067566d787a815fc29aa07b36ad4dd0280f0.1487373517.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17 2017, Shaohua Li wrote:

> Previous patch (raid5: only dispatch IO from raid5d for harddisk raid)
> defers IO dispatching. The goal is to create better IO pattern. At that
> time, we don't sort the deffered IO and hope the block layer can do IO
> merge and sort. Now the raid5-cache writeback could create large amount
> of bios. And if we enable muti-thread for stripe handling, we can't
> control when to dispatch IO to raid disks. In a lot of time, we are
> dispatching IO which block layer can't do merge effectively.
>
> This patch moves further for the IO dispatching defer. We accumulate
> bios, but we don't dispatch all the bios after a threshold is met. This
> 'dispatch partial portion of bios' stragety allows bios coming in a
> large time window are sent to disks together. At the dispatching time,
> there is large chance the block layer can merge the bios. To make this
> more effective, we dispatch IO in ascending order. This increases
> request merge chance and reduces disk seek.

I can see the benefit of batching and sorting requests.

I wonder if the extra complexity of grouping together 512 requests, then
submitting the "first" 128 is really worth it.  Have you measured the
value of that?
If you just submitted every time you got 512 requests, you could use
list_sort() on the bio list and wouldn't need an array.

If an array really is best, it would be really nice if "sort" could pass
a 'void*' down to the cmp function, and it could sort all bios that are
*after* last_bio_pos first, and then the others.  That would make the
code much simpler.  I guess sort() could be changed (list_sort() already
has a 'priv' argument like this).

If we cannot change sort(), then maybe use lib/bsearch.c for the binary
search.  Performing two comparisons in the loop of a binary search
should get a *fail* in any algorithms class!!

The "pending_data" array that you have added to the r5conf structure
adds 4096 bytes.  This means it is larger than a page, which is best
avoided (though it is unlikely to cause problems).  I would allocate it
separately.

So there is a lot that I don't really like, but it seems like a good
idea in principle.

Thanks,
NeilBrown


>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  drivers/md/raid5.c | 141 ++++++++++++++++++++++++++++++++++++++++++++---=
------
>  drivers/md/raid5.h |  11 ++++-
>  2 files changed, 127 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d7c90da..fe6232f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -56,6 +56,7 @@
>  #include <linux/nodemask.h>
>  #include <linux/flex_array.h>
>  #include <trace/events/block.h>
> +#include <linux/sort.h>
>=20=20
>  #include "md.h"
>  #include "raid5.h"
> @@ -876,41 +877,121 @@ static int use_new_offset(struct r5conf *conf, str=
uct stripe_head *sh)
>  	return 1;
>  }
>=20=20
> -static void flush_deferred_bios(struct r5conf *conf)
> +static void dispatch_bio_list(struct bio_list *tmp)
>  {
> -	struct bio_list tmp;
>  	struct bio *bio;
>=20=20
> +	while ((bio =3D bio_list_pop(tmp)))
> +		generic_make_request(bio);
> +}
> +
> +static int cmp_sh(const void *a, const void *b)
> +{
> +	const struct r5pending_data *da =3D a;
> +	const struct r5pending_data *db =3D b;
> +
> +	if (da->sector > db->sector)
> +		return 1;
> +	if (da->sector < db->sector)
> +		return -1;
> +	return 0;
> +}
> +
> +static void dispatch_defer_bios(struct r5conf *conf, int target,
> +				struct bio_list *list)
> +{
> +	int start =3D 0;
> +	int end =3D conf->pending_data_cnt - 1;
> +	int mid;
> +	int cnt =3D 0;
> +
> +	if (conf->pending_data_cnt =3D=3D 0)
> +		return;
> +	sort(conf->pending_data, conf->pending_data_cnt,
> +		sizeof(struct r5pending_data), cmp_sh, NULL);
> +
> +	while (start <=3D end) {
> +		mid =3D (start + end) / 2;
> +		if (conf->pending_data[mid].sector > conf->last_bio_pos)
> +			end =3D mid - 1;
> +		else if (conf->pending_data[mid].sector < conf->last_bio_pos)
> +			start =3D mid + 1;
> +		else {
> +			start =3D mid;
> +			break;
> +		}
> +	}
> +
> +	end =3D conf->pending_data_cnt - 1;
> +	for (mid =3D start; mid <=3D end; mid++) {
> +		conf->last_bio_pos =3D conf->pending_data[mid].sector;
> +		bio_list_merge(list, &conf->pending_data[mid].bios);
> +
> +		cnt++;
> +		if (cnt >=3D target) {
> +			mid++;
> +			break;
> +		}
> +	}
> +	conf->pending_data_cnt -=3D cnt;
> +	BUG_ON(conf->pending_data_cnt < 0);
> +	if (mid <=3D end) {
> +		memmove(&conf->pending_data[start], &conf->pending_data[mid],
> +			(end - mid + 1) * sizeof(struct r5pending_data));
> +		return;
> +	}
> +
> +	for (mid =3D 0; mid < start; mid++) {
> +		conf->last_bio_pos =3D conf->pending_data[mid].sector;
> +		bio_list_merge(list, &conf->pending_data[mid].bios);
> +
> +		cnt++;
> +		if (cnt >=3D target) {
> +			mid++;
> +			break;
> +		}
> +	}
> +
> +	conf->pending_data_cnt -=3D mid;
> +	BUG_ON(conf->pending_data_cnt < 0);
> +	if (mid =3D=3D start) {
> +		BUG_ON(conf->pending_data_cnt);
> +		return;
> +	}
> +	memmove(&conf->pending_data[0], &conf->pending_data[mid],
> +			(start - mid) * sizeof(struct r5pending_data));
> +}
> +
> +static void flush_deferred_bios(struct r5conf *conf)
> +{
> +	struct bio_list tmp =3D BIO_EMPTY_LIST;
> +
>  	if (!conf->batch_bio_dispatch || !conf->group_cnt)
>  		return;
>=20=20
> -	bio_list_init(&tmp);
>  	spin_lock(&conf->pending_bios_lock);
> -	bio_list_merge(&tmp, &conf->pending_bios);
> -	bio_list_init(&conf->pending_bios);
> +	dispatch_defer_bios(conf, conf->pending_data_cnt, &tmp);
>  	spin_unlock(&conf->pending_bios_lock);
>=20=20
> -	while ((bio =3D bio_list_pop(&tmp)))
> -		generic_make_request(bio);
> +	dispatch_bio_list(&tmp);
>  }
>=20=20
> -static void defer_bio_issue(struct r5conf *conf, struct bio *bio)
> +static void defer_issue_bios(struct r5conf *conf, sector_t sector,
> +				struct bio_list *bios)
>  {
> -	/*
> -	 * change group_cnt will drain all bios, so this is safe
> -	 *
> -	 * A read generally means a read-modify-write, which usually means a
> -	 * randwrite, so we don't delay it
> -	 */
> -	if (!conf->batch_bio_dispatch || !conf->group_cnt ||
> -	    bio_op(bio) =3D=3D REQ_OP_READ) {
> -		generic_make_request(bio);
> -		return;
> -	}
> +	struct bio_list tmp =3D BIO_EMPTY_LIST;
> +
>  	spin_lock(&conf->pending_bios_lock);
> -	bio_list_add(&conf->pending_bios, bio);
> +	conf->pending_data[conf->pending_data_cnt].sector =3D sector;
> +	bio_list_init(&conf->pending_data[conf->pending_data_cnt].bios);
> +	bio_list_merge(&conf->pending_data[conf->pending_data_cnt].bios,
> +		bios);
> +	conf->pending_data_cnt++;
> +	if (conf->pending_data_cnt >=3D PENDING_IO_MAX)
> +		dispatch_defer_bios(conf, PENDING_IO_ONE_FLUSH, &tmp);
>  	spin_unlock(&conf->pending_bios_lock);
> -	md_wakeup_thread(conf->mddev->thread);
> +
> +	dispatch_bio_list(&tmp);
>  }
>=20=20
>  static void
> @@ -923,6 +1004,8 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  	struct r5conf *conf =3D sh->raid_conf;
>  	int i, disks =3D sh->disks;
>  	struct stripe_head *head_sh =3D sh;
> +	struct bio_list pending_bios =3D BIO_EMPTY_LIST;
> +	bool should_defer;
>=20=20
>  	might_sleep();
>=20=20
> @@ -939,6 +1022,8 @@ static void ops_run_io(struct stripe_head *sh, struc=
t stripe_head_state *s)
>  		}
>  	}
>=20=20
> +	should_defer =3D conf->batch_bio_dispatch && conf->group_cnt;
> +
>  	for (i =3D disks; i--; ) {
>  		int op, op_flags =3D 0;
>  		int replace_only =3D 0;
> @@ -1093,7 +1178,10 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
>  				trace_block_bio_remap(bdev_get_queue(bi->bi_bdev),
>  						      bi, disk_devt(conf->mddev->gendisk),
>  						      sh->dev[i].sector);
> -			defer_bio_issue(conf, bi);
> +			if (should_defer && op_is_write(op))
> +				bio_list_add(&pending_bios, bi);
> +			else
> +				generic_make_request(bi);
>  		}
>  		if (rrdev) {
>  			if (s->syncing || s->expanding || s->expanded
> @@ -1138,7 +1226,10 @@ static void ops_run_io(struct stripe_head *sh, str=
uct stripe_head_state *s)
>  				trace_block_bio_remap(bdev_get_queue(rbi->bi_bdev),
>  						      rbi, disk_devt(conf->mddev->gendisk),
>  						      sh->dev[i].sector);
> -			defer_bio_issue(conf, rbi);
> +			if (should_defer && op_is_write(op))
> +				bio_list_add(&pending_bios, rbi);
> +			else
> +				generic_make_request(rbi);
>  		}
>  		if (!rdev && !rrdev) {
>  			if (op_is_write(op))
> @@ -1156,6 +1247,9 @@ static void ops_run_io(struct stripe_head *sh, stru=
ct stripe_head_state *s)
>  		if (sh !=3D head_sh)
>  			goto again;
>  	}
> +
> +	if (should_defer && !bio_list_empty(&pending_bios))
> +		defer_issue_bios(conf, head_sh->sector, &pending_bios);
>  }
>=20=20
>  static struct dma_async_tx_descriptor *
> @@ -6808,7 +6902,6 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
>  	atomic_set(&conf->active_stripes, 0);
>  	atomic_set(&conf->preread_active_stripes, 0);
>  	atomic_set(&conf->active_aligned_reads, 0);
> -	bio_list_init(&conf->pending_bios);
>  	spin_lock_init(&conf->pending_bios_lock);
>  	conf->batch_bio_dispatch =3D true;
>  	rdev_for_each(rdev, mddev) {
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 6b9d2e8..eb6d5d5 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -572,6 +572,13 @@ enum r5_cache_state {
>  				 */
>  };
>=20=20
> +#define PENDING_IO_MAX 512
> +#define PENDING_IO_ONE_FLUSH 128
> +struct r5pending_data {
> +	sector_t sector; /* stripe sector */
> +	struct bio_list bios;
> +};
> +
>  struct r5conf {
>  	struct hlist_head	*stripe_hashtbl;
>  	/* only protect corresponding hash list and inactive_list */
> @@ -689,9 +696,11 @@ struct r5conf {
>  	int			worker_cnt_per_group;
>  	struct r5l_log		*log;
>=20=20
> -	struct bio_list		pending_bios;
>  	spinlock_t		pending_bios_lock;
>  	bool			batch_bio_dispatch;
> +	struct r5pending_data	pending_data[PENDING_IO_MAX];
> +	int			pending_data_cnt;
> +	sector_t		last_bio_pos;
>  };
>=20=20
>=20=20
> --=20
> 2.9.3

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli45nUACgkQOeye3VZi
gbk5dQ/+P2H33VDL5yhtL4GURjaVRYlHAUdlw8q/eW1oQURZad/pCQpBkB77WgeY
/m7REeVQPs4kQE6PA24k4kxTXO2lA2bhoWSGYBNtCF2TjCvsNxWBfynsy6OOOKCK
hFgn/2ED+74X4Z2HiGRoAa7KtVoLngsr4LgWf62PD6jozKVCbRRhH3pRNgxAiH5C
R3eQ3ksEtrTKVtbgwIacfc+EFQTpu6DWbRPaLyxGb1Mwy1dpG7gu6qjCn2+T37nz
xSo11D742YOk0tABp79zkLEb+bH1hmIQOOP2YNqSQioub9yYZyNV4zHa73LBMh/f
LGJmP8osx0Re+pHzCJ07uw+9qrdNlHyjNysOJAZHaXBOnU6mUjyeR4OiXIJcZnrr
M8zqJ03rBvaMgcFhk2g8K9chsb9WBE0PANIYikQzaistPFDoYX05HNhFySaDkXuQ
fcdmw6lbj2YQIqmQV8F0UsKWjkYv1xj6lREPgT9yMY1VcnlfQUCU4TQMcSU/cgI+
5P2dNmYlPmK8Rg6ZJeqfOlcml3AsHzRkFlU8pIpsVb0U/wBr6M6Jt5JrO2EbJHST
6g7aiVAgfAgEuBKl3nvYBVLl6wkpWGD5CWRDTn6cHj5pCALjoT5hVtgSD7SS7R/7
zmx/WXpRBD/+ywurzmrapLJcu7gpRVB2JmSS11axDpjD60q31ac=
=6JEA
-----END PGP SIGNATURE-----
--=-=-=--
