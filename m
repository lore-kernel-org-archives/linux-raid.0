Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFF83B2AA
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690501; cv=none; b=c6irWITnbiYd0XI7yG9CRTiKbbU0N92CewWvIghpVEzLy9UIh7Zm0fTtU19rHcVw+ZHLytFF2y+IBxjFuy2HhlPuicmY+d/tb2geE7eWKNHLo9yv15E+z136tv2fK3U7dkithjQ9JVwBFkEuUJrd63BePdsAHzLuG97qvo0tgj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690501; c=relaxed/simple;
	bh=KlfuIMRy1boqnkFwjsaVkTy+7xcVKSfr2zgWLUZ4ti0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tg/eMmRGSN/AcOmSaYJHdPOKbrHwhJTozEBb79xsBSOcRtfpcR4+SszOpX4YIMIqHWb6Qz6BezsG2F6uf6N2d7Us0AqtczfDa2F5LPBap+dvRUcF+6InVlmIS2l9tgEylf12eXWGqEGE2i/ThOoxzoGqQ2icRWGBYIEa29az3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J/F7tftS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J/F7tftS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C921F000E9;
	Fri, 10 Jul 2026 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690499;
	bh=xL2nQo9gJkBXCFrV2sdqtQ2X9nbpbDV78H8y2Hy6eF4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J/F7tftSDqzL9kQRuxLK57FC9yS8SG9MtivC8zNHb+Zfjl4pcyuG0q3fCpi7+1tUC
	 TvkGycIlQgfnOo4dW6PC+EGGNHFIaKvubtC9XBZrVutj2LSCOOapAVNKEws/weZIt3
	 di2+hkzerO5fQGB6IUDGfnou3VfAojC9mB9hFRF2tuDAzAY1DJ1WQdWmK8n86Apx9v
	 Bt+mJ9KT5/9PKzgXA2Ub3MoKeZWkpuO21o0DC+6A7Z56VAWiQ3Sp9Hj4iwfSAtetUu
	 0H3hXlVHKTYthzezRuHbfYQzwqGS2d2L4/bdb1gqudEWTEg9/0yI+cuULMBICsOEPw
	 QXBxt7eSlB6/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] md/raid5: reserve stripe cache for user I/O during
 rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260710132339.7284-3-nishidafmly@gmail.com>
References: <20260710132339.7284-1-nishidafmly@gmail.com>
 <20260710132339.7284-3-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:34:59 +0000
Message-Id: <20260710133459.A6C921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The newly added stripe cache reservation logic is completely ineff=
ective because it fails to throttle the calling loop in md_do_sync().
--

--- Patch [2]: [PATCH 2/2] md/raid5: reserve stripe cache for user I/O duri=
ng rebuild ---
commit fb8a80692f7a386d69a8bee1d9b364db1d33380f
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: reserve stripe cache for user I/O during rebuild

This commit attempts to prevent burst-starvation of user I/O during a RAID5
rebuild by reserving a portion of the stripe cache. It adds checks in the
read-ahead loop of raid5_sync_request() to yield when there is competing
user I/O.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 574880e4f23fe..6575bdb84bb23 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6656,6 +6656,27 @@ static inline sector_t raid5_sync_request(struct m=
ddev *mddev, sector_t sector_n
>  	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
>  	     win_sector < mddev->resync_max;
>  	     submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
> +		/*
> +		 * Yield to user I/O: stop the read-ahead if anyone is waiting
> +		 * for a stripe.  The check is intentionally racy -- a waiter
> +		 * appearing just after is serviced by the next sync_request
> +		 * call, so no barrier is needed.
> +		 */
> +		if (waitqueue_active(&conf->wait_for_stripe))
> +			break;
> +		/*
> +		 * Reserve cache for user I/O only when it is actually competing.
> +		 * preread_active_stripes counts stripes queued for write I/O
> +		 * (including the read phase of RMW); sync stripes never set
> +		 * STRIPE_PREREAD_ACTIVE, so during a pure rebuild it stays zero
> +		 * and the window fills freely.  Competing user reads do not bump
> +		 * the counter but are caught by the waitqueue_active() check
> +		 * above.
> +		 */
> +		if (atomic_read(&conf->preread_active_stripes) > 0 &&
> +		    atomic_read(&conf->active_stripes) >=3D
> +		    conf->max_nr_stripes / RAID5_SYNC_HWMARK)
> +			break;

[Severity: High]
Does this actually throttle the rebuild as intended?

When we break out of this loop here, raid5_sync_request() returns the number
of sectors processed so far back to md_do_sync(). Since md_do_sync()
continuously loops calling the sync_request handler until the rate-limit wi=
ndow
is met, it will immediately call raid5_sync_request() again.

When raid5_sync_request() is re-entered, the very first stripe is allocated
unconditionally without checking the high-water mark:

drivers/md/raid5.c:raid5_sync_request() {
    ...
	sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, R5_GAS_NOBLOCK);
    ...
}

Will the sync thread just rapidly consume stripes one-by-one, completely
bypassing the 50% cache reservation and filling the cache 100% anyway?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132339.7284=
-1-nishidafmly@gmail.com?part=3D2
