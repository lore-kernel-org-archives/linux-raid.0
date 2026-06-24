Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF82337AA75
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285760; cv=none; b=LOILABxwfd2LDl0X0mFsHvWwucRYfZ4jhznELLFE9sNrxA2X8L2yNhNiTLrG+zfmDg/YbGDavH+lRXblGkMSKY9TXIojHOkV6A+9GrntaazGP11STwXzRxuQU64n5jndWSummgiOiajgb1RvZd/yZQst7vu1Hip4ULFTF+R4PQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285760; c=relaxed/simple;
	bh=yNB+qoIs+W3hIBJZ862MaDrI7hqRi44bnUHqqC69Xlk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VTA+7HjVpXYnk6oY+jx+DhsXyrkc4BErjhUkbpquQwiTcZtpPafwid44mJHrZ8scQo+TaWatXN3hiE9tXozBCLEaKe4IGc+iPfZp8q04BwBdEMuTtS/Lkq9lNKnvp7O5++h9W2bBekMgKvIkhXvNzz8Y9s0AOJXE39KkvHaIous=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDmzEjtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDmzEjtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506FA1F000E9;
	Wed, 24 Jun 2026 07:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285757;
	bh=cMNIKyGexwtmWTBo1gq1MGBll1Sn+ACVPh6m311HvvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gDmzEjtHwi0Am2N0AZ01zeMtxBg0TjG+RCQQOGEatBSRXn7K7tfPcGp/U6+NjQUqm
	 w4oPaD3gDDDxuNq12g1JB8uwchrsWd4FYq9HqCA6Y2T/oIbayg+yXEeDeatntiirUS
	 wqAcl6Jc6dE/bYNcWhYYtumw3+rVS7ZhqyzsEOXJVmGgzW38wayxbE4CCDiscvg/IL
	 L9X+9UFlZ4dbhhOmayrGH4eAB0Kj8RwbBZ6VHa4ETJyugZahTOBbk2k3WcMFY5mXlg
	 ENH0IT5BZQKBuQ32U1MMigR2nylL45UTygab0DQnbr9fZU6ZhtEEnS+Qxt/3Ary0tA
	 r9FFqey5jJzsQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 15/20] md/raid10: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <54625332edcdb5f009fb0920220ea12aa696f408.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <54625332edcdb5f009fb0920220ea12aa696f408.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:22:35 +0000
Message-Id: <20260624072236.506FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] raid10_start_reshape skips initializing llbitmap's reshape geometr=
y, causing bitmap corruption during and after reshape.
- [Low] Hardcoded check for `ID_LLBITMAP` in `raid10_finish_reshape` breaks=
 the polymorphism of `mddev->bitmap_ops`.
--

commit 84732a3d166ed5b144ce82fb596703bb8b35f73c
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: wire llbitmap reshape lifecycle

Prepare llbitmap before RAID10 starts growing, checkpoint the bitmap
before advancing reshape_position, finish the llbitmap geometry update
when reshape completes, and export the old and new tracked sizes.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1242b8d3bb6bd..e50e4adee389f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4394,6 +4394,12 @@ static int raid10_start_reshape(struct mddev *mdde=
v)
> =20
>  	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>  		return -EBUSY;
> +	if (md_bitmap_enabled(mddev, false) &&
> +	    mddev->bitmap_ops->reshape_can_start) {
> +		ret =3D mddev->bitmap_ops->reshape_can_start(mddev);
> +		if (ret)
> +			return ret;
> +	}

[Severity: High]
Does this fully wire up the llbitmap reshape lifecycle?

Further down in raid10_start_reshape(), the call to mddev->bitmap_ops->resi=
ze()
is gated by `if (mddev->delta_disks && mddev->bitmap)`.

If a reshape is started that only grows the chunk size (where
mddev->delta_disks =3D=3D 0), won't this skip initializing the llbitmap's r=
eshape
geometry?

If resize() is bypassed, llbitmap->reshape_chunksize would remain at the old
chunk size, causing llbitmap_encode_range() for the new layout to map IOs
using the old chunk size. Could this set bits for incorrect regions, leading
to dirty data not being tracked properly and silent data corruption upon
array recovery?

[ ... ]

> @@ -5039,10 +5062,15 @@ static void end_reshape_request(struct r10bio *r1=
0_bio)
>  static void raid10_finish_reshape(struct mddev *mddev)
>  {
>  	struct r10conf *conf =3D mddev->private;
> +	bool llbitmap =3D mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +		md_bitmap_enabled(mddev, false);
> =20
>  	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>  		return;
> =20
> +	if (llbitmap && mddev->bitmap_ops->reshape_finish)
> +		mddev->bitmap_ops->reshape_finish(mddev);

[Severity: Low]
Is this hardcoded check for ID_LLBITMAP necessary?

By explicitly checking mddev->bitmap_id, this seems to defeat the polymorph=
ism
of mddev->bitmap_ops. If another bitmap implementation introduces
reshape_finish(), wouldn't it be silently ignored?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D15
