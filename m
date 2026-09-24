Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0D625B091
	for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 08:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790238656; cv=none; b=erfslQet8y746kh+83XbIXHBGFPStacfE0EfmkayRF/kVHw7uSpWAjNkSW7k41sf8k2fvB8qYV4NVkziuplSADh9RMtCHRV0JcBkuSuGc/nk5zxEQQL+V9/sh0KhIIHuvRBM89pgJ3bHLUa0zhipd3717myp2GE/IusnRqMipRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790238656; c=relaxed/simple;
	bh=4g+y8SfYQsQggFgyfFJP5tg6KQtGhpme9rRJr35HfHs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hBlOctFM8uiD7JCOvGSzU18Yl3BMqdeEhfzUztdceWcw7+zoufLYv7bpcnYcSWCl9za0RkBqhg9FzgsJNsdks354kSKiHGrn6S8W0ly5qpVyvQRjDpLdCjGr92MkYCFPS6IUNqPXQUu07Xe4a8frbmS/RQYdiiVlZWvHJ96Od0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WRgUamtL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WRgUamtL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037EC1F00893;
	Thu, 24 Sep 2026 08:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790238653;
	bh=Ot/IRw0NMnnbliyslGPhT+AHKJHzWVQhbuHsUj906l4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WRgUamtLHIF3HayCRRXNnYX/yu5M5yE9uSh7s5bDR0+At3HoCMWg3De+OfsPb9lu4
	 xp3uPXZESvWVqQXVidhLmq/QYKc13JffZzfZM2Xc8xSTTq1x3Mb6GWA17WAy3Xf9Xm
	 9kZz6an0C9kcjv06AEo49hPS+7TYbQWkz6iKtX+bJl33h9pzwcL2DJgZuDh9enF+/I
	 xipQb5hHXX1ce1PXlDGH2Zu41LgqGO0TNfj453WOkxoL8xotQ+eVBCLmMCpjkaOlwl
	 VXq9P0OMJHApqjmJaXXDLehEXLKGjFbHy+4gLWjgc/wgMqDskHmeaFzv4c8T9WuwK6
	 dNGBWALc/ImPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] md: remove legacy async del_gendisk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260924081552.2564214-1-dayou5941@163.com>
References: <20260924081552.2564214-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 08:30:52 +0000
Message-Id: <20260924083053.037EC1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] md: spurious -EEXIST during concurrent array allocation due to m=
issing synchronization
--

commit 2bbedaa2916a59078e57417858612d10fe4a7cc6
Author: Li Youhong <liyouhong@kylinos.cn>
Subject: md: remove legacy async del_gendisk

This commit removes the legacy async del_gendisk mode and delayed array
deletion. It processes deletions synchronously to avoid lockdep cycles
between major_names_lock, md_misc_wq, and reconfig_mutex.

Closes: https://syzkaller.appspot.com/bug?extid=3D68e1f51046d68329940f

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..fbe302418be97 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -677,10 +698,15 @@ static bool mddev_put_locked(struct mddev *mddev)
> =20
>  void mddev_put(struct mddev *mddev)
>  {
> +	bool complete_delete;
> +
>  	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
>  		return;
> =20
> -	__mddev_put(mddev);
> +	complete_delete =3D __mddev_put(mddev);
>  	spin_unlock(&all_mddevs_lock);
> +	if (complete_delete)
> +		mddev_complete_delete(mddev);
>  }

[Severity: Medium]
Could this create a window where a concurrent array allocation sees the
partially deleted array?

When all_mddevs_lock is dropped here, the mddev is still present in the
all_mddevs list because kobject_put has not yet run via
mddev_complete_delete.

[ ... ]

> @@ -6327,12 +6323,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
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
>  	if (IS_ERR(mddev)) {

[Severity: Medium]
Can this missing synchronization lead to spurious -EEXIST or -EBUSY failures
during array creation?

With flush_workqueue removed, if one thread executes mddev_put and is
preempted after dropping all_mddevs_lock but before calling
mddev_complete_delete, a concurrent md_alloc can iterate all_mddevs, find t=
he
partially deleted array (since it does not filter out MD_DELETED devices),
and fail with -EEXIST or later during add_disk.

This might break user-space scripts that rapidly tear down and recreate
arrays, such as testing suites or mdadm.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924081552.2564=
214-1-dayou5941@163.com?part=3D1
