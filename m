Received: from va-2-39.ptr.blmpb.com (va-2-39.ptr.blmpb.com [209.127.231.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750F814A619
	for <linux-raid@vger.kernel.org>; Sun, 31 May 2026 10:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780223813; cv=none; b=HfMTJWsJpPZfflAHbe6xXQZ7hFumVPtSX1OnnuBtL70lMM+dlZgWQCRKGofvtiCJgDjfnDy/0qP17quF+VyxU1RLzh8YKeS9xc20IAFRbdDOajlKXFqjp9+B5NK5lS35Jd/u1DXfjP70UOxGSH1nkzKGgE388ONPCVv58xTJJYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780223813; c=relaxed/simple;
	bh=fu6Q088IcmHqhTBWhmQ9G1qg33Lnq3lZNd7PWrsphlw=;
	h=Cc:From:Subject:Date:In-Reply-To:References:To:Mime-Version:
	 Content-Type:Message-Id; b=GKchBrLpl8/a5U05/MCYvNj8uo8YlO8H5rWOuuZ6AgykDuCw8CcJ9gOMaZGuqgHMZtA0NmU6p1AQI7UaOth2mqQwTRcwWhbqsB902l6esxXSfCVitX59zT4nFXggZiqzHc0QQcqs1LddKOTDdNJFZKA+5PigT6JGGJhW2SfVfpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=RF2J12Hw; arc=none smtp.client-ip=209.127.231.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="RF2J12Hw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780223804;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=HZsKvIL60zRvFhKTYOUQOlkwXlkAgqpqOkH1lxVJ24U=;
 b=RF2J12HwQSuHlGjP3qF+SHtURjZcmd3i8kpxqaYSbKaQ8KhZIyJ5tICCcPnCsRxZWf7qNJ
 rlCBJkR4yAcGKMfGjFj0Uw7le4VbzPqyiTZ8KtAYRe/MYQeTD+F6QF6UbUhxtj40B9Rjte
 ELokzh0yDRY/bNbFcZFC8YWBhn8gdUKq6Er7y+2St58UNyFkYe2GvYdULLae2Rgxq3uAN1
 M843vJ8XrZI6MgJryP+iemX+WsvOEw+T+UQW1s7kVfH8BVKrFVPSELgx+2P1LVAG4JejIu
 C3vk/U3CcaNUgqjkjYEZJZuYk9kIRDJtr2sxJzWNYP985SMw/bN1P45H2SZD+A==
Cc: <linux-kernel@vger.kernel.org>
From: "Yu Kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3 1/2] md/raid10: make r10bio_pool use fixed-size objects
Date: Sun, 31 May 2026 18:36:40 +0800
In-Reply-To: <20260525015520.2565423-2-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io
References: <20260525015520.2565423-1-chencheng@fnnas.com> <20260525015520.2565423-2-chencheng@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fygo.io>
Content-Language: en-US
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.134]) by smtp.larksuite.com with ESMTPS; Sun, 31 May 2026 10:36:42 +0000
Message-Id: <9c1fdb05-dea2-4cf3-b940-179466950619@fygo.io>
X-Lms-Return-Path: <lba+26a1c0f3b+88a500+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/5/25 9:55, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> raid10 currently allocates r10bio_pool objects with conf->geo.raid_disks,
> which makes regular r10bio objects geometry-dependent.
>
> That model breaks down across reshape. mempool objects are preallocated a=
nd
> reused, so a reshape that changes the number of raid disks can leave old
> r10bio objects in the regular I/O pool with a devs[] array sized for the
> previous geometry. After the geometry switch, those stale objects may be
> reused or later freed under the new layout, creating a width mismatch
> between the reused r10bio and the current array geometry.
>
> For example, during a 4-disk to 5-disk reshape, an r10bio allocated befor=
e
> the geometry switch has room for only 4 devs[] entries. After reshape
> updates conf->geo.raid_disks to 5, that stale object can be reused under
> the new geometry. Code such as __make_request(), put_all_bios(), and
> find_bio_disk() may then access devs[] using the new geometry and step
> past the end of the old 4-slot object, leading to slab out-of-bounds
> accesses.
>
> The root problem is that regular r10bio pool objects are geometry-depende=
nt,
> while mempool elements are preallocated and reused across requests.
>
> Switch r10bio_pool to a fixed-size kmalloc mempool so regular I/O objects=
 no
