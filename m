Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795201594;
	b=dRyEr4rrjHaSEO7cLE1DENQNPL7nMvOubrA6kaR4lzRKpgvgRXZLwtXKgpm3bcilKiob
	 UjIGWFLwiIVAbt8Za/K+tmhMGkhlBgALJGFyzuXzpyDoIe8TpGTS6EcAS8qerzOa5bB15
	 nUnd6Gp3543wZ6gpSEDwsZh/xypAcPUEBf6LUDGMNtANlyXhOvM19vY42p2L3+9KQjnnt
	 4n2YWu6Ry4KNZ2RW4s/J1ri85b73GuJMUyM8b4g+eFofowgqM9uCpVgUqFw4DWYabIMcn
	 6g1MmilntuqbopbA3Gj0NHQlXpamK/ih422hYRGwuUiGYT07HGxEiYy2Wf0nEFy1o8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795201594;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=DQzEuhh+xD2BuQhNPiSK7xK9b+lEajh/c9KK2ht3hUU=;
	b=YT6IQ/fYtFfWV1D+IvFL+N5yUd1m0HXCCeLTZBnMaXY7QLrrbLdIs3tCARa5Baadpxof
	 rPZP0Xmr/kewV3XDBNqHIGUjvge+XbKgedW6DfzZiNz9CRgWpBM4ID0aWpkUihyfdJmdq
	 NnqY0SXfrBSj6yu2prK2dau2cCqj+cyRmJZ2xk1kDpHFiYuhomWfsa9dyrfrJsnB5XRwF
	 aCSS8gz41HZI/thwU5z8gyGIlnPUkSIu/qGMWbuCjFBvlzk8v23MUwX7qPMFOxnauJFuH
	 pFv2EAbRuqcFRuKtKel9IrY4bVKshA1AkwHGDbD0FFGM80GbPC1WVo992Uji3kxoFAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=URCb6dTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ABE606A337
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=URCb6dTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579701F000CA;
	Fri, 20 Nov 2026 19:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795201594;
	bh=DQzEuhh+xD2BuQhNPiSK7xK9b+lEajh/c9KK2ht3hUU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=URCb6dTJWYxnVVSDZE0BBS1bPwjEzY/2pq9lVDqRctN3kUfjMBmDxLVk5Vi5F8Nbt
	 ZWZkgiArrU1UjBMYLdNkHPVz8hFsJBlHl7brHEWKRPc0VawR3C0PwkW0WQ9iLSeUio
	 1TKFwq5FNpvFlYSCwtgTVlBZC9LSJZ15cErh8Q9rzUMlH526vUBUfYpOOQfGjZiS4e
	 lg3qPzCNpla5XoFnaTjBdEBUJ+vMrT1yUZ86A4VusPUTukppav4hqyTP61FCVEZ4Fn
	 +VTxzHSRbyu6o1YpKfF3eWdZzn/KYp4EVt5jIwix41TwwMi75KsfBGiHTNmq5DM3D1
	 5k+ITQJKPb/fg==
Message-ID: <sashiko-outbox-225891@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: reject an invalid chunk size when continuing
 a reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vasiliy Kovalev" <kovalev@altlinux.org>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261120184801.614123-1-kovalev@altlinux.org>
References: <20261120184801.614123-1-kovalev@altlinux.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 19:06:33 +0000
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
- [Medium] md/raid5: unvalidated mddev->chunk_sectors in raid5_run()
  masked by max()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [Critical] md/raid5: sysfs leak in raid5_run() leading to type
  confusion [1]
--

commit 9d4cf0a64af3fa8dfc560d2c2354bd784b6f5097
Author: Vasiliy Kovalev <kovalev@altlinux.org>

md/raid5: reject an invalid chunk size when continuing a reshape

