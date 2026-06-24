Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52AD26E71E
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 09:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782292021; cv=none; b=V13KoQYfmYqm0xCI/h0rMtiRfSZDKbIz27ZLd3AHJiuVuT3myAfQerLfOBSkNZbHViSuTYxEE9rzmtXlyzr7bK+OvqJR7es+54RL4WSJujrWiMdnrnCi35P9f79va6OBVY4CMScrve+e0bNKjRtfsZ8HI6zHS+tJuPDxMWX3tlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782292021; c=relaxed/simple;
	bh=Ja5aOVc+8OPm4tgaDznYC0BPLFIM8eKoe6UHKIB2ZS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EwWIOsx5watKqTJgQTIFQehvSYjGsfloxrRRDKD4ZZc9ynoU7M8PyXadgH8dhPlI5IXOf0xON5WGVm178nOMhI58jT5dB5+6ivUoGAfcxZcoqCOAEnz/v4N9TZyHnwbdR/kqr7u+bde1AuOjJRv7Y91PYjKRRENkRnsgOkBpiE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpJHZ5tm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpJHZ5tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433731F000E9;
	Wed, 24 Jun 2026 09:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782292020;
	bh=NSrZUT4vINZbJ56lXGHEEMTuj20ROoQontUvEnqOquY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dpJHZ5tmYi/vL/WW2xUMxx1kqjV6nkgKUcSBdMGRA6YwU9HkjNgzdVJrJ9uWaOed1
	 n+PozxPB4uWfLcpu25zsBW1XuhFcs5DHarrilAwpGTb0oGrYvLYtGTdFPuqUvZCAOb
	 OnDTMDzg/BVnWduVrBH3aMnOh+NOEOhxEYLpeSNiBx+Lu5qcDQuGg/X9ixtIrPE8oj
	 nq58wiD7yxx/xcGXmWmH56itWW3pnbA8EAEtQX0090Jw6r7B8WSGFiDEG21x+BIu+z
	 C1alLg0t8Cx0uj3bw6lpr5UrQ23MBvSzwmcL0q2/iB2g0x62+bS9bWk/dOQaZy51uB
	 QOHH+MEpwtMGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/20] md/md-llbitmap: finish reshape geometry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <73a8a0409b741c57bbc9927abc7a9981cbafbf27.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <73a8a0409b741c57bbc9927abc7a9981cbafbf27.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 09:06:59 +0000
Message-Id: <20260624090700.433731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The entire bitmap is unnecessarily flushed to disk twice during res=
hape finish.
--

commit ae4a6d71e5ee77405793f20d5d615e089187608f
Author: Yu Kuai <yukuai@fygo.io>
md/md-llbitmap: finish reshape geometry

This commit introduces the final step for reshaping llbitmap arrays by
committing the staged geometry. It handles quiescing the device, updating
internal state, writing the superblock, and flushing the bitmap.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index cdced2126e975..ae2e87fd58874 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -1680,6 +1680,30 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
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
> +	llbitmap->chunks =3D llbitmap->reshape_chunks;
> +	llbitmap->sync_size =3D llbitmap->reshape_sync_size;
> +	llbitmap_refresh_reshape(llbitmap);
> +	mddev->bitmap_info.chunksize =3D llbitmap->chunksize;
> +	llbitmap_update_sb(llbitmap);
> +	__llbitmap_flush(mddev);

[Severity: Low]
Is this second flush of the entire bitmap redundant?

The code calls llbitmap_flush() at the beginning of the lock section.
After updating the geometry and writing out the superblock via
llbitmap_update_sb(), __llbitmap_flush() is called again. Since no bitmap
data bits are modified in the interim, does this cause an unnecessary
synchronous I/O spike that could be avoided?

> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +
> +	if (mddev->pers->quiesce)
> +		mddev->pers->quiesce(mddev, 0);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D8
