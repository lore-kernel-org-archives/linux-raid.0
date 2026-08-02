Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061D72E889C
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702257; cv=none; b=YlTlqx2pA8VtxFAUpGNnwOZ4Jc3UEoWU21cmhD06jeAk0yI7r9NWHJPLPm96VvVBHRIiH2N6Ojwzbdhumx62j4m+0Ig9RZ+0Z6Qo8/TE0B8TC/CZYTSjF0nM17OQhAbhpy2CrckFuMFCyI4bszGbca6iVrWyTTiSD5BDi0c9L/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702257; c=relaxed/simple;
	bh=BeVKgpJaNB0ewruHLN+rWTePqQPRPNrgrZ8R6ethPho=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tsT7zqOeNiYatdsG6kkrqaMLjaMLjp7wrBvs02TR6SJ8EyyzL12y/8IOQ04zFe2WGiUcfMT9+2hWuNABH9FLc370HwbQ5l2Xs5bBb2Wjld9fo/y0kPoycHIYiTiLvVa9JPbnLmqzaUrEgps1Vx4AOFE3kzO7jO3r2oi4JfJdiRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HS4uvOmr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HS4uvOmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621D81F000E9;
	Sun,  2 Aug 2026 20:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702255;
	bh=O+xQ+5GdwN03BW1GkUWd0R/OfUJOksBHZS3mMmSelgM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HS4uvOmrJ4Fq9hkLvBGhvT+j4HsTJfx23yDYSrWHlViFnANTACMnZVHmeQ7EYKteG
	 WD6rp5WOKyyfHEU0DVqPHRXqS4YaLIDs7Wr3vT5AEfg+17FTY8NzPS2qY64DpPygEC
	 6481v5Qfn1/S4bfnEgpJ9Xty46Sk3w3ndTjlRxxFcasecw51KmY9NEkhWPNOMYzrt1
	 RE5ohcVPcVaCzvOU8M46hHWvYgfzafQH4tP4lDQyQCkNTvn9dioG3nxhAVZiIeQ7LD
	 qTdLcnkB7TffTduXy8/QAQxg0pckR+QK6mR6AV+1/NVJcZYz7SviagCv4UnVfd/wik
	 PvseanuDZVnmQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 13/29] md/md-llbitmap: track bitmap sync_size
 explicitly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-14-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-14-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:24:14 +0000
Message-Id: <20260802202415.621D81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

New issues:
- [High] Missing bounds check in IO fast paths allows out-of-bounds access =
to the `llbitmap->pctl` array when writing to regions beyond `llbitmap->syn=
c_size`.
- [High] The `chunksize` validation in `llbitmap_read_sb()` incorrectly che=
cks against `mddev->resync_max_sectors` instead of the newly tracked `sync_=
size`.
- [High] Strict validation of `sync_size` against `resync_max_sectors` in `=
llbitmap_read_sb` permanently fails array assembly during shrink operations=
 and crash recovery.
- [Medium] `llbitmap->sync_size` and `chunksize` are modified without consi=
stent locking, causing a data race and potential 64-bit torn reads.

Pre-existing issues:
- [High] `llbitmap_resize` increases tracking limits (`chunks`, `sync_size`=
) but fails to reallocate the `llbitmap->pctl` array to accommodate the new=
 capacity.
--

--- Patch [13]: [PATCH v5 13/29] md/md-llbitmap: track bitmap sync_size exp=
licitly ---
commit 19aa94c506f3423cf682ebddc1ee49bc66629dd1
Author: Yu Kuai <yukuai@fygo.io>
Subject: md/md-llbitmap: track bitmap sync_size explicitly

This patch modifies the llbitmap layer to track its own sync_size explicitl=
y=20
rather than relying directly on mddev->resync_max_sectors. It updates the=20
superblock reader and writer to store and load this tracked sync_size. This=
=20
lays the groundwork for tracking old and new reshape geometries independent=
ly.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 4583bbc37c2e7..0813cebfbdeb3 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
[ ... ]
> @@ -939,6 +942,7 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
>  	unsigned long daemon_sleep;
>  	unsigned long chunksize;
>  	unsigned long events;
> +	sector_t sync_size;
>  	struct page *sb_page;
>  	bitmap_super_t *sb;
>  	int ret =3D -EINVAL;
[ ... ]
> @@ -988,6 +992,14 @@ static int llbitmap_read_sb(struct llbitmap *llbitma=
p)
>  		goto out_put_page;
>  	}
> =20
> +	sync_size =3D le64_to_cpu(sb->sync_size);
> +	if (!sync_size)
> +		sync_size =3D mddev->resync_max_sectors;

[Severity: High]
Does decoupling the bitmap geometry from the array size require updating
the chunksize validation check?

