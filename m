Received: from va-2-52.ptr.blmpb.com (va-2-52.ptr.blmpb.com [209.127.231.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60332F0C79
	for <linux-raid@vger.kernel.org>; Sat, 20 Jun 2026 20:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781985940; cv=none; b=rfnow41ZXRxMzAhkMwjg/1txMrawZsk4nIiKEzK5V79eW4vIFbGTCxYDypEjjRnnbJAUkbafaxSKh3scwG7/wm0TENNoogTVaWX09HC6IV3omzUdHZRGdU1kJe35IyAOA/cM4f55/qM9ovlaZsHJEsCnzDbb3u4qn+BpJ/8MpeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781985940; c=relaxed/simple;
	bh=8noKOa8pjMmGNZ7A7yDyVZOA7NDpmBYOfVHwubhMmsw=;
	h=In-Reply-To:From:Date:To:Subject:References:Mime-Version:
	 Content-Type:Cc:Message-Id; b=R4lAyV+XWEgl6EctYVmFeOThKtuwjXKZgNfvlk6Y3Twm8+rF1WTlDwoUXmaIFsQYwbKrbEHH8E6RmNX06G+Rfmb1dB+eEjbIlIGB0fax8Aj71jPF5ePo6ZtGudanBRmEZikMA2a7l6o/e/PC5UatlBFxLrNK0S+mZ58yR8p6xqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=pOCVOpVk; arc=none smtp.client-ip=209.127.231.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="pOCVOpVk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1781985933;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AVHBlB12Pftv0MNTqw3iY6S8DNcnLnzpd2wwySEqinw=;
 b=pOCVOpVkP8VFELQShr2vsNeIfyNOCgnWdnpt60i8PBDnhsOoweM0WJes2AcuyToDTrlRYx
 QNQro0IpVoL58eu0UTKR+cN1h7QIyxFORR0S3E5d92zoBA2olAjNSJXg8VskxstbK6Rrnj
 TGA3o3Zg4+8yHiw8WTAoYnhmgujZuDsSuEN0lDOVpBxfzp0e2oM/MqHRND56r3u6I1EMcf
 QsFGBuuWdfd6jB5uD4giDFNXNXx6d92fjAIsfMYtmiBTKtjSyf1mo98dCI0wFBAdtpB3EL
 Otx2CWwGv/ZdIA9wgW/VBJhCuVwtmBQX20zophG3t5QnY6CYZdFr1mO2BDH1Ug==
In-Reply-To: <20260603035925.217847-3-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a36f28c+787b15+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Sun, 21 Jun 2026 04:05:28 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.148]) by smtp.larksuite.com with ESMTPS; Sat, 20 Jun 2026 20:05:31 +0000
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] md/raid10: make r10bio_pool use fixed-size objects
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-3-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, <yukuai@fygo.io>
Message-Id: <01f109d9-dcb4-46e0-8348-c208d43778ca@fygo.io>

Hi,

=E5=9C=A8 2026/6/3 11:59, Chen Cheng =E5=86=99=E9=81=93:
> From: Chen Cheng <chencheng@fnnas.com>
>
> raid10 currently sizes regular r10bio_pool objects from
> conf->geo.raid_disks, which makes the mempool element width depend on
> the current geometry.
>
> That breaks across reshape. Regular r10bio objects are preallocated and
> reused, so after a geometry change the pool may still contain objects
> allocated for the old width. A later request under the new geometry can
> then reuse an r10bio whose devs[] array is still sized for the previous
> raid_disks value.
>
> Fix this by backing r10bio_pool with a fixed-size kmalloc mempool sized
> for the maximum width needed across the current reshape transition.
> Apply the same sizing rule to standalone r10bio objects allocated from
> r10buf_pool_alloc().
>
> This removes the geometry-dependent allocation width from regular
> r10bio_pool objects and prevents reshape from reusing pool entries that
> are too small for the new layout.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 48 +++++++++++++++++++++++++++++++++------------
>   drivers/md/raid10.h |  2 +-
>   2 files changed, 36 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cee5a253a281..5eca34432e63 100644
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

I don't understand this change first, I get what you want to do after takin=
g
a look at patch 3. However, I think geo.raid_disks is safe here. A r10_bio
that is allocated from old pool should never be reused under new geometry.

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
> @@ -1537,11 +1552,11 @@ static void raid10_write_request(struct mddev *md=
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
> @@ -1729,11 +1744,11 @@ static int raid10_handle_discard(struct mddev *md=
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
>   	r10_bio->read_slot =3D -1;
>   	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
> @@ -3830,11 +3845,11 @@ static int setup_geo(struct geom *geo, struct mdd=
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
> @@ -3877,13 +3892,12 @@ static struct r10conf *setup_conf(struct mddev *m=
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
> @@ -4373,10 +4387,11 @@ static int raid10_start_reshape(struct mddev *mdd=
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
> @@ -4409,10 +4424,17 @@ static int raid10_start_reshape(struct mddev *mdd=
ev)
>  =20
>   	if (spares < mddev->delta_disks)
>   		return -EINVAL;
>  =20
>   	conf->offset_diff =3D min_offset_diff;
> +	if (mddev->delta_disks > 0) {
> +		new_pool =3D create_r10bio_pool(mddev);
> +		if (!new_pool)
> +			return -ENOMEM;
> +		mempool_destroy(conf->r10bio_pool);
> +		conf->r10bio_pool =3D new_pool;
> +	}
>   	spin_lock_irq(&conf->device_lock);
>   	if (conf->mirrors_new) {
>   		memcpy(conf->mirrors_new, conf->mirrors,
>   		       sizeof(struct raid10_info)*conf->prev.raid_disks);
>   		smp_mb();
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
Thanks,
Kuai