This commit validates chunk_sectors and its products with the old and new
data disk counts in raid5_run() when continuing an in-progress reshape.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d52adf81065a7..e31ae5d6eece8 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8113,6 +8113,13 @@ static int raid5_run(struct mddev *mddev)
>  		here_new =3D mddev->reshape_position;
>  		chunk_sectors =3D max(mddev->chunk_sectors, mddev->new_chunk_sectors);
>  		new_data_disks =3D mddev->raid_disks - max_degraded;
> +		if (chunk_sectors <=3D 0 ||
> +		    (u64)chunk_sectors * new_data_disks > INT_MAX ||
> +		    (u64)chunk_sectors * (old_disks - max_degraded) > INT_MAX) {
> +			pr_warn("md/raid:%s: invalid chunk size for reshape - aborting.\n",
> +				mdname(mddev));
> +			return -EINVAL;
> +		}
>  		if (sector_div(here_new, chunk_sectors * new_data_disks)) {
>  			pr_warn("md/raid:%s: reshape_position not on a stripe boundary\n",
>  				mdname(mddev));

[Severity: Medium]
Can an invalid mddev->chunk_sectors slip past this check when
mddev->new_chunk_sectors is positive and valid?

Because chunk_sectors is max(mddev->chunk_sectors, mddev->new_chunk_sectors=
),
a valid mddev->new_chunk_sectors masks a zero, negative, or non-power-of-two
mddev->chunk_sectors (which chunk_size_store() leaves untouched once
reshape_position !=3D MaxSector, and which v1.x/v0.91 superblocks load from=
 a
separate on-disk field).  setup_conf() only validates
mddev->new_chunk_sectors before copying mddev->chunk_sectors into
conf->prev_chunk_sectors:

drivers/md/raid5.c:setup_conf() {
    ...
	if (!mddev->new_chunk_sectors ||
	    (mddev->new_chunk_sectors << 9) % PAGE_SIZE ||
	    !is_power_of_2(mddev->new_chunk_sectors)) {
		pr_warn("md/raid:%s: invalid chunk size %d\n",
			mdname(mddev), mddev->new_chunk_sectors << 9);
		return ERR_PTR(-EINVAL);
	}
    ...
	if (conf->reshape_progress !=3D MaxSector) {
		conf->prev_chunk_sectors =3D mddev->chunk_sectors;
		conf->prev_algo =3D mddev->layout;
	}
    ...
}

An unvalidated conf->prev_chunk_sectors (for example -2^30 with 4 old data
disks) can then overflow sectors_per_chunk to 0 and trigger a divide error =
in
raid5_bitmap_sector_map(), or violate power-of-two chunk alignment assumpti=
ons
in raid5_set_limits(), in_chunk_boundary(), and raid5_size().  Should
mddev->chunk_sectors be validated with the same rules as
mddev->new_chunk_sectors?

[Severity: Critical]
This problem wasn't introduced by this patch, but if a later setup step in
raid5_run() jumps to abort [1], does it leak raid5_attrs_group on
mddev->kobj?

drivers/md/raid5.c:raid5_run() {
    ...
	if (mddev->to_remove =3D=3D &raid5_attrs_group)
		mddev->to_remove =3D NULL;
	else if (mddev->kobj.sd &&
	    sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
		pr_warn("raid5: failed to create sysfs attributes for %s\n",
			mdname(mddev));
    ...
	ret =3D log_init(conf, journal_dev, raid5_has_ppl(conf));
	if (ret)
		goto abort;

	return 0;
abort:
	md_unregister_thread(mddev, &mddev->thread);
	print_raid5_conf(conf);
	free_conf(conf);
	mddev->private =3D NULL;
	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
	return ret;
}

When raid5_set_limits(), raid5_create_ctx_pool(), or log_init() fails, abort
frees conf and clears mddev->private without removing raid5_attrs_group or
setting mddev->to_remove.  If the array is then started with another
personality such as RAID1, accessing the leftover RAID5 sysfs attributes (f=
or
example raid5_show_group_thread_cnt()) casts the new personality's
mddev->private to struct r5conf * and dereferences it, causing type confusi=
on
and out-of-bounds memory accesses.

[1] https://sashiko.dev/#/bug/linux-799de59e-8448-4ba5-a36c-4b6d949b8ba3

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120184801.6141=
23-1-kovalev@altlinux.org?part=3D1