In llbitmap_read_sb(), the chunksize validation still checks if it is large
enough using mddev->resync_max_sectors instead of the newly tracked
sync_size:

if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
                      mddev->bitmap_info.space << SECTOR_SHIFT)) {
    pr_err("md/llbitmap: %s: chunksize too small %lu < %llu / %lu",

If an array was recently expanded, could the old geometry's chunksize
falsely appear too small for the new array size, breaking array assembly?

> +	if (sync_size > mddev->resync_max_sectors) {
> +		pr_err("md/llbitmap: %s: sync_size %llu exceeds array sync size %llu",
> +		       mdname(mddev), sync_size, mddev->resync_max_sectors);
> +		goto out_put_page;
> +	}

[Severity: High]
Will this strict check break array assembly during a crash recovery?

If an array is shrunk and the system crashes after the array superblocks
are updated but before the bitmap superblocks are written, the on-disk
bitmap's sync_size will be larger than mddev->resync_max_sectors.

Does permanently rejecting a larger sync_size here prevent the array
from assembling in this scenario?

>  	chunksize =3D le32_to_cpu(sb->chunksize);
>  	if (!is_power_of_2(chunksize)) {
>  		pr_err("md/llbitmap: %s: chunksize not a power of 2",
[ ... ]
> @@ -1023,8 +1035,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitm=
ap)
> =20
>  	llbitmap->barrier_idle =3D DEFAULT_BARRIER_IDLE;
>  	llbitmap->chunksize =3D chunksize;
> -	llbitmap->chunks =3D DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors, c=
hunksize);
> +	llbitmap->chunks =3D DIV_ROUND_UP_SECTOR_T(sync_size, chunksize);

[Severity: High]
Could a maliciously crafted superblock with a small sync_size cause an
out-of-bounds dereference?

Because chunks is calculated from the untrusted sync_size, the allocated
pctl array will be small. The md core can still issue I/O up to the full
array size (mddev->resync_max_sectors).

Fast paths like llbitmap_start_write() shift the offset to determine the
page_start index without checking against nr_pages:

int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
while (page_start <=3D page_end) {
    llbitmap_raise_barrier(llbitmap, page_start);
    page_start++;
}

Will this sequence lead to accessing memory past the end of llbitmap->pctl?

>  	llbitmap->chunkshift =3D ffz(~chunksize);
> +	llbitmap->sync_size =3D sync_size;
>  	ret =3D llbitmap_cache_pages(llbitmap);
> =20
>  out_put_page:
[ ... ]
> @@ -1161,6 +1174,7 @@ static int llbitmap_resize(struct mddev *mddev, sec=
tor_t blocks, int chunksize)
>  	llbitmap->chunkshift =3D ffz(~chunksize);
>  	llbitmap->chunksize =3D chunksize;
>  	llbitmap->chunks =3D chunks;
> +	llbitmap->sync_size =3D blocks;

[Severity: High]
This is a pre-existing issue, but does llbitmap_resize() safely expand the
tracking capacity?

When the array is expanded, chunks and sync_size are increased, but there
does not appear to be any code to reallocate the underlying llbitmap->pctl
array.

Subsequent I/O to the newly grown sectors maps to an index that exceeds
the originally allocated nr_pages, which might cause an out-of-bounds
memory access.

> =20
>  	return 0;
>  }
[ ... ]
> @@ -1541,7 +1555,7 @@ static void llbitmap_update_sb(void *data)
>  	sb->events =3D cpu_to_le64(mddev->events);
>  	sb->state =3D cpu_to_le32(llbitmap->flags & ~BIT(BITMAP_SHUTDOWN));
>  	sb->chunksize =3D cpu_to_le32(llbitmap->chunksize);
> -	sb->sync_size =3D cpu_to_le64(mddev->resync_max_sectors);
> +	sb->sync_size =3D cpu_to_le64(llbitmap->sync_size);

[Severity: Medium]
Is there adequate locking for the 64-bit sync_size field?

In llbitmap_resize(), llbitmap->chunksize and llbitmap->sync_size are
updated while holding only mddev->reconfig_mutex.

Concurrently, md_update_sb() can acquire mddev->lock and call
llbitmap_update_sb() without holding reconfig_mutex (such as during
background metadata updates).

Since these accesses do not share a common lock, can llbitmap_update_sb()
experience a torn read of the 64-bit sync_size on 32-bit systems, or read
an inconsistent state where chunksize and sync_size mismatch?

>  	sb->events_cleared =3D cpu_to_le64(llbitmap->events_cleared);
>  	sb->sectors_reserved =3D cpu_to_le32(mddev->bitmap_info.space);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D13
