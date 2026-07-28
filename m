Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F81041D129
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230557; cv=none; b=i/o1b/RrznZloFa9TIJQ2PH2nR+PZ6tj4+8qREe48XmkglEc+sBzqguTfSm2Y6mKFOUDQzhd0lRHSUI5zb/Vn09Cz7LTxG+t79ASIS/UpVd2G/i3s+zXZKKnzMpYC49jY069RJ42Uw5mmUFkXlQwz6JYAjnnKcsQpFJQyGfAT1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230557; c=relaxed/simple;
	bh=4eRjHee3mskMoTtrWiFChurPF+LoRsyaiQNjqztEhys=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IIpgrQU/7IN+xbjXMMk6gaSWYVrtWUkJTHElnjYmOpxlk75kNXc8eUVPwlUTpm4JWaHbdiKUqNv6JMMOP/2CjE0HixIRIodlhThjDuhaDwBRu1+9DJZjjs11chgRLoauDfr2PTabg3/XErftj/0B76r6Ik5L/Lk9nGMIwYJ+LcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKu8FDgp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKu8FDgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1361F00A3A;
	Tue, 28 Jul 2026 09:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230556;
	bh=Ra61iM0d09X8IE3XCjaJrkwlvuTfoBtufCGNiutm9dY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gKu8FDgp+hMbChh8ZaBZloT2usremgN8JthKlWMpJbm/LxBbOz0CSCG6GNgFyb4Uk
	 hBtA9RON3cyEwl7Z0EQgxNtn1UTZ8J+yyJeN7T/YtSm6bk++/LMVkEeGJOfSLf11Rd
	 bp1dQaYXjWc3MQyfBMD34yVEltzq4/ARH+3QJgz255oPYOM3teNR9XogsXfXDBJYcz
	 6hDHIBN5mYlKOX17D3WEGXpW+N8BzC3gpvEI7bT58ltRRUGEOD0P9ydL42pHv3XTHN
	 AdC/THlxLTweLDd7nUeRakMLCciSIZOe0wn/0vaj0v4ThjRuYvHBL5dox8xbuGAukn
	 XLFU0/ewPF3UQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 16/21] md/raid10: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <a5d81ab33dd45f4f98cbb8cec9ad530258d1a144.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <a5d81ab33dd45f4f98cbb8cec9ad530258d1a144.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:22:35 +0000
Message-Id: <20260728092236.4A1361F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The `raid10_finish_reshape()` function hardcodes a check for `ID_LL=
BITMAP` before calling the polymorphic `reshape_finish` callback, bypassing=
 the abstraction provided by `bitmap_ops`.
--

--- Patch [16]: [PATCH v3 16/21] md/raid10: wire llbitmap reshape lifecycle=
 ---
commit 2d6aab72980238a6e16cc2a451989159951188f3
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: wire llbitmap reshape lifecycle

This commit wires up the llbitmap reshape lifecycle in the RAID10 subsystem.
It prepares the bitmap before growing, checkpoints it before advancing the
reshape position, and finishes the update when reshape completes.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1242b8d3bb6bd..e50e4adee389f 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
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
> +

[Severity: Low]
This isn't a bug, but does this code unnecessarily hardcode a check for
ID_LLBITMAP? It looks like this restricts the reshape_finish callback to
llbitmap, bypassing the abstraction provided by the generic bitmap_ops
interface.

>  	if (mddev->delta_disks > 0) {
>  		if (mddev->resync_offset > mddev->resync_max_sectors) {
>  			mddev->resync_offset =3D mddev->resync_max_sectors;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D16
