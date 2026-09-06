Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8E15474E
	for <linux-raid@vger.kernel.org>; Sun,  6 Sep 2026 14:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706521; cv=none; b=FJVrHeQqZjvxDSgVeds/fPmGvl8HqOZ6xlc68enO59vRV6mg0/CCoZ9EX44mWoUzyNtxCb9Xb9CIpoZJazOOLhhXR2mhRoFcbLiAQwCdr7F/4Xxke7DkfgUH8Tm2L2uRTQdTqLz0OeERZ4oYfJbp6NtTWhe/lD6BXyft44sw3WA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706521; c=relaxed/simple;
	bh=STbAWFTX1qD2tDwEsU3DpR3r3vRkKc5fxdNUbYR0d1o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LWB2cYdDvg/cFc0/22LiFGGkv5TiHfyndZ1sWchFarWZwFUr0HtQZMwfg5jpDpnt19t/b/AJtgDA65JjDNos3gdmvw/0gVWAlj6hIdKV1o5aNorHRhu1No+xZuvZcT8Syh/weLpoN/81MaZyIoRhDwe+98q1UCl1jH8XtmCN/h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdP1NL2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdP1NL2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA711F00A3A;
	Sun,  6 Sep 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788706518;
	bh=flWKADKKKNcyK95JStaK0RFF34Xh9z826gCPJxVc11g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BdP1NL2adYpLINXKk/eIpaI45Z/XAvozrJrMphFXAU6OG9su4WDytjgsfIkauwH2k
	 oeHPywTufVD3X6BOjbHq7z4U8cjoPz0uEeiG32xfJTvmoVr4AChRljaDoUhxM1cK6K
	 qpxqDoMJSk/by5HgRlJwglbp6ywhgz6h3Es0EczEc+eF/bfcZCuZuVeomXGvdi3ec2
	 iEt+cKsem5P9YVh05dVOxYZjyrl6VgFyNGiRFToAioRANvOG0gyCfS+FaYO/EQ1k/G
	 FESmPIi4gG20S882S9bSJq2hlUtFqMnq6uBRdWIFwD8+IcymhZKZp08RNd0iGFlxmK
	 zLEdv9JdUBh6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid0: validate device count before allocating
 devlist
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chandradhar Kumar" <chandradhar.2003@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260906143928.105165-1-chandradhar.2003@gmail.com>
References: <20260906143928.105165-1-chandradhar.2003@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 06 Sep 2026 14:55:17 +0000
Message-Id: <20260906145518.7FA711F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The newly added validation `if (nr_devs < mddev->raid_disks)` us=
es signed integer comparison, which can be bypassed if `mddev->raid_disks` =
is set to a negative value from user-space, resulting in an incomplete fix.
--

commit b0e2bd0b0a05bf7824ef3d801efa4d7542d36bbc
Author: Chandradhar Kumar <chandradhar.2003@gmail.com>

md/raid0: validate device count before allocating devlist

This commit adds early validation to check if there are enough member
devices before allocating the device list. It aims to prevent excessive
allocations that trigger warnings on invalid configurations.

Link: https://syzbot.org/bug?extid=3Da32ff75e417c0f49a8e9

> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 35e103f0c2c3e..586e3411f24c1 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
[ ... ]
> @@ -147,6 +150,14 @@ static int create_strip_zones(struct mddev *mddev, s=
truct r0conf **private_conf)
>  	conf->strip_zone =3D kvzalloc_objs(struct strip_zone, conf->nr_strip_zo=
nes);
>  	if (!conf->strip_zone)
>  		goto abort;
> +
> +	if (nr_devs < mddev->raid_disks) {
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
[Severity: Medium]
Does this signed comparison allow bypassing the early abort if a negative
value is provided from user-space?

If a user issues the SET_ARRAY_INFO ioctl with a negative value for
raid_disks, it gets assigned directly without validation:

drivers/md/md.c:md_set_array_info() {
    ...
    mddev->raid_disks    =3D info->raid_disks;
    ...
}

When followed by the RUN_ARRAY ioctl, this validation check in
create_strip_zones() evaluates to false (e.g., 1 < -1). This bypasses the
check and allows the negative value to be cast to SIZE_MAX in array3_size()
which is then passed to kvzalloc().

Could this trigger the exact same warning for huge memory allocations that
this patch was explicitly intended to fix?

> +		pr_warn("md/raid0:%s: too few disks (%d of %d) - aborting!\n",
> +			mdname(mddev), nr_devs, mddev->raid_disks);
> +		err =3D -EINVAL;
> +		goto abort;
> +	}
> +
>  	conf->devlist =3D kvzalloc(array3_size(sizeof(struct md_rdev *),
>  					     conf->nr_strip_zones,
>  					     mddev->raid_disks),

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260906143928.1051=
65-1-chandradhar.2003@gmail.com?part=3D1
