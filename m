Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750DB481AAE
	for <linux-raid@vger.kernel.org>; Fri,  2 Oct 2026 09:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932477; cv=none; b=gmRRnAgFUwVAAkUKqiKH3b4NczDvfva9ibrZl4vM/FMq7C0NJ2WhN9ChJpvMrQtGj83P1LztC4yCJEA/G8ebv1fMpJOTXfT5v4CtBqlDgCvDNbyvTNaiYWKk0+lol87gDtnRs3u40U0NyzA4AuU3ElqyjxerFi/9hvV/XvzTML0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932477; c=relaxed/simple;
	bh=Zo7hEj4SiSSSNxFAP/Eop/MaND/4w9m/a9Ren7VGPfU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g8RUm3ofbYg9eeMTI0G9znc3CDQhQUb3VTgXVQJslcJ021S7c2KKvzjihMd/UEhKv3h8iIG74ikMH3QM1aHaCPa3vwsqI3Sn98g6xxC8ReuhuG4tEw3p52izvtT79hGQebuZCoL9zzTs3if6fxmiVfh7XdbsOpTboaklXYiksj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h+RxuMIl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h+RxuMIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E5A1F000FF;
	Fri,  2 Oct 2026 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932476;
	bh=WsndlHNiXdzg0jV6aL1IheGhxBjTGkeNW5/pjoZP0lg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h+RxuMIli+9Fk8X5s0J8iv4FJMiefpVo7cvRecAJc8i2bmXaKm3/50erJb/0dWUsa
	 2kP9nT/575c1DcZvDEow1NMmSHTrziWO1DeDwQsGKt2AvRptPS/oEvPI6vVzkFnjlM
	 SnACt6KwuKmGd6sFXJyHv1W5qvUKyTx1DusVZSkTvO5bfFebtU2mIXu7OaCTIWrcmw
	 gbXof1hrwdgSGe/VlJEmX80VtuSquKBvMKGPQnRaYsRYdWS/tOs33uc3FSf2+KAU/m
	 DsadET6Xk5dyn8atjE7ZepcgoyJrDdvIKBu5srUubn1qx24RkFzqtGYCmdK8kGXRmP
	 jPzaCwBA3JpGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] md: remove legacy async del_gendisk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261002065642.1726950-1-dayou5941@163.com>
References: <20261002065642.1726950-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:14:35 +0000
Message-Id: <20261002091436.28E5A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md: race between md_alloc and mddev_put causes duplicate sysfs war=
nings
--

commit 6f4e37981f391fc56de7da8a4b3ba68d6d5786d3
Author: Li Youhong <liyouhong@kylinos.cn>
Subject: md: remove legacy async del_gendisk

This patch removes the legacy async gendisk deletion path, making
del_gendisk() synchronous from mddev_unlock() and the final
kobject_put(). It also removes del_work and the flush_workqueue()
in md_alloc().

Closes: https://syzkaller.appspot.com/bug?extid=3D68e1f51046d68329940f

> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

>  void mddev_put(struct mddev *mddev)
>  {
> +	bool complete_delete;
> +
>  	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>  		return;
> =20
> -	__mddev_put(mddev);
> +	complete_delete =3D __mddev_put(mddev);
> +	if (complete_delete)
> +		mddev_unlist(mddev);
>  	spin_unlock(&all_mddevs_lock);
> +	if (complete_delete)
> +		mddev_complete_delete(mddev);
>  }

[Severity: High]
Does unlisting the dying mddev from all_mddevs before its gendisk is fully
deleted make the old name prematurely invisible to a concurrent md_alloc()?

If a process triggers mddev_put() (e.g. by closing an unconfigured /dev/mdX=
X),
the array is removed from all_mddevs before the synchronous del_gendisk()
is called.

[ ... ]

> @@ -6327,12 +6334,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
>  	int unit;
>  	int error;
> =20
> -	/*
> -	 * Wait for any previous instance of this device to be completely
> -	 * removed (mddev_delayed_delete).
> -	 */
> -	flush_workqueue(md_misc_wq);
> -
>  	mutex_lock(&disks_mutex);
>  	mddev =3D mddev_alloc(dev);

[Severity: High]
Since flush_workqueue(md_misc_wq) is removed, could a concurrent md_alloc()
proceed and fail to find the unlisted mddev?

If md_alloc() starts while mddev_put() is deleting a gendisk with the same
name, it won't find the old array in all_mddevs.

It would then allocate a new gendisk with the same name and call add_disk(),
which collides with the dying gendisk.

This leads to a -EEXIST failure in add_disk() and a kernel warning
for duplicate sysfs filenames. On systems with panic_on_warn set, this could
cause a crash.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002065642.1726=
950-1-dayou5941@163.com?part=3D1
