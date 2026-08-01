Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D83B3AE1A0
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606116; cv=none; b=ogQMYH3IwSo4CBAQ+MDcmflATk7rKgC8Ct4+Ua3lP/GMHniZVMT3DiVEo04hOFMVISgJ52a7JIocUf6QbUyG2KPDlEh9Gwp4QopZ/+fctbqv+zv/I/VWFnl/xK9suDbsK7cwa4bC17mGnxm51EXgq6THpa34AF6/INJ32SWmvx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606116; c=relaxed/simple;
	bh=gFQ++jenAmCwD2nowWYLNUyKPQYononiE7/JQufuayg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rfB23DiAbZf2wZ5GUR9M8yHSMRiryQjQfMhWn2s8atPU4ld9ZuiHcM3ZhKApHj0tt04awJu1T0jMYja8XlW/evmGXsFdpcXMZ3Y52Rw9k1/tx7t7IoC12hm+j03YyaX/2uf+xp1PMjtftvAFf9aSJgatutG7zmMB9rI8JlDGLno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4gFdpMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4gFdpMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940571F00AC4;
	Sat,  1 Aug 2026 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606114;
	bh=bSD69uwADh4JqwwLPvhLa+LLeh4VSMyw/Ll2pA+/YqA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b4gFdpMdQZ9TUqKoc90aDMIgQkjxNR2onTuvBxZcfKbbWdx34ZOmq70PrTz0SuqnD
	 y3GxUwywOP5cUrZfw+4j+v+3ifGl9gT+AwnCgqRTvp3asyzn4Li4vw43SAe98LRLKd
	 pSppSw1xoE1zr5T1pfgFuvFDS6C6pY4rKtJGlwxTYNnLk7uuzn1MYr/8Fr1uPF+zCH
	 Gk60WVcay6LfOgXw4c1ojDCzm3dhXAds16bD68GnI1r6Iiq9EctIwpLfg/06vUILJy
	 yGCyFAQI5A9SHLagIjzSpVSFAJeRdJvZq6KuI6N2+DqWQoAL+34RiKoEOxi+7Jw9HY
	 d5j7bkZnppgiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/25] md: add helper to split bios at reshape offset
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-9-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-9-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:41:54 +0000
Message-Id: <20260801174154.940571F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] READ_ONCE() on the 64-bit `mddev->reshape_position` can result=
 in a torn read on 32-bit architectures, leading to incorrect bio splitting=
 and silent data corruption.
--

--- Patch [8]: [PATCH v4 08/25] md: add helper to split bios at reshape off=
set ---
commit 71f7d05880dacfb8a18a94d6924ba3faac7d7965
Author: Yu Kuai <yukuai@fygo.io>

md: add helper to split bios at reshape offset

This commit adds mddev_bio_split_at_reshape_offset() to allow RAID
personalities to share reshape-offset bio splitting. It introduces a
lockless read of mddev->reshape_position using READ_ONCE().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> +struct bio *mddev_bio_split_at_reshape_offset(struct mddev *mddev,
> +					      struct bio *bio,
> +					      unsigned int *max_sectors,
> +					      struct bio_set *bs)
> +{
> +	sector_t boundary;
> +	sector_t start;
> +	sector_t end;
> +	unsigned int split_sectors;
> +
> +	split_sectors =3D bio_sectors(bio);
> +	if (max_sectors && *max_sectors && *max_sectors < split_sectors)
> +		split_sectors =3D *max_sectors;
> +
> +	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +		goto split;
> +
> +	boundary =3D READ_ONCE(mddev->reshape_position);
> +	start =3D bio->bi_iter.bi_sector;
> +	end =3D bio_end_sector(bio);
> +	if (start >=3D boundary || end <=3D boundary)
> +		goto split;

[Severity: Critical]
Is it possible for the READ_ONCE() above to result in a torn read on 32-bit
architectures?

Since mddev->reshape_position is a sector_t (64-bit value), compiling a
READ_ONCE() on a 32-bit architecture will result in two separate 32-bit loa=
ds.
If the reshape thread concurrently updates this value without a lock, a read
could happen exactly when crossing a 32-bit boundary, producing a corrupted
boundary value.

If the torn read produces an oversized boundary value, will this bounds che=
ck
evaluate to true and incorrectly skip splitting the bio?

Passing an unsplit bio that spans both old and new geometry layouts to the
RAID personality might result in writes to incorrect disks and offsets. Bef=
ore
this helper was introduced, did personalities like RAID5 use a lock (like
conf->device_lock) to prevent this 64-bit read race?

> +
> +	if (boundary - start < split_sectors)
> +		split_sectors =3D boundary - start;
> +
> +split:
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D8
