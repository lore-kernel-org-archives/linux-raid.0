Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FDF1A239A
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 05:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779340733; cv=none; b=ENnuTam7Xh5mj2k3PlRXJ/fBXM3oLvJ4WjTyTkol79WADmAGMXBvhEWGwBnu81Tx+mc+30/7fXhvMlbngdmiDibBu5L9k6BTEGfTTHYxDXzv/Bdxqm9Yv7FsgESk/VZfkpj+Npk3plpGeLXoRR/u47w+8Z++PI2j3U1YTh/LV6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779340733; c=relaxed/simple;
	bh=0VwtxZ69SWiMftsmjuFXRetJDcKnWFusj1GhG+co6S4=;
	h=Subject:Date:To:Mime-Version:Content-Type:References:From:Cc:
	 Message-Id:In-Reply-To; b=bSaF52ZdyyNwiGLSGFSgrl/mMArKK+k0KIAb6W27l2tbzcenPDJUN699Fq85wSL5hij+m9JpnF54ZJzRUafZKgLgrmGZIscB3rcMXYchefTWa3GukfYQRvXYRDykFiQpPDzhCi/0K5N7/UYp5zMurUR2suLKSph62dCe9P9sMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=hzewRgMl; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="hzewRgMl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779340721;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=bBUz3/LXT4xRej+7BZhIrTq1P6goRrQ3ms5hqEa3zpg=;
 b=hzewRgMl9kwi92Ynjt2AxwPy9QEtehhhama5FfL/MyzMFYF5hPQpRV7vUGsy3R+UB4dLv3
 wXJUiOgz58jE0r98Lcw4QXrwki3OoJ1UvBP082+5MqY7wdc3D9uH0P/oD/hKxuabBhOLcZ
 KWtvdRTKmxo+aAIL6G+4ESn+rRKkI/SsR/53ROEODQKI6dddDC3IHFgi4EXed/jl0QmXfm
 mQIB7ikTlF18UHXi1qnJFrxIalw5OXMtuzA8NtQG2YUxbmCwybjH2oyxmLMEiT5XqiPTtY
 zWrGp5BN88APH2kx4KmiErfsQLFmJxU/3nbQcWRoJzfvkOURRjt9iTF2vxDnDg==
Subject: Re: [PATCH v2 1/2] md/raid10: make r10bio_pool use fixed-size objects
Date: Thu, 21 May 2026 13:18:37 +0800
X-Original-From: Yu Kuai <yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20260515092707.3436464-1-chencheng@fnnas.com> <20260515092707.3436464-2-chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a0e95af+ede580+vger.kernel.org+yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <09858001-d8cb-4d87-bd27-6fe9c8f0b137@fygo.io>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Thu, 21 May 2026 13:18:39 +0800
Content-Language: en-US
In-Reply-To: <20260515092707.3436464-2-chencheng@fnnas.com>
Reply-To: yukuai@fygo.io

Hi,

=E5=9C=A8 2026/5/15 17:27, Chen Cheng =E5=86=99=E9=81=93:
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
> Because reshape updates live array state such as conf->mirrors, conf->geo=
,
> reshape_progress, and reshape_safe, the geometry switch must happen only
> after normal I/O has gone fully quiet. raise_barrier() alone is not stron=
g
> enough here: freeze_array() also marks that an array freeze is in progres=
s,
> flushes pending writes, and waits until in-flight I/O has either complete=
d
> or been queued.
>
> Freeze the array before switching reshape geometry, rebuild r10bio_pool f=
or
> the new width inside that freeze window, and switch raid10_quiesce() to u=
se
> freeze_array()/unfreeze_array() as well. This keeps new requests from reu=
sing
> stale-width regular I/O objects after the geometry change.
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>   drivers/md/raid10.c | 57 +++++++++++++++++++++++++++++++++------------
>   drivers/md/raid10.h |  2 +-
>   2 files changed, 43 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 39085e7dd6d2..886bbe6b1ebc 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -103,13 +103,28 @@ static inline struct r10bio *get_resync_r10bio(stru=
ct bio *bio)
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
> @@ -137,7 +152,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>   	int nalloc, nalloc_rp;
>   	struct resync_pages *rps;
>  =20
> -	r10_bio =3D r10bio_pool_alloc(gfp_flags, conf);
> +	r10_bio =3D alloc_r10bio(conf->mddev, gfp_flags);
>   	if (!r10_bio)
>   		return NULL;
>  =20
> @@ -277,7 +292,7 @@ static void free_r10bio(struct r10bio *r10_bio)
>   	struct r10conf *conf =3D r10_bio->mddev->private;
>  =20
>   	put_all_bios(conf, r10_bio);
> -	mempool_free(r10_bio, &conf->r10bio_pool);
> +	mempool_free(r10_bio, conf->r10bio_pool);
>   }
>  =20
>   static void put_buf(struct r10bio *r10_bio)
> @@ -1531,7 +1546,7 @@ static void __make_request(struct mddev *mddev, str=
uct bio *bio, int sectors)
>   	struct r10conf *conf =3D mddev->private;
>   	struct r10bio *r10_bio;
>  =20
> -	r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
> +	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
>  =20
>   	r10_bio->master_bio =3D bio;
>   	r10_bio->sectors =3D sectors;
> @@ -1723,7 +1738,7 @@ static int raid10_handle_discard(struct mddev *mdde=
v, struct bio *bio)
>   				(last_stripe_index << geo->chunk_shift);
>  =20
>   retry_discard:
> -	r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
> +	r10_bio =3D mempool_alloc(conf->r10bio_pool, GFP_NOIO);
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->state =3D 0;
>   	r10_bio->sectors =3D 0;
> @@ -3823,7 +3838,7 @@ static void raid10_free_conf(struct r10conf *conf)
>   	if (!conf)
>   		return;
>  =20
> -	mempool_exit(&conf->r10bio_pool);
> +	mempool_destroy(conf->r10bio_pool);
>   	kfree(conf->mirrors);
>   	kfree(conf->mirrors_old);
>   	kfree(conf->mirrors_new);
> @@ -3870,9 +3885,8 @@ static struct r10conf *setup_conf(struct mddev *mdd=
ev)
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
> @@ -4131,9 +4145,9 @@ static void raid10_quiesce(struct mddev *mddev, int=
 quiesce)
