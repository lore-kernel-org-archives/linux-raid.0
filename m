Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB243D3D1B
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 11:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782213933; cv=none; b=ig7bKBJEsYEHRcdSXcDXouDyT/0/OZnI2ZSVYQFgzi6yfiKL+d97En3/Z5NOm+2GeR/tcmCG6v8Cm7N+2W/bfJhViHTQc7pzrQLbr2fW2muDHi9Zb0tCdBtewzuX3YxBoUuMdAE822w2FwlANeWHydSLFQOA0o9YSmIUPotd9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782213933; c=relaxed/simple;
	bh=uM+YVgMbBzwqqpka5OcCtONTl5BAjlrjVBGmbr/b3l0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=agsQnxvsSbImGCZYHQTtv8ofDCyQvZgrSA/4s9X8bTkocU8Z1gXda1AegpFWy5WT3Uwh74yjz0sSDeTkupyA2p91yNqwinRF6uWq7ePLH657oUB86dMShzpMeC/KindVbh9NGPw8bgFAOVOBhUFhsqC1hKtXS/ULoc6Q2KKHoAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHVpwa0/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHVpwa0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4761F000E9;
	Tue, 23 Jun 2026 11:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782213932;
	bh=mjzY83e3nJOMx4ZDnqMxT8UboF7g9vsC9hcGAMIVy/I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dHVpwa0/cAE7fhs/MoPe/9WkLRHszRzjVT2L5ARY43kH2ks9FKZlpknbYA8DCkUFT
	 N+TS04d9JircUcpOyueFeRrAH0GL49BZkO8TlG0pMbJgV4van99MeVfAF6MnEwNaXr
	 2pkWfbNToo+417SVZBcVsYdguNTjyVdaWwLEm566+mjxvJIyGO18tDxJ7JnvyJzHjO
	 xt+dJtmctZ9qyNa+Z1IPsXB1EKKFuQz8bc1/y+OB6nrDB1dFPfFKydUsMxVokS13QY
	 oo76614TKcO1Cm8D4yl1/1pJMoc0xuF1di5ZLI2jXiL9ZSEmKnZy667Ri//nJSaTMn
	 QyOkku+THmSlw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: use READ_ONCE() for lockless reads of sb_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260623111617.2500313-1-chencheng@fnnas.com>
References: <20260623111617.2500313-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 11:25:31 +0000
Message-Id: <20260623112532.4D4761F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Low] Lockless plain reads of `mddev->recovery` will cause KCSAN data rac=
e warnings, similar to the ones fixed for `sb_flags`.
--

commit f286787fa23a14cb6ec022eb99574f7a85f9957d
Author: Chen Cheng <chencheng@fnnas.com>

md: use READ_ONCE() for lockless reads of sb_flags

This patch adds READ_ONCE() annotations to lockless reads of mddev->sb_flags
across md, raid1, raid5, and raid10. It aims to fix KCSAN data race warnings
caused by concurrent set_bit() operations on sb_flags.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 096bb64e87bd5..c5c50640b6849 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6832,7 +6832,7 @@ int md_run(struct mddev *mddev)
>  		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>  	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);

[Severity: Low]
This is a pre-existing issue, but since this patch targets KCSAN warnings f=
or
atomic bitmasks, could plain lockless reads of mddev->recovery trigger simi=
lar
data races?

There are places where mddev->recovery is read without locks and without
READ_ONCE(), potentially causing KCSAN noise against set_bit() updates:

drivers/md/md.c:md_sync_action() {
    ...
    unsigned long recovery =3D mddev->recovery;
    ...
}

drivers/md/md.c:set_bitmap_file() {
    ...
    if (mddev->recovery || mddev->sync_thread)
    ...
}

drivers/md/md.c:update_array_info() {
    ...
    if (mddev->recovery || mddev->sync_thread) {
    ...
}

Should READ_ONCE() also be applied to these reads of mddev->recovery to
provide a more complete fix?

> -	if (mddev->sb_flags)
> +	if (READ_ONCE(mddev->sb_flags))
>  		md_update_sb(mddev, 0);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623111617.2500=
313-1-chencheng@fnnas.com?part=3D1
