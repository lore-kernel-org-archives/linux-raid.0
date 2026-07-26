Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D43175A83;
	Sun, 26 Jul 2026 12:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067744; cv=none; b=QmPuHmQq5T1Up9V/3sK4s5GMhKA7G1J8Kld6ZeQteLNgkQR0Nk4un6UQJQxyfVLjJAS4m9ESRXj11V92D/xyVBidZ5poveB1CWFPyYNFbCRl5ooFj5XBUJHR6u00NT7qOtgIon3rUrPAahiNy7VaJOtQnSFRW3kM80mWlzh9iHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067744; c=relaxed/simple;
	bh=Y98gLFIGyZsFL4xdGV64nhgRW/KPTUY32ihoehdIZoM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uLRvIdPRF0XW4PSBIcOC1dlecI5H94BEuO24r4nsOon/aT/trZjOVPUGQIn+XvXsBERzBZ2RduR5/bTcztD8FbQve7hn1DawroKcu+CCn6eXx0vURNTJE3tFMviE0aQe5WVnrW0JV7OiOSqUCRiR8m01AA9T0g0OtOve1sygXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYNcJAEo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYNcJAEo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B291F000E9;
	Sun, 26 Jul 2026 12:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067743;
	bh=+mbFZDOt0tp+or/jRA3qH5UHRgUNYDo88PpQMyicicM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YYNcJAEo/XOT7I3DNeHGmS00Afw98JHR0V6eGatQv1b0PdDuPP6KfIl95d0Lfv4Nk
	 pZGJDcYWUxIce8jBAeBpQq0Bh36IcvUsCHW0bdnyGw81NX2vZ4LOE5CF3bpURVsofo
	 XjSIIiRcBsg1vfc1Rg5cIkRGygnwdbq3TkrleUSzMgltila7lsfY5n1pyL5Dff9PkO
	 /Me6+E+Uz+qoWltWVTt86fzDF4DXDENq2ehb84qaNpeMVhRN5coNpPkIjWariTzzQ2
	 m4626WhtnU6CD6lLDzIGVQw0elt6zmZqyZthYtTqk+yDFew9+gmdle7MnUCtzUFFJ2
	 qEQpDV60IlXUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/12] md/raid1,raid10: keep REQ_NOMERGE on
 narrow_write_error() retry clones
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260726113229.2154269-7-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-7-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:09:02 +0000
Message-Id: <20260726120903.67B291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unconditional assignment to `wbio->bi_opf` destroys all request fl=
ags cloned from the master bio, leading to potential data corruption.
--

--- Patch [6]: [PATCH v6 06/12] md/raid1,raid10: keep REQ_NOMERGE on narrow=
_write_error() retry clones ---
commit 333e1430f8770afc53cf111be8c36899e6c4c5e3
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones

This commit restores REQ_NOMERGE on P2PDMA retry clones in
narrow_write_error() to prevent member queues from improperly merging
segments.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f07edeac6e5a3..19c4dec450de0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -2561,6 +2561,9 @@ static void narrow_write_error(struct r1bio *r1_bio=
, int i)
>  		}
> =20
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This isn't a bug introduced by this patch, but does this assignment
unintentionally overwrite all request flags?

Since bio_alloc_clone() copies the original bi_opf, setting it directly to
REQ_OP_WRITE zeroes out the upper 24 flag bits, which drops flags like
REQ_FUA and REQ_PREFLUSH.

Could this result in data corruption on power loss if the original write
requested forced unit access?

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;
>  		wbio->bi_iter.bi_sector =3D r1_bio->sector;
>  		wbio->bi_iter.bi_size =3D r1_bio->sectors << 9;
> =20
[ ... ]
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 5b63175fb3826..428bddddfe71d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -2823,6 +2823,9 @@ static void narrow_write_error(struct r10bio *r10_b=
io, int i)
>  		wbio->bi_iter.bi_sector =3D wsector +
>  				   choose_data_offset(r10_bio, rdev);
>  		wbio->bi_opf =3D REQ_OP_WRITE;

[Severity: High]
This is the same pre-existing issue as in raid1.c. Does overwriting bi_opf
drop critical data integrity flags like REQ_FUA cloned from the master bio?

> +		/* Keep P2PDMA retry bios unmergeable, like the original */
> +		if (md_bio_is_p2pdma(wbio))
> +			wbio->bi_opf |=3D REQ_NOMERGE;
> =20
>  		if (submit_bio_wait(wbio) &&
>  		    !rdev_set_badblocks(rdev, wsector, sectors, 0)) {

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D6