>   	struct r10conf *conf =3D mddev->private;
>  =20
>   	if (quiesce)
> -		raise_barrier(conf, 0);
> +		freeze_array(conf, 0);
>   	else
> -		lower_barrier(conf);
> +		unfreeze_array(conf);
>   }
>  =20
>   static int raid10_resize(struct mddev *mddev, sector_t sectors)
> @@ -4365,6 +4379,7 @@ static int raid10_start_reshape(struct mddev *mddev=
)
>   	struct md_rdev *rdev;
>   	int spares =3D 0;
>   	int ret;
> +	mempool_t *new_pool;
>  =20
>   	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>   		return -EBUSY;
> @@ -4400,7 +4415,17 @@ static int raid10_start_reshape(struct mddev *mdde=
v)
>   	if (spares < mddev->delta_disks)
>   		return -EINVAL;
>  =20
> +	freeze_array(conf, 0);

freeze array here is incorrect. see the comments of freeze_array:

wait for pending IO requests to coplete or be rqueued for re-try.

Which means there can still be IO pending for re-try.

>   	conf->offset_diff =3D min_offset_diff;
> +	if (mddev->delta_disks > 0) {
> +		new_pool =3D create_r10bio_pool(mddev);
> +		if (!new_pool) {
> +			unfreeze_array(conf);
> +			return -ENOMEM;
> +		}
> +		mempool_destroy(conf->r10bio_pool);
> +		conf->r10bio_pool =3D new_pool;
> +	}
>   	spin_lock_irq(&conf->device_lock);
>   	if (conf->mirrors_new) {
>   		memcpy(conf->mirrors_new, conf->mirrors,
> @@ -4417,6 +4442,7 @@ static int raid10_start_reshape(struct mddev *mddev=
)
>   		sector_t size =3D raid10_size(mddev, 0, 0);
>   		if (size < mddev->array_sectors) {
>   			spin_unlock_irq(&conf->device_lock);
> +			unfreeze_array(conf);
>   			pr_warn("md/raid10:%s: array size must be reduce before number of di=
sks\n",
>   				mdname(mddev));
>   			return -EINVAL;
> @@ -4427,6 +4453,7 @@ static int raid10_start_reshape(struct mddev *mddev=
)
>   		conf->reshape_progress =3D 0;
>   	conf->reshape_safe =3D conf->reshape_progress;
>   	spin_unlock_irq(&conf->device_lock);
> +	unfreeze_array(conf);
>  =20
>   	if (mddev->delta_disks && mddev->bitmap) {
>   		struct mdp_superblock_1 *sb =3D NULL;
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index ec79d87fb92f..b711626a5db7 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -87,7 +87,7 @@ struct r10conf {
>   						   */
>   	wait_queue_head_t	wait_barrier;
>  =20
> -	mempool_t		r10bio_pool;
> +	mempool_t		*r10bio_pool;
>   	mempool_t		r10buf_pool;
>   	struct page		*tmppage;
>   	struct bio_set		bio_split;

--=20
Thansk,
Kuai
