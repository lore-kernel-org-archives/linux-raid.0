Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D133AFCE3;
	Sat, 18 Jul 2026 16:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784393883; cv=none; b=JBswGC/XZ5/4+ai61miWOwHK+U/QSQQMW3a0jF2VjYDyysNIO0NPRsxGTBH/1jrQoYGeNfUupF9e/aFKfn9gysa5yPfNTi6XJJp+6Pl+GFofKk/prLAGrpZxCU7xuD3kUZRhYTnDEf4z8FxYxdyXIwOaHXgIG3PlcoMrkoWIkR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784393883; c=relaxed/simple;
	bh=7k46JtU0lVBARPJx5X+pE5SQTSM0M5vywM9gPCZhzQ8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TqGU4DNgp9oEwxzfTm2ODcyCv5YUGYBlHrkskfPYE4e/RiRdSvyryMdIqTHS0hW1AIPqr6zlm8lWOHRqu76jOC5RXuACBebFQk65KpwYOgQ+mx97QfJ37cFlmpAuEl7mycKjIUm196JoTcRRkBy1SPD88s3ebC12AJVLFzmc9CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvzovrO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvzovrO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF71F000E9;
	Sat, 18 Jul 2026 16:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784393881;
	bh=tQ8TBhzbe6Y7Z+nrK1UnUqzvk6zVNAL1kqoOx5pCtXA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QvzovrO2My5FLSI/RW7uHOgE04hznFE6zuGj1fUFgjBYrAFqhVOjiE0tt4SQXIPkB
	 UJ2Uau7NMSU0pQdEOB0+ucT3+AjoDZiNaQkUAoeUgTzQDdcaGmkmTLZk4wuBNIjf7Y
	 p0Z+xIxR4ejRfDGaGRR3jsXVy3bUy6j0SLwK0q3d4ojRFip5LxV52O7tGNF6XoWxIz
	 FUGKuEebGviKOy9HXi4vJ0SNAtHYip5rnHWCGl0giFiMUqX8DJLDtI2YL5oNO9up8b
	 03V0qgxQWmGfMjIOQcsYZOBigBxvhPCt5ws/UeZ/B8Lvv8Se3g7Vm4vbeV3W6T0kV7
	 MYk8J0vRSHgsA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/6] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260718162547.448892-5-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-5-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 16:58:00 +0000
Message-Id: <20260718165801.6BCF71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] narrow_write_error() silently drops REQ_FUA, REQ_PREFLUSH, and REQ=
_SYNC flags during block-by-block write retries by overwriting the bio's op=
 flags with a bare REQ_OP_WRITE.
--

--- Patch [4]: [PATCH 4/6] md/raid1,raid10: keep REQ_NOMERGE on narrow_writ=
e_error() retry clones ---
commit 2b72bc4b60daf0429fd1c6c62c181f2b0048e81d
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones

This commit ensures that REQ_NOMERGE is retained on P2PDMA retry bios in
narrow_write_error(). It addresses an issue where resetting bi_opf to a
bare REQ_OP_WRITE dropped this protection, potentially allowing unsafe
merging.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 57f64e8901024..a300323211911 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -2565,6 +2565,9 @@ static void narrow_write_error(struct r1bio *r1_bio=
, int i)
>  		}
> =20
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This isn't a bug introduced by this patch, but does this overwrite of
bi_opf with a bare REQ_OP_WRITE drop important operational flags?

If the original write contains data integrity flags like REQ_FUA, REQ_PREFL=
USH,
or REQ_SYNC, losing these flags during a retry means the retried write might
only be placed in the disk's volatile cache.

Since bio_alloc_clone() already copies bi_opf from the master bio, overwrit=
ing
it here wipes out those flags, which could risk silent data corruption on p=
ower
loss if a transient failure triggers this retry path in narrow_write_error(=
).

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;
>  		wbio->bi_iter.bi_sector =3D r1_bio->sector;
>  		wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;
> =20
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

[Severity: High]
This isn't a bug introduced by this patch, but similarly here in raid10
narrow_write_error(), does assigning a bare REQ_OP_WRITE silently drop flags
like REQ_FUA and REQ_PREFLUSH?

If an original write has these flags set, the retry might succeed without
them, leading the array to consider the disk perfectly synced while the data
only resides in the disk's volatile cache.

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;
> =20
>  		if (submit_bio_wait(wbio) &&
>  		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718162547.4488=
92-1-mykola@meshstor.io?part=3D4
