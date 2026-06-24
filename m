Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0B52DEA8C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286171; cv=none; b=aKLkUG0myKl3k4ssyebiOLnIhYquSvX5PFy4Let3GW7nu+GCyQU/u89ZVMA6UAC4IUA1eDb+J49JWYZRX+YKa2DaYpaHEe38Ltq+vu8sjRX6+4rMfcAxsu3ovjyBcNXH87YW+9hyhwqwpxR98eOFBiXsny6dd9x/yUJtk0ssK+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286171; c=relaxed/simple;
	bh=Dy89v0UJyZHhVubvJQ4UxxH96DMrYZ674nu1Gse2lDk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BhwIenokcJfUj5/1bD1W15X2FhJz1TX1cMuRjtnWqt29oVpNqxi+QSDJojkkwL9l8tRpUzQwBBvY4ZSxFd5LVWJyBcLjlTa/FVdUKf/LV3/VVl2Cx9OV+CdrIFQMB9SfR+mif8ua9NH2RFRQY68Z3WF2v4wfuLE0GJ+jPhkt0fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjZ3G35j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjZ3G35j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43381F000E9;
	Wed, 24 Jun 2026 07:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782286170;
	bh=neYPV4TZ6i4jegdbHeh46TDjsr4UEFZnLXOn1IBvI1k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bjZ3G35j77dVJY/8eSAV949BssQBMThxTDuXUjEHfE1QbhvLnYYbEgEoAKpTq2Gsi
	 pIX6ZQrYDD+XvSLNHTTEjFiQy+2jIa9pd/l98nNnZzkFkuFdb4uwPCB9vkaQ48sguo
	 7RBc7fsZx3ozR31mcgv5u9MvCrDG+vrhPmtPafdDi686pu7FazlsMZaoNplrCw1HKV
	 kdMmz6C+9WHIk2Y4/Zm2aChm8Uzb/gIDml4Jk3NmRDHk5/5ytkEQxLWDSFXCyJCj+O
	 qPCDhpoLhltHbY8Gq8NFI1tzsJfzi+SgLDTbsx8MIw1Jm0IMzUkm4A5MOzAbVRwjBh
	 tZ1lXenf1pYQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/20] md/raid5: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <f4bcf3a6cdb16689c42f2f5b5bb6b5dca0c84768.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <f4bcf3a6cdb16689c42f2f5b5bb6b5dca0c84768.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:29:29 +0000
Message-Id: <20260624072929.C43381F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Splitting a bio in `raid5_make_request()` breaks the `STRIPE_W=
AIT_RESHAPE` retry logic, causing a double-submission of the remainder and =
a permanent leak of the split front.

Pre-existing issues:
- [High] `make_discard_request()` leaks the `REQ_OP_DISCARD` bio without co=
mpletion if an array is reshaping or `REQ_NOWAIT` is set.
--

commit fd0cb884709b54fc9c1fe1f70aa2016108b2a998
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: split reshape bios before bitmap accounting

The commit uses mddev_bio_split_at_reshape_offset() in
raid5_make_request() to split bios at the reshape offset. This ensures
that RAID5 submits only one-side bios to llbitmap during reshape.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ac7ea483502fd..fb346a3c4aa3b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6181,6 +6181,14 @@ static bool raid5_make_request(struct mddev *mddev=
, struct bio * bi)

[ ... ]

>  		return true;
>  	}
> =20

[Severity: High]
This is a pre-existing issue, but is it possible for the discard bio to be
leaked if the array is reshaping or REQ_NOWAIT is set?

In make_discard_request() which is called just above this context, it retur=
ns
early without completing the bio:

    if (WARN_ON_ONCE(bi->bi_opf & REQ_NOWAIT))
        return;

    if (mddev->reshape_position !=3D MaxSector)
        return;

Since raid5_make_request() calls make_discard_request() and then unconditio=
nally
returns true, does this strand the bio and cause indefinite hangs?

> +	bi =3D mddev_bio_split_at_reshape_offset(mddev, bi, NULL,
> +					       &conf->bio_split);

[Severity: Critical]
Does splitting the bio here break the STRIPE_WAIT_RESHAPE retry logic and c=
ause
a double-submission and memory leak?

When mddev_bio_split_at_reshape_offset() splits the bio, it submits the
remainder via bio_submit_split_bioset() and returns the front half as the
new bi.

Later in raid5_make_request(), if make_stripe_request() hits the reshape wi=
ndow
and returns STRIPE_WAIT_RESHAPE, it handles the retry:

    if (res =3D=3D STRIPE_WAIT_RESHAPE) {
        DECLARE_COMPLETION_ONSTACK(done);
        WRITE_ONCE(bi->bi_private, &done);
        bio_endio(bi);
        wait_for_completion(&done);
        return false;
    }

When false is returned, md_handle_request() loops and retries the original
bio pointer.

However, the original bio was already submitted as the remainder by the spl=
it
operation. Will this result in concurrently submitting the remainder twice?

Additionally, when completing the cloned front half (bi) with the completion
flag, md_end_clone_io() does not complete the original split bio, which
permanently leaks the front half.

> +	if (!bi) {
> +		if (rw =3D=3D WRITE)
> +			md_write_end(mddev);
> +		return true;
> +	}
> +
>  	logical_sector =3D bi->bi_iter.bi_sector & ~((sector_t)RAID5_STRIPE_SEC=
TORS(conf)-1);
>  	bi->bi_next =3D NULL;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D20
