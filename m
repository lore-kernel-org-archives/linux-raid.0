Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AF0233947
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230515; cv=none; b=SbnI5U7oRZlRenYzg8aY4eF8p1Q4rMWVNlFSiYh6TgXAlp5uu3sAFA9ANVFA2ZiLtw3sxobT2tQO0prmvkVmBctc+RKr3f4XbGTpKlwYSe0mCDJlPcyOOWcDObW76gLfIT4eVeNxwe9aambjAcpVcWnMmK2UrWNkbeLzX4yG8Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230515; c=relaxed/simple;
	bh=QLCNq8f++49zXGuG+TltYpl+XCH6wFjglwlCz/W4eJg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KkSc9XpPUxUNiVRBRaXXmAThhn53HxlC3QaNqbsEd6KLdfl6n/FmoosY1hEG52QdUI+Jaf+KQpVL0EngA0xHoeqGGH18N9yz6QFZ/KaZs7SJaFxchN7aGCQVRjJ9LjEfzpbDF0H0zKW6KU0ZvI8uJl1qFxRUTz8AwjGD+Nq4+ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miIU4YQq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miIU4YQq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD691F000E9;
	Tue, 28 Jul 2026 09:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230514;
	bh=bMlI+Czg5zgy+YyCVci02SIISs2MNLejiOP8b+WIU44=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=miIU4YQqnoxa38Il4NrdG++vkltWWE9Oxpt8S393P7PQtalirA8eDYVxiGWWvEEww
	 /d4tdUmA80u3URLJKhySKKflN3tca5pnlpFkVXv+agmvI6KcsZkj9Gr4C7ND/nm3q2
	 /c1XFzJ2XQDWQ+KFjWeNjBwe8Zi87XlprTa40B8M9WtsQSGV9rJg5LLsxr0nBLaL3E
	 37Rdx1OvOg46UO8fMd9NoSpnt9g1yrMPyvUqYNpu3ZpSGLamOLhcj5M1OJyVONQZeK
	 U+GdR4QrjyARMtr95EpcsTFc7jWvALbgHd/WbbuakS5KRUWYSoe7iMFO0mXcBdWAib
	 rPMAX5HAiankw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 20/21] md/raid5: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <c7c18559845a627beae107842354e6684cb26924.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <c7c18559845a627beae107842354e6684cb26924.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:21:53 +0000
Message-Id: <20260728092154.2CD691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Setting mddev->resync_offset =3D 0 unconditionally upon reshape fi=
nish forces an unnecessary full parity resync for RAID5.
--

--- Patch [20]: [PATCH v3 20/21] md/raid5: wire llbitmap reshape lifecycle =
---
commit 692471147c5f67f1af148855c6b48cd2fffeec7a
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: wire llbitmap reshape lifecycle

This commit prepares the llbitmap before a RAID5 reshape starts, checkpoints
the bitmap before advancing the reshape position, and completes the llbitmap
geometry update when the reshape finishes.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -8688,8 +8717,16 @@ static void raid5_finish_reshape(struct mddev *mdd=
ev)
>  {
>  	struct r5conf *conf =3D mddev->private;
>  	struct md_rdev *rdev;
> +	bool llbitmap =3D mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +		md_bitmap_enabled(mddev, false);
> =20
>  	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> +		if (llbitmap && mddev->bitmap_ops->reshape_finish)
> +			mddev->bitmap_ops->reshape_finish(mddev);
> +		if (llbitmap) {
> +			mddev->resync_offset =3D 0;

[Severity: High]
Does setting mddev->resync_offset to 0 here force an unnecessary full parity
resync for the array?

Since a RAID reshape already migrates data and parity, unconditionally rese=
tting
the resync_offset to 0 informs the MD core that the parity needs to be fully
re-synchronized from sector 0.

> +			mddev->resync_max_sectors =3D mddev->dev_sectors;
> +		}
> =20
>  		if (mddev->delta_disks <=3D 0) {
>  			int d;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D20
