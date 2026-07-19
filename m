Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25881E531;
	Sun, 19 Jul 2026 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784460057; cv=none; b=Ev+AiqDub7KVWe6fNQEmu8mw5Qr4TEO7lDt9lhb1Z97XT19RK0pLyhJy/KEJ5vL1/dpu0W+a/8eSgFpROo4+Qg3LD3I+2WeghOdoFPtRH3Hw5tZcPB8VTQQODwbPd0rKVnS+1Ecx4A/uu5y49s6esQ3LH0ZKVtWhghbP2S0Pmq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784460057; c=relaxed/simple;
	bh=e7mbOyVCQWdBhI0rJuxG1QYS3hPCYztlpiaUXKKUy0E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Su8Oj4wD467nN+4My/Xv6xZ6Qvle+2/Z9V1sAMalHKVbxME/oVOCkFsTt+jvTZlDlKjt63mo07m+hFP2qCecdXVq/Lt61fSLDcYk8W3kFLd0H+HpsHGuTZeKmeb8XRRvHx+I+Rpy0YDhQzC8yL6/EXIdPe5eupGxDRsF0gBlIE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b39/ELgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b39/ELgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F201F000E9;
	Sun, 19 Jul 2026 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784460056;
	bh=LCrma1I/f2IGlnHDFLFLXtmJkpEBMQX+nfD3WJ6fZ0M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b39/ELgId8g6erwu+vSq+EnVh61PlzyU8zMhjY34Ko/y3FZf788tr0yKA5Ve6trH2
	 Znfy5MejGqIu0ZXLd+jI/thrUHtNeyqJ0jkSk+sf9hLydh043d1Y6N2SsEA3TY4Rhj
	 K0YN2wWTZ8sfyESCnYTPQbhGhULvOAnn+Cx1MgXMbPuTw+r7TEANE4kiTK8dsXkKzU
	 3QACM475eSh+VmSUL10+N4sZhHY0qWz4My5o/rtmdjpYqUmxyPJcSdQ9xwP6M03JIq
	 ul2HXpUnNsCoT354lkFlWH4BNfCsYHcOsRUmL8DcPSym2qSphMVtrph5glHg9nv+e3
	 +cS4euZ+a8Cdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/7] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260719105327.864949-6-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-6-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:20:55 +0000
Message-Id: <20260719112056.34F201F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] The newly added `md_bio_is_p2pdma(wbio)` check evaluates a cloned =
bio after its operation type has been forcibly overwritten to `REQ_OP_WRITE=
`, defeating the `bio_has_data()` guard and leading to a kernel panic for d=
ata-less bios.

Pre-existing issues:
- [High] Pre-existing data integrity bug: `narrow_write_error()` unconditio=
nally overwrites `bi_opf` to `REQ_OP_WRITE`, silently stripping essential f=
lags like `REQ_FUA` and `REQ_PREFLUSH`.
- [High] Pre-existing block layer crash: `narrow_write_error()` blindly ove=
rwrites data-less operations with `REQ_OP_WRITE`, submitting invalid bios t=
o underlying block drivers.
--

--- Patch [5]: [PATCH v2 5/7] md/raid1,raid10: keep REQ_NOMERGE on narrow_w=
rite_error() retry clones ---
commit 21dea61208137a1862fe54775b5bbeea8b5691ab
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones

This commit fixes an issue where narrow_write_error drops the REQ_NOMERGE
flag on P2PDMA bios during a write error retry. It adds a check to restore
the flag for P2PDMA bios, preventing invalid merges across pgmaps.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 914fb86452c03..f562b6bd438b9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2573,6 +2573,9 @@ static void narrow_write_error(struct r1bio *r1_bio=
, int i)
>  		}
> =20
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This isn't a bug introduced by this patch, but does the unconditional
assignment to REQ_OP_WRITE in narrow_write_error() strip essential flags
like REQ_FUA and REQ_PREFLUSH?

If an I/O error occurs on a write that carries these flags, dropping them
could silently break flush guarantees and cause data corruption after a
power failure. Could we preserve the existing flags via a mask instead?

[Severity: High]
This is also a pre-existing issue, but does overwriting data-less
operations with REQ_OP_WRITE in narrow_write_error() submit invalid bios
to the block drivers?

When operations like REQ_OP_WRITE_ZEROES fail, they are transformed into a
standard write with a non-zero bi_size but no initialized data vectors.
Attempting to map this payload for DMA via bio_for_each_segment() might
dereference uninitialized memory and cause a crash.

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;

[Severity: High]
Does checking md_bio_is_p2pdma() immediately after forcing the operation
type to REQ_OP_WRITE defeat the bio_has_data() guard?

Because the operation is now a standard write, bio_has_data() will return
true even for originally data-less operations. This would cause the function
to evaluate the uninitialized page pointer in the bio vector, potentially
leading to a kernel panic. Should the check evaluate the original bio
instead of the modified clone?

>  		wbio->bi_iter.bi_sector =3D r1_bio->sector;
>  		wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;

[ ... ]

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..f7ef903a3d4ec 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2831,6 +2831,9 @@ static void narrow_write_error(struct r10bio *r10_b=
io, int i)
>  		wbio->bi_iter.bi_sector =3D wsector +
>  				   choose_data_offset(r10_bio, rdev);
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This isn't a bug introduced by this patch, but this overwrite has the same
issue as in raid1.c. Does this unconditional assignment strip operation fla=
gs
like REQ_FUA and REQ_PREFLUSH, leading to potential data integrity issues?

[Severity: High]
This is also a pre-existing issue, but does this similarly submit invalid
bios to the block layer by changing failed data-less operations into standa=
rd
writes without initialized data pages?

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;

[Severity: High]
Similar to the raid1.c code, does calling md_bio_is_p2pdma() right after
the operation code is forced to REQ_OP_WRITE neutralize the bio_has_data()
guard? Evaluating the uninitialized memory for data-less operations could
cause a kernel panic here as well.

> =20
>  		if (submit_bio_wait(wbio) &&
>  		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D5
