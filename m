Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3AE40F8D0
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229787; cv=none; b=SM38ovCCyhPCH54xoSb5OXUg8iyaZMb4viIsp/EtrxIByxr4phmgbMIyUiiXe3C35dT4+VV3RTAEsE6M17bwyFVPu5H33P27KjW3Ix/0JdvWjSWf06QTgmRShHM+DgDjcJYskExTNu5jirrXpxlrcIukq0UIhHTgmNf6VwkpPjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229787; c=relaxed/simple;
	bh=xXKrp5m0DlYbmLkVkisX51/VWxCI8eg4DbsbAeTt2aU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NJe/qjfne55NntLAFBsyHiAcZlU+wtbjx/BWzFN+A5zy64NY4+T8w7L6gOKYMQ/BANQ1NCRh50OxMYGV7qKMmkA9V0x9QCXI0/xGj33dxQkaQmBw1nn78rdyDHlFIu1rA/WoTZvke9TLD9bCoHhoO2CvUX0isc0ZXSserNToPmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSfWFHd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSfWFHd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7951F000E9;
	Tue, 28 Jul 2026 09:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229786;
	bh=TNtVIuyUqEm5tN4wpeMhFTkUNowTwoZA0Es8uq5R1O4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VSfWFHd9P1cVmlfIaJLrzBtpFqxmxKdE5eCBuxfK7awjftFfypOQ4CYR/qeDEsEJU
	 2py15QF6clvIOzO9zrzhcSY+Cq/onpk3d4dM+R3Fl5msnoVNEo74WjosDfRm71+ZrS
	 5zf86faLpvPI6P3NUwxmIT3FlcmoKSdxkRkC7qLI4zXu4rr0PlVgGw6HYtFwFqutY6
	 OpQCv6DdrKHkZF84PpVePVAiuIRZSRNQfx2293AGFOuI7WLPsv4Ai1Ebzo6waXatBB
	 QQva/E9+dwVQ1WzknA/yC5X9HvHqOah5w6ffqpjDoj976B3ixn9dgch26gcVolW9s5
	 4O6XFYceQt5kQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/21] md/md-llbitmap: grow the page cache in place
 for reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <7f146fb22b6051aea3b0e79072d4403526ed46f0.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <7f146fb22b6051aea3b0e79072d4403526ed46f0.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:09:45 +0000
Message-Id: <20260728090946.0A7951F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 6 potential issue(=
s) to consider:

New issues:
- [High] Use-After-Free on `llbitmap->pctl` array during bitmap resize.
- [High] Block IO recursion deadlock due to `GFP_KERNEL` allocation under `=
reconfig_mutex`.
- [High] Out-Of-Bounds array access during resize due to stale `chunkshift`.

Pre-existing issues:
- [High] Divide-by-zero crash in `llbitmap_calculate_chunks` on 32-bit syst=
ems due to `chunksize` overflow.
- [High] Use-After-Free timer race during `llbitmap_destroy`.
- [High] Out-of-Bounds disk write due to missing `BITMAP_DATA_OFFSET` in ca=
lculation.
--

--- Patch [7]: [PATCH v3 07/21] md/md-llbitmap: grow the page cache in plac=
e for reshape ---
commit 7e002f8cabd473784285f63600d75c1d7d7d30c4
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: grow the page cache in place for reshape

This patch uses the page-control helpers to grow the llbitmap's cached pages
in place for resize and later reshape preparation, instead of rebuilding the
whole cache.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 4c3fc4b35aff0..1ab9b1689fd80 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -416,6 +416,19 @@ static char state_machine[BitStateCount][BitmapActio=
nCount] =3D {
>  };
> =20
>  static void __llbitmap_flush(struct mddev *mddev);
> +static void llbitmap_flush(struct mddev *mddev);
> +static void llbitmap_update_sb(void *data);
> +
> +static void llbitmap_calculate_chunks(struct mddev *mddev, sector_t bloc=
ks,
> +				      unsigned long *chunksize,
> +				      unsigned long *chunks)
> +{
> +	*chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
> +	while (*chunks > mddev->bitmap_info.space << SECTOR_SHIFT) {

[Severity: High]
This is a pre-existing issue, but does this calculation allow the on-disk
footprint to exceed the reserved space limit?

The check ensures *chunks does not exceed mddev->bitmap_info.space, but
the on-disk layout includes an additional 1024 bytes (BITMAP_DATA_OFFSET)
for the superblock before the raw bitmap state data.

When llbitmap_write_page() writes the tail chunks to disk, could it write
1024 bytes past the reserved bitmap region and corrupt adjacent data?

[Severity: High]
This is a pre-existing issue, but does this loop risk a divide by zero on
32-bit systems?

If *chunksize is 32 bits, and the array is extremely large with very small
reserved space, *chunksize could shift until it overflows to 0.

Would the subsequent call to DIV_ROUND_UP_SECTOR_T(blocks, 0) cause a crash
when the sysfs size is written?

> +		*chunksize =3D *chunksize << 1;
> +		*chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, *chunksize);
> +	}
> +}

