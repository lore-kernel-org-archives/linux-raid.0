Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40AD409614
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 09:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501620; cv=none; b=Anbl7/x1Hxn81xnn/HJskEMNIYf5xGbJkm2QxpGYoJZCTbtqTtHdZBY0rTRtZt3UFVafPNuwsIZunrXUViHFWt5RrwLSIFdEufWKtHL5CQJhxrYCl/eKi87FTJxu4sBjdrtNaNeOYj1qOScaU19thmIrJnW2rqsVTo9rA8XAggE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501620; c=relaxed/simple;
	bh=ZxusXYQL32ak7oMoCeyrJDgxljR0wrPj2lrv0EnKzDo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aCGhKjq56JsPKgAmzROqqCV+I2IoKQiYDmMf/OZ7Ik3X27lsNFGxpywxhDpQrtvTLRaNBGa1ddmbQMVpzpUxlyNd0fClQgCPAic4x9g0JyrCYRS7ObfYbdXuyZcabO46p7RxVQj1TTFa2qnhSQS54j8IsFoiYu6C/OUX9F0/VP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j28jCZLo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j28jCZLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8567A1F000E9;
	Wed,  8 Jul 2026 09:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783501618;
	bh=PfdsasGRuj40gQKKR00+s7dQTWMd7IA7wb4QiDA8ffE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j28jCZLowbKuode6PZ0LbbsDZ0aDOR/mWcwWTmA23AesakzF/L1TJ3CT8TIfYlOtX
	 g3Ystq4Maogy+xoJn8Esoz+W3c1XvwD7x81kIsTgEHXnoTw6oGyVKtPpnjVx4/eIgA
	 dtSicZL2X8j3qkHkVyihXqUPqBywpZt6XHfN/J4QPZnvQAHWEZSPmoLll9mDuLpnKa
	 3H8iSsR7N9T5YLPZKm2nzQOrDUThiQdCb9DNqXnyjLdN4QVAwYHSqj8h+j2VXBAkqS
	 hib39q23sDm8TFW6B84amRqs3p3V8bHSGz/Kzh1IEWutPxmxgIdqirS9j5Uk0kItq1
	 bPfOnRQnG+MDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid10: free r10_bio on write NOWAIT exits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260708084701.737763-1-lgs201920130244@gmail.com>
References: <20260708084701.737763-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 09:06:58 +0000
Message-Id: <20260708090658.8567A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The MD layer and RAID10 driver sleep in multiple paths while handl=
ing a `REQ_NOWAIT` bio, violating the non-blocking semantics of the block l=
ayer.
- [High] The driver unconditionally uses `GFP_NOIO` for mempool and bio all=
ocations, which can sleep when memory is low, violating `REQ_NOWAIT` non-bl=
ocking semantics.
--

--- Patch [1]: [PATCH] md/raid10: free r10_bio on write NOWAIT exits ---
commit 2e30580bb5bb2ae342c9d924bf8c217f5b6c832f
Author: Guangshuo Li <lgs201920130244@gmail.com>

md/raid10: free r10_bio on write NOWAIT exits

This commit fixes a memory leak in raid10_write_request() where the r10_bio
structure was not returned to the mempool on two REQ_NOWAIT early exit
paths. It ensures free_r10bio() is called before returning false for these
NOWAIT cases.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..d480344c5b8f3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1364,6 +1364,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		DEFINE_WAIT(w);
>  		/* Bail out if REQ_NOWAIT is set for the bio */
>  		if (bio->bi_opf & REQ_NOWAIT) {
> +			free_r10bio(r10_bio);
>  			bio_wouldblock_error(bio);
>  			return false;
>  		}

[ ... ]

> @@ -1397,6 +1398,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		md_wakeup_thread(mddev->thread);
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			allow_barrier(conf);
> +			free_r10bio(r10_bio);
>  			bio_wouldblock_error(bio);
>  			return false;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but are there other blocking
operations in the NOWAIT path that could still violate the non-blocking
semantics?

If a REQ_NOWAIT bio does not hit these early exits, it proceeds down to
wait_blocked_dev() later in raid10_write_request(), which does not check
for REQ_NOWAIT:

	raid10_find_phys(conf, r10_bio);
	wait_blocked_dev(mddev, r10_bio);

If a member device is blocked, wait_blocked_dev() drops the barrier and
sleeps in md_wait_for_blocked_rdev() (which has a 5-second timeout) and
then sleeps again in wait_barrier(conf, false).

Additionally, if the bio crosses a chunk boundary, it reacquires the
barrier without checking for REQ_NOWAIT:

	if (r10_bio->sectors < bio_sectors(bio)) {
		allow_barrier(conf);
		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
					      &conf->bio_split);
		wait_barrier(conf, false);

Could these unconditional sleeps cause the thread submitting the async I/O
to stall, potentially exhausting io_uring worker threads?

[Severity: High]
This is also a pre-existing issue, but does the driver unconditionally use
GFP_NOIO for allocations when handling a REQ_NOWAIT bio?

Before raid10_write_request() is even called, __make_request() allocates
the primary r10_bio using GFP_NOIO:

	r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);

Later, raid10_write_one_disk() clones the bio unconditionally using
GFP_NOIO:

	mbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);

If the mempool is depleted and memory pressure requires direct reclaim,
won't these GFP_NOIO allocations sleep and stall the IO submission thread?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708084701.7377=
63-1-lgs201920130244@gmail.com?part=3D1
