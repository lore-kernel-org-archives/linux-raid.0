Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1AE46A5EE;
	Tue, 21 Jul 2026 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657122; cv=none; b=XLi4IpB/P8EuRsH0KXZBrTYKJRzeWymThUVIqyuwktrCj4WMAHxTYsDt9bQpQJK6rANV4qAKqlqQQ3wQw/Q12CE1hyEXt+syLhjuykGqo3Q3oDSfR6OSdJqFnaTRcc0MnfiXFjWhIle6B8ul1uiy1J8UQadPTT5XFqiuT298Ctg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657122; c=relaxed/simple;
	bh=dSNi2GZ9W+8PtQzIkINrifEDbgKQZ1zRLMFEnM9alrA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OEGk8vRS8QIBv9nbwv0q/JxqUMLYabK6V1yEXv2bw1mAheVmNreQb74o4dcClLQ0s+cd53oAdaYdGx1hxFkyubucnSupzsGbFmNWd+wwQmewNUdO2TBtK3WMFPvlzOTgZJMzPU0tPbpQ4yTpsYpsYRsR0p+xdXfaoePtbVOKWFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YcVYKicz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YcVYKicz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86811F00A3D;
	Tue, 21 Jul 2026 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784657121;
	bh=zmxkG36FLW13jQA6wqdwHlH+xDdwuNmBIPiFskZp8is=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YcVYKicziTgF8jzJ8dHb2CComdoBeHR/gGpAgWD0TOIqzv7U+SAb6UHoqVH693XlT
	 KNGLmnIhI6gaWeG5lXQYR+d/hNAWW5PO3JV9vZni8Hi+P9IVKV2/E3BfYI7NPDa6v9
	 jkzF387HladPEITfooeLVypxUTtYGFGpK1yuOp6LK6KZezOzcPXyHiEUZXxbHCbTqR
	 31RkPciYU5IswcZs6ugGmL4gXkzq1knlr25+nRQ60EXcOoQx2Xc7gdZdm8KYBcG6he
	 P8/PO4DgQ9Sg8AiLVbNuhO2fKXTjjogTzXo/HN3MeEg1h85V1/rpU9C91nav5mW/Uq
	 fPH1vT1nMigMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 5/8] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260721174502.111503-6-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-6-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:05:20 +0000
Message-Id: <20260721180520.E86811F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch addresses the loss of the REQ_NOMERGE flag by explicitly=
 checking for P2PDMA, but fails to fix the root cause: the hardcoded assign=
ment wbio->bi_opf =3D REQ_OP_WRITE wipes all critical durability and behavi=
oral flags like REQ_FUA and REQ_SYNC.
--

--- Patch [5]: [PATCH v3 5/8] md/raid1,raid10: keep REQ_NOMERGE on narrow_w=
rite_error() retry clones ---
commit 02b26b8d91beb002faa116497233b6b12f8d369f
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones

This commit restores the REQ_NOMERGE flag on P2PDMA bios during bad block
isolation retries in narrow_write_error(). The flag is needed to prevent
member queue merging of P2PDMA segments after the bio operation is reset
to a bare REQ_OP_WRITE.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7d769b6460ca7..16b7465c233ac 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -2570,6 +2570,9 @@ static void narrow_write_error(struct r1bio *r1_bio=
, int i)
>  		}
> =20
>  		wbio->bi_opf =3D REQ_OP_WRITE;
> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;

[Severity: High]
This is a pre-existing issue, but does hardcoding wbio->bi_opf to
REQ_OP_WRITE clear all other upper flag bits inherited from the master bio?

If the original write was synchronous and required Force Unit Access
(REQ_FUA), stripping it would cause the retry to be treated as a normal
write, which might be absorbed by the disk's volatile cache. This could
allow a retry of a physically defective block to erroneously succeed,
bypassing the bad block record and risking data loss if power is lost.

Would it be safer to mask the operation instead, preserving all durability
and behavioral flags, like:
wbio->bi_opf =3D (wbio->bi_opf & ~REQ_OP_MASK) | REQ_OP_WRITE;

This approach would naturally preserve REQ_NOMERGE as well, without needing
a P2PDMA-specific check.

>  		wbio->bi_iter.bi_sector =3D r1_bio->sector;
>  		wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;
[ ... ]
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..f7ef903a3d4ec 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -2831,6 +2831,9 @@ static void narrow_write_error(struct r10bio *r10_b=
io, int i)
>  		wbio->bi_iter.bi_sector =3D wsector +
>  				   choose_data_offset(r10_bio, rdev);
>  		wbio->bi_opf =3D REQ_OP_WRITE;
> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;

[Severity: High]
This is a pre-existing issue, but the same logic flaw appears here in the
RAID10 bad block isolation path. Does overwriting bi_opf silently drop
important flags like REQ_FUA and REQ_SYNC?

> =20
>  		if (submit_bio_wait(wbio) &&
>  		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D5
