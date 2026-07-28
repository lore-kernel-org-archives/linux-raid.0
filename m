Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B36241B8D4
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230056; cv=none; b=o9edNntAjiaZjD/I0qSc2IAZFA/aUGh1GtOVZiuqnyq+cCS+U73V3QGn40UHSzP10eHvb3EMfpSsaHJFp2SUNMdaMdp10F6UYiB0e8OC3PxlDj+dlhWVlRN29N5KNP/QqVCv1nFqlElBpPEnk+2cyn1tdfSgtKAX+Ep/PH9n7bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230056; c=relaxed/simple;
	bh=G4Or+9hVtB1eR9Oplm3k7I9myvNK2QidF4+aiNJjQKg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Cl1NMd+/afMxzShtykGbaV5ENzgrT8q3ggIOQyvu119awmuqcXXT2b5ccDjNWuH2GpDotGaaZKvSsXkATwins7vGz4NGEq+i+G9ZFmL01413Z8cvQbj537SOENzg2Lw0pbB+IfmHfMIs6UtpNPg4BUALZcDaNFIFkQevMrhB3uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e85GNw50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e85GNw50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036311F000E9;
	Tue, 28 Jul 2026 09:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230055;
	bh=KEGGuuczSMBZXuOiBVfUdsRTQXOlWSZd/ZbpcDKAS34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e85GNw50UJbrQJLrCfQGaIKmXug5JOxc6kl9HRqQsJJ2sLYMJDZunLngQkXyvkpxU
	 GKKQ0cKW7w3QKprb4oHf+pyAh6iMKdJ9eynxfhpMb5wJGEqQlDEUXsuM29BniuccZ6
	 ijnMrBUmJtqBcuc1Ko/z14rFzW/XBxc/GTznN8CQBkGJMgPVFs+We7nRH1g4SPXFE+
	 hfkuBeJ56YYpRjw6n/WWDSXF5AdkdomwOAH4bNMnyDZJOEAXxO1StF+MrbfePgntpX
	 JGRmDsxLQ+A0yw+8jr5KmPnZ5IrMHZP0cUVztPrcEOmR23x7ioQGMBBQVE3+9YGRE9
	 gZz6nLfsl0WDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/21] md/md-llbitmap: finish reshape geometry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <ed61e406f8b6b60193c647ab83dd8fb5df0391d0.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <ed61e406f8b6b60193c647ab83dd8fb5df0391d0.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:14:14 +0000
Message-Id: <20260728091415.036311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] The newly implemented `.reshape_finish` callback is never called b=
y the md core, leaving the staged geometry uncommitted at runtime.
- [High] Concurrent array resize causes Use-After-Free of `llbitmap->pctl`.

Pre-existing issues:
- [High] Teardown symmetry violation in `llbitmap_destroy` leading to UAF o=
n `llbitmap`.
- [High] Permanent crippling of the bitmap daemon expiration logic after an=
y flush operation.
--

--- Patch [9]: [PATCH v3 09/21] md/md-llbitmap: finish reshape geometry ---
commit 83899f955ca5cb817105e296dabf1a5632ece1df
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: finish reshape geometry
   =20
When assembling a stopped reshape, md_run() creates the bitmap before
publishing mddev->pers. This commit refreshes the staged reshape geometry
again from llbitmap_load() after mddev->pers is available, and expands
the in-memory page controls before replaying bitmap state.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index cdced2126e975..55ab2a8a11e5f 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1349,11 +1349,20 @@ static int llbitmap_load(struct mddev *mddev)
>  {
>  	enum llbitmap_action action =3D BitmapActionReload;
>  	struct llbitmap *llbitmap =3D mddev->bitmap;
> +	int ret;
> =20
>  	if (test_and_clear_bit(BITMAP_STALE, &llbitmap->flags))
>  		action =3D BitmapActionStale;
> =20
> +	mutex_lock(&mddev->bitmap_info.mutex);
> +	llbitmap_refresh_reshape(llbitmap);
> +	ret =3D llbitmap_expand_pages(llbitmap, llbitmap->chunks);

[Severity: High]
Can this concurrent array resize cause a use-after-free of the page control
array?

If llbitmap_expand_pages() frees the active pctl array while replacing it
with a new one:

drivers/md/md-llbitmap.c:llbitmap_expand_pages() {
    ...
    kfree(llbitmap->pctl);
    llbitmap->pctl =3D pctl;
    ...
}

Normal read/write I/O paths like llbitmap_start_write() call
llbitmap_raise_barrier(), which locklessly dereferences the array:

drivers/md/md-llbitmap.c:llbitmap_raise_barrier() {
    ...
    struct llbitmap_page_ctl *pctl =3D llbitmap->pctl[page_idx];
    ...
}

Does this require synchronization, such as quiesce or RCU, to safely update
the array without causing a use-after-free during concurrent I/O?

> +	if (ret) {
> +		mutex_unlock(&mddev->bitmap_info.mutex);
> +		return ret;
> +	}
>  	llbitmap_state_machine(llbitmap, 0, llbitmap->chunks - 1, action);
> +	mutex_unlock(&mddev->bitmap_info.mutex);
>  	return 0;
>  }
> =20

