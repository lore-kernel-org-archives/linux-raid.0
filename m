Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0593859F9
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037984; cv=none; b=ZvrkgOYeH5+uvnWMjEcWZ2A6YDV84qDbQ9wucFd2PXJb1WT5ftqiIN5HDkn6mXM75zul/t5ojtu5CZn1J7qt/Y+OyvfmUFb/AslpCE0IWH89KAPjb0by7N0Ez24d466I1VFCwNsP+LQRrw8/g38t3hUEfoVD0XwL1nR2RlDQBlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037984; c=relaxed/simple;
	bh=3/UqUeTH9D3ytnvMNfFYvERqQ958EB0QYMm9dCEBR3U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EgYQGAndF8NRcsupR/upec/eOeBrwogkFkrZbt19+J9zxYMuR8Kze3C9whtU+kAJmrLoWHsufVM83v2NUdse/dNgGYNctfYE6oZza4UDbZBdF7Iyp+xVkU4ow6Ml/Qz05lEA77lmt6ogIvVksha6LhVNZANwWwkQ8ikOd/j0Fhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KG3HajnI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KG3HajnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDB71F000E9;
	Tue, 18 Aug 2026 07:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787037983;
	bh=z+Wa2IrA02gAacWprwzsEtT81W3+3T2ByujkOQTvfB0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KG3HajnI3CTA2/85h5Lfbr3eoVmaxD6ochyGCC7mJuwAoW/nCzY7YtWnB0eBtCVcB
	 sg1u/TDjPxKWQjuKWM7HNFZnoQpX1/cHb2HsoIYZgPSVE6mg7DO5nw0taQ3dTcLNqF
	 FyzofMnT5TDnDkNkd7bW8WuPlrSMIffa9vuFXqm/yzU8nmoEAydY+5nuCBhL6jcqkt
	 FLbWHtvrAs5q/Y6DNxQhsS4MMDYo1MhOf4GQ7AO4WKDEeew9jXHgbNiEBZPSpwdxd2
	 lqO6C20J2BVl1tvJ/718rdR7KrRywqlee22CVH//B8V/hU3WVHhsgtlVQtweZNWI9t
	 R00+mlQefVnmw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/5] md/raid1: do not move nonrot reads onto a rot
 disk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260818070646.1029149-3-chencheng@fnnas.com>
References: <20260818070646.1029149-1-chencheng@fnnas.com>
 <20260818070646.1029149-3-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 07:26:22 +0000
Message-Id: <20260818072623.1DDB71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Sequential and distance-based heuristics are broken for rotational=
 disks when non-rotational disks fail because `has_nonrot` does not check r=
eadability.
- [High] Sequential reads on rotational disks will thrash in mixed arrays b=
ecause idle sequential disks fail the early-return check and are artificial=
ly penalized.
--

--- Patch [2]: [RFC PATCH 2/5] md/raid1: do not move nonrot reads onto a ro=
t disk ---
commit bee044f7822d405084d8b841ba855a8f7a81b6a4
Author: Chen Cheng <chencheng@fnnas.com>

md/raid1: do not move nonrot reads onto a rot disk

This patch updates the read balancing logic in RAID1 to prefer non-rotation=
al
disks over rotational ones in mixed arrays. It modifies choose_best_rdev() =
to
ensure that non-rotational disks are favored during sequential I/O and
round-robin selection, aiming to prevent rotational disks from slowing down
faster NVMe or SSD drives.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 319b24bcab5b7..36520e48826f2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -829,10 +849,12 @@ static int choose_best_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio)
>  		pending =3D atomic_read(&rdev->nr_pending);
>  		dist =3D abs(r1_bio->sector -
>  			   READ_ONCE(conf->mirrors[disk].head_position));
> +		nonrot =3D test_bit(Nonrot, &rdev->flags);
> =20
>  		/* Don't change to another disk for sequential reads */
>  		if (is_sequential(conf, disk, r1_bio)) {
> -			if (!should_choose_next(conf, disk) && !pending)
> +			if (!should_choose_next(conf, disk) && !pending &&
> +			    (nonrot || !has_nonrot))
>  				return disk;

[Severity: High]
Does has_nonrot check if the non-rotational disks are actually readable?

Since has_nonrot is initialized as READ_ONCE(conf->nonrot_disks) at the top
of the function, it appears to evaluate to true if non-rotational disks are
configured in the array, even if they have failed, are rebuilding, or have
bad blocks.

If the non-rotational disks are unreadable, and we are evaluating a
sequential read on a rotational disk, (nonrot || !has_nonrot) will evaluate
to false. This causes the logic to bypass the early return for the
sequential disk.


[Severity: High]
Will this logic also cause sequential reads to thrash between idle rotation=
al
disks in a healthy mixed array?

If the array has non-rotational disks (has_nonrot =3D=3D true) that are cur=
rently
busy, but multiple rotational disks are idle:

1. A sequential read for HDD1 is evaluated.
2. The early return is bypassed because (nonrot || !has_nonrot) is false.
3. HDD1's pending count is artificially incremented to 1 via pending++.
4. HDD2 is evaluated, and since it is idle (pending =3D=3D 0), it wins the
   min_pending contest against HDD1.

>  			/*
> @@ -844,17 +866,18 @@ static int choose_best_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio)
>  			 * If there is no other idle disk, this disk
>  			 * will be chosen.
>  			 */
> -			ctl.sequential_disk =3D disk;
> +			if (ctl.sequential_disk < 0 ||
> +			    (nonrot && !ctl.sequential_nonrot)) {
> +				ctl.sequential_disk =3D disk;
> +				ctl.sequential_nonrot =3D nonrot;
> +			}
>  		}
> =20
> -		if (ctl.min_pending > pending ||
> -		    (has_nonrot && ctl.min_pending =3D=3D pending &&
> -		     ctl.min_pending_disk >=3D 0 &&
> -		     raid1_rr_pos(disk, rr_start, conf->raid_disks) <
> -		     raid1_rr_pos(ctl.min_pending_disk, rr_start,
> -				  conf->raid_disks))) {
> +		if (is_better_disk(pending, disk, nonrot, &ctl,
> +				   rr_start, conf->raid_disks)) {
>  			ctl.min_pending =3D pending;
>  			ctl.min_pending_disk =3D disk;
> +			ctl.min_pending_nonrot =3D nonrot;
>  		}
> =20
>  		if (ctl.closest_dist > dist) {
> @@ -867,7 +890,8 @@ static int choose_best_rdev(struct r1conf *conf, stru=
ct r1bio *r1_bio)
>  	 * sequential IO size exceeds optimal iosize, however, there is no other
>  	 * idle disk, so choose the sequential disk.
>  	 */
> -	if (ctl.sequential_disk !=3D -1 && ctl.min_pending !=3D 0)
> +	if (ctl.sequential_disk !=3D -1 && ctl.min_pending !=3D 0 &&
> +	    (ctl.sequential_nonrot || !has_nonrot))
>  		return ctl.sequential_disk;

[Severity: High]
Is it intentional that the sequential disk fallback is bypassed here?

Because HDD2 was idle (ctl.min_pending =3D=3D 0), this sequential fallback
condition fails. The function will then fall through and return
ctl.min_pending_disk (HDD2), moving the I/O away from the sequential disk
(HDD1) and causing the read to ping-pong between the rotational disks.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818070646.1029=
149-1-chencheng@fnnas.com?part=3D2
