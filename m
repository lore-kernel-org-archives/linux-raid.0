Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258FB3B9DA9
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607534; cv=none; b=XZV3XZP80SLFyyyK6hASBgHOxlFcwyEKxVdJPxIRCPrcwqw6ppoyIAMzEdGbHcI1YHA7D8Z4WruH9Lr3hoZWmWmRNt7mK3iNNT+ctN+nTktAOGoFSi890aLDIbRVlJp9cIwu5cvFYa313iDJp21gl72QUVlhDzajSxLmY0OjQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607534; c=relaxed/simple;
	bh=k9fbHf35AMzhfe2dcNpUI6sPnuX67gTRg9YBk/WxH84=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=psGmmJv8wdgApNllwhWgtPbU0+JDOUWGODLUZ96HYuAB3NwtUtieOkDvKRzDYpE9uZKAcgRveEcvvuRN4Hg3F0CaiX0ElQQe5eDgSITpAbU1tA5QyHYyiaJDlexrDQGQdIUGx64ok4RJ7BsnC+6jY4FZxZQm6juEvbpqKdaWe3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X0Z1G22d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X0Z1G22d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A10E1F00AC4;
	Sat,  1 Aug 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607532;
	bh=iDCXbLKeYnafXqnWfYKNW1sVHPA1d5YkoggQERxiZ64=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X0Z1G22dVM+OOUe00bpmx7iNqY5XZOl39ns12u1ChJ/MqJOp1DoaIAqGw/VwrJIcs
	 YOuHwkd6zVepLeI0Ob1vvjB8j/xHkcAmzFg6egSzDQ61n1O6of/t9k2Q68iaGLbDlG
	 RH/8H49LGPUlzKMcmIVRaVcC3tMb1yjq1Zk7EzyoloKiyDjC31qqkhbHmS4WpZuQw0
	 54QUSg6iT1596wGDakOanRwJ77tMhQbdc7f6ZJM+iXFrd8QR9v+HQed2dvNpKUZJdj
	 ds8KLRtdRq7fAuwqWrY1Vuxgn2cbNmIPYWQq/HK3JkUPYXtDqjqJ6nd5gYe732qDOb
	 VzgooXXQIIfjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/25] md: skip bitmap accounting for empty write
 ranges
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-8-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-8-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:05:32 +0000
Message-Id: <20260801180532.7A10E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Uninitialized `start_time` leads to corrupted IO accounting, and u=
sing `0` as a sentinel causes in-flight IO leaks when `jiffies` wraps to 0.
--

--- Patch [7]: [PATCH v4 07/25] md: skip bitmap accounting for empty write =
ranges ---
commit b61151db244d77a3d38d7fc791d0c00d7e6a2723
Author: Yu Kuai <yukuai@fygo.io>

md: skip bitmap accounting for empty write ranges

This commit prevents zero-sector flush/FUA bios from dirtying bitmap bits.
It skips bitmap accounting for empty write ranges by verifying the bio has
sectors in both md_bitmap_start() and md_clone_bio().

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3b20a57b8c7ed..0b59c676f7c03 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -9423,10 +9426,12 @@ static void md_clone_bio(struct mddev *mddev, str=
uct bio **bio)
>  	md_io_clone =3D container_of(clone, struct md_io_clone, bio_clone);
>  	md_io_clone->orig_bio =3D *bio;
>  	md_io_clone->mddev =3D mddev;
> +	md_io_clone->sectors =3D 0;
>  	if (blk_queue_io_stat(bdev->bd_disk->queue))
>  		md_io_clone->start_time =3D bio_start_io_acct(*bio);

[Severity: High]
This is a pre-existing issue, but does md_clone_bio() leave start_time
uninitialized when IO stats are disabled?

Since md_io_clone is part of a bio allocation from a mempool, it might not
be zero-initialized. If blk_queue_io_stat() returns false, start_time could=
=20
retain garbage memory.=20

Later, in md_end_clone_io(), the completion path checks:

md_end_clone_io() {
        ...
        if (md_io_clone->start_time)
                bio_end_io_acct(orig_bio, md_io_clone->start_time);
}

If start_time contains garbage, couldn't this falsely trigger=20
bio_end_io_acct() and decrement counters that were never incremented,=20
corrupting the block layer metrics?

Additionally, if jiffies happens to be exactly 0 when bio_start_io_acct()=20
is called, start_time becomes 0. The sentinel check in md_end_clone_io()=20
would then evaluate to false, skipping bio_end_io_acct() and permanently=20
leaking the in-flight IO counter. This leak prevents q_usage_counter from=20
reaching zero, which would cause blk_mq_freeze_queue() to hang indefinitely=
=20
during block device teardown.

Could start_time be explicitly initialized, or perhaps tracked with a=20
separate flag instead of relying on 0 as a sentinel?

> -	if (bio_data_dir(*bio) =3D=3D WRITE && md_bitmap_enabled(mddev, false))=
 {
> +	if (bio_data_dir(*bio) =3D=3D WRITE && bio_sectors(*bio) &&
> +	    md_bitmap_enabled(mddev, false)) {
>  		md_io_clone->offset =3D (*bio)->bi_iter.bi_sector;
>  		md_io_clone->sectors =3D bio_sectors(*bio);
>  		md_io_clone->rw =3D op_stat_group(bio_op(*bio));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D7
