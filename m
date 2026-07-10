Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4FD36E497
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690562; cv=none; b=dd62K6LgrGLveHqFcF3xeQSnOtH9Y+bb+51IE/PQs7Y7dNmk2fSYj2Ugt5Dc4/NTMSskOQK7yRPDOtYjV4mj/C8ndunA7hn4223UYZ89tZ6IubMeYnxhpLBJjeNbh/GGNGn7pjhjwKtCac2YNleEnf+iqwG/jcjVoCqsFu/3jbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690562; c=relaxed/simple;
	bh=BxqDYZ031rZAUbEkSTPQbYNeBvyv/HXRIDW+Tk17Mdc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VPPYc0I7GivFxlZ9l75ynHkIb6Q+t9Af1+iG6kQ1YEU4tQ3QObrmwf9bg0ewcvV2C2wqe1sIx/iklOCnuBy9XLCfoUKFdfggmpgMEAmdoxeZlSw9O1Ik1nQ6s9CSGO+Oks1ryG7R2n71gPRk579LFPNECb/bWQLqejZP3+fpxE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDiBnRXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDiBnRXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099961F000E9;
	Fri, 10 Jul 2026 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690561;
	bh=7I+UC7LuDUvOiS5MBjoPKnMu7PEEBkrwV9J8po7oCIs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PDiBnRXdJrMp+QXLR+UV9x7qDq8iTQ+Nn9UovJNfhlY46CKJuN5tqoooMpkh9zsOo
	 57XTuaovnmVb/dvCImnL858NzPOlyXkRh+nYbdLdTlUtkA3cZuBBoznKowcAjDMZ7z
	 PrANOMHER6n0dtHz/O1o8+gRzYpJoqqmLR6bRA3AJpD+I7KO6RY3MlRrNXnpf45UGm
	 LUu9lCj7geGO4XLWCY4tMYZI3XsBmFDaTBZEZ8gbuaqGksMBR6eD9B+sz8Ym6UErTC
	 0lL9TE9gqHx7g2rd0lpu+mCQ+BR8Qh6eESwVVsa+cSr38PSmoy3Cqtge0V4kc8IwtP
	 Kht90gQ8Zm6TA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] md/raid5: submit a window of stripes during
 resync/recovery
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260710132339.7284-2-nishidafmly@gmail.com>
References: <20260710132339.7284-1-nishidafmly@gmail.com>
 <20260710132339.7284-2-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:36:00 +0000
Message-Id: <20260710133601.099961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The batched sync loop can greedily drain the stripe cache without =
yielding, causing severe latency spikes and potentially starving user I/O.
--

--- Patch [1]: [PATCH 1/2] md/raid5: submit a window of stripes during resy=
nc/recovery ---
commit 2b3cdb45d82bdea6112cba5dad14b59ec3acb23a
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: submit a window of stripes during resync/recovery

This patch updates the RAID5 sync path to dispatch a batch of up to 32
stripes per call instead of just one. It throttles only on the first stripe,
allowing subsequent stripes to be submitted without blocking to improve
resync performance.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..574880e4f23fe 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -6640,13 +6632,42 @@ static inline sector_t raid5_sync_request(struct =
mddev *mddev, sector_t sector_n
[ ... ]
> +	/* Submit remaining stripes in the window non-blocking.  Stop early
> +	 * if the stripe cache is full: the disk queue is already saturated.
> +	 * Bound by resync_max so a user- or cluster-imposed sync ceiling is
> +	 * not overshot.
> +	 */
> +	win_sector =3D sector_nr + RAID5_STRIPE_SECTORS(conf);
> +	for (submitted =3D 1;
> +	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
> +	     win_sector < mddev->resync_max;
> +	     submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
> +		sh =3D raid5_get_active_stripe(conf, NULL, win_sector,
> +					     R5_GAS_NOBLOCK);
> +		if (!sh)
> +			break;

[Severity: High]
Can this batched sync loop greedily drain the stripe cache without yielding=
 to
user I/O?

During array resync or recovery, this loop acquires up to 32 free stripes
sequentially. Could this starve user I/O threads that are blocked on the
conf->wait_for_stripe waitqueue, since it doesn't check if user I/O is wait=
ing
(e.g., via waitqueue_active(&conf->wait_for_stripe)) before getting the next
stripe?

> +		md_bitmap_start_sync(mddev, win_sector, &sync_blocks,
> +				     still_degraded);
> +		set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
> +		set_bit(STRIPE_HANDLE, &sh->state);
> +		raid5_release_stripe(sh);
> +	}
> +
> +	return submitted * RAID5_STRIPE_SECTORS(conf);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132339.7284=
-1-nishidafmly@gmail.com?part=3D1
