Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DDC1D7E41
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 16:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783787249; cv=none; b=MwC3xPfH9pNMW3pEpEExWfahQsWSVLpzyDeQikBtqWgdu8qdVi4uxLzbsW+WRW7I/Aq+e6gwlH18ImM19Mou53EOZBE6NlxzmW4tkVEIoVRRfuU/wlZPB8SmZapYy2CLuNLWf5F55whBoJ/dh0M7yfS9oFlUzYJeNjKiufqfX6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783787249; c=relaxed/simple;
	bh=sJxiy+1LnSCJgGwkW3fP/DOY9mfbSlJ9kAyr5vPggWI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gp76hNvFiIGQxVJRoeOuK6j/llEkVCIzOBATiW9dVF0PdnPeE3sDDbi40PuLlSV81dQvYLIXyTe06VdKR2LlUXu+qNppX3uLUEapEQmBGXAt+scLOjnTVl7Yw9N05AqaNL9GaGEKeyqp3hw69uDglWNlpp0UQSzS/gWklxY6wQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjaFwrWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjaFwrWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369B01F000E9;
	Sat, 11 Jul 2026 16:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783787248;
	bh=ivREvlY2C07fjWASr5KmJcaTdzJQQ/iukb+LvDasjRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TjaFwrWS3Jb5Nh93ju2ASgJnp5cN1MOVBx+PqLhErHia71q3SrsEO+c80TqVUmqxv
	 IY0lLfupl2sd+4E/5hIPuQ5/go4INa8vQ8QxnEnddE046QujTn7XzdE6bI17TilTRH
	 0JlMJaL6uoynRXc6NwcfZYSmwmFTYWyNOk6fe5A018hYPThdjJWygBVYuhBuy3V/mj
	 2JdcuwRryFYKod5A/xPzzthueoIly6msgJxXxzfVaWN7V4TKq2UMt+jzXvNLB3gvBI
	 ay44BXjrw3H0qWk47LopNSYAObC/zB0uB1uVwmhRgMUbo4CTQEhNtHrUCML9WmhSE6
	 hgwPZo5sXDNPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: complete discard bios while reshape is active
Reply-To: sashiko-reviews@lists.linux.dev
To: Genjian <zhanggenjian@126.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260711161326.962336-1-zhanggenjian@126.com>
References: <20260711161326.962336-1-zhanggenjian@126.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 11 Jul 2026 16:27:27 +0000
Message-Id: <20260711162728.369B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Completing blocking bios with BLK_STS_AGAIN violates block layer s=
emantics and causes unexpected errors in synchronous paths.

Pre-existing issues:
- [High] make_discard_request() leaks the bio and causes an uninterruptible=
 hang if REQ_NOWAIT is set.
--

--- Patch [1]: [PATCH] md/raid5: complete discard bios while reshape is act=
ive ---
commit f117d558ba13364f82645f866dea16210cadce51
Author: Genjian Zhang <zhanggenjian@kylinos.cn>

md/raid5: complete discard bios while reshape is active

This patch modifies the discard request handling to complete bios with
BLK_STS_AGAIN when an mdraid reshape is in progress. This prevents callers
from hanging in uninterruptible sleep waiting for a completion that never
arrives.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5722,9 +5722,11 @@ static void make_discard_request(struct mddev *mdd=
ev, struct bio *bi)
>  	if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
>  		return;

[Severity: High]
This isn't a bug introduced by this patch, but does this early return leak
the bio and cause an uninterruptible hang if REQ_NOWAIT is set?

If a caller submits a discard bio with REQ_NOWAIT, the driver encounters th=
is
warning and returns immediately without calling bio_endio(). Because the
caller assumes the bio was successfully handled, could this lead to a
resource leak and task hang?

> =20
> -	if (mddev->reshape_position !=3D MaxSector)
> +	if (mddev->reshape_position !=3D MaxSector) {
>  		/* Skip discard while reshape is happening */
> +		bio_endio_status(bi, BLK_STS_AGAIN);

[Severity: High]
Does completing a blocking bio with BLK_STS_AGAIN violate block layer
semantics?

Since the REQ_NOWAIT bios are filtered out just above this check, this path
is only reached by synchronous, blocking discard bios. Completing them with
BLK_STS_AGAIN will propagate an unexpected -EAGAIN error to synchronous IO
paths and userspace applications.

Block APIs typically handle BLK_STS_NOTSUPP gracefully, but passing -EAGAIN
back through synchronous paths might cause filesystem transaction aborts or
userspace failures. Should this return BLK_STS_NOTSUPP instead?

>  		return;
> +	}
> =20
>  	if (!raid5_discard_limits(mddev, bi))
>  		return;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260711161326.9623=
36-1-zhanggenjian@126.com?part=3D1
