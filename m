Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEAE63839A0
	for <linux-raid@vger.kernel.org>; Fri, 11 Sep 2026 04:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789100839; cv=none; b=Mne9W5GLL7gkjEvCTgayb2H660vIRZoul4yPXocK0alkRSr0Ybowkd3JVyPaol+JTsmawHUpUqqpXUqt3IE8qS3CF0LtQmb0DBlz1/JHCgK1GYCZSHnP59N6TH3tcm3bN57CI6gyDGEgfvRXuGzZLvLh+vkV9/HTKlluFdh7Swk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789100839; c=relaxed/simple;
	bh=EF8UoSdsoJ5R9BM//UcB+8VBPNvgHryyZQ5l0CADwDo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cVMOhmBAKDVwM0ML79GzK2vX2OrC/pL6do2li717VCRpa+jbcrf4/T1Xko546/srjLCzXZKjJ7auqTVx52TE1l8by8fI78Hq1QKvwsu2o/W2ge6IeOOx6cNXo16KXFqHKJcX+04qSt1EmPbQvqKSZksTbHqTTvtvCKTdVmw9Ac4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z7slzvgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z7slzvgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487AC1F00898;
	Fri, 11 Sep 2026 04:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789100837;
	bh=NcQcqqblyBb82psr+KrHrSfjZlP2IuBXWeCYEmJA88c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z7slzvgB7IctN5wANKgjbNcnv8tULIY9/IlCmJ4wbyuuysaOyn5GRM3QS2iKOnjlu
	 wW1wzc73EJWMn1HirJm+H1R0zd0P0yGtQq6AEe8KN7DSKYjecefEqzZ5C9IDqnhiVz
	 MXqfYGPOAMMaVmCqkzHo+KAldfb/cgG7qm1Gf1knQ+atv4+RLEp7El8JghkvyO/v2S
	 4LJHP+DPrGNjlthDrEp+rVLArQUxD2BE+T7XA3QFhTjKC/36zxzDyaUxZmZGJ0qq4s
	 YhLSlFu1589ePAUQcpapWoGzr7RtMEt/T3+UVAqGZ5rWXsbOFWjeXneNm8EpKbks7G
	 vV36MUKcDaLxQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] md/raid5: reject raid4/5 arrays with too few disks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260911041521.2433222-1-chencheng@fnnas.com>
References: <20260911041521.2433222-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 04:27:16 +0000
Message-Id: <20260911042717.487AC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Division by zero in `raid5_run()` when assembling an array with an=
 active reshape and insufficient data disks.
--

commit e2bb0701d8414cbf17eed6287965f8022ffe5eab
Author: Chen Cheng <chencheng@fnnas.com>

md/raid5: reject raid4/5 arrays with too few disks

raid4 and raid5 require at least two disks, while raid6 requires at least
four disks. setup_conf() only rejects raid6 arrays with fewer than four
disks. As a result, an invalid raid4 or raid5 array can be assembled with
no data disks and later reach raid5_set_limits().

Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@google.=
com/
Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..e1f20035703ba 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7657,9 +7657,11 @@ static struct r5conf *setup_conf(struct mddev *mdd=
ev)
>  			mdname(mddev), mddev->new_layout);
>  		return ERR_PTR(-EIO);
>  	}
> -	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4) {
> -		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n",
> -			mdname(mddev), mddev->raid_disks);
> +	if ((mddev->new_level !=3D 6 && mddev->raid_disks < 2) ||
> +	    (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4)) {
> +		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n",
> +			mdname(mddev), mddev->raid_disks,
> +			mddev->new_level =3D=3D 6 ? 4 : 2);

[Severity: High]
This isn't a bug introduced by this patch, but does this fully prevent
invalid array geometries from causing panics during array assembly?

In raid5_run(), if there is an active reshape and the array is assembled wi=
th
insufficient data disks, we calculate new_data_disks and divide by it before
setup_conf() is called to validate the array geometry:

drivers/md/raid5.c:raid5_run() {
    if (mddev->reshape_position !=3D MaxSector) {
        ...
        new_data_disks =3D mddev->raid_disks - max_degraded;
        if (sector_div(here_new, chunk_sectors * new_data_disks)) {
            ...
        }
        ...
        sector_div(here_old, chunk_sectors * (old_disks-max_degraded));
    }
    ...
    if (mddev->private =3D=3D NULL)
        conf =3D setup_conf(mddev);
}

If a crafted superblock sets raid_disks <=3D max_degraded and reshape_posit=
ion
is not MaxSector, these divisions by zero are reached before the new checks
in setup_conf() can reject the array.

Could these checks be moved earlier in the assembly path to prevent the
divide-by-zero panics?

>  		return ERR_PTR(-EINVAL);
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911041521.2433=
222-1-chencheng@fnnas.com?part=3D1
