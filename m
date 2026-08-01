Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7E1A5B9D
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606110; cv=none; b=Sbbtrqa29iA461o4JczkN9nrzffq09cqMTERVKEcCaKTLurQdYkwx3NbEg1LlawO/3yTedAeQ1EianOhRRgXFGjkiyRqGjriBCWjRqsHm6p4n/sxsyHUKBSAfcFeHazhscz2R4EVng0jWfEokYt6n6h8RllTUFvq54hdcZkFgPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606110; c=relaxed/simple;
	bh=CCR2uh/EKq8ZBLuRUjoh7p/RswHuJWVIFaq0mhCNh9s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kvu+R57N2+PnVR+Ou8+WUTLWrjfYWfYxbQ3OA2oxtUAejXg7RniiDjihr8hZ7evNXh9eOJNoP76u67FUUiNEeY8P9H1C557m3Adf9BVvswJuUfT15i4rkad+Os301y6hq1wTJ8VE4JhKJV0/3tC9Iwvqrk3anRkR8Jy5tAgkcuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ngkX3hwL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ngkX3hwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B741F00AC4;
	Sat,  1 Aug 2026 17:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606109;
	bh=3snk/iFbXRbTS111zCPsnJcTfZ8qLRhg85K1IWwqyWc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ngkX3hwLA4SWKh2d9k4fHcAVmhQz1Y5ICWnqzAyRJag+r8ooqEWezXXLlqyhTIW+I
	 agOZLFg3T0Skcf4vaegwQafvSr7eOZFUqAthsmX07/0bpc3Fk4+2EYrZQzWv1ijVNP
	 PhRo/pPEs062FFSFtHIt2EdRwRLHWhBhja4aMhv2GB5OduU3CTQdovOXfAEGGJblVe
	 TzXTuvUJMLTRjdU9M7rgPypqeiVtjZiIpKm35za5BOsXNZKRj9y8A2EiIwEykt+xb+
	 Kvhsoar1lhbsivnfEVsPE58Pbmr+08Pmf8BAC+ZAPk6vWFSO4Xp13KDngJg4dNareq
	 vUzH4n8W37uoQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/25] md/md-llbitmap: don't skip reshape ranges from
 bitmap state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-17-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-17-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:41:48 +0000
Message-Id: <20260801174148.D1B741F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer overflow in `blocks` calculation can cause `md_do_sync` to=
 skip the entire array.
--

--- Patch [16]: [PATCH v4 16/25] md/md-llbitmap: don't skip reshape ranges =
from bitmap state ---
commit 20fdc8d04a69beb6ba6a356b102dd6e6920204f1
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: don't skip reshape ranges from bitmap state

Reshape progress is tracked by array metadata rather than llbitmap.
Do not let llbitmap skip_sync_blocks() suppress reshape ranges based on
stale bitmap state before the corresponding checkpoint is persisted.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index eed3e248b730d..5597b1afcb580 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1686,12 +1686,20 @@ static sector_t llbitmap_skip_sync_blocks(struct =
mddev *mddev, sector_t offset)
>  {
>  	struct llbitmap *llbitmap =3D mddev->bitmap;
>  	unsigned long p =3D offset >> llbitmap->chunkshift;
>  	int blocks =3D llbitmap->chunksize - (offset & (llbitmap->chunksize - 1=
));
        ^^^^

[Severity: High]
This isn't a bug introduced by this patch, but can this integer subtraction
overflow?

If llbitmap->chunksize is dynamically calculated up to 2^31 sectors for
extremely large arrays, would 'blocks' overflow to a negative value since it
is a 32-bit signed int?

When returned as a sector_t (unsigned 64-bit), C sign-extends it to a massi=
ve
value (0xffffffff80000000). Could the caller md_do_sync() add this to its
position tracker, exceeding max_sectors and prematurely terminating the res=
ync
process, which would leave the array degraded?

>  	enum llbitmap_state c;
> =20
>  	if (p >=3D llbitmap->chunks)
>  		return 0;
>  	c =3D llbitmap_read(llbitmap, p);
> =20
> +	/*
> +	 * Reshape progress is tracked by array metadata rather than llbitmap.
> +	 * Skipping reshape ranges from stale bitmap state can lose data after a
> +	 * restart before the corresponding bits are checkpointed to disk.
> +	 */
> +	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> +		return 0;
> +
>  	/* always skip unwritten blocks */
>  	if (c =3D=3D BitUnwritten)
>  		return blocks;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D16
