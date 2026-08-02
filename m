Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1047270EC3
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703471; cv=none; b=RU3tw9ClMafT4b8NZ2GRX29yb4M9VvaNI1TTVBpOFFZXPskqbzwor8V3BfXUWhG9ZLPZFT18DD0Xq9aVxs6a2RYjBHdyW1smZ2WLHp8PNUakHNUegwJu99RKKK0z1aRwAd47khw6FWGMrmpn4KucsIrWgahohKR9OCZyH4juuK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703471; c=relaxed/simple;
	bh=Kl9MGXLzMl+Pdczk3B0o6HM/2FXftT/6XQFlvaY6fiY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BLpNiU45l8f0+Oxl8DoWcciqOKx7hsHdfBGvw3uypB+662RWylS6Pt694QU6V472zAQqJJl6mIEaGTqrROiHVC4lpMK3iQ/zAl/Jcmk5hXiSNPO6vo9WIPjeLb+hMecZQZjx79o5I1RXv00ijvmNrwCXqIVx1fVNyXABg8KT12w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dRIJ7cFo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dRIJ7cFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9501F000E9;
	Sun,  2 Aug 2026 20:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703469;
	bh=2KGySAuX5YFKziNjGsa1nmXEWmJuWwVfX5DTwWxJ404=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dRIJ7cFo1ScMj7UzDGYdj2w4QPsAJXLYox3TgN48lNld+XzFlemyrBEuCZWuae32u
	 H7K+6qy99uxxQv7O1+SLU1tr+2R7ULErAMIPjrMs/PM5TRihu9qQc2LPh/ND9xYA5O
	 WfD5EFjQ0m1rYTmOdw79FDYgYE+8rW7KDkYNhgaadm1ca5Zqq+IvBoHhskaAexygpC
	 wSgEV1+PiUZzxa/xH7GvWtTYw0AXUBBCV5A7GzRi2uAn87o3L9lBWzIlMCCYmoNJZo
	 jV8wj5fv+et7eDDL8j/ZaUcroa+BxJLdN4K416ti86KJlvHlN2H/tvMA+oZwGOPtPL
	 7dqpToJGIqRUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/29] md/md-llbitmap: use GFP_NOIO for cache
 allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-3-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-3-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:44:28 +0000
Message-Id: <20260802204428.EB9501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] `llbitmap_resize()` recalculates capacity limits but fails to real=
locate the `pctl` array, causing out-of-bounds pointer dereferences during =
subsequent operations.
- [High] `blkdev_issue_zeroout()` is called with `GFP_KERNEL` while `mddev_=
lock()` is held, risking a direct reclaim deadlock.
- [High] The background timer and workqueue can re-arm each other during te=
ardown, leading to a Use-After-Free of the `llbitmap` struct.
--

--- Patch [2]: [PATCH v5 02/29] md/md-llbitmap: use GFP_NOIO for cache allo=
cations ---
commit 0ace115175e6f1ed40865ea8b812e7ca53aadaed
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: use GFP_NOIO for cache allocations

This commit changes the memory allocation flags from GFP_KERNEL to GFP_NOIO=
 for
the llbitmap object and its related structures. This change prevents direct
memory reclaim from triggering block I/O while MD resize state locks are he=
ld,
avoiding potential deadlocks.

> llbitmap allocates its in-memory page cache and page-control structures f=
rom
> paths that can already be holding MD reconfiguration or bitmap state lock=
s.
> For example, component_size_store() takes mddev_lock(), update_size() cal=
ls
> the personality resize method, and llbitmap_resize() can grow the page ca=
che
> through llbitmap_prepare_resize().

[Severity: High]
This is a pre-existing issue, but the commit message claims that
llbitmap_resize() grows the page cache through llbitmap_prepare_resize().

Looking at llbitmap_resize():

llbitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
{
	...
	llbitmap->chunks =3D chunks;

	return 0;
}

The function updates the capacity limits but does not update llbitmap->nr_p=
ages
or reallocate the llbitmap->pctl array. The referenced llbitmap_prepare_res=
ize()
function does not seem to exist.

Because the pctl array is not reallocated, won't subsequent I/O operations =
call
llbitmap_write() with an index that exceeds the original nr_pages length?

llbitmap_write() calculates the index:

	idx =3D pos >> PAGE_SHIFT;
	bit =3D offset_in_page(pos);

	llbitmap->pctl[idx]->state[bit] =3D state;

Could this lead to an out-of-bounds pointer dereference when accessing the =
new
chunks limit?

> Use GFP_NOIO for the llbitmap object, cached bitmap pages, page controls,
> page-control arrays, and percpu_ref initialization. Leave the explicit
> metadata zeroout path unchanged because it is intentional bitmap I/O rath=
er
> than reclaim-driven allocation.

[Severity: High]
This isn't a bug introduced by this patch, but the commit message explicitly
notes that the metadata zeroout path was left unchanged.

Looking at llbitmap_zero_all_disks(), which is called during array
initialization or reconfiguration with mddev_lock() held:

	ret =3D blkdev_issue_zeroout(rdev->bdev,
				   rdev->data_offset,
				   dev_sectors,
				   GFP_KERNEL, 0);

While the I/O itself is intentional, blkdev_issue_zeroout() uses the provid=
ed
GFP flags internally to allocate the bio and payload pages. If memory is ti=
ght,
won't GFP_KERNEL enter direct reclaim, potentially submitting a bio back to=
 the
same mddev and causing a deadlock?

Should this also be updated to use GFP_NOIO?

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 71e9a21b98b2e..3cd8373bc9b22 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

[Severity: High]
This is a pre-existing issue, but there appears to be a resource lifecycle
regression during teardown.

Looking at llbitmap_destroy():

	timer_delete_sync(&llbitmap->pending_timer);
	flush_workqueue(md_llbitmap_io_wq);
	...
	kfree(llbitmap);

If the timer had already fired and queued the daemon_work, timer_delete_syn=
c()
returns immediately. flush_workqueue() then blocks waiting for the work ite=
m to
execute.

Inside md_llbitmap_daemon_fn():

	if (restart)
		mod_timer(&llbitmap->pending_timer,
			  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);

If unexpired dirty pages are found, it sets restart =3D true and unconditio=
nally
calls mod_timer(), re-arming the timer while the subsystem is undergoing
destruction.

After flush_workqueue() finishes, llbitmap_destroy() frees the llbitmap obj=
ect.

When the newly re-armed timer fires, won't it access the freed object?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D2
