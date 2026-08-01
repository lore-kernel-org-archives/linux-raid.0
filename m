Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553F7489879
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606477; cv=none; b=L/+SNlumsI8TzdfoIZqRAKSCODekPHEiks+D78cTaBX1lEiCuTu6wIxh1nOAtdcEC0uQL1GR/dQmoNalMAxsCoCUGEcbFZpObrk0DZPdL3Q+K8VAlX4RRl26TKwjpmBqlLtvMRpFv4yCRWic+gVVaCTZKBNCiagKVK5MUdxqPYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606477; c=relaxed/simple;
	bh=YAIUiT/n1OqkCtRxR7VXzzrT7EPn3dslVAZU0YoJFNE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bd9fAFctaBT78D5YQKL1jZbKtR1F3rftzvq6FunRpVHOir0kpdZ1dMYNf9KFKIvnMNVnBg9Zjhx8VTCB5sriWejWQmBJVSUIRPhP3muSkc8Av1k55jszmyWJvaMsDfDaVCyNSxze3Bq44tH13wH2aEPxNQ23KdYH+isaG6Pn8cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CItqiOzD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CItqiOzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B416B1F00AC4;
	Sat,  1 Aug 2026 17:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606476;
	bh=jtIa0Aif5U7LJkElK4RbV7yEgMeinsiU5JAPOEWDxkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CItqiOzDjr17AAEdnUV8VlqoH0WCP4bSu6tkd1O16D5jRNhLZIh5Qp4OCQRJAfel+
	 lLHVQctHfnH8SSOe+JO2J6DBRcqdS4jVi3/831hg6XBbx44gcJy/huKbkmE9zgT8v0
	 8BfMi8xlV24fNYo/9638x4kTeZs3WQauAAOLDWGJXb6hZ0hb4Y3vKL9duFpsElbqRc
	 oc8z7/91kmzYWTO1YTGOT6FJwSqrCYxNlT0gUOH3Yzk1jGTOOvF6YNoizFVGjDuZzz
	 T0tbgAgRrNXeJuU/FylIfefkAEjiylWNHirOHkTpMX5V28/H5HuWlcpREjbdcAOArn
	 au7IJP7T5rl3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 15/25] md/md-llbitmap: add reshape range mapping
 helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-16-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-16-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:47:55 +0000
Message-Id: <20260801174755.B416B1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Missing post-mapping clamp in llbitmap_map_layout causes out-of-bo=
unds array access.
- [High] Missing RAID5 personality callbacks for exact bitmap mapping cause=
 array-sector I/Os to be improperly clamped and silently dropped.
- [High] Bios are not split at the reshape boundary before bitmap processin=
g, causing I/Os to span the boundary and corrupt sync state.

Pre-existing issues:
- [High] Timer teardown race in llbitmap_destroy allows the daemon workqueu=
e to re-arm the timer on a freed structure.
--

--- Patch [15]: [PATCH v4 15/25] md/md-llbitmap: add reshape range mapping =
helpers ---
commit 9c9574c9c91f5e10866a7c4d06542de767878cc2
Author: Yu Kuai <yukuai@fygo.io>
Subject: md/md-llbitmap: add reshape range mapping helpers

This patch updates llbitmap to choose between old and new geometry during a
reshape and to encode exact bitmap ranges. It also distinguishes writes from
discards for range preparation and clamps pre-map ranges to array-sector
limits.

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> +static sector_t llbitmap_logical_size(struct llbitmap *llbitmap, bool pr=
evious)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +
> +	if (!mddev->private || !mddev->pers ||
> +	    !mddev->pers->bitmap_array_sectors)
> +		return llbitmap_personality_sync_size(llbitmap, previous);
> +	return mddev->pers->bitmap_array_sectors(mddev, previous);
> +}

[Severity: High]
Does this fallback to llbitmap_personality_sync_size() hide the fact that
the raid5 personality doesn't implement bitmap_array_sectors or
bitmap_sector_map?

If an I/O is issued beyond the component size (for instance, past 1/N of
the array size), won't the pre-map clamp in llbitmap_map_layout() see
start >=3D limit and force sectors =3D 0?=20

This would silently drop the bitmap update, leading to permanent data
corruption if the system crashes and fails to resync those unrecorded
regions.

[ ... ]
> +static void llbitmap_map_layout(struct llbitmap *llbitmap, sector_t *off=
set,
> +				unsigned long *sectors, bool previous)
> +{
[ ... ]
> +	if (llbitmap->mddev->pers->bitmap_sector_map)
> +		llbitmap->mddev->pers->bitmap_sector_map(llbitmap->mddev, offset,
> +							 sectors, previous);
> +	else if (!previous && llbitmap->mddev->pers->bitmap_sector)
> +		llbitmap->mddev->pers->bitmap_sector(llbitmap->mddev, offset,
> +							 sectors);
> +}

[Severity: High]
Is there a missing post-mapping clamp against the component sync_size here?

When a write near the end of the array is passed to llbitmap_start_write(),
the pre-map clamp correctly limits offset and sectors to the array size.
However, bitmap_sector() translates only the offset to component space
without scaling down the sectors value.

If offset + sectors exceeds the component size, couldn't this cause the
calculated page_end index in llbitmap_start_write() to exceed
llbitmap->nr_pages? This would result in an out-of-bounds read beyond the
llbitmap->pctl pointer array and memory corruption when accessing the active
percpu_ref.

[ ... ]
> @@ -1394,11 +1475,35 @@ static void llbitmap_destroy(struct mddev *mddev)
[ ... ]
>  	mutex_unlock(&mddev->bitmap_info.mutex);
>  }

[Severity: High]
This is a pre-existing issue, but does this teardown sequence have a
use-after-free race with the daemon workqueue?

If the timer fires right before timer_delete_sync(), it queues daemon_work.
flush_workqueue() then blocks until md_llbitmap_daemon_fn() finishes.
However, md_llbitmap_daemon_fn() can unconditionally re-arm the timer:

	if (restart)
		mod_timer(&llbitmap->pending_timer, ...);

If the timer is re-armed during the flush, won't it fire again after
kfree(llbitmap) executes, dereferencing the freed structure?

> +static bool llbitmap_map_previous(struct llbitmap *llbitmap, sector_t of=
fset,
> +				  unsigned long sectors)
> +{
> +	struct mddev *mddev =3D llbitmap->mddev;
> +	sector_t boundary =3D READ_ONCE(mddev->reshape_position);
> +
> +	if (boundary =3D=3D MaxSector)
> +		return false;
> +
> +	WARN_ON_ONCE(sectors && offset < boundary && offset + sectors > boundar=
y);

[Severity: High]
Can bios span across the reshape boundary and trigger this warning?

It appears mddev_bio_split_at_reshape_offset() is exported in md.c but is
never called before md_account_bio(). Because the bio isn't split,
md_bitmap_start() will receive the original, un-split bio from the block
layer.

If a spanning bio triggers this warning, llbitmap_map_previous() forces the
entire bio to be mapped to a single geometry. Won't this fail to mark the
necessary bits in the other geometry and corrupt the sync state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D15
