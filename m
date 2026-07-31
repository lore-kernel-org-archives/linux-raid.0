Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BFF3B6C13
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 09:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785491183; cv=none; b=iY68jBeJIfzVIz3zCHA6A9cv3T+gZ//IFrP7UrRiiXWlKUo0e+YYzbejX4DnwkNxKpTJFQPG0SAgCfLwqCkGoMvSuoiKFXw2y4OOiuFa9s5mP2zrXSTLGLfJA32qJAvAdSnvkqmFSkz81VyME2KXbBSqE7d2lTD0y7YuoiYu6yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785491183; c=relaxed/simple;
	bh=pbYKIQL5w+ESuNxW6FGjdjrvIpMOcCONX9jI4VDzlZg=;
	h=In-Reply-To:Cc:Message-Id:References:Mime-Version:Content-Type:
	 From:Subject:Date:To; b=u+vOCSkX5aVOxmjLOpR6HT1Cte7ZFoai8HqCRa6OgSDOIN2BNH+5NG1BkpUJdL08MzvgqpyPim+lut3GocXX5pIExTxoGifriu0OEd2qYSo4rXwBDAdTHt0XFmzVL7X3fjH4aKQMiylgzGEs6SCc28ojAbiBUVB6NKPKVG2EjIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=CY0mrOjg; arc=none smtp.client-ip=209.127.231.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="CY0mrOjg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785491172;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=32VAPVs2XuwmyPQzbxjLgXcy9GDEPLMzghCzQb0SvC4=;
 b=CY0mrOjgL6P425RN0udpuTQanBnwzPLkNZZJ10x68OKQ8awy7YkCpwpgdz6TUoZ3IddM2F
 4GY9mWYAIRvYD6gpjZKu0buZHDdLFkTmVThl5KdXqtkiclJHm1IQt9izB68ClqyCPCPiaL
 63zZTLPfI72jnm6TUj095McnHACUA6XibnZ6xTk35TobI+Nwu85oBWYh/rApgjZgT+snXr
 MrblUEqArxV6BS/hsy0OB/YyMovLB3gKVorgIQYY87IvEjzj0YPxESx+0kEXZKT6+WHZu8
 JUcsktqkKiAG07wo5A4YFmE57kvZuK8G3QN0y2ydHu1PdzBEtmjfxmVpnuMGCg==
In-Reply-To: <20260723135535.101995-4-yunye.zhao@linux.alibaba.com>
Reply-To: yukuai@fygo.io
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Joseph Qi" <joseph.qi@linux.alibaba.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0650db8f-14d2-4f80-949f-82553fd8485b@fygo.io>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-1-yunye.zhao@linux.alibaba.com> <20260723135535.101995-4-yunye.zhao@linux.alibaba.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 09:46:11 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a6c6ee3+b77eba+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during recovery
Date: Fri, 31 Jul 2026 17:46:07 +0800
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/23 21:55, Yunye Zhao =E5=86=99=E9=81=93:
> During recovery of a degraded RAID10 with a mostly-clean bitmap, the
> "everything skipped" path (biolist =3D=3D NULL) returns max_sync =3D=3D 1=
28
> sectors, even though md_bitmap_start_sync() already reported a much
> larger clean range (an unallocated bitmap page spans 2^31 sectors with
> a 512M bitmap chunk).  On the reported 2^40-sector array md_do_sync()
> then crawls through 2^33 no-op iterations, burning a CPU for the whole
> sweep; the cond_resched() in md_do_sync()'s skip path only stops the
> watchdog firing.
>
> The skip path cannot simply return sync_blocks: sync_blocks is measured
> in array sectors while the return value advances the per-device recovery
> cursor, and the two spaces differ by the raid10 layout.  For a near
> layout (far_copies =3D=3D 1 && !far_offset) the mapping is linear with sl=
ope
> raid_disks / near_copies; when near_copies evenly divides raid_disks the
> conversion is exact.  Track the minimum clean span across the skipped
> devices, convert it to device sectors and skip it in one step.
> far/offset layouts are not a linear scale and keep the previous
> behaviour.
>
> Only devices skipped as clean feed that minimum, and the skip is
> suppressed when a device needed rebuilding but had no readable source
> (missing_source), so the cursor never jumps past sectors that still
> need recovery.
>
> The generic bitmap skip_sync_blocks() path cannot be used here: it does
> not see mrdev/mreplace (the recovery target and its replacement), and
> replacement targets must rebuild even bitmap-clean chunks.

