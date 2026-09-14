Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF501BA34
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 00:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789344170; cv=none; b=Dt8MkPIHCRyk1uXki82RGMZcGoBdh4comOvOG1TMD5OmbGBQS2YsjjR+dJDyR7yvIsEBljqZ8qSmS6r4odlcoWI03kkSjDrMytkgieBZRTluzx0X6xOtu9JxtJLpp73s+YIF6LXEI3wzEzrdPzWQXUy7Ek01rPxsASeSIsMvHlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789344170; c=relaxed/simple;
	bh=wUflXk0TfOkdAXoKdtXiAmDhCRqydbHS2N+jrZDsx34=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W+Q+flIR3xlnu8gNk1ybDRNQmQsGFXBoO3f/8rrSvHdY1ExsasOVojTY+osnpAyY/FBmjz3qx62+gljzFx6wmNh7Ka/YcKsU+10svLn4mPTMrLVIRlwrTCkQwVlR/T7IQDPITuh16pPRqAv5Q4Zyy5pKo1Y9AWfAo8QE/1tbMPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hTTWE3V9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hTTWE3V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE661F000FF;
	Mon, 14 Sep 2026 00:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789344168;
	bh=92UV79aQGQ1IYSNLnJeE0F0O2wTfItQGMzzpFpPU8dY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hTTWE3V9mcJzWRPF33sbfKAT0gqvuEAscorvUP9emlez5PGTH7rZ3hNBAQWVzUn6L
	 q/+IcglOZ6LYkizmP5jDh57W5xyfBcBDZTlOcAh6w4CmMfmVU5fTbKPsAKODKwxtBV
	 Lt3HTQ6GYU72ukoa5fNgBVkuHkG6IXVn4yrE6wu3e0QYQf0JHbju5MnWvkSvgAOrbn
	 hMDvdkSilWr62yQIx7sFRBsVDCesin/SkmaPcLB9trE9FC36G1MKJoaOfd/2jxcnvH
	 TSsS4FpD/OZxfEJnpk8jgFqNh+GuI5V7J3Djk4FS8KaILQ4phv9AyBSF8ruxhb3ZRG
	 6gbgUW0xT2U4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: add max_disks bound check in older version
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aaditya Kansal" <aadityakansal390@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260913234627.465492-1-aadityakansal390@gmail.com>
References: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
 <20260913234627.465492-1-aadityakansal390@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 00:02:47 +0000
Message-Id: <20260914000248.2BE661F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Skipping disk descriptor assignment via `continue` leaves `rdev->d=
esc_nr` unhandled, causing out-of-bounds array reads or silent metadata cor=
ruption when assigning `sb->this_disk`.
--

commit c2add8f93f69d601b2a3935bff10c239b5018489
Author: Aaditya Kansal <aadityakansal390@gmail.com>

md: add max_disks bound check in older version

This commit adds a bounds check to prevent raid_disks from exceeding
the maximum allowed disks for version 0.90 superblocks. It prints a warning
and skips processing for devices that exceed this limit.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..f5fce41637f12 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1693,6 +1693,12 @@ static void super_90_sync(struct mddev *mddev, str=
uct md_rdev *rdev)
>  			desc_nr =3D rdev2->raid_disk;
>  		else
>  			desc_nr =3D next_spare++;
> +
> +		if (desc_nr >=3D MD_SB_DISKS) {
> +			pr_warn("md: raid_disks =3D %d exceeds max_disks =3D %d for version 0=
.90\n",
> +					desc_nr, MD_SB_DISKS);
> +			continue;
> +		}

[Severity: High]
Does skipping the disk descriptor assignment here leave the descriptor numb=
er
unhandled?

If an array has enough devices such that a newly added spare reaches
MD_SB_DISKS, this continue statement skips setting the descriptor number.
Since new devices are initialized with a value of -1, it remains -1.

After the loop, the descriptor is used unconditionally:

drivers/md/md.c:super_90_sync() {
    ...
    sb->this_disk =3D sb->disks[rdev->desc_nr];
    sb->sb_csum =3D calc_sb_csum(sb);
}

Can this lead to an out-of-bounds array read if rdev->desc_nr is negative or
invalid?

This is a pre-existing issue, but super_90_validate() blindly uses the
descriptor number read from the on-disk superblock to index the disks array:

drivers/md/md.c:super_90_validate() {
    ...
    if (sb->disks[rdev->desc_nr].state & (
    ...
}

If the bounds are not strictly enforced, could a crafted disk image trigger
an out-of-bounds read there as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913234627.4654=
92-1-aadityakansal390@gmail.com?part=3D1
