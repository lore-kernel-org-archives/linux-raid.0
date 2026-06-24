Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FD5392802
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782285645; cv=none; b=LRIGZfHqFi0Y1rMclMNbAlum5xn7cJHH3dgiA2V5v4LwhGttS3JDFepMC8MYXOxa8V95uhvK0fW/VJganogwLdgJ9817GoXU+Y0qS2Mnk4zk4uwkb2WtoLUxV0RTK/WGsrPUD5KVtIxG6ncVLSqzZUP2tpYyUDAYZLuhmtJcYEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782285645; c=relaxed/simple;
	bh=edR/IzQSWhlbkVsGOLIV0PvIfqs0WCJcBjvk2zYefiY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WTakGF1M4X8HW8XjnMVBwSuWNUWxR3meB525J2c4ejFoASij7NmmC2w1tiYEBSf/8Kfu6LjZxan0Q3+O/rrIIDAwe74SolztRGy9JX7VYXxgOtj+f1okg7CxGw7R5xrWENACoNyRnX/TVADDWgmBVaywUrAbPbEtX0pW9esq6G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfCOneom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfCOneom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A60D1F000E9;
	Wed, 24 Jun 2026 07:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782285638;
	bh=ExmxFGhGN+VdQKQfKQMOQdsyuY8Ilwz2ZwOOfZ6GYpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cfCOneomEOgwlPIECWKhGp+VdyjQpUODgBSYMVOwjokzcd7veNnuAAE841G4PuZTv
	 DJ10//YU4mdEUUMidMLklAJ15b2HQD8GCuA6M4HX44botwHr46dYnlduLeAUO/5Hqn
	 AcOyAaTe8V7LvkeM8BAyK/nFyReA471BklFbZe20lEukpZzvaNecwFmR2k2bY3yhLw
	 g/u5aPHNlSrs/o7Pl0GSDq1hWg5xTViE1f5VcXoVv3ez8elbNZ8u8kbYTVS4sFt2mB
	 D8Swem95SYcOHknAAM2xA9uXEm0jg4oDDOWsL6bplNrfzz6Xy47w4gbrXWL25AoF3h
	 rWNSJdlqB4xmg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 16/20] md/raid10: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <afeb48e05a8925b52e9def6bab1b0ca1e87c4aa0.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <afeb48e05a8925b52e9def6bab1b0ca1e87c4aa0.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:20:38 +0000
Message-Id: <20260624072038.8A60D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing `md_write_end()` on `mddev_bio_split_at_reshape_offset()` =
failure path causes `writes_pending` leak.
- [Medium] Lockless read of `mddev->reshape_position` can result in a torn =
read on 32-bit architectures, leading to incorrect bio splitting.
--

commit 2a6f82a757276f6bbae0c22cb819c9c6d6b3e4b0
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: split reshape bios before bitmap accounting

Use the shared mddev_bio_split_at_reshape_offset() helper so RAID10
submits only one-side bios to llbitmap during reshape.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1911,6 +1911,12 @@ static bool raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>  		sectors =3D chunk_sects -
>  			(bio->bi_iter.bi_sector &
>  			 (chunk_sects - 1));
> +
> +	bio =3D mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
> +						&conf->bio_split);

[Severity: Medium]
Can the lockless read of mddev->reshape_position inside this helper
result in a torn read on 32-bit architectures?

In mddev_bio_split_at_reshape_offset(), mddev->reshape_position (a 64-bit
sector_t) is read without READ_ONCE() or a seqcount:

drivers/md/md.c:mddev_bio_split_at_reshape_offset() {
    ...
    boundary =3D mddev->reshape_position;
    ...
}

On 32-bit systems, could racing with the reshape thread's update (for
example, at the 2TB boundary) tear the 64-bit load and yield a garbage
sector value?

If so, this might cause bio_split to slice the bio at an unaligned offset,
leading to IO errors when the underlying block device rejects it.

> +	if (!bio)
> +		return true;

[Severity: High]
Does this early return bypass the md_write_end() cleanup required to
balance the earlier md_write_start() for write requests?

If mddev_bio_split_at_reshape_offset() fails and returns NULL, it appears
the writes_pending percpu reference is leaked.

Will this prevent the array from reaching the clean safemode state, causing
it to perpetually appear dirty and trigger a full resync on the next
assembly?

> +
>  	if (!__make_request(mddev, bio, sectors))
>  		md_write_end(mddev);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D16
