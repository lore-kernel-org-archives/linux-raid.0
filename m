Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC4E2E7366
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782657600; cv=none; b=Z7VrvhuzsMKGVE2EhQfBd3EbdBcvYSP8ZdaPsnkKyVTTN79C/sS5hAT0TIab9Xq2Spce/Gtxcetk+HZy5ukGmI0DqNlSGTZhkxcUkdmbKZ8a6QFmJuxUVQidBBgU4EmChSlFq8dC2rdOiCWyQX5qd5g8qTCxFgKV6skV12d86CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782657600; c=relaxed/simple;
	bh=/H8CFz45nmpl4Zz3tr7S2UCmtax8m6BlBR5E1gPTpzs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BlnNUZwUvXrksEtflJu3IxIIGndCw5L3jseLZp9qmSu8ww6mhTx65KPr+uWKJun/ZJjZkCvN4ZT5mtLaREYOQYz+LxCcsU8su0KS93YkmXI7LniFLf4N1ikig6VKgUIgQvUUxyCziJSXPro0bJi4YVNMjrJhqdplguu/i/ZiYQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfXKKiRC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfXKKiRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D0D1F000E9;
	Sun, 28 Jun 2026 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782657598;
	bh=U1uQs6CoDumn6LHIndPw8lSF5MIfhFOputBJk3qEets=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YfXKKiRCxWWaMZ1YsniaODJj/LYxhkYwFMuSYjoGeECszs94nbJGTQcEowzhNnJhb
	 Px3YYW+85FJyIawqgLwnwmPxr4n6mPcKOw1n9b5RMHPvEJijNt4akumuVT2u3Oo/qM
	 zKon4gx20jmEFiWFil9uwh53cC1injWjlbYPXUieTOmrFhb9HyO34ulIhjvcW/adjf
	 y7Q5HqFey5/y0jgSJb+Hl6M0CWUBfyfbNKBeImsvc2V9Cv/RlvrG4Ik2r8jZPEeezh
	 yTFw0gtcWjzOTKV5Q3yN1zr/MRK7zr9ymP9/Ka2tek3QrQKj0OcFWh6OT60tLgDpWn
	 MH60ZWreZtloQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/7] md/raid10: fix r10bio leak in
 raid10_write_request() error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260628142420.1051027-2-abd.masalkhi@gmail.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-2-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 28 Jun 2026 14:39:58 +0000
Message-Id: <20260628143958.A8D0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Execution paths in raid10_write_request and raid10_read_request un=
conditionally block on REQ_NOWAIT bios.
- [High] Unconditional use of GFP_NOIO for r10_bio allocation can block, vi=
olating REQ_NOWAIT semantics.
--

commit d4f532acb9d5fd7506dfbbb4a12a97248c3fb429
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: fix r10bio leak in raid10_write_request() error paths
   =20
When raid10_write_request() fails because REQ_NOWAIT is set, the
allocated r10_bio is not freed before returning, resulting in a memory
leak. Free r10_bio before returning from the REQ_NOWAIT error paths.
   =20
Link: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp.k=
ernel.org/

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

[ ... ]

> @@ -1398,6 +1399,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			allow_barrier(conf);
>  			bio_wouldblock_error(bio);
> +			free_r10bio(r10_bio);
>  			return false;
>  		}

[ ... ]

[Severity: High]
This is a pre-existing issue, but does wait_blocked_dev() still block
unconditionally later in raid10_write_request() even when REQ_NOWAIT is set?

raid10_write_request() {
    ...
    r10_bio->read_slot =3D -1;
    raid10_find_phys(conf, r10_bio);

    wait_blocked_dev(mddev, r10_bio);
    ...
}

Inside wait_blocked_dev(), the code calls md_wait_for_blocked_rdev() and
wait_barrier(), both of which can block indefinitely. Can this cause
unintended latency spikes or thread starvation for userspace applications
issuing async I/O?

Similarly, in raid10_read_request(), when a bio is split across a chunk
boundary, it calls wait_barrier(conf, false) without checking the
parent bio's REQ_NOWAIT flag.

[Severity: High]
This is another pre-existing issue, but do the mempool_alloc() calls in
__make_request() and raid10_handle_discard() bypass REQ_NOWAIT semantics?

__make_request() {
    ...
    r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);
    ...
}

If the mempool is depleted and memory is low, this GFP_NOIO allocation can
block. Should this use GFP_NOWAIT for REQ_NOWAIT bios and return
BLK_STS_AGAIN when the pool is exhausted to preserve the non-blocking
contract?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260628142420.1051=
027-1-abd.masalkhi@gmail.com?part=3D1
