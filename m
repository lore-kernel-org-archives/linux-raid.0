Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7249244781F
	for <linux-raid@vger.kernel.org>; Mon, 31 Aug 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198646; cv=none; b=hjRGoblVP1j6HAARNiof2bWYUY1HVMsWugmNTAzNVff76pZzUxMONjPsVwrou88zlZwONw9NwsaK+gXDQgVQcZYOW1hd/6z041GdlqTvAw/H5gRhLocz7oAOa+rqlg5e0eu2YG+zvjRgK7BCK65VQ0vCiAYRr+zsBWFkTU8+CCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198646; c=relaxed/simple;
	bh=dPjcjy6NB1Efs03bLQdd+Pzldo4gTvOPSd0/YpS/xNQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pj7mqtGLpZQUZwp855mBQFp/Bz7zI+ER8TSVC6nthZHdq6tPz+wz8gbnhV5JY6gjFxIeCXHClaROkzP1zW9XAdxmpprx1Ik1PgQBH91Srs5xZrRfAd2Kn35r6EoP/KSek7xaKV6tC7VTj6yQb8YphipmD6ziFcWk431caiE0YqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QwF1vP4N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QwF1vP4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D162C1F000E9;
	Mon, 31 Aug 2026 17:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788198645;
	bh=63vIZeTrxIt0oZAvXLZWruo6tpbt/Mmuh3j9T+0lKY0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QwF1vP4Nw4l6PlMrTycyxW0rYzxCxK05TvH1JMIBT4KM2D2bSdgsjmvvjtfk3wlhl
	 XUw1bHURc7RdURc6Tcj0Z13FrlfuqmCz8IBexS8IkXT4ZsbBlsB5vUf6uedjmDNuUM
	 VtwpQVziHdKmjKxPCAR6Ou/F+8UJ//TUWe7dn3yRlpEFpcMRAMqtj6lRzSuFvfVi8Q
	 qLW8lwXnNOlPxSZSXSLxFSzRYquxgIKOjJI/0kDWnfdx7JUN4KZjiI51R8pTvD0hsd
	 Hzu6vDzgmc6pXCE+IDbvC9lnkOF+kKt2F8voEXDNpRYkNdYSCp4jtTMQ7lSlCUdsbH
	 3YpDbk3chWhaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.15] md/raid5: account discard IO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260831133314.4125787-655-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-655-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 17:50:44 +0000
Message-Id: <20260831175044.D162C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Discard bios are leaked (never completed) if REQ_NOWAIT is set or =
a reshape is in progress.
--

commit 411f7ab7bd6961f4f041d0cc04dc0f2c9fb67a13
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: account discard IO

This commit adds discard IO to the md-device iostat accounting for RAID5,
which was previously bypassed. It trims the bio request to the full data
stripes before accounting it, then restores the iterator to ensure correct
bio completion and iostat coverage.

Link: https://patch.msgid.link/20260605072639.2434847-2-yukuai@kernel.org

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 24b32a0c95b40..a163d33b0e075 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5685,7 +5685,10 @@ static void make_discard_request(struct mddev *mdd=
ev, struct bio *bi)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	sector_t logical_sector, last_sector;
> +	sector_t first_stripe, last_stripe;
>  	struct stripe_head *sh;
> +	struct bvec_iter bi_iter;
> +	struct bio *orig_bi =3D bi;
>  	int stripe_sectors;
> =20
>  	/* We need to handle this when io_uring supports discard/trim */
> @@ -5696,19 +5699,29 @@ static void make_discard_request(struct mddev *md=
dev, struct bio *bi)
>  		/* Skip discard while reshape is happening */
>  		return;

[Severity: High]
This isn't a bug introduced by this patch, but does returning early from
make_discard_request() without completing the bio cause an I/O hang?

When a user task issues a discard to a RAID5 array undergoing a reshape,
raid5_make_request() calls make_discard_request(). If it takes these early
returns without calling bio_endio(bi), the bio is leaked. Because the
caller assumes the bio was handled and returns true, the task hangs
indefinitely waiting for completion.

Should these early return paths complete the bio to avoid leaking it?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831133314.4125=
787-655-sashal@kernel.org?part=3D1
