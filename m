Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1335640BCB0
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783679512; cv=none; b=itfZnTbAO0ApzKz9/hgEYhwniMgbVnYOWj7cD7Nvg2hXb+3cw64t8jY0WNauCXa5iaB3Wh4GpLENIP9jTr25zbn3kY+efhNhsoZPwZkjlW/3bc28DoaRPt8Gm3HvECgynMroySQu8Zuuy1/dmaifCYlSzh5wJfsC440LzcltX0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783679512; c=relaxed/simple;
	bh=V70SWWFIJNksg8ci4B2Wix8FhFZgnzPWUIZTqT7Ve50=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u9p8ZIrIsh9dzouvX2DIruOtkLDmH1JJ0y/lUDbep6JrdmkyrXcDn6FHO3IlV29UEP+X6Yw0Qd9ZE2wOEj1r90z/UYE7pCLI8Z7JGwRcD31mNPs6F37BenZ/9OK/iWavAMVvdch0ewJ76vFYcQnrrYLMzZEUYmXLaxD0HCiBzm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1APjh/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1APjh/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0CB1F00A3A;
	Fri, 10 Jul 2026 10:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783679509;
	bh=PIRGCpubGuUF2fPM0iaj2RzB+/snkGZzYa8xD7xytaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g1APjh/Zh+PLYHGy3rSuWF3vz7VQdreeGXqRmNTy7jta1+rFJsCP5AmWJiKPSexB3
	 mT9UTb3LoG/HrRhdDNufjAlga/kGt7Z7zsuum2lpi5/toTg9w+qg78goW9GtZADETw
	 Zt1TfUsCPpAO7XzZp+7THbD7rtM9++sW+NUdntmwkfvb+8/wsVb6R3tY+TMvuqhaWO
	 i49eDx7BIKpNCpzQYBUkabNzfaObCFVc/PwadyLbGaZ1xT94QHXENWo+O7Hh5ZjZGi
	 bqqPynr9pXgpv2T9NgvQY3cGcYh+Q6Nc5TCa+aclV21Bd54SOQ673Bf4XBy97PCSN5
	 SLX2iNQEHfdvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/7] md/raid10: fix r10bio leak in
 raid10_write_request() error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260710101521.1714-2-abd.masalkhi@gmail.com>
References: <20260710101521.1714-1-abd.masalkhi@gmail.com>
 <20260710101521.1714-2-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 10:31:48 +0000
Message-Id: <20260710103148.DB0CB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Allocation of `r10_bio` with `GFP_NOIO` can sleep, violating `REQ_=
NOWAIT` semantics.
- [High] Functions in the IO path (`wait_blocked_dev()` and `wait_barrier()=
`) sleep unconditionally, violating `REQ_NOWAIT` semantics.
--

--- Patch [1]: [PATCH v4 1/7] md/raid10: fix r10bio leak in raid10_write_re=
quest() error paths ---
commit d87114f7731cb53cc142eafbf2338e5b721f84ad
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: fix r10bio leak in raid10_write_request() error paths

When raid10_write_request() fails because REQ_NOWAIT is set, the
allocated r10_bio is not freed before returning, resulting in a memory
leak. Free r10_bio before returning from the REQ_NOWAIT error paths.

Closes: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp=
.kernel.org/

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..bd322eccdc3ff 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1365,6 +1365,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		/* Bail out if REQ_NOWAIT is set for the bio */
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			bio_wouldblock_error(bio);
> +			free_r10bio(r10_bio);
>  			return false;
>  		}

[Severity: High]
This isn't a bug introduced by this patch, but while looking at REQ_NOWAIT
handling, it appears the initial allocation of r10_bio in __make_request()
and raid10_handle_discard() ignores the REQ_NOWAIT flag.

Both functions call:

    r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);

Since GFP_NOIO includes __GFP_DIRECT_RECLAIM, this can sleep if the mempool
is depleted.

Could this violate the strict non-blocking guarantees of REQ_NOWAIT IO and
potentially starve async workers?

>  		for (;;) {

[ ... ]

> @@ -1398,6 +1399,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			allow_barrier(conf);
>  			bio_wouldblock_error(bio);
> +			free_r10bio(r10_bio);
>  			return false;
>  		}

[Severity: High]
This is a pre-existing issue, but further down in the IO path, several
functions seem to sleep unconditionally even for REQ_NOWAIT bios.

For example, wait_blocked_dev() does:

    md_wait_for_blocked_rdev(blocked_rdev, mddev);
    wait_barrier(conf, false);
    goto retry_wait;

Also, in raid10_write_request() and raid10_read_request(), when a bio spans=
 a
chunk boundary and is split, the code unconditionally blocks:

    allow_barrier(conf);
    bio =3D bio_submit_split_bioset(bio, max_sectors, &conf->bio_split);
    wait_barrier(conf, false);

Could these calls to wait_barrier(conf, false) and md_wait_for_blocked_rdev=
()
deadlock async submitters that rely on the non-blocking guarantee?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710101521.1714=
-1-abd.masalkhi@gmail.com?part=3D1
