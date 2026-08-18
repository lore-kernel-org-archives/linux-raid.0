Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C18F340DB8
	for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2026 07:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787037390; cv=none; b=eHRzQZ4JI7viB8CY0lAWqLs3xQXR8pvttdMRr/cUTKADgEEepPVl8KjzITIxSSYdhJqML8V4EAQhFvSE9xfthLhxTF08q1eBj2pLoTTh+/97UgduZe4wbg9mGjMVcDRpRj3LmxdInUfKT5xfKFUiNf3Vzp/M+KEwnD204tLNg4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787037390; c=relaxed/simple;
	bh=V2LEZ5nuf1ArlGe27ZlDIseGScyYTAq+TCepfNY0OeI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DxKrBPRnKPuN8MOsP48HoNX4Ss9uVjIozscRO7dPjGicKnbjMBV8ZmQ00EwxN5cVVe6nWNEh1HaDZXa3+PtQlRiGjCWWd1S87qjjc+jHOJzM9NHkr9nnIq9jyAlEPoDMkEZUkMtpxVzuJKj80YBjnRRVDTkTUIQBD3KyjMSOgDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGQCSgJ6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGQCSgJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20241F000E9;
	Tue, 18 Aug 2026 07:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787037389;
	bh=KaGAb2CCejRgtwAYZats+490RgKMgsR3f0aihU+9xbc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HGQCSgJ6hJpIEJL/B5RxfF+gDbJlV1H11NxS13AlYwk7sdv+nK5JIrsLj09iZQfYU
	 UE3kFRc6wzVFGfADon3Z+aQVpspCrrZGeOuBa8pTkJZ8nyz+Fr3mB8G+hzQIYMMPRW
	 QJbwVOcRWgvsJibKyPsxtV5gylNRnU1du45EWxe+Lmhq3jpT/iSycgInIcJgpZPG2B
	 Q2aaosJRXBNKXFN/I3oMmnr2P2lcSEoSwxioaqJcdCnSM0r1zcj4Ggn8Sb3I7PNlGZ
	 6XeoB4KsjKVFTRvYamG/rJr9xRPql7CZSKxuDf6+mYG5OWRIUS+Ub4c/FkF3XA3h+2
	 b0wD4rbfqU7BA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/5] md/raid1: balance reads across non-rotational
 disks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260818070646.1029149-2-chencheng@fnnas.com>
References: <20260818070646.1029149-1-chencheng@fnnas.com>
 <20260818070646.1029149-2-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 07:16:28 +0000
Message-Id: <20260818071628.D20241F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The use of a global atomic counter (`atomic_inc_return(&conf->re=
ad_rr)`) in the read fast-path introduces severe cacheline contention on hi=
gh-concurrency NVMe arrays, heavily throttling peak read IOPS scalability.
--

--- Patch [1]: [RFC PATCH 1/5] md/raid1: balance reads across non-rotationa=
l disks ---
commit fe7aa5a93e1157781321a0273156730cd901aaec
Author: Chen Cheng <chencheng@fnnas.com>
md/raid1: balance reads across non-rotational disks

This commit optimizes read balancing for non-rotational disks in RAID1 by
distributing reads more evenly when pending IOs are equal. It introduces a
round-robin start slot rotation across disks to prevent low-depth random
reads from always sticking to the first slot.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f0646fb24371f..319b24bcab5b7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
[ ... ]
> @@ -799,6 +806,10 @@ static int choose_best_rdev(struct r1conf *conf, str=
uct r1bio *r1_bio)
>  		.sequential_disk	=3D -1,
>  	};
> =20
> +	if (has_nonrot)
> +		rr_start =3D (unsigned int)atomic_inc_return(&conf->read_rr) %
> +			   conf->raid_disks;

[Severity: Medium]
Will updating a global atomic counter on every read operation introduce
severe cacheline bouncing across CPU cores?

For high-concurrency NVMe arrays processing millions of IOPS, could this
global atomic increment in the read fast-path become a major scalability
bottleneck due to exclusive cacheline ownership?

> +
>  	for (disk =3D 0 ; disk < conf->raid_disks * 2 ; disk++) {
>  		struct md_rdev *rdev;
>  		sector_t dist;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818070646.1029=
149-1-chencheng@fnnas.com?part=3D1