I'm confused, recovery means replace a new disk, and md_do_sync() iterate
from 0 to mddev->dev_sectors, which is per rdev offset, there is nothing to
skip in this case for old bitmap, as the whole new disk have to rebuild.

So are you talking about the case that the array is already broken? That
there is no data can be read to rebuild.

>
> On a mostly-clean array with 8T per device (near=3D2, 4 disks) the
> recovery sweep drops from 37.2s of CPU spinning to about 10ms.
>
> Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
> ---
>   drivers/md/raid10.c | 46 ++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 54cddb3a98cd..8acbd5ef618b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3176,6 +3176,9 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>   	int i;
>   	int max_sync;
>   	sector_t sync_blocks;
> +	sector_t min_sync_blocks =3D MaxSector;
> +	sector_t sync_end;
> +	bool missing_source =3D false;
>   	sector_t chunk_mask =3D conf->geo.chunk_mask;
>   	int page_idx =3D 0;
>  =20
> @@ -3258,6 +3261,14 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>   	if (max_sector > mddev->resync_max)
>   		max_sector =3D mddev->resync_max; /* Don't do IO beyond here */
>  =20
> +	/*
> +	 * The chunk clamp below caps a single sync I/O to at most one chunk.
> +	 * The bitmap-clean recovery skip issues no I/O, so remember the real
> +	 * end here to bound the skip against it rather than the chunk
> +	 * boundary.
> +	 */
> +	sync_end =3D max_sector;
> +
>   	/* make sure whole request will fit in a chunk - if chunks
>   	 * are meaningful
>   	 */
> @@ -3334,9 +3345,13 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>   			if (!must_sync &&
>   			    mreplace =3D=3D NULL &&
>   			    !conf->fullsync) {
> -				/* yep, skip the sync_blocks here, but don't assume
> -				 * that there will never be anything to do here
> +				/* Skip the clean sync_blocks here; don't
> +				 * assume there will never be anything to
> +				 * do.  Only a genuinely skipped clean span
> +				 * may widen the bulk skip below.
>   				 */
> +				if (sync_blocks < min_sync_blocks)
> +					min_sync_blocks =3D sync_blocks;
>   				continue;
>   			}
>   			if (mrdev)
> @@ -3459,6 +3474,7 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>   			if (j =3D=3D conf->copies) {
>   				/* Cannot recover, so abort the recovery or
>   				 * record a bad block */
> +				missing_source =3D true;
>   				if (any_working) {
>   					/* problem is that there are bad blocks
>   					 * on other device(s)
> @@ -3514,6 +3530,8 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>   			}
>   		}
>   		if (biolist =3D=3D NULL) {
> +			sector_t skip_sectors =3D max_sync;
> +
>   			while (r10_bio) {
>   				struct r10bio *rb2 =3D r10_bio;
>   				r10_bio =3D (struct r10bio*) rb2->master_bio;
> @@ -3521,7 +3539,29 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>   				put_buf(rb2);
>   			}
>   			*skipped =3D 1;
> -			return max_sync;
> +
> +			/*
> +			 * min_sync_blocks is in array sectors, but the return
> +			 * value advances the per-device cursor; for a near
> +			 * layout the two spaces differ by the factor
> +			 * raid_disks / near_copies.
> +			 */
> +			if (!missing_source &&
> +			    conf->geo.far_copies =3D=3D 1 && !conf->geo.far_offset &&
> +			    conf->geo.raid_disks % conf->geo.near_copies =3D=3D 0 &&
> +			    min_sync_blocks !=3D MaxSector) {
> +				sector_t clean_sectors =3D min_sync_blocks;
> +
> +				clean_sectors *=3D conf->geo.near_copies;
> +				sector_div(clean_sectors, conf->geo.raid_disks);
> +				clean_sectors &=3D ~chunk_mask;
> +				if (clean_sectors > sync_end - sector_nr)
> +					clean_sectors =3D sync_end - sector_nr;
> +				if (clean_sectors > skip_sectors)
> +					skip_sectors =3D clean_sectors;
> +			}
> +
> +			return skip_sectors;
>   		}
>   	} else {
>   		/* resync. Schedule a read for every block at this virt offset */

--=20
Thanks,
Kuai