[ ... ]

> @@ -655,6 +668,48 @@ static unsigned int llbitmap_reserved_pages(struct l=
lbitmap *llbitmap)
>  			    PAGE_SIZE);
>  }
> =20
> +static int llbitmap_expand_pages(struct llbitmap *llbitmap,
> +				 unsigned long chunks)
> +{
> +	struct llbitmap_page_ctl **pctl;
> +	unsigned int old_nr_pages =3D llbitmap->nr_pages;
> +	unsigned int nr_pages =3D llbitmap_used_pages(llbitmap, chunks);
> +	unsigned int i;
> +	int ret;
> +
> +	if (nr_pages <=3D old_nr_pages)
> +		return 0;
> +
> +	pctl =3D kcalloc(nr_pages, sizeof(*pctl), GFP_KERNEL);

[Severity: High]
Can this allocation trigger a block IO recursion deadlock?

This is reached via array_size_store() which acquires mddev_lock()
(taking reconfig_mutex) without setting memalloc_noio_save() context.

Under memory pressure, GFP_KERNEL can enter direct reclaim and issue I/O
writeback to the MD array. If the array superblock needs updating,
md_write_start() waits on mddev->sb_wait for MD_SB_CHANGE_PENDING to clear.

Since the management thread must clear this flag but blocks trying to acqui=
re
reconfig_mutex held by this resizing thread, does this result in a deadlock?

> +	if (!pctl)
> +		return -ENOMEM;
> +
> +	if (llbitmap->pctl)
> +		memcpy(pctl, llbitmap->pctl,
> +		       array_size(old_nr_pages, sizeof(*pctl)));
> +
> +	for (i =3D old_nr_pages; i < nr_pages; i++) {
> +		pctl[i] =3D llbitmap_alloc_page_ctl(llbitmap, i);
> +		if (IS_ERR(pctl[i]))
> +			goto err_alloc_ptr;
> +	}
> +
> +	kfree(llbitmap->pctl);
> +	llbitmap->pctl =3D pctl;

[Severity: High]
Could this cause a use-after-free if concurrent IO is happening?

The MD array does not suspend IO for sysfs-triggered resize operations.
The concurrent IO path accesses this array in llbitmap_start_write():

llbitmap_start_write()
    llbitmap_raise_barrier(llbitmap, page_start);

This happens without holding mddev->bitmap_info.mutex and without RCU
protection. If the IO path dereferences the array just after this kfree()
completes, will it trigger a panic?

> +	llbitmap->nr_pages =3D nr_pages;
> +	return 0;
> +

[ ... ]

> @@ -1171,24 +1254,53 @@ static int llbitmap_create(struct mddev *mddev)
>  static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chu=
nksize)
>  {

[ ... ]

> +	if (reshape) {
> +		llbitmap->chunks =3D max(old_chunks, chunks);
> +	} else {

[Severity: High]
Does this cause an out-of-bounds array access during a reshape?

During reshape, this path updates llbitmap->chunks to a potentially larger
capacity but does not update llbitmap->chunkshift.

The active IO path continues to map array offsets to bitmap chunk indices
using the smaller old chunkshift:

llbitmap_start_write()
    start =3D offset >> llbitmap->chunkshift;
    ...
    page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;

Because the old chunkshift maps to a larger number of total chunks than the
new chunks capacity (which was reduced by doubling bitmap_chunksize), could
an IO towards the end of the new array compute a page_start index that
exceeds the capacity of the newly reallocated llbitmap->pctl array?

> +		if (blocks < old_blocks && chunks < old_chunks)
> +			llbitmap_mark_range(llbitmap, chunks, old_chunks - 1,
> +					    BitUnwritten);
> +		mddev->bitmap_info.chunksize =3D bitmap_chunksize;
> +		llbitmap->chunks =3D chunks;
> +		llbitmap->sync_size =3D blocks;
> +		llbitmap_update_sb(llbitmap);
> +	}
> +	__llbitmap_flush(mddev);
> +	mutex_unlock(&mddev->bitmap_info.mutex);
>  	return 0;

[Severity: High]
This is a pre-existing issue, but is there a use-after-free race between
llbitmap_destroy() and the daemon work queue?

llbitmap_destroy() deletes the timer and then flushes the workqueue:

llbitmap_destroy()
    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

If md_llbitmap_daemon_fn() is actively executing in the workqueue while
teardown happens, the timer is not pending, so timer_delete_sync() returns
immediately.

The running daemon work then evaluates restart =3D true and re-arms the tim=
er:

md_llbitmap_daemon_fn()
    if (restart)
        mod_timer(&llbitmap->pending_timer, ...);

Could flush_workqueue() complete, allowing llbitmap_destroy() to free the
llbitmap structure, while the re-armed timer later fires and accesses the
freed memory?

> +
> +out:
> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D7
