Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7E333C1B6
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 02:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790044330; cv=none; b=AtFr9OACRFXfSP2GaKAMo5R2nXjRDB42BR3dQ3TEsE56sJNMNKrHm2a+tfx97gXvoEmOlEnVC0uWECzamF9kvw1UOwlxnQvMtlCaEVwRaDwrSqo8XIEyyd4iKRo1jp6MObcpuzQpcASxUDYfoanfaJHHcGRvFeZtE/MGFaHvKUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790044330; c=relaxed/simple;
	bh=PkWNbGAWx2wPMeWmIYFObjeIwzbFagwu8m9tclzFAu4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=am5H2S2BknJf7BU+SY3/aZZptO89ZPDKhIWh4e8AqCtWTzwmihwonT63MclyzhMlWT0/D4LXbNzJSEIP2vbG5k2lefPNOZWchxI0vlKd17PAmjftIJtd3DhkQCP9GOh/ZUWuOOLgfZigLGBmXceJg97kjXcWkZl47+1Sk/UQ1Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1hJ5Qm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1hJ5Qm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA78D1F000FF;
	Tue, 22 Sep 2026 02:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790044326;
	bh=LEzlkgeUae8zQxjpikuZ3cWyTyAp4hBotqovB9eiYFE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z1hJ5Qm5bXZw7TT2yIbSSSqBB0woG4+nDQKRLIN9+Za5qbOWZHWFcLYtLQilfybG2
	 MFNfZiy3lvvOPt3M0jQ/ob6oNGk3wTPBsiOHgy1Kv8VSuIqdN1mpRCMCEgbpQx15UP
	 z2AFLKclyzXXfYWncK4UVuGUGdreU9tacG60oFQj76WExAZ6ezefqigxwvfXizga1n
	 2ajobasUoRo6TNYLk9u2YhfpOWv80+mpUobwKZDp99pxJw2zx/B5+MMrjM3a6zBNPE
	 uccpHTAeXApiHjeT2OB//83/MIyX1ZnZt2IS8tvP5xbgdmqrLBs0jsb04sBf+M1dnJ
	 fxwXHhs/LwE7Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md: remove legacy async del_gendisk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260922021533.2935172-1-dayou5941@163.com>
References: <20260922021533.2935172-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 02:32:06 +0000
Message-Id: <20260922023206.AA78D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] md: Use-After-Free in md_notify_reboot and md_exit due to unsafe l=
ist_for_each_entry_safe
- [High] md: Use-After-Free in md_seq_show when mddev_get fails
- [High] md: sysfs self-deadlock in md_attr_store due to synchronous kobjec=
t_del
--

commit 882f6ccb12f02b986de958463cf3afb9ffc46b20
Author: Li Youhong <liyouhong@kylinos.cn>

md: remove legacy async del_gendisk

This commit removes the legacy async del_gendisk path to resolve a lockdep
cycle between major_names_lock, md_misc_wq, and reconfig_mutex. Deletions
are now done synchronously in mddev_unlock() and mddev_put().

Closes: https://syzkaller.appspot.com/bug?extid=3D68e1f51046d68329940f

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..5d9e76f3256be 100644
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
>  	spin_unlock(&all_mddevs_lock);
> +	if (complete_delete)
> +		mddev_complete_delete(mddev);
>  }

[Severity: High]
Could synchronous kobject_del() on the active path in drivers/md/md.c:mddev=
_put()
cause a self-deadlock when triggered from a sysfs handler like md_attr_stor=
e()?

Writing 'stop' to /sys/block/mdX/md/array_state executes md_attr_store() un=
der
kernfs active protection. The handler calls do_md_stop(), marking the array=
 as
deleted, and then calls mddev_put().

Since mddev_put() now synchronously invokes mddev_complete_delete() ->
kobject_del(), kobject_del() will call kernfs_remove() and block in
kernfs_drain() waiting for the active protection to drop. The calling thread
is holding the active protection itself, causing a deadlock regression.

[ ... ]
> @@ -9041,8 +9042,13 @@ static int md_seq_show(struct seq_file *seq, void =
*v)
>  	}
> =20
>  	mddev =3D list_entry(v, struct mddev, all_mddevs);
> -	if (!mddev_get(mddev))
> +	if (!mddev_get(mddev)) {
> +		md_seq_flush_delete(seq);
>  		return 0;
> +	}

[Severity: High]
Can this sequence in drivers/md/md.c:md_seq_show() lead to a use-after-free
regression when mddev_get() fails?

If mddev_get() fails (because MD_DELETED is set), the current iterator v is
unpinned. The code then calls md_seq_flush_delete(seq), which temporarily
drops all_mddevs_lock to perform delayed deletion of a previous node.

During this unlocked window, the unpinned current node v could be fully
deleted and freed by a concurrent thread. When md_seq_flush_delete() reacqu=
ires
the lock and md_seq_show() returns 0, seq_read() will call md_seq_next(),
which dereferences the now-freed v pointer.

[ ... ]
> @@ -10714,10 +10721,11 @@ EXPORT_SYMBOL_GPL(rdev_clear_badblocks);
>  static int md_notify_reboot(struct notifier_block *this,
>  			    unsigned long code, void *x)
>  {
> -	struct mddev *mddev;
> +	struct mddev *mddev, *tmp;
> +	bool complete_delete;
> =20
>  	spin_lock(&all_mddevs_lock);
> -	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> +	list_for_each_entry_safe(mddev, tmp, &all_mddevs, all_mddevs) {
>  		if (!mddev_get(mddev))
>  			continue;
>  		spin_unlock(&all_mddevs_lock);

[Severity: High]
Does dropping all_mddevs_lock inside list_for_each_entry_safe() in
drivers/md/md.c:md_notify_reboot() expose tmp to concurrent deletion?

Since list_for_each_entry_safe() caches the next pointer into tmp before
executing the loop body, tmp is unpinned and unprotected during the unlocked
window. Because mddev_put() now performs synchronous deletion, a concurrent
array teardown could drop the last reference to tmp and free its memory. Wh=
en
the lock is reacquired, the loop advances by reading tmp->all_mddevs.next,
which dereferences freed memory.

[ ... ]
> @@ -11075,20 +11088,15 @@ static __exit void md_exit(void)
>  	remove_proc_entry("mdstat", NULL);
> =20
>  	spin_lock(&all_mddevs_lock);
> -	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> +	list_for_each_entry_safe(mddev, tmp, &all_mddevs, all_mddevs) {
>  		if (!mddev_get(mddev))
>  			continue;
>  		spin_unlock(&all_mddevs_lock);

[Severity: High]
Similarly, does dropping the lock here in drivers/md/md.c:md_exit() while
holding an unpinned tmp risk list corruption on module exit?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922021533.2935=
172-1-dayou5941@163.com?part=3D1
