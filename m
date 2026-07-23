Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F85D3DDB18;
	Thu, 23 Jul 2026 21:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840760; cv=none; b=RnCN99WTxa6yBDZcxFtvwgqvzreMN2db5dZrQ4DDvzPPucNKK4gx91rzVnC8vWwl/NsdhPVngCx01uKZ4cbi2yDToaBkgToz8iIIER6qAjvzgnMqjJLLtOO4RiIAVLVBmacvh6yxvsWC1XVuv/8gQ/++BP5DdT8gVwHPGC+e6vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840760; c=relaxed/simple;
	bh=NEPZ44y/ugXZkmffqF0Y5C5I47PdmhOX15mskq50dEA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Sm5fV74xOvvSvfBz3iVYqPfP+mFoWXr2eI25vtZSZ5WZSTlqxy7aJwGH4KgdTnKkJM0+3QVr5703yi4efk1bOfXEsCV5KFocJa74jPpwt86RB97UKc7i7TFcIEAxyBG9FA0QqCdvrnssPiw/haHbwDRTzHd8hrJWCv+pw3v929w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4OoFmbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4OoFmbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D66A1F000E9;
	Thu, 23 Jul 2026 21:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840757;
	bh=rnAMsAfB3h0Xta+lRsnYIaF/Qow0skM8kPo/jwbXJAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z4OoFmbXkS4LzAmUgmv2EdethFNeSHIDOImkQ19EfZfkYljiQPqY3qrA5aM3Gy3b6
	 V5svdNQKAbqSSKkS2x2tGRv/MIDeSSW0QLOUUs8G6ReTiPsXmFiPvSiiosm/pStNYy
	 8kQcWIm2TQJaI5pGLoSPBEt09NbLbrSowRD0e35NzfYYLAhVhQ1ylxe5uge6IzGLno
	 VCgqViRthwST3N6HaHv78hSe1VG1d+nnd4XKDy5NCUOvNIimoFoacYFIxRXiZBgyYC
	 e/DMpKBdJlmnFyDVUYJMSWNeEPRH6qo1R7n1Gtyar+1VyFvvBKRs4wS3DIerRq+x4z
	 QNFvjRt8KlZVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/10] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260723204206.76930-7-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-7-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:05:57 +0000
Message-Id: <20260723210557.8D66A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] narrow_write_error() dangerously converts failed dataless operatio=
ns into normal writes (REQ_OP_WRITE), causing crashes during trimming or bl=
ock layer submission.
- [High] narrow_write_error() resets bi_opf to a bare REQ_OP_WRITE, silentl=
y dropping critical data integrity flags like REQ_FUA.
--

--- Patch [6]: [PATCH v5 06/10] md/raid1,raid10: keep REQ_NOMERGE on narrow=
_write_error() retry clones ---
commit 63dc9314df6c2490722e42dfb137e9e52bd9544f
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones

narrow_write_error() re-issues a failed write in badblock-granularity chunk=
s,
cloning from the master bio and resetting bi_opf to a bare REQ_OP_WRITE. Th=
is
drops REQ_NOMERGE for P2PDMA bios, so the patch restores the flag on P2PDMA
retry clones.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f07edeac6e5a3..19c4dec450de0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2561,6 +2561,9 @@ static void narrow_write_error(struct r1bio *r1_bio=
, int i)
>  		}
> =20
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This is a pre-existing issue, but does forcing wbio->bi_opf to REQ_OP_WRITE
cause crashes for dataless operations?

If an underlying device fails an operation like REQ_OP_SECURE_ERASE or
REQ_OP_WRITE_ZEROES, forcing it to REQ_OP_WRITE means it is no longer
recognized as dataless.

Would bio_trim() then attempt to advance the bio iterator and dereference
a NULL bi_io_vec array? Even if it doesn't span multiple badblocks and
bypasses the trim crash, would it be submitted to the lower-level driver as
a malformed payloadless write?

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;
>  		wbio->bi_iter.bi_sector =3D r1_bio->sector;
>  		wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;
> =20
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5b63175fb3826..428bddddfe71d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2823,6 +2823,9 @@ static void narrow_write_error(struct r10bio *r10_b=
io, int i)
>  		wbio->bi_iter.bi_sector =3D wsector +
>  				   choose_data_offset(r10_bio, rdev);
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This isn't a bug introduced by this patch, but does resetting bi_opf to a
bare REQ_OP_WRITE silently drop critical data integrity flags?

By overwriting the opcode rather than modifying it, it appears flags like
REQ_FUA and REQ_SYNC that were present on the master bio would be lost on t=
he
retry clone, potentially leading to data loss if a power failure occurs.

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;
> =20
>  		if (submit_bio_wait(wbio) &&
>  		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D6
