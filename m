Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90EB2F8E9C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284645; cv=none; b=JAhqMV8/DZXe9gA6zakhbweww90tuMx5eMcYHV5uVZL+tULRZWfD6wvlECeZ5Imvf1GWXylVOtvV+R3jOPrG+N/Tf+GJkSCziFzIbBKzmIOUoSHim2wesuVAZzaucXbHyN6WXEtIhgxoxULJCNf/p1VnRCQHL9/vsIMl9f37ESk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284645; c=relaxed/simple;
	bh=FfsEdZdY1jhh82RzfQGELe+0UosEYr9P/kOZCkApL2s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ElFUZOWeBraKR/YugxaNkKdyBG4008/KHWcHdFtrLuZn9GQTgoP6ouZC2FGRWtT42Hufzl3Hj6X8d8rhyrfVpHHKNK7D6irxQwn8zjhp6pTQVicav6bbPf2Y8xZBudJm+4kQmyL5aIsPGj8czj49f13t23Z608NNjfN9P1Pt0Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LP3FNAWf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LP3FNAWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6271F000E9;
	Wed, 24 Jun 2026 07:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284644;
	bh=a/BAUh3lni4V4+JvXHjkPX8KDoGB0KKfQrEHrov8Xn8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LP3FNAWfXxDhQK5DAQGCzmyNzF3KhMKH5BWKRSEj0HosybQvZ+CmY9xwmFrl5S5/c
	 J585gbM1Zq+7o6D/RxFhnry1dLO0yyyr7O5bp2Zt9y1CTIvh8fnnbdYpd1I1ZPDJmS
	 REHtHMK9k8/MAfeiHIf5U/omVYErwjGMGBcHBBb81SirgZBl3UGh4rmXF2ppS1j4qG
	 cytSnnn1TTL1e26DAPRiHkEWP9qEQ+gsSyfN4JQgJHOTnx+ELLeicIpig88F0DXGpU
	 zMOE/4V4Hvnah+JA1ROquNabHG8x8Dn0CiMGIe1xbnHi1U6rKi++GviwBt1j3yHk6T
	 C3xgPuKLP3nQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/20] md: skip bitmap accounting for empty write
 ranges
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <d978c0c72c874d7033b0806a2dba255d6ff9e359.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <d978c0c72c874d7033b0806a2dba255d6ff9e359.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:04:03 +0000
Message-Id: <20260624070404.2B6271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Using `md_io_clone->start_time =3D=3D 0` to check whether IO accou=
nting was started is unsafe because `jiffies` can legitimately be exactly 0=
, permanently leaking the device's `in_flight` counter.
--

commit ff695222c639e0740f645b5e4a15298c468511f4
Author: Yu Kuai <yukuai@fygo.io>

md: skip bitmap accounting for empty write ranges

This commit updates md bitmap accounting to handle zero-sector flush/FUA bi=
os.
It treats both naturally empty bios and ranges trimmed by the prepare_range
hook as not started, preventing the completion path from calling end_write()
on an empty range.

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
This isn't a bug introduced by this patch, but is it safe to use
md_io_clone->start_time as a boolean flag to track if IO accounting was
started?

Looking at bio_start_io_acct(), it returns the current jiffies value. If an
IO request is submitted exactly when the jiffies counter wraps to 0,
start_time will be set to 0.

When the IO completes, md_end_clone_io() evaluates the following condition:

    if (md_io_clone->start_time)
        bio_end_io_acct(orig_bio, md_io_clone->start_time);

If start_time happens to be 0, it skips bio_end_io_acct() and the block=20
device's in_flight counter is permanently leaked. This prevents
is_mddev_idle() from ever returning true, which could permanently throttle
background sync operations until the system is rebooted.

> -	if (bio_data_dir(*bio) =3D=3D WRITE && md_bitmap_enabled(mddev, false))=
 {
> +	if (bio_data_dir(*bio) =3D=3D WRITE && bio_sectors(*bio) &&
> +	    md_bitmap_enabled(mddev, false)) {
>  		md_io_clone->offset =3D (*bio)->bi_iter.bi_sector;
>  		md_io_clone->sectors =3D bio_sectors(*bio);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D2
