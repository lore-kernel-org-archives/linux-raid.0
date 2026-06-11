Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1CB30C366
	for <linux-raid@vger.kernel.org>; Thu, 11 Jun 2026 08:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781167795; cv=none; b=pHt/LjIBJvgLL4NhzGm0bFjG2CIjLYZzPigkGiUfcewDcarWZ5y+orSMrm8991B7wt8uBzdFxRNF41FpT9VUA8W45nHmjRFIuqYvy2jhYN1iQAknXNXpUJh2KQFsqt6YvdgI6bPzmW3qiFbkA+dJUtE512mI50ZatphYZdnAXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781167795; c=relaxed/simple;
	bh=NaGKxT6Dd3ADn04ATthbu0ECI/lCHQ8vnjdn7KBD3rg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d0hNrxrcRsVg05UJ43AKTPkHCoiumkGYjcovUVUTc3rPYPUAtjZ/Rx0p4oz83NXTut0ocaTHRb1f25S/w1RYTcqec1+dx9xd3B5YU0mgXqV/0vN6BLZWn3q+dd54VetP2dPhT7uiknEee6aazDzwYwYVqi2g39JVrTsYoXLxkMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPv9y5Ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPv9y5Ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E078E1F00898;
	Thu, 11 Jun 2026 08:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781167794;
	bh=OPlMOzTV3+ONHk2NdfelbDB8XXld9UDX5XwGTOHDn+c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SPv9y5VeAaZBvnC4ehiL0D33AuGC/ihCVPodCmR5tQwocCGzT/9NUhzAzDKvvx0b9
	 KxZRk6b0bUsPn2HmOsIlbwrzcuQVNlJVAZ2Gs5jofHb6eVaIReX8ytKtRh+5s1JGyn
	 MFzEG7u/H9HjoFq1NvvgR4PoTr6QYP92FBsZRPStUNW3OoroZ3upzYE4wdCYxW/2es
	 7hSMdfVqou9bKXNVarOzx7YgtEFzaB7CIozDX6EENV/Ekf2VJwCyvB1YEPhUDLXX5F
	 +4Ud9L7qOQwPB81eXwf6HbgZS92B6KBGd4zABT0hMbfNFBMm5xtfYWgC0NOkz5xOzD
	 ZR6u72pMJ5vow==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid1: honor REQ_NOWAIT when waiting for behind
 writes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260611083514.754922-1-abd.masalkhi@gmail.com>
References: <20260611083514.754922-1-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 08:49:53 +0000
Message-Id: <20260611084953.E078E1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Leaking pre-allocated `r1_bio` when `REQ_NOWAIT` reads fail `wait_=
read_barrier()` during retry.
- [High] Permanent barrier leak if a REQ_NOWAIT write encounters a blocked =
device.
- [Medium] REQ_NOWAIT semantics violation: memory allocations use GFP_NOIO =
unconditionally.
--

commit 7fed7389f4fe20e79eece974eaf3b8d317519e27
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid1: honor REQ_NOWAIT when waiting for behind writes

This commit ensures that raid1 consistently honors REQ_NOWAIT reads
across paths that may otherwise wait for behind writes. It modifies
bitmap_wait_behind_writes() to return early instead of sleeping if
the nowait flag is set.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 5b9368bd9e700..d03da046a5920 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -1360,8 +1361,7 @@ static void raid1_read_request(struct mddev *mddev,=
 struct bio *bio,
>  	 * Still need barrier for READ in case that whole
>  	 * array is frozen.
>  	 */
> -	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
> -				bio->bi_opf & REQ_NOWAIT)) {
> +	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector, nowait)) {
>  		bio_wouldblock_error(bio);
>  		return;
>  	}

[Severity: High]
This is a pre-existing issue, but does this early return leak the=20
pre-allocated r1_bio when wait_read_barrier() fails during a retry?

When a REQ_NOWAIT read fails its initial attempt, it is queued to the=20
retry_list and handled by the raid1d thread via handle_read_error().

That function passes the existing, pre-allocated r1_bio back to=20
raid1_read_request():

drivers/md/raid1.c:handle_read_error() {
    ...
    raid1_read_request(mddev, bio, r1_bio->sectors, r1_bio);
    allow_barrier(conf, sector);
    ...
}

If the array is concurrently frozen, wait_read_barrier() returns false=20
since REQ_NOWAIT is still set on the master bio. The code handles this=20
by returning immediately, bypassing the err_handle cleanup path and=20
failing to call raid_end_bio_io().

Since handle_read_error() assumes ownership was taken and only releases=20
its old barrier, does this result in a permanent memory leak of the=20
r1_bio from the r1bio_pool mempool?

[Severity: Medium]
This is another pre-existing issue, but does the allocation path for=20
REQ_NOWAIT bios violate block layer non-blocking semantics by=20
unconditionally using GFP_NOIO?

Even when REQ_NOWAIT is requested, alloc_r1bio() uses GFP_NOIO=20
unconditionally:

drivers/md/raid1.c:alloc_r1bio() {
    ...
    r1_bio =3D mempool_alloc(conf->r1bio_pool, GFP_NOIO);
    ...
}

Similarly, bio_alloc_clone() in raid1_read_request() unconditionally=20
uses gfp flags that include __GFP_DIRECT_RECLAIM.

Since mempool-backed allocations will sleep under memory pressure=20
instead of failing immediately when these flags are used, will this=20
cause unexpected high latencies and potential priority inversion in=20
asynchronous contexts?

[Severity: High]
This isn't a bug introduced by this patch, but does=20
raid1_write_request() permanently leak the barrier if a REQ_NOWAIT=20
write encounters a blocked device?

In raid1_write_request(), the code successfully acquires a barrier by=20
calling wait_barrier(), which internally increments conf->nr_pending.

Immediately after, it calls wait_blocked_rdev():

drivers/md/raid1.c:raid1_write_request() {
    ...
    if (!wait_blocked_rdev(mddev, bio)) {
        bio_wouldblock_error(bio);
        return;
    }
    ...
}

If the device is blocked and the request is REQ_NOWAIT,=20
wait_blocked_rdev() returns false and the function returns early.=20
However, it fails to call allow_barrier() before returning to drop=20
the previously acquired barrier increment.

Because freeze_array() waits for nr_pending to reach 0, could this=20
permanently prevent the array from ever freezing again, deadlocking=20
resyncs, reconfiguration, and array teardown?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611083514.7549=
22-1-abd.masalkhi@gmail.com?part=3D1
