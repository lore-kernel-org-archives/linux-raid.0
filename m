Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF411AAE28
	for <linux-raid@vger.kernel.org>; Sat, 13 Jun 2026 18:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781376044; cv=none; b=c6M6NsiiPmscM9WnoF2rpT6c3QrfXS3enRoWODerwZM0h1CkybD2RDjMnE+hiUZ//eV85slZWzerU3WpV0dAehbAm5mUd3dWYg7J4eAXURWNVQLhqkukP5ubZncIKZXJ6H4SL96ebkk8yi1p9Tdd6pIRmbD4HMwThWrYSYQHTsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781376044; c=relaxed/simple;
	bh=4TwglVIGIHWhjQWcdtExkqM+/s1gtQ6g+ANnWgpHE30=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LO9HJnz7tq361m/9BhV7aUoq4b7Yvlzhyk59VvNwyxBUqd8oWEZNQaksn0VyvrfvgFnfUhYQS93iI9Whn3/oHJjepDpk8O4kSPnlZdbE+UwXRJNN5TwV54EJJO94cReafIlU+qeuOHUpYYJezEQ3KSgM3EAfUzrJAV0xkhnGLQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Etf7nQ4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Etf7nQ4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEC01F000E9;
	Sat, 13 Jun 2026 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781376043;
	bh=/igdRv6JmXuZAPvz9d76zUHjo4q+4W1CKEtUHRbuOZw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Etf7nQ4CMRfKzhmiqy8ginDHJ6cge1csO34YkwJn/ANCqZAQE8mtG0jdMtBU17NUw
	 YzqjtmcTdbf2sUOO7jhYWGlXvlBEqXe5KshwSjPht/b1hH2wg0a6aVCHU347VBVCU2
	 d5zR03ndHcQ3GWYlhKLsjwoh+/ps/+2PtUJkv/c5oktsVDiOyVX7UOzvECIncz6+JO
	 abvReps3pX8ZJ/F2bjNQVCLmOmsrjGy3gGrJz0ap0Nh9Xr+0TZ1Ov7kiTovHuG6fKJ
	 sJzAgLmT3huYwEvsePVCQS0/Du+fvKr51hskYmPWtEN7MALb74kNfcI34+So/NYUAK
	 kDWyXLFJj0SuQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] md/raid10: fix writes_pending leak on write
 request failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260613182810.1317258-3-abd.masalkhi@gmail.com>
References: <20260613182810.1317258-3-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 13 Jun 2026 18:40:42 +0000
Message-Id: <20260613184042.BCEC01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `r10_bio` structure allocated from the mempool is leaked when =
`raid10_write_request()` bails out early due to `REQ_NOWAIT`.
--

commit 3940ccdb4c7c7e19c20f9b5e2e1d12545c2558b5
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: fix writes_pending leak on write request failures

raid10_make_request() acquires a writes_pending reference with
md_write_start() before dispatching write requests. Several failure
paths in raid10_write_request() complete the bio and return without
reaching the normal write completion path, causing the corresponding
md_write_end() to be skipped.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cee5a253a281d..c123a8c76ddcd 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -1365,7 +1365,7 @@ static void raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		/* Bail out if REQ_NOWAIT is set for the bio */
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			bio_wouldblock_error(bio);
> -			return;
> +			return false;

[Severity: High]
This isn't a bug introduced by this patch, but does this early return leak
the r10_bio structure?

__make_request() allocates r10_bio using:
    r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);

It then passes it to raid10_write_request(). When the bio has REQ_NOWAIT set
during a clustered area resync, we complete the bio with an error and return
false without freeing the r10_bio. Could repeatedly triggering this exhaust
the r10bio_pool, causing deadlocks on subsequent operations?

Note that the regular_request_wait() error path right below correctly calls
free_r10bio(r10_bio) before returning.

>  		}
>  		for (;;) {
[ ... ]
> @@ -1398,7 +1398,7 @@ static void raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			allow_barrier(conf);
>  			bio_wouldblock_error(bio);
> -			return;
> +			return false;

[Severity: High]
This is a pre-existing issue, but does this path also leak the r10_bio
mempool allocation when waiting for a reshape metadata update?

Similar to the clustered area resync case above, the r10_bio allocated in
__make_request() does not appear to be freed before returning here.

>  		}
>  		mddev_add_trace_msg(conf->mddev,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260613182810.1317=
258-1-abd.masalkhi@gmail.com?part=3D2
