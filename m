Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE77925B0AE
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703203; cv=none; b=c9yzxhcmtxEuhLj1HLxza52n3TFSkqWk0zJlIk7WzlySgE6HVsll/PgkYrH3CsORQ53ImAedC+zX6k4ucjzyMobnDdvHa779cg2zEe/k03Li87ViBrCCxK/3oHeb5Y5KxrvXcXK/i0UJAGOrDiDdo650Nz7+dYiBzBttYxG3qcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703203; c=relaxed/simple;
	bh=sBOGYHrUxTY/c2EvOICgXu2sUDBBLRY5YsU5p+Q8zOE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jQamFrKahTAkJ1rhAID9lVmCJ9Fb6cSR9McRf+2GuorVPsLqIbmt7a/LbiC4Kck2psWe9iDcDfTKZEUj+nsHu1DuHdp2uWUoZapTUjaCfjIbWsiS3fChgB/ETIgmPjNTPFZWpbuQuJh7vGrP2wxpjCrZzuRFydeTcm7LmXZbXjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RI0UhRZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RI0UhRZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D191F00A3A;
	Sun,  2 Aug 2026 20:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703202;
	bh=nkgAPA9k6Ojj6dy2/TMm74VJXxcNmRcMFto/OlqMFnY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RI0UhRZM50QEM0S4NTr+ykaNPVgivFKB+5PKs8bbiydjSjAsKHvLjpQVDTtg5n4uX
	 umhD/ypAsUxSiDzJErYYqRJBeqesOgVP5a6uvTI8YMZ5X2fLVLHXAUtyfxOUWqz707
	 UPcl5UGgDBZj7s92BUzGFPdREi1KNKYBIG9lzlinRdlLQRvc/ZRxyak3oasr4l0y4L
	 zN7VfodyGOSmm1vRBQKRFTP7NqBy+ljcOayuGXVPYS+3A/9WbEDDM84bNsZgNDvLE6
	 GX8oRgnk3qXQCsmHRGM2m4pF+YX8uQ+OleQj2DjLNn0RyE+WrdD+cnkgorFeVUGI3U
	 t4CdpAHFPOVLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 06/29] md: wait for behind writes before destroying
 bitmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-7-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-7-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:40:01 +0000
Message-Id: <20260802204002.69D191F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dynamic removal of llbitmap via sysfs or ioctl does not wait for b=
ehind writes, leading to a NULL pointer dereference.
- [High] Teardown asymmetry in llbitmap_destroy allows the pending_timer to=
 be re-armed after deletion, leading to a Use-After-Free of llbitmap.
- [High] Lockless TOCTOU race on `mddev->bitmap_ops` leading to NULL pointe=
r dereference.
--

--- Patch [6]: [PATCH v5 06/29] md: wait for behind writes before destroyin=
g bitmap ---
commit 908390619225b153696b5648f3002688751593a6
Author: Yu Kuai <yukuai@fygo.io>

md: wait for behind writes before destroying bitmap

__md_stop() previously destroyed the bitmap before calling mddev_detach(),
skipping the wait for behind writes. This commit reorders them to call
mddev_detach() first, ensuring behind writes are waited on while the
bitmap is still alive.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 51b620edbef75..b61040315aef6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7085,8 +7085,8 @@ static void __md_stop(struct mddev *mddev)
>  {
>  	struct md_personality *pers =3D mddev->pers;
> =20
> -	md_bitmap_destroy(mddev);
>  	mddev_detach(mddev);
> +	md_bitmap_destroy(mddev);

[Severity: High]
This is a pre-existing issue, but does dynamic removal of the bitmap via
sysfs fail to wait for behind writes?

When a user writes to bitmap/location to clear the bitmap dynamically,
location_store() calls mddev_suspend_and_lock() to suspend the array.
mddev_suspend() waits for active_io to drop to 0. For RAID1 behind writes,
active_io is dropped by md_end_clone_io() when non-writemostly devices
complete their writes:

drivers/md/md.c:md_handle_request() {
...
	percpu_ref_put(&mddev->active_io);
...
}

This means behind writes to writemostly devices can still be in flight.
location_store() then proceeds to free the bitmap:

drivers/md/md-bitmap.c:location_store() {
...
	md_bitmap_destroy_nosysfs(mddev);
...
}

When behind writes finally complete, could close_write() dereference the
now NULL bitmap_ops pointer?

drivers/md/raid1.c:close_write() {
...
	mddev->bitmap_ops->end_behind_write(mddev);
...
}

[Severity: High]
This is a pre-existing issue, but can the llbitmap pending_timer be re-armed
after it is deleted during destruction?

llbitmap_destroy() deletes the timer and flushes the workqueue:

drivers/md/md-llbitmap.c:llbitmap_destroy() {
...
	timer_delete_sync(&llbitmap->pending_timer);
	flush_workqueue(md_llbitmap_io_wq);
...
}

If the timer expires right before deletion, the handler queues
md_llbitmap_daemon_fn() to the workqueue. If unexpired dirty pages exist,
the daemon function evaluates time_before(jiffies, pctl->expire). Since
llbitmap_resume() sets pctl->expire to LONG_MAX, this evaluates to true,
setting restart to true. The timer is then unconditionally re-armed:

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
...
	if (restart)
		mod_timer(&llbitmap->pending_timer, ...);
...
}

The flush_workqueue() call in llbitmap_destroy() will wait for this work
to finish, but it does not prevent the timer from being re-armed. Could
this leave the timer armed with a freed llbitmap pointer, causing a
use-after-free when it fires?

[Severity: High]
This isn't a bug introduced by this patch, but is there a TOCTOU race on
mddev->bitmap_ops between the teardown path and concurrent readers?

In the background thread, md_check_recovery() checks md_bitmap_enabled(),
which locklessly verifies mddev->bitmap_ops is not NULL:

drivers/md/md.c:md_check_recovery() {
...
	if (md_bitmap_enabled(mddev, false) && mddev->bitmap_ops->daemon_work)
		mddev->bitmap_ops->daemon_work(mddev);
...
}

Concurrently, a write to bitmap/location via sysfs triggers location_store(=
),
which acquires reconfig_mutex (but not mddev->lock or bitmap_info.mutex)
and calls md_bitmap_destroy_nosysfs(), unconditionally setting the ops
pointer to NULL:

drivers/md/md.c:md_bitmap_destroy_nosysfs() {
...
	mddev->bitmap_ops =3D NULL;
...
}

Could md_check_recovery() proceed to dereference the now NULL pointer? A
similar race appears to exist with md_seq_show() reading /proc/mdstat,
which holds locks not respected by the sysfs teardown path:

drivers/md/md.c:md_seq_show() {
...
	md_bitmap_status(seq, mddev);
...
}

>  	spin_lock(&mddev->lock);
>  	mddev->pers =3D NULL;
>  	spin_unlock(&mddev->lock);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D6
