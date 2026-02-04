Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A21533ADAD
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770223691; cv=none; b=n2LF2zju6oP2d1XAmYJiMXV0xJp4twg39NdGZ+BJhiFI1RyB00P7ohxW+l0KkHpsx7jtntoq6Ne50UvFhji9RZs0ZTKd2BGH1xRMgOuDSs9JsSFlHaocAlfO3TKUBBAAi5ZkpraIcseHnQOZ1x92MjpSkJeOaWzIPSPXjDEe4LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770223691; c=relaxed/simple;
	bh=gOSv9NYGOzcPEeu1wWF6/k4l83ZEQLwuh/bza3y0iPQ=;
	h=Message-Id:References:Date:Cc:From:To:Mime-Version:Content-Type:
	 Subject:In-Reply-To; b=EKO8G+IQkUpzzMPOGeNZYz9zmM9QR4prrUd6isykUjZL6RmDLn2HGT1hXrfi9NzYxE06u8d6/iQUwsFUOss5L63rhXiSyEyUZZwJWw3q70q/N0R99qemetAB+Titf6u4VYp01l4vyXDQnvESmsDBrafXLd9D70Rd7sgawbsS3d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=P+FqB1A1; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="P+FqB1A1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770223684;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UrLacLaY2qXTd+zd2YFpeiTrHsUZZ+x90r6aiG7rEOw=;
 b=P+FqB1A1mtEqo7/o+o23UxGfHVdCgQS4yoMSVXoGCt54LSuCz1gbliOu+SjarkVDisT0pN
 oEIzQgAfkvsuAZx1jUdGB6o+tLnM97pFxxyQUGyB41OlP81uiqofwSYqcjhnRLNFIWOZbg
 BDjVgT4DYL3EkHDkDplaQl1P5AUf+b6jHupSGdb/GbTBWCKBi4FUxTOwh5SpdhucBEFaYe
 z/hRvcqGiUOYJfCOifa60ePWz/dsDTiCyi0oR9H5Resc3T9MZlH56peEf+uwlvOa6SHdYm
 96KyDUm7H2Rf+tysAd/Sh4FgQgcN2uDEegmqO5Ij7ycfCzxxlE84OO74+V8GuQ==
Message-Id: <887aa7a7-0b74-4b92-a053-0f019bac7d85@fnnas.com>
References: <20260128075708.2259525-1-linan666@huaweicloud.com> <20260128075708.2259525-15-linan666@huaweicloud.com>
User-Agent: Mozilla Thunderbird
Date: Thu, 5 Feb 2026 00:48:00 +0800
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Thu, 05 Feb 2026 00:48:01 +0800
Reply-To: yukuai@fnnas.com
Cc: <xni@redhat.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>, <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
To: <linan666@huaweicloud.com>, <song@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Subject: Re: [PATCH v2 14/14] md/raid1,raid10: fall back to smaller order if sync folio alloc fails
In-Reply-To: <20260128075708.2259525-15-linan666@huaweicloud.com>
X-Lms-Return-Path: <lba+269837842+b12583+vger.kernel.org+yukuai@fnnas.com>

Hi,

=E5=9C=A8 2026/1/28 15:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:
> From: Li Nan <linan122@huawei.com>
>
> RESYNC_BLOCK_SIZE (64K) has higher allocation failure chance than 4k,
> so retry with lower orders to improve allocation reliability.
>
> A r1/10_bio may have different rf->folio orders. Use minimum order as
> r1/10_bio sectors to prevent exceeding size when adding folio to IO later=
.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/raid1-10.c | 14 +++++++++++---
>   drivers/md/raid1.c    | 13 +++++++++----
>   drivers/md/raid10.c   | 28 ++++++++++++++++++++++++++--
>   3 files changed, 46 insertions(+), 9 deletions(-)

Looks like this patch should be merged into patch 5, there is no need to in=
troduce
that higher allocation failure and then fix it here.

