Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B3330274D
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230763; cv=none; b=aS4MO4mmHdUU/gx18G6XGS6qMHuPBIav/R2BJQG1CDNKcxKO7BWHVuyEeEquGiKq5lWPQHLLTn/KEDjSV4eZq8oB+DivrafeA1Zy/9fKikH6/pRjcWd6Oh7cAv3mTGhRo2GdoZAEJxGG74rxMK09seP22ByVv2nA++Jo8lkOWGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230763; c=relaxed/simple;
	bh=scm4LfqX/QzoVwMtWOYtLlvIdxs/gLYrRN6+YEoHjW0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P8JTO9iGFQjTK8EmlLGkJkJ8tpVe19qX6bTlNpq9fBXlFcbB2/LM0fembpKk7/nQuoSCYOAeTh4TEs0Pu39+ZN6h07OaRAeWYYsbmqNXSu5s6S103uHsEOr7V4nDykUKE7A5c5n1SRakMrZTxMRapZO83NnGwSqGksKWMG3CXIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxMJjI8j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxMJjI8j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951E81F00A3A;
	Tue, 28 Jul 2026 09:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230761;
	bh=pUloTqy5kxIduLh1ltwpt3p6J22U/ug2EdeouM/PTNU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZxMJjI8j5t/iBGoyNZLqmD5qqR9MgL0nOjGVkog4TpCYY+kl1YfAvbR8duJGeLUHx
	 EBxja6y1Jm2tHl3btVjsfD60fk0ZQD8/7E9h/K632o3beL/U2K7f8iQ+ng6oDEBUgy
	 d1rHIGmoaaT4p4uVBifyo4So6Nh7lqO1SfFBQox1yFcDE5gElyrzTXU9BbLMtneuhH
	 tqidLyYAMEfDdqBEGbVPZYMFTf12B/yqtB179/xKqOX5Uu1ilqM1RjRdEaxGmc112E
	 we6DxnEjEt+jxN/KHdVp0E6Uu97bYj2sWNFdpbzjheO+2b51KIfZT6b+MgZo0TToEj
	 dBLCEFkP7djIQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 21/21] md/raid5: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <4444c934f36b1c902cccfef2c4a9c9a919ff1145.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <4444c934f36b1c902cccfef2c4a9c9a919ff1145.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:26:01 +0000
Message-Id: <20260728092601.951E81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Returning `false` from `raid5_make_request()` after a split bi=
o encounters `STRIPE_WAIT_RESHAPE` causes double-submission of the remainde=
r bio, leaks the split bio, and hangs IO indefinitely.
--

--- Patch [21]: [PATCH v3 21/21] md/raid5: split reshape bios before bitmap=
 accounting ---
commit a1d64516f61f7855ab4b16be870b2ea6fb0d09a0
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: split reshape bios before bitmap accounting

This patch updates raid5_make_request() to use the shared
mddev_bio_split_at_reshape_offset() helper. This ensures RAID5 submits
only one-side bios to llbitmap during reshape.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f70b2f6119801..30e18ce7c0e3d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6184,6 +6184,14 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)
>  		return true;
>  	}
> =20
> +	bi =3D mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
> +					       &conf->bio_split);
> +	if (!bi) {
> +		if (rw =3D=3D WRITE)
> +			md_write_end(mddev);
> +		return true;
> +	}
> +

[Severity: Critical]
If this bio is split, `bi` is updated to the first half, while the original
bio (the remainder) is submitted asynchronously.

Later in raid5_make_request(), if make_stripe_request() returns
STRIPE_WAIT_RESHAPE, it sleeps and returns false:

	if (res =3D=3D STRIPE_WAIT_RESHAPE) {
		DECLARE_COMPLETION_ONSTACK(done);
		WRITE_ONCE(bi->bi_private, &done);

		bio_endio(bi);

		wait_for_completion(&done);
		return false;
	}

When raid5_make_request() returns false, md_handle_request() retries the
request using its original `bio` pointer:

drivers/md/md.c:md_handle_request() {
	...
	if (!mddev->pers->make_request(mddev, bio)) {
		percpu_ref_put(&mddev->active_io);
		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
			return false;
		goto check_suspended;
	}
	...
}

Because the original `bio` is now the remainder that was already submitted
asynchronously, won't returning false here cause a double-submission
of the remainder bio?

Additionally, if the completion handler intercepts the completion of the fi=
rst
half to wake the sleeper but skips calling bio_endio() on the split bio, wo=
n't
this leak the split bio? Because the bio was split and chained, does skippi=
ng
the completion prevent the parent bio's reference count from dropping to ze=
ro,
causing IO to hang indefinitely?

>  	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SEC=
TORS(conf)-1);
>  	bi->bi_next =3D NULL;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D21
