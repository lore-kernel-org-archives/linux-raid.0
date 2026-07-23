Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDE8387569;
	Thu, 23 Jul 2026 21:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840957; cv=none; b=j4xSUZ+HOFLSePIW2mW2j+DKl6z6h8g8xYeJhfTr+JC6VMPK93PpQ/1KxOJyIKdnfkJhMpEBmmXHIafABuGrQWwLh7QCcOtCQ7Atvbm5JgVlTNAh/mwCU8MaQVgNMe2kXq+9/+rhIhITw/UxPMj91KebH+IgsiG+ssLc0q5Fj5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840957; c=relaxed/simple;
	bh=Sac80Cl5MFfbi7wdd9jdVCrwgR7woyPs9n+iyL4kOl0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TkoKVg9c42ZUrWXoMrU3LVkOdNPow3+okyVZQj/MYeoJ/KzRH0hNmEL68qb0l+xN4FD6Plsgn5GDC56N1O6seHrDSBvjZDlBTSgGveF+6jQToSQRJJHxsXdppsrr680gcx2h/GwTenKGs+JAG6/FZNqPCwTKspS2OMnDilWoA4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mQhgdj2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQhgdj2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2231F00A3E;
	Thu, 23 Jul 2026 21:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840946;
	bh=oPCzaETXU+1w3hOMo03gRbUTmS2TAEYdhf15OuBzMAc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mQhgdj2sZsVhO/PjLaIMcb/LiiV+5tq1RrlC6g2qMsSrLSWQAZtDbWMLnJg72OAXw
	 IzZxNEnK/o0rKQRphCj3vSu+dGhpUAQukbKie9sfgIzEwunTaTLvipa3mP/lsmQz9t
	 P0M3TJzwbNAjL3U5jL06WGVhi3RDq8mm/N/J7hMi6eUPe6kth0Dolwk4qGsQeuVEAw
	 g1uXaURMtiKh5tr+XsjuURB7eCP7VPdNSHvQry37oak2R/qtz2VMzBZtv5mGH4p+MK
	 q+PHE8t4fa1PaQEmhsDmf2JyiT0VxoQRZM8y1B/ukZYo3UDKIpKWsdWdOkYIU63Zqa
	 qC3UXmgGxUTSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/10] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260723204206.76930-8-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-8-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:09:05 +0000
Message-Id: <20260723210906.2F2231F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `rounddown` and `roundup` macros evaluate to a value but do no=
t modify their arguments in place, causing bad block alignment to fail.
--

--- Patch [7]: [PATCH v5 07/10] md/raid1,raid10: skip futile retries on P2P=
DMA mapping failures ---
commit 7daa9c9f8cade5fa7f5dd4ab20ed50fa6c654eff
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: skip futile retries on P2PDMA mapping failures

This patch skips replacement and FailFast eviction for BLK_STS_P2PDMA errors
in raid1 and raid10, keeping the WriteErrorSeen flag so the range stays
fenced. It also bypasses block-by-block submit_bio_wait retries for
P2PDMA errors, instead recording the whole range as a bad block.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19c4dec450de0..83ebf40237d57 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -2624,10 +2624,15 @@ static void handle_write_finished(struct r1conf *=
conf, struct r1bio *r1_bio)
>  			 * narrow down and record precise write
>  			 * errors.
>  			 */
> +			struct md_rdev *rdev =3D conf->mirrors[m].rdev;
> =20
>  			fail =3D true;
> -			narrow_write_error(r1_bio, m);
> -			rdev_dec_pending(conf->mirrors[m].rdev,
> -					 conf->mddev);
> +			if (r1_bio->bios[m]->bi_status =3D=3D BLK_STS_P2PDMA)
> +				rdev_set_badblocks(rdev, r1_bio->sector,
> +						   r1_bio->sectors, 0);

[Severity: High]
This is a pre-existing issue, but will these rdev_set_badblocks calls
fail to align correctly due to how rounddown and roundup are used
in the badblocks subsystem?

Looking at _badblocks_set in block/badblocks.c, the alignment macros
are evaluated but their results are discarded rather than assigned back to
s and next:

block/badblocks.c:_badblocks_set() {
    ...
    if (bb->shift > 0) {
        rounddown(s, 1 << bb->shift);
        roundup(next, 1 << bb->shift);
    }
    ...
}

Does this cause MD RAID configurations with bb->shift > 0 to track
unaligned, smaller bad blocks instead of the full chunk?

If so, this could allow later I/O requests to bypass the check and access
bad hardware sectors. The same discarded macro results appear to be present
in _badblocks_clear and _badblocks_check as well:

block/badblocks.c:_badblocks_clear() {
    ...
    roundup(s, 1 << bb->shift);
    rounddown(target, 1 << bb->shift);
    ...
}

block/badblocks.c:_badblocks_check() {
    ...
    rounddown(s, 1 << bb->shift);
    roundup(target, 1 << bb->shift);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D7
