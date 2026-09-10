Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DED73BBFB6
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789029107; cv=none; b=NQFaVGVGj4QoHfruvvtN/ldM3GniJqnMoGEOlsPT3KZfi8GTNpCGHDwFsND6+4bqaAy/oiGPrIQgOreU/5imqVKyOd0iqZUs/3NUjfrGzUG0/4E4t71qJkNGIPv5N9BTLfHpdZ/GqQ+mZzXR2vZdpEf3BlJS/oGoNjaTG+LB2t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789029107; c=relaxed/simple;
	bh=KQW06klW1AFZ7GAxuAFbITpA5FnZEi4PbovNr8oWIqY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pt4EYwL1FpwmoJGtpC6OEqhJpreRk9bqupgEEPYGr9ZHig/hTZnyK6JV8WxDoVZLPGiqksb2gVAVEhjLovtOznbXWgS5iMC9A5eMcT7AG6wNPorR/bMYSitnrRUkp2uvQ7LdAYvswSIwJEJDB3SQeTpsFuuYbcW/AwPFd1dFIe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QjIm8oCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QjIm8oCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0921F000FF;
	Thu, 10 Sep 2026 08:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789029105;
	bh=cz/OTRvoEecSxwrFd4Qg3F5A5JQpSuYB6vxJv6/MEH0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QjIm8oCcUhHDgVMYiCSrRLThVfMX2lsTaZux81eVDeilh1YNgy7Oy16yMwn/+k5dv
	 jbesbzNc6pu9/yzG30LDeieQJnOXptv6RF9wbtg2/Q+O6oWFYx5chKYStGBbAvGqQr
	 9IV8F1XvwSmAQDE0tyjGzYlIGHI4vt8WPBBu9J7xm7kt+aJKRYBaBTnVdsx3QkFGau
	 I/0nRfcXiRUhdtUWoUkg2ASnDTlqZ7YiUze3wdb0GBleluZRfxTr+vcl2DnnVfRXO+
	 1zBjbGXRl1N+dLiMikPFxEOU8p5L6o+ZfW1K9ui7s5kJKLuAayKEVPf2azpobRFqLN
	 KeN/gYRvenHYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/8] md: pass a queue_limits down to ->hot_add_disk()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260910081114.1605746-2-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-2-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:31:45 +0000
Message-Id: <20260910083145.AD0921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] raid1_add_disk fails to stack limits or validate compatibility for=
 replacement disks.
--

commit d7876b523180e9507873b141ec81e8cdf84d9929
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: pass a queue_limits down to ->hot_add_disk()

This commit updates the md hot-add disk paths to accept a queue_limits
argument. This allows callers to manage the limits lock explicitly when
adding a disk, preventing potential deadlocks.

[ ... ]
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1923,7 +1924,12 @@ static int raid1_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>  	for (mirror =3D first; mirror <=3D last; mirror++) {
>  		p =3D conf->mirrors + mirror;
>  		if (!p->rdev) {
> -			err =3D mddev_stack_new_rdev(mddev, rdev);
> +			if (lim =3D=3D MDDEV_STACK_SKIP)
> +				err =3D 0;
> +			else if (lim)
> +				err =3D mddev_stack_rdev_into(mddev, rdev, lim);
> +			else
> +				err =3D mddev_stack_new_rdev(mddev, rdev);
>  			if (err)
>  				return err;

[ ... ]

> 		if (test_bit(WantReplacement, &p->rdev->flags) &&
> 		    p[conf->raid_disks].rdev =3D=3D NULL && repl_slot < 0)
> 			repl_slot =3D mirror;
> 	}
>=20
> 	if (err && repl_slot >=3D 0) {
> 		/* Add this device as a replacement */
> 		clear_bit(In_sync, &rdev->flags);
> 		set_bit(Replacement, &rdev->flags);
> 		raid1_add_conf(conf, rdev, repl_slot, true);
> 		err =3D 0;
> 		conf->fullsync =3D 1;
> 	}

[Severity: High]
This is a pre-existing issue, but does this replacement path in
raid1_add_disk() omit queue limits validation?

Unlike the primary hot-add path modified above, the fallback block for
configuring replacement disks skips the queue limits stacking entirely.
If a replacement disk is hot-added with incompatible features, such as
a larger logical block size or an unsupported integrity profile, it
appears the array will accept the disk without validation.

Could this allow the queue limits API contract to be bypassed,
potentially leading to misaligned I/Os being sent to the underlying
block device and resulting in I/O errors or data corruption during array
reconstruction?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910081114.1605=
746-1-jinpu.wang@ionos.com?part=3D1
