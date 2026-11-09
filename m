Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216448;
	b=o9uMPMm6NRwapdBIcsXQ9YsFLdI7/wBrYw5Y64BHJFxHsC8kyYhGRav2UqimGcjzHSMB
	 +LuiXrwi+avImT8/RinxC29FZX0giTogN7WYTTkFuX4TuiXsd6xSz+qzSmPxMxsnrjVqy
	 lNcnza/hXSoToJd0uM52lp0Oo+v6TVvdOn7JQwmGaUMa2hlMR9qqt/uDVXEpfaS7EEvbz
	 O5iwO4RF0so5sZbCYmFVVLxjVfQLEGeyVKfoL/jQG0sfrELU9Cru6tthPUR4SV6XFU02D
	 ux8D0aar/TC4Jt64tTbeEhzwFawXrvS6/fV389eiLOvlmN4Mp3Hm2rSqFfskJyI1Qkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216448;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pHg9AEOj1s5JBt+9tBWnH7MLBFDDNBPWtLIVgzlX8hQ=;
	b=KU2KgA6rQxKGQWL2gltmEYi/AAPc2VFyXIeKG3n4at4eUf3Vrw+ougtzZX8c7SIQIlMM
	 YGlvf404uR9ts6gcczE9xNebnLvTOrh2I3u0M7kR/IOw0iBdCL1W/ILu04o36Jciyw0yl
	 6ca0tgukXSyu+DLi0c8cMBUN62fJcgr+vZerKgyGpJIwQhRHXySWOM4tfqsog82gyHytR
	 W+0URyib7aMDeSV+iZpAky6+H1yBXwnGiE/+BcsVql0L9T5NQaGVI2DYMIZ6FOZppjP//
	 CH7mzX4R2SYTNP1CDyZCmusO59suFySwUxbocyzzWbIHX/NLHtvNJPjH6RiR1sNMngw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4LI9eU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3E8606A332
	for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2026 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W4LI9eU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402A81F0089F;
	Mon,  9 Nov 2026 09:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794216447;
	bh=pHg9AEOj1s5JBt+9tBWnH7MLBFDDNBPWtLIVgzlX8hQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W4LI9eU52k3gHN4okHRI9rjtXacjpNlGGHLt8+0LWvaQHVnIf4+EDkGMFrdVy//NY
	 Vtviai5aflMKVMkBsjkwzoEXKnGGK1U5G+rfL4mOhX2+kyt4szMgFNdBKEhhAvQdtG
	 MR/a5HJDftIYuT9G+h0bedkdxkmTt/5uO/13d+43IP2i2SGYUauyvDJKED1bbgvxil
	 Sdb38wuVtt/ojq+8L0DuWsEO1DbzkBRKqMfsMM58BV8qdB4vj1IfVMmLSE4WtdFKEY
	 bny+HBi5Cm4/r5t37eJB1muhdiHadgIQUaQ4H8VmJktvhq36yWbPEBa1pXIANZrA9M
	 G4OetoXvpl8EA==
Message-ID: <sashiko-outbox-204695@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] md/raid5: preserve active PPL log when removing a
 replacement
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yingjie Wang" <x-professor@outlook.com>
Cc: =?utf-8?b?bGludXgtcmFpZEB2Z2VyLmtlcm5lbC5vcmc=?= <linux-raid@vger.kernel.org>, yukuai@fygo.io
In-Reply-To: <4e31c3b1c402e1b80cfd027c3441684dfd1909a6.1794215128.git.x-professor@outlook.com>
References: <cover.1794215128.git.x-professor@outlook.com>
 <4e31c3b1c402e1b80cfd027c3441684dfd1909a6.1794215128.git.x-professor@outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 09:27:26 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] md/raid5: raid5_remove_disk() fails to clear slot beyond
  raid_disks with PPL
--

commit ade16f0f32de5eb72fa3bf67b1040d7514f41d37
Author: Yingjie Wang <x-professor@outlook.com>

md/raid5: preserve active PPL log when removing a replacement

This commit restricts the log_modify(conf, rdev, false) call in
raid5_remove_disk() to cases where the removed device is the slot's active
rdev rather than a replacement device, and moves clearing *rdevp after
log_modify().

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 455e36ddceeed..2f4fe416113c0 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8474,12 +8474,12 @@ static int raid5_remove_disk(struct mddev *mddev,=
 struct md_rdev *rdev)
>  		err =3D -EBUSY;
>  		goto abort;
>  	}
> -	WRITE_ONCE(*rdevp, NULL);
> -	if (!err) {
> +	if (rdev =3D=3D p->rdev) {
>  		err =3D log_modify(conf, rdev, false);
>  		if (err)
>  			goto abort;
>  	}
> +	WRITE_ONCE(*rdevp, NULL);

[Severity: Medium]
Does moving WRITE_ONCE(*rdevp, NULL) after log_modify() prevent removing a
disk in a slot where number >=3D conf->raid_disks when PPL is enabled?

After shrinking an array, conf->raid_disks is smaller than conf->pool_size
while extra disks remain in conf->disks[number].rdev.  If PPL is enabled
before those disks are detached, ppl_conf->count is initialized to
conf->raid_disks, and ppl_modify_log() rejects any slot at or beyond
conf->raid_disks:

drivers/md/raid5-ppl.c:ppl_modify_log() {
	...
	if (rdev->raid_disk >=3D ppl_conf->count)
		return -ENODEV;
	...
}

Jumping to abort on that error before clearing *rdevp leaves rdev stuck in
p->rdev, and every subsequent removal attempt fails with -ENODEV.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1794215128.gi=
t.x-professor@outlook.com?part=3D2
