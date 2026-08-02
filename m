Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7C6244667
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703622; cv=none; b=lOLr/Wf2YkWI8UXM0eGnE/NkNEw0FvQvX11aHn+MCVoOGh+TyyFuTiJNM2b9Zio160gMaxoaGC64mT+367mC1XIMkz80CdC5k7Tr+Vw4d9m769GlBThM19LrNeZWqvwVLp0twji9eypjR05w1dSv0kM5eXrOQ8kGViW8E37qM00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703622; c=relaxed/simple;
	bh=59JxrfdM/hgUr/3TxSzq+h+ztd1Y7jToqK0n+CYIe8w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u22XU+0NQMHm7PtSc4Nk6cgSAC9hgdphmK1eaY0cC40qmsv7VieNpekKzPxeYS7bbde3bEziNo5EerhH1dKInpUNu86vdPlvwaNzO+BA5+NaI391HMxATKDm94j7y9gQt/jJItICcfDPpxwjT7enYOZtd8XZ0yxN2YGwy9dmQdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IxISQ7U6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IxISQ7U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF851F000E9;
	Sun,  2 Aug 2026 20:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703620;
	bh=rN7cEwlZk/Of2Kq067rFOaesoShspjNUst9l7w832gY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IxISQ7U6OV2InWopgYgUj7ew99/xwfXqvJjQHsJxPTPsNp07NmsUiwke4fM4ve+iN
	 PBimnJb5VqABvYZ3jV8hXJ1oEralMFZrzxger2Bsznvv5aDuEc34VsS4XSV5P9vhRH
	 ovkC6QiMti6GCQimv/STljVzfxiUcVox/aHdENkYjT2uyfbjNk5E8uFJ2sG6sLKHoz
	 9JRoc3TX36PgXqljfQEPjFT2PtX1/MPOdaeNa1biln0EO8SKvPRma7y9VH0QBllgTc
	 yNm6LwSbbbbFFZNfLFtczKVyPx9xZrOCo74R2Qq4uQergTKnH0u4PQn0Xit2tGUQU0
	 +NBSV94HXm4zA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 28/29] md/raid5: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-29-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-29-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:46:59 +0000
Message-Id: <20260802204659.CFF851F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Torn metadata update between llbitmap data and the array superbloc=
k during RAID5 reshape, leading to data corruption upon crash recovery.
--

--- Patch [28]: [PATCH v5 28/29] md/raid5: wire llbitmap reshape lifecycle =
---
commit 3a12d425cf5a2752c68bb352670db1a3775e5849
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: wire llbitmap reshape lifecycle

Prepare llbitmap before RAID5 reshape starts, checkpoint the bitmap
before advancing reshape_position, and finish the llbitmap geometry
update when reshape completes.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 67d56c92c8a44..5176de5b59568 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6497,6 +6497,13 @@ static sector_t reshape_request(struct mddev *mdde=
v, sector_t sector_nr, int *sk
>  			   || test_bit(MD_RECOVERY_INTR, &mddev->recovery));
>  		if (atomic_read(&conf->reshape_stripes) !=3D 0)
>  			return 0;
> +		if (md_bitmap_enabled(mddev, false) &&
> +		    mddev->bitmap_ops->reshape_mark &&
> +		    conf->reshape_safe !=3D conf->reshape_progress) {
> +			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
> +						       conf->reshape_progress);
> +			mddev->bitmap_ops->unplug(mddev, true);
> +		}

[Severity: High]
Can this sequence cause a torn metadata update between the llbitmap data
and the array superblock during a reshape?

If a crash occurs in the window immediately after the bitmap pages are
synchronously flushed to disk here, but before the array superblock write
completes (via wait_event(mddev->sb_wait, mddev->sb_flags =3D=3D 0) shortly
after), the system might reboot with an inconsistent bitmap state.

Since llbitmap relies entirely on the array's mddev->reshape_position
and doesn't track its own, could dirty bits be misread as clean due to
layout misalignment, potentially leading to degraded arrays skipping necess=
ary
resyncs and causing data corruption upon recovery?

[ ... ]

> @@ -8732,10 +8752,19 @@ static int raid5_start_reshape(struct mddev *mdde=
v)
>   */
>  static void end_reshape(struct r5conf *conf)
>  {
> +	struct mddev *mddev =3D conf->mddev;
> =20
>  	if (!test_bit(MD_RECOVERY_INTR, &conf->mddev->recovery)) {
>  		struct md_rdev *rdev;
> =20
> +		if (md_bitmap_enabled(mddev, false) &&
> +		    mddev->bitmap_ops->reshape_mark &&
> +		    conf->reshape_safe !=3D conf->reshape_progress) {
> +			mddev->bitmap_ops->reshape_mark(mddev, conf->reshape_safe,
> +						       conf->reshape_progress);
> +			mddev->bitmap_ops->unplug(mddev, true);
> +		}
> +

[Severity: High]
Does this have the same torn metadata update risk as above?

This flushes the reshaped bitmap layout to disk synchronously before the
array metadata is finalized by md_finish_reshape() shortly after. A crash
here seems like it would leave the bitmap and superblock out of sync in the
same way.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D28