[ ... ]

> @@ -1680,6 +1689,30 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
v, unsigned long s,
>  	llbitmap_state_machine(mddev->bitmap, s, e, BitmapActionStartwrite);
>  }
> =20
> +static void llbitmap_reshape_finish(struct mddev *mddev)
> +{
> +	struct llbitmap *llbitmap =3D mddev->bitmap;
> +
> +	if (mddev->pers->quiesce)
> +		mddev->pers->quiesce(mddev, 1);
> +
> +	mutex_lock(&mddev->bitmap_info.mutex);
> +	llbitmap_flush(mddev);

[Severity: High]
This is a pre-existing issue, but does calling llbitmap_flush() permanently
cripple the bitmap daemon's expiration logic?

llbitmap_flush() sets the LLPageFlush flag on all page control structures to
force immediate flushing:

drivers/md/md-llbitmap.c:llbitmap_flush() {
    ...
    for (i =3D 0; i < llbitmap->nr_pages; i++)
        set_bit(LLPageFlush, &llbitmap->pctl[i]->flags);
    ...
}

The daemon skips the expiration check if this flag is set:

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
    ...
    if (!test_bit(LLPageFlush, &pctl->flags) &&
        time_before(jiffies, pctl->expire)) {
        restart =3D true;
        continue;
    ...
}

Since there doesn't seem to be a corresponding mechanism to ever clear the
LLPageFlush flag, won't all subsequent I/O bypass write batching and flush
immediately?

> +
> +	llbitmap->chunksize =3D llbitmap->reshape_chunksize;
> +	llbitmap->chunkshift =3D ffz(~llbitmap->chunksize);
> +	llbitmap->chunks =3D llbitmap->reshape_chunks;
> +	llbitmap->sync_size =3D llbitmap->reshape_sync_size;
> +	llbitmap_refresh_reshape(llbitmap);
> +	mddev->bitmap_info.chunksize =3D llbitmap->chunksize;
> +	llbitmap_update_sb(llbitmap);
> +	__llbitmap_flush(mddev);
> +	mutex_unlock(&mddev->bitmap_info.mutex);
> +
> +	if (mddev->pers->quiesce)
> +		mddev->pers->quiesce(mddev, 0);
> +}
> +

[ ... ]

> @@ -1977,6 +2010,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.get_stats		=3D llbitmap_get_stats,
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
> +	.reshape_finish		=3D llbitmap_reshape_finish,

[Severity: High]
Is the newly added .reshape_finish callback ever invoked by the md core?

Without a caller in the md core, it appears the staged reshape geometry
remains uncommitted at runtime, which would leave the active geometry stale.
Can this result in incorrect bitmap behavior or data corruption during or
after a reshape?

>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

As a side note, I noticed another pre-existing issue in the teardown path:

[Severity: High]
This is a pre-existing issue, but does llbitmap_destroy() have a teardown
symmetry violation that could lead to a use-after-free on the llbitmap
structure?

When stopping an array, llbitmap_destroy() deletes the timer and flushes the
workqueue without setting a termination flag:

drivers/md/md-llbitmap.c:llbitmap_destroy() {
    ...
    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);
    flush_workqueue(md_llbitmap_unplug_wq);

    mddev->bitmap =3D NULL;
    llbitmap_free_pages(llbitmap);
    kfree(llbitmap);
}

If the daemon work item executes on the workqueue, it can re-arm the timer =
if
there are unexpired dirty pages:

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
    ...
    if (restart)
        mod_timer(&llbitmap->pending_timer,
                  jiffies + llbitmap->mddev->bitmap_info.daemon_sleep * HZ);
    ...
}

Because md_llbitmap_daemon_fn() doesn't check for a teardown flag, couldn't
the timer be re-armed, and then fire later on the freed llbitmap memory aft=
er
llbitmap_destroy() completes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D9
