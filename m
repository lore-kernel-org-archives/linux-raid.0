Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B171C48AE16
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163998; cv=none; b=YAktXOmg3LYgB2bns2q2eS1g1nrXlUntiZu5wuobNCPeFt2nIIXy8D/kMueWHB+GYlLgXQ6h95lSpHjp8A/Qh7ApQMO37QtOH3Lt0VHSQ1+5rlOow8Nxam4JMMAEKbueJysM8+e50UDWPFKh2V9b87X5LmB8kHOlNU5FS1vbZf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163998; c=relaxed/simple;
	bh=wCdcCDX73BvJSFKuYQKs3G0e7Lx4JDFwIqs/jCHhEDg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BL0jNmoGPmqHOjNyehS08oiNoyiDuM9ydG3ZF6ynEoPNuEgE44EJSCxKcE8mXA4lPgAO7blc7cdROB4Byykzu7nKhWHsDp96EBczbQQFZ31lMRXxpE1+Flvka7civjAb+Avrh7aqQJlPGnv6RVIpc0wVYT9NDPNhLYETHcpsJ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/QMOAaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/QMOAaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC921F000FF;
	Wed, 23 Sep 2026 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790163987;
	bh=UY16BWwje3DynUygM/PM89OXL5JQoFmIis3AUU0wRZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e/QMOAaqzHbuNnDLswQa2YEkLcvT5yShUY+XQCsCaQwY/ly0sNBxZzzvpVFDnAMRZ
	 t7/3f03xiYXcYWR2BqVAXdk1Rj/vqLoPlYhgdCnXls2pD0MQyO4n+bXqKel4vGOd5B
	 Gx8noz/Zm1DxKpoQYqT35djM0AuQAjkVZaXliyg3HjnoKLuKNqCR4thcwPs/fhoEta
	 eOvJWvNcsE0GaMTKADIQYtoxR0634PnCahHahVQ3wb2ZOXrpO9vMx9SPovnUQzjfvT
	 KJua1MDZpmCDv08qd/4fAv4zjWEo/d6l+Sniv9r0tV5YgW8jJSU0DbwM1s9q2NqROQ
	 8BPZFWNB0K0sQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/4] md: Handle pers->run failure in level_store
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhihao Cheng" <chengzhihao1@huawei.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260923112159.94175-3-chengzhihao1@huawei.com>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
 <20260923112159.94175-3-chengzhihao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 11:46:26 +0000
Message-Id: <20260923114627.3CC921F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md: NULL pointer dereference in md_handle_request() after pers->ru=
n() fails
--

commit 3549464235e3de415ce8ceb834293e195eafad7d
Author: Zhihao Cheng <chengzhihao1@huawei.com>

md: Handle pers->run failure in level_store
   =20
This commit adds error handling for the pers->run(mddev) call in
level_store(). When pers->run() fails, it stops the array via __md_stop()
and unlinks sysfs nodes before unlocking and returning.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..0a3252098780b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c

[ ... ]

> @@ -4229,7 +4230,33 @@ level_store(struct mddev *mddev, const char *buf, =
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
> +		if (mddev->pers->sync_request && mddev->to_remove =3D=3D NULL)
> +			mddev->to_remove =3D &md_redundancy_group;
> +		if (md_bitmap_enabled(mddev, true))
> +			mddev->bitmap_ops->flush(mddev);
> +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
> +		mddev_destroy_serial_pool(mddev, NULL);
> +		__md_stop(mddev);
> +		rdev_for_each(rdev, mddev)
> +			if (rdev->raid_disk >=3D 0)
> +				sysfs_unlink_rdev(mddev, rdev);
> +		set_capacity_and_notify(mddev->gendisk, 0);
> +		mddev->changed =3D 1;
> +		md_new_event();
> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
> +		goto out_unlock;

[Severity: High]
Can this trigger a NULL pointer dereference in md_handle_request() for
concurrent bios?

If pers->run() fails, __md_stop() sets mddev->pers to NULL. The error path
then jumps to out_unlock, which subsequently calls mddev_unlock_and_resume(=
).

When the array is resumed, mddev_unlock_and_resume() resurrects active_io
and wakes up mddev->sb_wait. If there are concurrent bios submitted to the
array, they may be blocked in md_handle_request() waiting on sb_wait:

drivers/md/md.c:md_handle_request() {
	...
		if (is_suspended(mddev, bio)) {
			/* Bail out if REQ_NOWAIT is set for the bio */
			if (bio->bi_opf & REQ_NOWAIT) {
				bio_wouldblock_error(bio);
				return true;
			}
			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
		}
		if (!percpu_ref_tryget_live(&mddev->active_io))
			goto check_suspended;
	}
	if (!mddev->pers->make_request(mddev, bio)) {
	...
}

Once woken up, they will re-acquire active_io and unconditionally dereferen=
ce
mddev->pers->make_request. Since mddev->pers was set to NULL by __md_stop(),
will this result in a kernel panic?

> +	}
>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>  	if (!mddev->thread)
>  		md_update_sb(mddev, 1);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923112159.9417=
5-1-chengzhihao1@huawei.com?part=3D2
