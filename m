Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F92D3E9C06
	for <linux-raid@vger.kernel.org>; Tue, 30 Jun 2026 10:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814709; cv=none; b=TN3MipC4Nfo07lN/sPGwAeus89sM2Ui0FCOT94h8ImqbB5BN0NCDiMDCIFOVnESn69K/9tr6J5z7wD7IN2RgXrWDAvHdgsZQdYDOaRub/n2QytPnLjyKwgMsJudd7MUMuBE424A5bewNgBVrb8R2xGzwL/ubTn1lbyS3u8Xmlqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814709; c=relaxed/simple;
	bh=onsgDQRCkIiz0hqAyXj0YjqySbdLU6As4GcAmSWoYs8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PchmT1jhL4ygOl81tGZL9ipSWR3klieb6ZXiygL8wu/CrnbJNNRAfaY9lqlOy4pmJyYKZNK+MNmL0xflVjhgKt6TAZnJfdyhdexnVZ5olwsdOXqqqlrDyAtzU0oOijn4dt1Kt+3BDzdQ2tm2kN2lyP2/lagxYfKEdtEn4UQhuZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZtQKFXvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZtQKFXvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B191F000E9;
	Tue, 30 Jun 2026 10:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782814701;
	bh=uZKwclh9eGIRwu4ZAzlvr9DyOAdYMjGqgom1HCSH9Os=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZtQKFXvHXRPZ6/m3nF9oa1W262H4HXYtGhZEfthaMIhdk/wa/+euTpAr6oTPAKtoV
	 6Di6ElxCTiwnvKPv4qlRMdHKGgO/g30ggXjdoWQ3g1zFhzyqQPIJxz68Y1gOS5Vtjn
	 i4ietl1NW6CKan7M78t5pgYQ9j4TpIcv4qfuMNOx9W12RC/8paOtQkeBgX3Hojj9Vf
	 cLfDOTcULXT0Dn6CMvYTkiGZOC+pagiAlIq5ZEUw+ael98QC5UGHrSaOhPvJRhkjoE
	 HwhUvJX0zOD94OPYFKppijOA9a8cpSE1qv3b/ljtXxlPAvvEodjVBBCBseQ8Bm5O1I
	 3qtvQYPiy2bSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: avoid modifying spares while the array is not
 suspended
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
References: <20260630075640.1081634-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 10:18:20 +0000
Message-Id: <20260630101821.67B191F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch prevents the recovery thread from starting or resuming f=
or existing rebuilding spares, silently abandoning recovery and leaving the=
 array permanently degraded.

Pre-existing issues:
- [High] The patch addresses a TOCTOU race for `state_store` but misses oth=
er vulnerable paths like `slot_store` and cluster updates, which still call=
 `remove_and_add_spares()` without array suspension.
--

commit 16cf64f20d25bc671dc52422ec0a44672674e524
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md: avoid modifying spares while the array is not suspended

This commit ensures that remove_spares() and remove_and_add_spares() are
only called after the array has been suspended. This prevents a race
condition where normal I/O could trigger a NULL pointer dereference when
rdevs are removed or replaced concurrently.

Closes: https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masalkh=
i@gmail.com?part=3D3

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..f555eb5aca5d8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10151,7 +10154,11 @@ static bool md_choose_sync_action(struct mddev *=
mddev, int *spares)
>  	 * also removed and re-added, to allow the personality to fail the
>  	 * re-add.
>  	 */
> -	*spares =3D remove_and_add_spares(mddev, NULL);
> +	if (array_suspended)
> +		*spares =3D remove_and_add_spares(mddev, NULL);
> +	else
> +		*spares =3D 0;
> +

[Severity: High]
Does this else branch prevent the recovery thread from starting or resuming
for existing rebuilding spares?

In md_start_sync(), suspend is determined by checking
md_spares_need_change(mddev). For an existing recovering spare receiving
normal I/O (where nr_pending > 0), both rdev_removeable() and
rdev_addable() can evaluate to false. This causes md_spares_need_change()
to return false, leaving suspend as false.

When md_choose_sync_action() is called with array_suspended =3D=3D false, t=
his
new else branch forces *spares =3D 0. By completely bypassing the counting =
of
existing recovering spares, md_choose_sync_action() will return false and
skip starting the sync thread.

Since nr_pending dropping to zero on a non-faulty spare doesn't trigger a
new MD_RECOVERY_NEEDED event, could this silently abandon recovery and
leave the array permanently degraded?

[Severity: High]
This is a pre-existing issue, but does restricting remove_and_add_spares()
calls to suspended arrays in md_choose_sync_action() leave other
vulnerable paths exposed?

The commit addresses a TOCTOU race by ensuring remove_and_add_spares() is
only called when the array is suspended, preventing concurrent I/O from
encountering a cleared replacement pointer.

However, slot_store() can still call remove_and_add_spares() without an
array suspension when a user writes "none" (slot =3D=3D -1):

drivers/md/md.c:slot_store() {
    ...
    clear_bit(Blocked, &rdev->flags);
    remove_and_add_spares(rdev->mddev, rdev);
    if (rdev->raid_disk >=3D 0)
        return -EBUSY;
    ...
}

Similarly, the MD cluster component updates the array configuration in
check_sb_changes() by calling remove_and_add_spares() while the array is
not suspended.

Could normal I/O still increment nr_pending on a replacement drive just
before remove_spares() removes the faulty drive and clears the replacement
pointer in these paths, reproducing the exact TOCTOU crash this patch
aims to fix?

> @@ -10196,11 +10203,12 @@ static void md_start_sync(struct work_struct *w=
s)
>  		 * As we only add devices that are already in-sync, we can
>  		 * activate the spares immediately.
>  		 */
> -		remove_and_add_spares(mddev, NULL);
> +		if (suspend)
> +			remove_and_add_spares(mddev, NULL);
>  		goto not_running;
>  	}
> =20
> -	if (!md_choose_sync_action(mddev, &spares))
> +	if (!md_choose_sync_action(mddev, &spares, suspend))
>  		goto not_running;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630075640.1081=
634-1-abd.masalkhi@gmail.com?part=3D1
