Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1DD3B840B
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789366021; cv=none; b=U7p5c59eihy//WFNN3sKAo4+LwdcGwQLn6dJAv4+tla27YNAxjjLSN0k6BPYFPB/ML1vMnnJ9hof0J4697VomBk5QmWwmR+iGQLKqfoSvC1lKbbwMKFKX2MTGqg9mWb2BfO3Byl6heFqLUma7xNE5NFD7Nu2cCBGKI4nDjl1VZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789366021; c=relaxed/simple;
	bh=iI5+PZvGtbOzRMYq0PjqtqAi+3bMFL5QBN+IyqXLt88=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B4yf+AjDZIuOL3ewXmNDq0s6XRw8yokngX2QM2BcPaPJQTH0wHMIAjcomp1ODtJY64qvbFqW0IFjj0vNBtgCqi2nQSx/tHzGaZQ4dJcycvn9kPs1KWp488FqwVm8DAytVc+wZMXWK6xYu83bDm9dppyFxuIFlwB/+zep+jfMLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HXXTLG1N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HXXTLG1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937B01F000FF;
	Mon, 14 Sep 2026 06:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789366016;
	bh=iNTS0sjH5LyECgZUnCELnuAoDkniTwL7MuxtYIqFRLM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HXXTLG1NACnvD4ew1Drovp2LadNbyPDF41JkEhk7P7sgpEODoBz480M3yf3alXVx6
	 dJdRbHqpQ+AO+hClYX/mLXkxE3conxmYNsgesm29RGC8cjYuFcqqUr5TM9oHHrpCnF
	 YQkmcxNCdplfwyKD2xrV1sSM7zt//uXpsXfOEy7q3KMVVFnlTgQrSmBb266C+vJvwC
	 yvqVvNXYi2x13OKJEddeXv5GgPVcgA+45X0mvCvjJbXVK4QviI2hxG57uDdkp6RFKA
	 NY7uNIPCRjr13xd6gCRLQgJIuJe+qs1AE7Kcpxpyy6tnCiCaVq+gHV0yIJ9jZvf9lU
	 oc6NwYTTstdhg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: fix out-of-bounds access to superblock disk array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Deepanshu Kartikey" <kartikey406@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260914055619.32929-1-kartikey406@gmail.com>
References: <20260914055619.32929-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 06:06:56 +0000
Message-Id: <20260914060656.937B01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Skipping devices with an out-of-bounds `desc_nr` in `super_90_sync=
()` leaves `rdev2->desc_nr` stale, silently corrupting the superblock's `th=
is_disk` field.

Pre-existing issues:
- [High] The patch fails to validate `sb->this_disk.number` in `super_90_lo=
ad()`, allowing an unvalidated value to be assigned to `rdev->desc_nr`, whi=
ch subsequently leads to out-of-bounds array reads in `super_90_validate()`.
--

commit b64c4503567571cb6b3f8a25617dfc053378beea
Author: Deepanshu Kartikey <kartikey406@gmail.com>
md: fix out-of-bounds access to superblock disk array

This commit adds bounds checks for raid_disks and desc_nr when loading and
syncing v0.90 superblocks. It aims to prevent out-of-bounds array accesses
to the 27-element sb->disks array caused by maliciously crafted or
corrupted metadata.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..81588c3fee49a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1393,7 +1393,8 @@ static int super_90_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor
>  		goto abort;
>  	}
> =20
> -	if (sb->raid_disks <=3D 0)
> +	if (sb->raid_disks <=3D 0 ||
> +	    sb->raid_disks > MD_SB_DISKS)
>  		goto abort;
> =20
>  	if (md_csum_fold(calc_sb_csum(sb)) !=3D md_csum_fold(sb->sb_csum)) {

[Severity: High]
This is a pre-existing issue, but while we are adding bounds checks to
super_90_load(), does this function still leave a critical path vulnerable?

Slightly further down in super_90_load(), the code does:

    rdev->desc_nr =3D sb->this_disk.number;

Since sb->this_disk.number is read from the untrusted superblock without
validation against MD_SB_DISKS, an unvalidated value is assigned directly
to rdev->desc_nr. Later during array assembly, super_90_validate()=20
unconditionally uses rdev->desc_nr to index the 27-element sb->disks array:

    desc =3D sb->disks + rdev->desc_nr;
    if (desc->state & (1<<MD_DISK_FAULTY))

Can a maliciously crafted MD superblock still trigger an out-of-bounds
memory read through this unvalidated rdev->desc_nr?

[ ... ]

> @@ -1693,6 +1694,13 @@ static void super_90_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  			desc_nr =3D rdev2->raid_disk;
>  		else
>  			desc_nr =3D next_spare++;
> +
> +		if (desc_nr < 0 || desc_nr >=3D MD_SB_DISKS) {
> +			pr_warn("md: %s: desc_nr %d out of range for rdev %pg, skipping\n",
> +				mdname(mddev), desc_nr, rdev2->bdev);
> +			continue;
> +		}
> +

[Severity: High]
Does skipping out-of-bounds devices here leave rdev2->desc_nr with a stale
value?

By using continue to early-exit the loop, we skip the subsequent
rdev2->desc_nr =3D desc_nr assignment. Later in this same function, the
superblock's this_disk field is populated using rdev->desc_nr:

    if (rdev->desc_nr >=3D 0 && rdev->desc_nr < MD_SB_DISKS)
        sb->this_disk =3D sb->disks[rdev->desc_nr];

If the target device was skipped during the rdev_for_each loop, will it
reuse its stale desc_nr and copy the descriptor of whichever other active
device took that slot, potentially causing metadata corruption?

>  		rdev2->desc_nr =3D desc_nr;
>  		d =3D &sb->disks[rdev2->desc_nr];
>  		nr_disks++;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914055619.3292=
9-1-kartikey406@gmail.com?part=3D1