> longer carry an allocation width tied to the current geometry. Use the sa=
me
> fixed-size allocation rule for the standalone r10bio allocated from
> r10buf_pool_alloc().
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 57 ++++++++++++++++++++++++++++++++++-----------
>   drivers/md/raid10.h |  2 +-
>   2 files changed, 45 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 39085e7dd6d2..64677dbe5152 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -101,17 +101,32 @@ static void end_reshape(struct r10conf *conf);
>   static inline struct r10bio *get_resync_r10bio(struct bio *bio)
>   {
>   	return get_resync_pages(bio)->raid_bio;
>   }
>  =20
> -static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
> +static inline unsigned int calc_r10bio_pool_disks(struct mddev *mddev)
>   {
> -	struct r10conf *conf =3D data;
> -	int size =3D offsetof(struct r10bio, devs[conf->geo.raid_disks]);
> +	/* If delta_disks < 0, use bigger r10bio->devs[] is ok. */
> +	return mddev->raid_disks + max(0, mddev->delta_disks);
> +}
> +
> +static inline int calc_r10bio_size(struct mddev *mddev)
> +{
> +	return offsetof(struct r10bio, devs[calc_r10bio_pool_disks(mddev)]);
> +}
> +
> +static mempool_t *create_r10bio_pool(struct mddev *mddev)
> +{
> +	int size =3D calc_r10bio_size(mddev);
> +
> +	return mempool_create_kmalloc_pool(NR_RAID_BIOS, size);
> +}
> +
> +static struct r10bio *alloc_r10bio(struct mddev *mddev, gfp_t gfp_flags)
> +{
> +	int size =3D calc_r10bio_size(mddev);
>  =20
> -	/* allocate a r10bio with room for raid_disks entries in the
> -	 * bios array */
>   	return kzalloc(size, gfp_flags);
>   }
>  =20
>   #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>   /* amount of memory to reserve for resync requests */
> @@ -135,11 +150,11 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, vo=
id *data)
>   	struct bio *bio;
>   	int j;
>   	int nalloc, nalloc_rp;
>   	struct resync_pages *rps;
>  =20
> -	r10_bio =3D r10bio_pool_alloc(gfp_flags, conf);
> +	r10_bio =3D alloc_r10bio(conf->mddev, gfp_flags);
>   	if (!r10_bio)
>   		return NULL;
>  =20
>   	if (test_bit(MD_RECOVERY_SYNC, &conf->mddev->recovery) ||
>   	    test_bit(MD_RECOVERY_RESHAPE, &conf->mddev->recovery))
> @@ -275,11 +290,11 @@ static void put_all_bios(struct r10conf *conf, stru=
ct r10bio *r10_bio)
>   static void free_r10bio(struct r10bio *r10_bio)
>   {
>   	struct r10conf *conf =3D r10_bio->mddev->private;
>  =20
>   	put_all_bios(conf, r10_bio);
> -	mempool_free(r10_bio, &conf->r10bio_pool);
> +	mempool_free(r10_bio, conf->r10bio_pool);
>   }
>  =20
>   static void put_buf(struct r10bio *r10_bio)
>   {
>   	struct r10conf *conf =3D r10_bio->mddev->private;
> @@ -1529,11 +1544,11 @@ static void raid10_write_request(struct mddev *md=
dev, struct bio *bio,
>   static void __make_request(struct mddev *mddev, struct bio *bio, int se=
ctors)
>   {
>   	struct r10conf *conf =3D mddev->private;
>   	struct r10bio *r10_bio;
>  =20
> -	r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
> +	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
>  =20
>   	r10_bio->master_bio =3D bio;
>   	r10_bio->sectors =3D sectors;
>  =20
>   	r10_bio->mddev =3D mddev;
> @@ -1721,11 +1736,11 @@ static int raid10_handle_discard(struct mddev *md=
dev, struct bio *bio)
>   		last_stripe_index *=3D geo->far_copies;
>   	end_disk_offset =3D (bio_end & geo->chunk_mask) +
>   				(last_stripe_index << geo->chunk_shift);
>  =20
>   retry_discard:
> -	r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
> +	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->state =3D 0;
>   	r10_bio->sectors =3D 0;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
>   	wait_blocked_dev(mddev, r10_bio);
> @@ -3821,11 +3836,11 @@ static int setup_geo(struct geom *geo, struct mdd=
ev *mddev, enum geo_type new)
>   static void raid10_free_conf(struct r10conf *conf)
>   {
>   	if (!conf)
>   		return;
>  =20
> -	mempool_exit(&conf->r10bio_pool);
> +	mempool_destroy(conf->r10bio_pool);
>   	kfree(conf->mirrors);
>   	kfree(conf->mirrors_old);
>   	kfree(conf->mirrors_new);
>   	safe_put_page(conf->tmppage);
>   	bioset_exit(&conf->bio_split);
> @@ -3868,13 +3883,12 @@ static struct r10conf *setup_conf(struct mddev *m=
ddev)
>   	if (!conf->tmppage)
>   		goto out;
>  =20
>   	conf->geo =3D geo;
>   	conf->copies =3D copies;
> -	err =3D mempool_init(&conf->r10bio_pool, NR_RAID_BIOS, r10bio_pool_allo=
c,
> -			   rbio_pool_free, conf);
> -	if (err)
> +	conf->r10bio_pool =3D create_r10bio_pool(mddev);
> +	if (!conf->r10bio_pool)
>   		goto out;
>  =20
>   	err =3D bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
>   	if (err)
>   		goto out;
> @@ -4363,10 +4377,11 @@ static int raid10_start_reshape(struct mddev *mdd=
ev)
>   	struct geom new;
>   	struct r10conf *conf =3D mddev->private;
>   	struct md_rdev *rdev;
>   	int spares =3D 0;
>   	int ret;
> +	mempool_t *new_pool;
>  =20
>   	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>   		return -EBUSY;
>  =20
>   	if (setup_geo(&new, mddev, geo_start) !=3D conf->copies)
> @@ -4398,11 +4413,23 @@ static int raid10_start_reshape(struct mddev *mdd=
ev)
>   		return -EINVAL;
>  =20
>   	if (spares < mddev->delta_disks)
>   		return -EINVAL;
>  =20
> +	mddev_unlock(mddev);
> +	mddev_suspend_and_lock_nointr(mddev);

This is weird, unless there is a strong reason, this is not acceptable to
unlock and then lock again.

Please check all the callers of pers->start_reshape, and if it's possible
to suspend before the lock.

>   	conf->offset_diff =3D min_offset_diff;
> +	if (mddev->delta_disks > 0) {
> +		new_pool =3D create_r10bio_pool(mddev);
> +		if (!new_pool) {
> +			mddev_unlock_and_resume(mddev);
> +			mddev_lock_nointr(mddev);
> +			return -ENOMEM;
> +		}
> +		mempool_destroy(conf->r10bio_pool);
> +		conf->r10bio_pool =3D new_pool;
> +	}
>   	spin_lock_irq(&conf->device_lock);
>   	if (conf->mirrors_new) {
>   		memcpy(conf->mirrors_new, conf->mirrors,
>   		       sizeof(struct raid10_info)*conf->prev.raid_disks);
>   		smp_mb();
> @@ -4415,20 +4442,24 @@ static int raid10_start_reshape(struct mddev *mdd=
ev)
>   	smp_mb();
>   	if (mddev->reshape_backwards) {
>   		sector_t size =3D raid10_size(mddev, 0, 0);
>   		if (size < mddev->array_sectors) {
>   			spin_unlock_irq(&conf->device_lock);
> +			mddev_unlock_and_resume(mddev);
> +			mddev_lock_nointr(mddev);
>   			pr_warn("md/raid10:%s: array size must be reduce before number of di=
sks\n",
>   				mdname(mddev));
>   			return -EINVAL;
>   		}
>   		mddev->resync_max_sectors =3D size;
>   		conf->reshape_progress =3D size;
>   	} else
>   		conf->reshape_progress =3D 0;
>   	conf->reshape_safe =3D conf->reshape_progress;
>   	spin_unlock_irq(&conf->device_lock);
> +	mddev_unlock_and_resume(mddev);
> +	mddev_lock_nointr(mddev);
>  =20
>   	if (mddev->delta_disks && mddev->bitmap) {
>   		struct mdp_superblock_1 *sb =3D NULL;
>   		sector_t oldsize, newsize;
>  =20
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index ec79d87fb92f..b711626a5db7 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -85,11 +85,11 @@ struct r10conf {
>   	int			have_replacement; /* There is at least one
>   						   * replacement device.
>   						   */
>   	wait_queue_head_t	wait_barrier;
>  =20
> -	mempool_t		r10bio_pool;
> +	mempool_t		*r10bio_pool;
>   	mempool_t		r10buf_pool;
>   	struct page		*tmppage;
>   	struct bio_set		bio_split;
>  =20
>   	/* When taking over an array from a different personality, we store

--=20
Thansk,
Kuai
