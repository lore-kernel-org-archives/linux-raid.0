Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F082D381E9B
	for <linux-raid@vger.kernel.org>; Thu, 10 Sep 2026 08:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030098; cv=none; b=sbHHhXhTPpY4tHa80B4pI/yXVpv3Lux4rZnFrl9LuW9ppAZ22BaqOlKAtBoiNNeJVIK1QsI06lLPLsX98f4evpSKAGNbVXEAXGazYs5v1BCAJaa5nB9PrVcet16g0RLFfIskV1y4CjBHXghc/e3j/PpflCNvXMKaLnLBoUH3GaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030098; c=relaxed/simple;
	bh=YOhjkdzvSGJS5i8oB9EYlLeb47G4uR6j3cUU7bqFuNw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d8Plt/Qa+yShdaXl6enWCSewuMpSdu/hPoDbuzcw9RYQjW27V6SsUioy9d9TWePfVxq0MCippqy48JTyDrTDP0uts7p1PH/KyaJ+DnCL652baJjrqgWK6y8lkz76Qu1ZB2Qn0gnbhgmCKgjCsilmpXiNiv0XL8UGDWP6VQEowrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4kk/ARi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4kk/ARi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFE81F000FF;
	Thu, 10 Sep 2026 08:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030096;
	bh=gOvH6fZH+6Zh9hSv6w1Oa67yv4hTYEpyJLDQf1E5wgA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P4kk/ARiBQT7hOaWyA5XjfBKFD6tpzplFocaxuTHhWdb9qcu5nsGJwzBcfpWco60C
	 /QQvFTwl7JU9YXn2i49flWF3SuQICqW54dYiRapE8vSg7ZvYTQfOjlm47q6d0Ar1Ev
	 xZGFvpYFT27e28q34MloQI9XLX2kc6iZW/YO3npMn2WtypA4Fuk6ql9i7oWU8AwIrH
	 7maG6SxqeRAiBUt2oLNX3PnaVUtrAf/XiGhWAD/OmNreYMaxYyqCslxSACHnUsbpxu
	 40eDUSz4vqkB3CWKm2KBW7ZAfRaUjDaqxSKanrXcv2zZK0zIH6PRBsHVhYBilkOB28
	 612c3mXlCWgvg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] md: open new legs before locking the array
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260910081114.1605746-8-jinpu.wang@ionos.com>
References: <20260910081114.1605746-1-jinpu.wang@ionos.com>
 <20260910081114.1605746-8-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 08:48:15 +0000
Message-Id: <20260910084816.3CFE81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] The patch leaves export_rdev() calls inside the mddev->reconfig_mu=
tex critical section on error paths, failing to completely break the disk->=
open_mutex deadlock cycle.
- [Medium] The snapshot check in md_add_new_disk() is bypassed when nd->rde=
v is NULL, allowing concurrent array reconfigurations to trigger a WARN_ON_=
ONCE.
--

commit 140222a8600d2514747d88643188f131c16b6c50
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: open new legs before locking the array

This commit aims to resolve a lockdep cycle between disk->open_mutex and
mddev->reconfig_mutex by opening new devices before acquiring the array
lock. It updates functions like md_import_new_disk() and new_dev_store()
to snapshot configuration and validate it after locking.

> diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
> index e15ae2fb58a2d..e592577356ad3 100644
> --- a/drivers/md/md-autodetect.c
> +++ b/drivers/md/md-autodetect.c
> @@ -216,7 +217,21 @@ static void __init md_setup_drive(struct md_setup_ar=
gs *args)
>  				(1 << MD_DISK_ACTIVE) | (1 << MD_DISK_SYNC);
>  		}
> =20
> -		md_add_new_disk(mddev, &dinfo, NULL);
> +		/*
> +		 * Opening a leg takes disk->open_mutex, which must not nest
> +		 * inside reconfig_mutex, see md_import_new_disk().  Drop the
> +		 * array lock around it; this is __init and the array is not
> +		 * reachable yet, so nothing else can touch it in between.
> +		 */
> +		mddev_unlock(mddev);
> +		if (md_import_new_disk(mddev, &dinfo, &nd)) {
> +			mddev_lock_nointr(mddev);
> +			continue;
> +		}
> +		mddev_lock_nointr(mddev);
> +
> +		md_add_new_disk(mddev, &dinfo, &nd, NULL);
> +		md_put_new_disk(&nd);

[Severity: High]
Does md_put_new_disk() recreate the lockdep cycle we are trying to fix?

Since md_put_new_disk() calls export_rdev() internally, and export_rdev()
acquires disk->open_mutex, calling it here while mddev_lock_nointr() is
held appears to preserve the reconfig_mutex -> disk->open_mutex lock order.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5be956e80563d..fa033d7d38318 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -7685,12 +7706,35 @@ static int get_disk_info(struct mddev *mddev, voi=
d __user * arg)
>  	return 0;
>  }
> =20
> +/*
> + * @nd carries an rdev the caller opened before locking the array, for t=
he
> + * branch its snapshot selected.  Every caller must open first; doing it
> + * here would nest disk->open_mutex inside reconfig_mutex.
> + */
>  int md_add_new_disk(struct mddev *mddev, struct mdu_disk_info_s *info,
> -		    struct queue_limits *lim)
> +		    struct md_new_disk *nd, struct queue_limits *lim)
>  {
>  	struct md_rdev *rdev;
>  	dev_t dev =3D MKDEV(info->major,info->minor);
> =20
> +	/*
> +	 * The open ran unlocked, so anything that selects a different branch
> +	 * below, or a different superblock format, means it was done against
> +	 * an array that no longer looks like this one.
> +	 */
> +	if (nd && nd->rdev &&
> +	    (nd->have_raid_disks !=3D (mddev->raid_disks !=3D 0) ||
> +	     nd->have_pers !=3D !!mddev->pers ||
> +	     nd->persistent !=3D mddev->persistent ||
> +	     nd->major_version !=3D mddev->major_version ||
> +	     nd->minor_version !=3D mddev->minor_version)) {

[Severity: Medium]
Is this validation check bypassed if nd->rdev is NULL?

If md_import_new_disk() is called on an array where ADD_NEW_DISK is
unsupported (for example, raid_disks !=3D 0 and pers =3D=3D NULL), it retur=
ns 0
with nd->rdev =3D NULL. If a concurrent ioctl like STOP_ARRAY resets
raid_disks to 0 before md_add_new_disk() acquires the lock, the condition
checking nd->rdev evaluates to false, skipping the validation entirely.

This allows the function to proceed into the !mddev->raid_disks branch
and hit the WARN_ON_ONCE(!nd || !nd->rdev) below, triggering a kernel splat.

> +		pr_warn("%s: array reconfigured while opening %pg\n",
> +			mdname(mddev), nd->rdev->bdev);
> +		export_rdev(nd->rdev);
> +		nd->rdev =3D NULL;
> +		return -EBUSY;
> +	}

[Severity: High]
This new failure path also executes with reconfig_mutex held, directly
calling export_rdev() and recreating the lockdep cycle.

Could this leave the system vulnerable to the same deadlock on error paths?

This pattern also occurs in new_dev_store(), where the error path calls
export_rdev() before mddev_unlock_and_resume().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910081114.1605=
746-1-jinpu.wang@ionos.com?part=3D7
