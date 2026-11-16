Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794819258;
	b=JLS/y+Pzro/majFflpoMco563hcBSMhc2gQ8PRDf5Yv/wNQJlKK+S/LEYXXwgcunegZR
	 tJDC+q+2hK/nOd/1W+PGgvOF1mtIzYP/cwNxOVgLjKKgera8sA99jm4DX/GmLkGnTvnWM
	 WecKiY4YGIQrxLkckafRsQDrissyBNBNS60Ti+Lz0bSlmMr1v5a+CTDWHjF4kahohCqL5
	 UM5S1jQ8iWj5VXwsjHUXoZY84yrRKO7liH1vX2X0OCa0sViVB36Z99ysC32CkdL7kefC9
	 khBj1tqXm6iqY6QFimttC6JdDuSUN5IYbtQttiZIsJXOq1gzL+zIjztnuErSMQlgO6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794819258;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=T5HfMaPXjs2pwmqycxo7uN57u8Ox7P1vNyGAHp2BryY=;
	b=Xvlh28PUXYf7opWGN6Q4YbFFEXNysRz+bNrZaGZuoIFj6WsBWGl8otqAscUgipDhUnPw
	 185ifGTObiM6/hRWURoycjIWFhLw7ilVwXYOw1wPxbnMd0Hk3eaNH1h9Sz7xI5b6K5yt4
	 DBUcDcLtt88cReNNqTNiBHMPPURDgfS1XWREJ3F8mNXMmfyxgW4lhfUEGeXygTrRqIsjV
	 avg/BFncUoQCgcNqm89Bgcq8jrtcXo1cTT37pRTrJ7tGP2fO1Ee/K1JDdsiAD1S1nNV4h
	 ZiKqyb/VRVolPM55Cgc3AcFCZMEWoOv26mGKMuL/HbISbj1PrfY+lx4K5hEeTxqKSrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivPTzRGo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8748E606A32C
	for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2026 08:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivPTzRGo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7471F000C5;
	Mon, 16 Nov 2026 08:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794819258;
	bh=T5HfMaPXjs2pwmqycxo7uN57u8Ox7P1vNyGAHp2BryY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ivPTzRGoaOv8AvPsEpL91lOHVf1IBZZpEmkKOfouiVUtjeOqq6x2Z8M+GVrojMBNH
	 LTf0JMJLh2mkzjP89cAdZCeJLngnIML7oVKwBJAnMgOd7noR4VKc7P34J1P02k6MSU
	 Zb5xcEAsxoXz1GSzOErLmY++6VsoGUfML7JY4yeErPoS4HyreSn0kjvQiMa7FGIVKr
	 eI+oW5OBSuNWIkcJxStgava73wVlGAK3qkigjePnbn/x8hBO2lYQrlu2OWPybdvwqA
	 vh/On4NQ6Z7V6vetI/6gN5T/+FX/rP6ZQbwu3zXDt3M6Q1LjXmyo0tUnXaHRIi9RZS
	 QngE7kH2MhK6A==
Message-ID: <sashiko-outbox-216570@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: reject out-of-bounds desc_nr in super_90_validate()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shuai Liu" <847807867@qq.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <tencent_3583131EEE6BD2102C15F21A4DEEB86A6208@qq.com>
References: <6afa2ce8.920b2b3a.148c65.0040.GAE@google.com>
 <tencent_3583131EEE6BD2102C15F21A4DEEB86A6208@qq.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 08:54:17 +0000
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
- [Medium] md: ignored super_90_validate() error in md_add_new_disk()
  and add_bound_rdev()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Medium] md: missing raid_disk and delta_disks validation in
  super_90_validate() [1]
--

commit 8c2da3468482d3b2e5d7496a1240f196823bd4e4
Author: Shuai Liu <847807867@qq.com>

md: reject out-of-bounds desc_nr in super_90_validate()

This commit adds a bounds check on rdev->desc_nr in super_90_validate() to
reject values outside [0, MD_SB_DISKS) with -EINVAL before indexing
sb->disks[].

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..83009b0d84092 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1495,6 +1495,9 @@ static int super_90_validate(struct mddev *mddev, s=
truct md_rdev *freshest, stru
>  	mdp_super_t *sb =3D page_address(rdev->sb_page);
>  	__u64 ev1 =3D md_event(sb);
> =20
> +	if (rdev->desc_nr < 0 || rdev->desc_nr >=3D MD_SB_DISKS)
> +		return -EINVAL;
> +
>  	rdev->raid_disk =3D -1;
>  	clear_bit(Faulty, &rdev->flags);
>  	clear_bit(In_sync, &rdev->flags);

[Severity: Medium]
Can a hot-added disk with an out-of-bounds sb->this_disk.number still be
accepted onto a running persistent v0.90 array?

Both md_add_new_disk() and add_bound_rdev() ignore the return value of
validate_super(), and unlike super_1_validate(), super_90_validate() does
not reset rdev->desc_nr =3D -1 on failure.  When sb->this_disk.number >=3D
MD_SB_DISKS and MD_DISK_JOURNAL is set, bind_rdev_to_array() skips its
max_disks check and add_bound_rdev() proceeds to hot_add_disk() with the
out-of-bounds rdev->desc_nr intact.  When sb->this_disk.number < 0,
bind_rdev_to_array() reassigns rdev->desc_nr to an in-range slot and the
second validate_super() call in add_bound_rdev() reads a different
descriptor slot than sb->this_disk.number.

[Severity: Medium]
This problem wasn't introduced by this patch, but can unvalidated
sb->delta_disks and desc->raid_disk values in super_90_validate() cause
out-of-bounds indexing into personality disk arrays [1]?

super_90_validate() copies sb->delta_disks into mddev->delta_disks and
desc->raid_disk into rdev->raid_disk without bounds checks:

drivers/md/md.c:super_90_validate() {
	...
		if (mddev->minor_version >=3D 91) {
			mddev->reshape_position =3D sb->reshape_position;
			mddev->delta_disks =3D sb->delta_disks;
	...
	} else if (desc->state & (1<<MD_DISK_SYNC)) {
		set_bit(In_sync, &rdev->flags);
		rdev->raid_disk =3D desc->raid_disk;
		rdev->saved_raid_disk =3D desc->raid_disk;
	...
}

When hot-adding via add_bound_rdev(), mddev->pers->hot_add_disk() is
called directly after super_90_validate() without analyze_sbs().  Even
during assembly, a desc->raid_disk >=3D 0x80000000 becomes a negative
rdev->raid_disk (< -1) with In_sync set, or a negative sb->delta_disks
inflates the upper bound in analyze_sbs() past mddev->raid_disks.
Personality handlers such as raid1_add_disk() then index
conf->mirrors[rdev->raid_disk] out of bounds.

[1] https://sashiko.dev/#/bug/linux-9ad89505-1b9e-435b-941d-6a126f8f4adb

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/tencent_3583131EEE6=
BD2102C15F21A4DEEB86A6208@qq.com?part=3D1
