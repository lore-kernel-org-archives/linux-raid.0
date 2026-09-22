Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7655C339
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790089309; cv=none; b=ukuZgxUbfpO7Lv2cD7qhWEJQvuvHd/8wcGia2dirNL4gjgIhgQk3v6cpUg2fQGVdAobfja87VEok/BtBrjQcyEq+VrkgfAxiiJwLhMJEeXxvGfbKXPdyoMF2sEQ+Jk5i4aBgv2YiCVzMi1A2TXPWlNHThOtoxTwj6TdSGZNnZe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790089309; c=relaxed/simple;
	bh=mCQN3bFlkDGXJKQ+JWKwVW8zpHn4i0cIfuAwgLMk+Pw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B6o+koanyl9QiJ74mPUZfnOc1ZjFtC8yWMYsJtALWO+hljY1IvdG995v4IotWPe2hWq1yPgEHPjHL10rNQXC8HbHn62/lho4wYCmK4v/l4Y52QN2nfm1FCND7pvceCCWa/VwvUFbwGwi8piZkjVBpUjilalYEMKEsPU1nLJLwsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifSW/gK6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifSW/gK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DC91F00899;
	Tue, 22 Sep 2026 15:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790089308;
	bh=nMabYXIDJZpjov4X7XPpZ5lSAgePAdNsBb2M5H5mJtg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ifSW/gK60Y6XEwCtihQf3WpF6CB23PQa30y03qCJEtBbpeR/ip9WAkOZVQBGevV5k
	 Wqp9jkT+5JlBxh/jVD8H9BpGhpZLTRPOSBa5HJjCPABPbDNPoyU3SBenNjBo0TGo9y
	 dgfe7rJNR4ATqe1+As23z863M4gsrfRoImrp/XkEFRtkHCLHyeKijJiNtbXDcDK9D5
	 tIG+napakvCo96m5J8n9NsEJ89ERps7t1R3JOTaYKWHKDDT3fU6EHoj+YXXfAHJRfk
	 oIelbsQa4E6VVdKflpw3CXUjFG3G9Gcmz4CovCB6GHDcgU/GsXMCiq4VsFBS2a3pM1
	 ugYdrfihB7IMw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] md: Handle pers->run failure in level_store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhihao Cheng" <chengzhihao1@huawei.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260922141456.738937-3-chengzhihao1@huawei.com>
References: <20260922141456.738937-1-chengzhihao1@huawei.com>
 <20260922141456.738937-3-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 15:01:47 +0000
Message-Id: <20260922150147.D5DC91F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] md: NULL pointer dereference in md_handle_request() when resuming =
array after pers->run() failure
- [Medium] md: sysfs group md_redundancy_group leaked on pers->run() failure
--

commit 4ab3c278fcfe04083eb0fb2b801da26eb96c6cec
Author: Zhihao Cheng <chengzhihao1@huawei.com>

md: Handle pers->run failure in level_store

This commit fixes a NULL pointer dereference that occurs when raid_disks
is set after raid5_run() fails during array conversion. It handles the
error by stopping the array if the new personality fails to run, allowing
a subsequent active order to restart it.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..f8fffc5de1143 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -4229,7 +4230,31 @@ level_store(struct mddev *mddev, const char *buf, =
size_t len)
>  		mddev->in_sync =3D 1;
>  		timer_delete_sync(&mddev->safemode_timer);
>  	}
> -	pers->run(mddev);
> +	rv =3D pers->run(mddev);
> +	if (rv) {
> +		/*
> +		 * ->run() has released the private data of the new personality,
> +		 * while the old one has already been released as well. There is
> +		 * nothing to fall back to, so stop the array to avoid leaving
> +		 * 'mddev->pers' pointing to a personality which has no private
> +		 * data, and reminds user to try to active the mddev again.
> +		 */
> +		pr_warn("md: %s: failed to run %s after takeover, please try to active=
\n",
> +			mdname(mddev), pers->head.name);
> +		if (md_bitmap_enabled(mddev, true))
> +			mddev->bitmap_ops->flush(mddev);
> +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
> +		mddev_destroy_serial_pool(mddev, NULL);
> +		__md_stop(mddev);

[Severity: High]
Does calling __md_stop() here introduce a NULL pointer dereference for in-f=
light IOs?

If level_store() is called while IOs are active, mddev_suspend_and_lock() w=
ill
force them to wait in md_handle_request(). __md_stop() sets mddev->pers =3D=
 NULL.

When the error path later reaches out_unlock and calls mddev_unlock_and_res=
ume(),
will the trapped IOs wake up and unconditionally call mddev->pers->make_req=
uest()
while mddev->pers is NULL, panicking the kernel?

> +		rdev_for_each(rdev, mddev)
> +			if (rdev->raid_disk >=3D 0)
> +				sysfs_unlink_rdev(mddev, rdev);
> +		set_capacity_and_notify(mddev->gendisk, 0);
> +		mddev->changed =3D 1;
> +		md_new_event();
> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
> +		goto out_unlock;

[Severity: Medium]
When converting from a non-redundancy array to a redundancy array,
sysfs_create_group() is called earlier in level_store() to add md_redundanc=
y_group.

Does this error path leak the sysfs group and its kernfs_node references, s=
ince
mddev->to_remove is not set to &md_redundancy_group to trigger cleanup in
mddev_unlock()?

> +	}
>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>  	if (!mddev->thread)
>  		md_update_sb(mddev, 1);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922141456.7389=
37-1-chengzhihao1@huawei.com?part=3D2
