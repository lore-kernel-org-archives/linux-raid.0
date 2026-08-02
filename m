Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF84231F9B9
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703151; cv=none; b=EVoHS1gDPWayIyy8aQZk6SdLFn2xwlY/CuM2f8sEn/SNhxJmp9MFHlzCK6Qcy4fXNDnVDRjJDMn41wfHMsqbkLEyK88PFOqBXwFDyATuyoGAr5ra1uKqySPNGpDna9K4NGDh5ij3pVA5Laqu1y8hpR1OBVpVF+8LE8VVw0PVpsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703151; c=relaxed/simple;
	bh=bKJCUtoMG01wM+Zo/I63XPCJFEmPympfaa8XHPLS0yY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eQanLzW2hz3ic8U8dABG+Cwx6k4P+Kv7wZxm8bqyw59NVgYwdcd2udkCcIy5+sAcOA8ovu7fTW4DhI5wXT2+dn780HKmmYFmB8bNl6VNxa1D5qtb7QG5BC9kYiZF7mw6hXliDUwrG/yF05dJZbOYXK+17MF6M4/BUNV9KYrn3vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YWyq2/3B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YWyq2/3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411B31F000E9;
	Sun,  2 Aug 2026 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703149;
	bh=CYzKQt6Sb+J/hnziDqVnYlLX8CGmqwiRoHl0auMo6y0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YWyq2/3BK2ejrHvWIg5C6taEPIyaOo9RvzXgV84nrETxACTc/AlzxN1QGr9QH0qyV
	 ZOn2cc+TOclLu6ltEpAASkzYc0EXTqfa8Wc72AwzPo3Shx6YZkirjxs8jvyH6xQfC5
	 VSOgriKhOvV0THVaCh+Ej2B1mgGOdh6Qv9V8YxXkejdIe8DR0oB+M1Ip63BI2ivE9l
	 jZQBWsqujp94zUpCEuQ/1MIBL1/8mHH3+qvzMZ2sF/uKwUPdzau/PTuv2gXvfNU/+B
	 ee4xtbnZMf69fRQfNCpsl1ucLxx/dBq/LLaxgTyupts/26zOD3zYwkUghDHtb4XqFc
	 VkpO3ReqQMu/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 17/29] md/md-llbitmap: finish reshape geometry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260802195038.164272-18-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-18-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:39:08 +0000
Message-Id: <20260802203909.411B31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The `reshape_finish` callback is never invoked by the md core, ren=
dering the new geometry commit logic dead code.
- [High] In-flight I/O during an array reshape triggers an out-of-bounds ar=
ray access in `llbitmap_raise_barrier` due to stale chunkshift values.
--

--- Patch [17]: [PATCH v5 17/29] md/md-llbitmap: finish reshape geometry ---
commit f7a8f4b26cc5a0c01433cbcd7568266fb367e5e1
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: finish reshape geometry

This commit updates the llbitmap reshape geometry when the reshape finishes.
It refreshes the staged reshape geometry in llbitmap_load() after mddev->pe=
rs
is available, and expands the in-memory page controls before replaying the
bitmap state.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 71a4903901425..a7c229db3058d 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> @@ -1709,6 +1718,30 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
v, unsigned long s,
>  	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
>  }
> =20
> +static void llbitmap_reshape_finish(struct mddev *mddev)
> +{
> +	struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +	if (mddev->pers->quiesce)
> +		mddev->pers->quiesce(mddev, 1);
> +
> +	mutex_lock(&mddev->bitmap_info.mutex);
> +	llbitmap_flush(mddev);
> +
> +	llbitmap->chunksize =3D llbitmap->reshape_chunksize;
> +	llbitmap->chunkshift =3D ffz(~llbitmap->chunksize);

[Severity: High]
Does this introduce a regression where in-flight I/O during an array
reshape triggers an out-of-bounds array access due to stale chunkshift
values before they are updated here?

When an array grows, the active chunkshift remains unchanged while the page
controls are allocated for the old chunk limit. If the new chunksize is
forced to double, the new I/O offsets mapping to the expanded capacity
could be processed by llbitmap_start_write():

drivers/md/md-llbitmap.c:llbitmap_start_write() {
    unsigned long start =3D offset >> llbitmap->chunkshift;
    unsigned long end =3D (offset + sectors - 1) >> llbitmap->chunkshift;
    int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
    ...
    llbitmap_raise_barrier(llbitmap, page_start);
}

Dividing the larger offset by the old, smaller chunkshift would generate a
bit index that exceeds the old chunks.

Would this result in an out-of-bounds read/write without bounds checking
when llbitmap_raise_barrier() is called?

drivers/md/md-llbitmap.c:llbitmap_raise_barrier() {
    ...
    struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
    ...
}

> +	llbitmap->chunks =3D llbitmap->reshape_chunks;
> +	llbitmap->sync_size =3D llbitmap->reshape_sync_size;
> +	llbitmap_refresh_reshape(llbitmap);
> +	mddev->bitmap_info.chunksize =3D llbitmap->chunksize;
> +	llbitmap_update_sb(llbitmap);
> +	__llbitmap_flush(mddev);
> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +
> +	if (mddev->pers->quiesce)
> +		mddev->pers->quiesce(mddev, 0);
> +}
> +
[ ... ]
> @@ -2000,6 +2033,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.get_stats		=3D llbitmap_get_stats,
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
> +	.reshape_finish		=3D llbitmap_reshape_finish,

[Severity: High]
Is there a regression where the md core never calls this reshape_finish
callback?

Looking at the md core code, it does not appear to invoke
mddev->bitmap_ops->reshape_finish anywhere. If this is never called, would
the staged reshape geometry be silently dropped, leaving the bitmap
permanently out of sync with the expanded array capacity after a reshape
completes?

>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D17
