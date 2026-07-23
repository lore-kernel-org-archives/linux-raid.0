Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8283090C5
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 14:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784816191; cv=none; b=TAObev6iFyRw4D+gKfWoNv6b2sapigccINebPlJ18iTyDkonr0QXunxXd726LlqvD0XO416viih73PP5nhaZSw39JeTkNhEmlm1uc9BIkQxfKyzmmrcz3rxyiNof2OQLYL6iBGiPaxeTaBDO0p9G3Rj1bBbFIcr8XKKeqUT/ixI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784816191; c=relaxed/simple;
	bh=jIPxxK0t6c/6GPVTK2bQcU6AZzrhWHMp2MyG+t0uu9s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Iq6G1Dhp4kcqNW0pxFb+5fC56EauPA8Xdent+4rcRo/z9pxvHuxxnW2iQu2vo3lgpreLpRiYynu2wOJbfIsOvYeXD9ncbbXY38wwObKCqsc8ZsLFe90neKmqvbsur0y72ikCDe9BBJRziVYQku3Co4qI3IuOqU8i8OKZfkQRqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026F31F00A3A;
	Thu, 23 Jul 2026 14:16:27 +0000 (UTC)
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during
 recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260723135535.101995-4-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-4-yunye.zhao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 14:16:20 +0000
Message-Id: <20260723141628.026F31F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Fallback to an unscaled `max_sync` mixes array and device sect=
ors, overshooting the recovery cursor and silently skipping dirty sectors.
--

--- Patch [3]: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during =
recovery ---
commit 4abce2392f76451810793b3efca0299da30d9898
Author: Yunye Zhao <yunye.zhao@linux.alibaba.com>

md/raid10: skip clean regions in bulk during recovery

During recovery of a degraded RAID10 array with a mostly-clean bitmap, this
patch calculates the skipped clean span in bulk. It tracks the minimum clean
span across skipped devices, converts it to device sectors, and skips it in
one step to reduce CPU spinning.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 54cddb3a98cd6..8acbd5ef618b4 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c

[ ... ]

> @@ -3514,6 +3530,8 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>  			}
>  		}
>  		if (biolist =3D=3D NULL) {
> +			sector_t skip_sectors =3D max_sync;
> +
>  			while (r10_bio) {
>  				struct r10bio *rb2 =3D r10_bio;
>  				r10_bio =3D (struct r10bio*) rb2->master_bio;
> @@ -3521,7 +3539,29 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>  				put_buf(rb2);
>  			}
>  			*skipped =3D 1;
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

[Severity: Critical]
This is a pre-existing issue, but does returning the unscaled max_sync mix
array and device sectors here?

When recovering a degraded RAID10 array, md_bitmap_start_sync() returns
sync_blocks in array sectors, which is then assigned to max_sync.

If a clean span is small or not chunk-aligned, the truncation:

    clean_sectors &=3D ~chunk_mask;

can force the scaled clean_sectors to 0. When that happens, the condition:

    if (clean_sectors > skip_sectors)
        skip_sectors =3D clean_sectors;

fails, leaving skip_sectors as the unscaled max_sync value.

Because raid10_sync_request() then returns skip_sectors (an array-sector
distance) to advance the physical per-device cursor in md_do_sync(), could
the physical cursor overstep the actual clean physical span?

For layouts where array sectors advance faster than device sectors
(e.g., near_copies > 1), won't this silently skip dirty sectors and leave
mirrors out of sync?

>  		}
>  	} else {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723135535.1019=
95-1-yunye.zhao@linux.alibaba.com?part=3D3
