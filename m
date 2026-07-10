Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3E13C1974
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690816; cv=none; b=rjnqPOWbR7drHpqEG5sM1c3D6aYCxf8KORGKip/MMyJVhrcATpl2Nz4JdWTDnNMggFCiRCFfWv5KlthCYwHKKDAZDXUv0O5xFQgDZFLFNrfBj0Ng2QHsse842lOyhzUQYRSuN7enF/bQmNN7QHeze7jIr+GaJH1fSv/tDvN6ozs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690816; c=relaxed/simple;
	bh=G2mgY3yc17WSXGZAKH8DsxjRG4X8QpGfN2OTyMMjURk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A6G2U/SrFLsqkXvTC7FSWijx8A2iNtvjRnLyesjiCd8bwJM0rozvQWTcrk1muyqrIXUu46UB1khWnW4pTCvi8t6ZRQCYPvC5IduewiFt9QzQhoZ26JyWASrmLb7qD2XV3FpNwTyNkqMrgPJIeg8gSCKKqGfRayZ8+12a5GURReA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUJ+GfmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUJ+GfmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D761F000E9;
	Fri, 10 Jul 2026 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690815;
	bh=lUAcoA9ZMwo+tpcvpWE09Us2XPWtG4hc+gKX9rk+ivw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PUJ+GfmFttlSYKLORtVDFJMKb7HIqHN1gTJ9JmWs8XZIVfsJ9UDht6gRTOyrZordn
	 bMR7AinTmMzZgwtaEyTusdN+xgaS/p3zSbMqCdJFwBUvKXv/fHQ2Vf1Rkhc7fwm9LE
	 5hk2dgu4UBwureCcSkPAmeO/fndDgXJvkdG5y6mlnRkjfu9YFsyT50IebeNL0S+mfx
	 KHfe+Jy1G+UZUZn3unrC29DmgXOIgUbyje68HQFlbwn119UpfxTLN1MpBm4yTUSUHQ
	 kL4+jC6v9IrZIInUzbFmIGkUVQ2XrvNVFeszZgja1WXz+uvfe3jEoIkaoci7sFMDKd
	 nnrx49c1+RYfg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] md: widen badblock sectors param from int to
 sector_t
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260710132329.7273-3-nishidafmly@gmail.com>
References: <20260710132329.7273-1-nishidafmly@gmail.com>
 <20260710132329.7273-3-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:40:13 +0000
Message-Id: <20260710134014.29D761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Arithmetic underflow in `is_badblock()` when a physical bad block =
overlaps `data_offset`.
- [High] Discarded macro results in `block/badblocks.c` make block alignmen=
t a no-op.
--

--- Patch [2]: [PATCH 2/2] md: widen badblock sectors param from int to sec=
tor_t ---
commit 19521e4f1c32c01e7a6122a185436691618d94c1
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md: widen badblock sectors param from int to sector_t
   =20
This commit changes the sectors parameter in md wrappers (rdev_set_badblock=
s,
rdev_clear_badblocks, and rdev_has_badblock) from int to sector_t. This
matches the core API and is_badblock() to prevent a truncation point.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..61f40fa41e781 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -10553,7 +10553,7 @@ EXPORT_SYMBOL(md_finish_reshape);
>  /* Bad block management */
> =20
>  /* Returns true on success, false on failure */
> -bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, int sectors,
> +bool rdev_set_badblocks(struct md_rdev *rdev, sector_t s, sector_t secto=
rs,
>  			int is_new)
>  {

[Severity: High]
This isn't a bug introduced by this patch, but since this code interacts
with the core badblocks API, I noticed a pre-existing bug in how block
alignment is handled in block/badblocks.c.

In _badblocks_set(), the code attempts to align sectors:

block/badblocks.c:_badblocks_set() {
    ...
    rounddown(s, 1 << bb->shift);
    roundup(next, 1 << bb->shift);
    sectors =3D next - s;
    ...
}

Similar logic exists in _badblocks_clear() and badblocks_check().

Because rounddown() and roundup() are macros that evaluate to the rounded
value but do not modify their arguments in-place, aren't the alignment
results being ignored here, leaving s and next unaligned?

If bb->shift > 0, wouldn't this break bad block alignment, fragment the
bad block table, and risk premature table exhaustion?

[ ... ]

> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b9ad26844799d..95835a3286aac 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h

[ ... ]

> @@ -311,7 +311,7 @@ static inline int is_badblock(struct md_rdev *rdev, s=
ector_t s, sector_t sectors
>  }
> =20
>  static inline int rdev_has_badblock(struct md_rdev *rdev, sector_t s,
> -				    int sectors)
> +				    sector_t sectors)
>  {
>  	sector_t first_bad;

[Severity: High]
This is a pre-existing issue, but while reviewing the badblock sector types,
I noticed a logic error in is_badblock() located just above this function.

drivers/md/md.h:is_badblock() {
    ...
    int rv =3D badblocks_check(&rdev->badblocks, rdev->data_offset + s,
                             sectors, first_bad, bad_sectors);
    if (rv)
        *first_bad -=3D rdev->data_offset;
    ...
}

If userspace tools (e.g., mdadm via sysfs bb_store) write a physical bad
block that starts before rdev->data_offset but extends into the array's data
area, badblocks_check() returns a *first_bad physical sector less than
data_offset.=20

Could the unconditional subtraction (*first_bad -=3D rdev->data_offset)
underflow here?

Would this create a massive false first_bad sector value, causing callers
like raid1 to mistakenly issue I/O to a known bad sector?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132329.7273=
-1-nishidafmly@gmail.com?part=3D2