>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index ffbd7bd0f6e8..e966d11a81e7 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -41,12 +41,20 @@ static void rbio_pool_free(void *rbio, void *data)
>   }
>  =20
>   static inline int resync_alloc_folio(struct resync_folio *rf,
> -				     gfp_t gfp_flags)
> +				     gfp_t gfp_flags, int *order)
>   {
> -	rf->folio =3D folio_alloc(gfp_flags, get_order(RESYNC_BLOCK_SIZE));
> -	if (!rf->folio)
> +	struct folio *folio;
> +
> +	do {
> +		folio =3D folio_alloc(gfp_flags, *order);
> +		if (folio)
> +			break;
> +	} while (--(*order) > 0);
> +
> +	if (!folio)
>   		return -ENOMEM;
>  =20
> +	rf->folio =3D folio;
>   	return 0;
>   }
>  =20
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 2253e65c5f03..5bee846f1534 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -149,6 +149,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>   	int need_folio;
>   	int j;
>   	struct resync_folio *rfs;
> +	int order =3D get_order(RESYNC_BLOCK_SIZE);
>  =20
>   	r1_bio =3D r1bio_pool_alloc(gfp_flags, conf);
>   	if (!r1_bio)
> @@ -182,7 +183,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>   		struct resync_folio *rf =3D &rfs[j];
>  =20
>   		if (j < need_folio) {
> -			if (resync_alloc_folio(rf, gfp_flags))
> +			if (resync_alloc_folio(rf, gfp_flags, &order))
>   				goto out_free_folio;
>   		} else {
>   			memcpy(rf, &rfs[0], sizeof(*rf));
> @@ -193,6 +194,7 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, void =
*data)
>   		r1_bio->bios[j]->bi_private =3D rf;
>   	}
>  =20
> +	r1_bio->sectors =3D 1 << (order + PAGE_SECTORS_SHIFT);
>   	r1_bio->master_bio =3D NULL;
>  =20
>   	return r1_bio;
> @@ -2776,7 +2778,7 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>   	int write_targets =3D 0, read_targets =3D 0;
>   	sector_t sync_blocks;
>   	bool still_degraded =3D false;
> -	int good_sectors =3D RESYNC_SECTORS;
> +	int good_sectors;
>   	int min_bad =3D 0; /* number of sectors that are bad in all devices */
>   	int idx =3D sector_to_idx(sector_nr);
>  =20
> @@ -2858,8 +2860,11 @@ static sector_t raid1_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>   	r1_bio->sector =3D sector_nr;
>   	r1_bio->state =3D 0;
>   	set_bit(R1BIO_IsSync, &r1_bio->state);
> -	/* make sure good_sectors won't go across barrier unit boundary */
> -	good_sectors =3D align_to_barrier_unit_end(sector_nr, good_sectors);
> +	/*
> +	 * make sure good_sectors won't go across barrier unit boundary.
> +	 * r1_bio->sectors <=3D RESYNC_SECTORS.
> +	 */
> +	good_sectors =3D align_to_barrier_unit_end(sector_nr, r1_bio->sectors);
>  =20
>   	for (i =3D 0; i < conf->raid_disks * 2; i++) {
>   		struct md_rdev *rdev;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 030812f908ac..72c77db9957c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -135,6 +135,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>   	int j;
>   	int nalloc, nalloc_rf;
>   	struct resync_folio *rfs;
> +	int order =3D get_order(RESYNC_BLOCK_SIZE);
>  =20
>   	r10_bio =3D r10bio_pool_alloc(gfp_flags, conf);
>   	if (!r10_bio)
> @@ -185,7 +186,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>  =20
>   		if (!j || test_bit(MD_RECOVERY_SYNC,
>   				   &conf->mddev->recovery)) {
> -			if (resync_alloc_folio(rf, gfp_flags))
> +			if (resync_alloc_folio(rf, gfp_flags, &order))
>   				goto out_free_folio;
>   		} else {
>   			memcpy(rf, &rfs[0], sizeof(*rf));
> @@ -200,6 +201,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>   		}
>   	}
>  =20
> +	r10_bio->sectors =3D 1 << (order + PAGE_SECTORS_SHIFT);
>   	return r10_bio;
>  =20
>   out_free_folio:
> @@ -3374,6 +3376,15 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>   						continue;
>   					}
>   				}
> +
> +				/*
> +				 * RESYNC_BLOCK_SIZE folio might alloc failed in
> +				 * resync_alloc_folio(). Fall back to smaller sync
> +				 * size if needed.
> +				 */
> +				if (max_sync > r10_bio->sectors)
> +					max_sync =3D r10_bio->sectors;
> +
>   				any_working =3D 1;
>   				bio =3D r10_bio->devs[0].bio;
>   				bio->bi_next =3D biolist;
> @@ -3525,7 +3536,15 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>   		}
>   		if (sync_blocks < max_sync)
>   			max_sync =3D sync_blocks;
> +
>   		r10_bio =3D raid10_alloc_init_r10buf(conf);
> +		/*
> +		 * RESYNC_BLOCK_SIZE folio might alloc failed in resync_alloc_folio().
> +		 * Fall back to smaller sync size if needed.
> +		 */
> +		if (max_sync > r10_bio->sectors)
> +			max_sync =3D r10_bio->sectors;
> +
>   		r10_bio->state =3D 0;
>  =20
>   		r10_bio->mddev =3D mddev;
> @@ -4702,7 +4721,12 @@ static sector_t reshape_request(struct mddev *mdde=
v, sector_t sector_nr,
>   	r10_bio->mddev =3D mddev;
>   	r10_bio->sector =3D sector_nr;
>   	set_bit(R10BIO_IsReshape, &r10_bio->state);
> -	r10_bio->sectors =3D last - sector_nr + 1;
> +	/*
> +	 * RESYNC_BLOCK_SIZE folio might alloc failed in
> +	 * resync_alloc_folio(). Fall back to smaller sync
> +	 * size if needed.
> +	 */
> +	r10_bio->sectors =3D min_t(int, r10_bio->sectors, last - sector_nr + 1)=
;
>   	rdev =3D read_balance(conf, r10_bio, &max_sectors);
>   	BUG_ON(!test_bit(R10BIO_Previous, &r10_bio->state));
>  =20

--=20
Thansk,
Kuai
