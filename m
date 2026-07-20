Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D413C3EC69B
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 11:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784547355; cv=none; b=qerDISBHeociYRqdDArKRG4ThX58NCMQ9Z4XrKoR+LekC/UKnRKdTtaAGFuMuOtv+B86SGrHdwdhQejhFWySLx+4s6VvJFSgH6fO4LkBlsbgy2ZpkFBHvKeHZXfrQ7wjJKF6PjHgPc5qaFkkny4FXAUwyK4mXfr5wCSWntsTG1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784547355; c=relaxed/simple;
	bh=ycH4QEWkBnwdpT4kvYjb2qij2kwfVleXAVYZU2I5f4s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cBgCUv7oaHcNrMnWefg78vH/SlFPnBJYL7AUBJB03T22wq9LehVJJMUsfpdl/LBWS2st8EgMnXZ6lP0OlrkD2XlHTdZaG5TOjWp8xYjNPfDVri0akiMmFdLO/Auzjdkr2WiZSaZ18G43haVj1oG7mHNtCReg8soiNo7bWO5GcCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rk35R6hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rk35R6hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9353D1F000E9;
	Mon, 20 Jul 2026 11:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784547353;
	bh=v/a/+JgLK/fXkZZaVl6HauVekzv9oLZ+9o7IKPh91iI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rk35R6hXMoT/u2pZc3/DvXsiOJ0Jh5dNAmu9T2CmNLsa1XytzRKiy0OPwn57bugcU
	 v4pBoXS8ScI32M3ZK2+lGXKUPQBlYf8QkI0LJndIB5BcFrtmnJLaHPAqq4kXfSwcKE
	 DGQaelCNdCuRJd/AbqGAFvsDJmbpm13QmLmeeczAp0kL4VR9KixNP2PEtS47whMP5q
	 SHleXROkCbSkAq7ncBijnGeMfhIbag41HTCPRz5nsf/2h1tmCxvLFOE8zH4DJFAgO0
	 M4n+1uPhiazcmjN5h9QuAilWV+iqteQQYPHRJnO6CBgIiJgJbmj4XZFtVCiVqx+JAo
	 KIDkCW+zwCXVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: do overflow check for sb->bblog_shift in
 super_1_load()
Reply-To: sashiko-reviews@lists.linux.dev
To: colyli@fygo.io
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260720111400.2120834-1-colyli@fygo.io>
References: <20260720111400.2120834-1-colyli@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 11:35:53 +0000
Message-Id: <20260720113553.9353D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The newly added bounds check for `sb->bblog_shift` incorrectly all=
ows values up to 63, failing to prevent 32-bit integer overflows and undefi=
ned behavior which can lead to a divide-by-zero kernel panic.
--

--- Patch [1]: [PATCH] md: do overflow check for sb->bblog_shift in super_1=
_load() ---
commit 36f9915dbd10f1c3803610b32e46390e9cb7ec7c
Author: Coly Li <colyli@fygo.io>

md: do overflow check for sb->bblog_shift in super_1_load()

This commit adds a bounds check for sb->bblog_shift in super_1_load() to
prevent possible overflows in the badblocks API. It limits the shift value
to be less than BITS_PER_TYPE(sector_t).

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..67f8edf4db368 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1920,6 +1920,13 @@ static int super_1_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor_
>  				  rdev->bb_page, REQ_OP_READ, true))
>  			return -EIO;
>  		bbp =3D (__le64 *)page_address(rdev->bb_page);
> +
> +		/* check for badblocks api. */
> +		if (sb->bblog_shift >=3D BITS_PER_TYPE(sector_t)) {
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: High]
This is a pre-existing issue, but does this bounds check still allow values
that can cause undefined behavior and integer overflows?

Since BITS_PER_TYPE(sector_t) is 64, this allows sb->bblog_shift to be up
to 63.

However, count is declared as a 32-bit signed int in super_1_load(), so the
following operation:

    count <<=3D sb->bblog_shift;

will cause undefined behavior if the shift is >=3D 31.

Additionally, downstream in block/badblocks.c (such as in badblocks_check()
and _badblocks_set()), the shift is used with a 32-bit literal:

    rounddown(s, 1 << bb->shift);

If sb->bblog_shift is >=3D 32, this can result in undefined behavior and
yield 0, leading to a divide-by-zero panic in the rounddown() macro during
array IO.

Should the maximum shift be restricted to a smaller value?

> +			pr_err("md: %pg: bogus bblog_shift %u for badblocks.\n",
> +				rdev->bdev, sb->bblog_shift);
> +			return -EINVAL;
> +		}
>  		rdev->badblocks.shift =3D sb->bblog_shift;
>  		for (i =3D 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
>  			u64 bb =3D le64_to_cpu(*bbp);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720111400.2120=
834-1-colyli@fygo.io?part=3D1
