Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47AD33CE88
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703054; cv=none; b=Mp2c3qQmybIoOIoJ53L0Cbul3Nl7y/AgRs55ZbzMyHSZbsIFHs3ZOMEAiC0JekCKC9EpvyEzJ+sI8wLBnWOYg7eSGcNJI2qOIUVnvbbgUdgiX3ugeNr+9Ak+mGXDLwZog/NSwG+K7KYzey4Wj51ZCBd88zuYLrYF2fKdvBGHbE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703054; c=relaxed/simple;
	bh=feSGHC/5eUbLQ/OKhR0UXl9O3ukvc8nPObq/WoR1dLs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=g1tErviK5jGT62PnQnDhtppmpwd+X0gKns6ttNSizHWTpQSVIGIuBivSMJI2MzPYXwh/s64VbGeMCLuQSUJnv8tXMeJl04Ah2iSgna0jkoYFkId6poFWg727RmvTxNLd6/6b28DnsMXo+T6+mp9PDl4qfC442iccA6uuphOvusk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=diggnq0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="diggnq0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8A31F000E9;
	Sun,  2 Aug 2026 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703052;
	bh=/+W975vgDLtANCfX5uT6glMufM8WZ2VohOLakr8TKxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=diggnq0I9hsPwVkoE8El+E5z1Mi+BAlcuhZVBa1WeoysfzcIpEf3AKJFv+5JHRv2H
	 xhpEDibhx3F6Lr/D/P8BW/iI+21JtOFoRLVxGJa5XOCudsNB1M5nK3NMiJ8fbkisP8
	 G1UladkaxJAHPOdeFszNuKZbnvB+iWV2FW3vvL0iD197dCf+3d8QIer+yxrTGqG90j
	 a9rZP5bhmXU4GRWTVlKEKAu1kmwQi/2wlpBqxTUvjUwYDIFSlGxq1dbb+zvILJSopr
	 yOojE2qWEHkXSD1vDxZMZJRxb1W5qJd2VdLGDL/Y/Ik3y0arOFbkNA6DlHz9wrZvYY
	 rwxXRWM6bkXYQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 15/29] md/md-llbitmap: grow the page cache in place
 for reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-16-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-16-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:37:31 +0000
Message-Id: <20260802203732.4D8A31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Mismatched chunkshift and page allocations during reshape caus=
e out-of-bounds dereferences.
- [High] Concurrent access to `llbitmap->pctl` during array resize leads to=
 Use-After-Free.
- [Medium] Missing `cond_resched()` in `llbitmap_mark_range` loop can cause=
 soft lockups during large array resizing.

Pre-existing issues:
- [Critical] Bitmap metadata writes can overflow the reserved bitmap space =
on disk because it ignores `BITMAP_DATA_OFFSET`.
--

--- Patch [15]: [PATCH v5 15/29] md/md-llbitmap: grow the page cache in pla=
ce for reshape ---
commit 73a7214b36a3cd36e140de64fe3e4cd6cfe6795a
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: grow the page cache in place for reshape

Use the page-control helpers to grow llbitmap's cached pages in place
for resize and later reshape preparation, instead of rebuilding the
whole cache.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 300dd8b93b01e..ddeea20989873 100644
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

[Severity: Critical]
This is a pre-existing issue, but does this calculation allow the metadata
writes to overflow the reserved disk space? It calculates the required chun=
ks
without reserving space for BITMAP_DATA_OFFSET, which could allow the requi=
red
size to silently exceed the reserved disk space. If the array size forces t=
he
chunk calculation to be exactly at or near the reserved space limit, could
used_pages exceed the reserved limit and overwrite sectors past the end of =
the
reserved space during a flush?

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
[ ... ]
> +	for (i =3D old_nr_pages; i < nr_pages; i++) {
> +		pctl[i] =3D llbitmap_alloc_page_ctl(llbitmap, i);
> +		if (IS_ERR(pctl[i]))
> +			goto err_alloc_ptr;
> +	}
> +
> +	kfree(llbitmap->pctl);
> +	llbitmap->pctl =3D pctl;

[Severity: High]
Can this sequence create a use-after-free window? If the daemon timer had
previously fired while the flush work was running and set BITMAP_DAEMON_BUS=
Y,
the daemon could re-arm pending_timer and exit. Could the timer then fire
concurrently while llbitmap->pctl is being freed here, causing the daemon to
wake up and dereference the freed pctl array?

> +	llbitmap->nr_pages =3D nr_pages;
> +	return 0;

[ ... ]

> @@ -730,6 +785,34 @@ static bool llbitmap_zero_all_disks(struct llbitmap =
*llbitmap)
>  	return true;
>  }
> =20
> +static void llbitmap_mark_range(struct llbitmap *llbitmap,
> +				unsigned long start,
> +				unsigned long end,
> +				enum llbitmap_state state)
> +{
> +	while (start <=3D end) {
> +		llbitmap_write(llbitmap, state, start);
> +		start++;
> +	}
> +}

[Severity: Medium]
If the array is resized significantly, the difference between start and end
could be hundreds of millions of chunks. Without a cond_resched() in this l=
oop,
could this monopolize the CPU for an extended period and trigger a soft loc=
kup?

[ ... ]

> @@ -1184,24 +1267,62 @@ static int llbitmap_create(struct mddev *mddev)
>  static int llbitmap_resize(struct mddev *mddev, sector_t blocks, int chu=
nksize)
>  {
>  	struct llbitmap *llbitmap =3D mddev->bitmap;
[ ... ]
> +	mutex_lock(&mddev->bitmap_info.mutex);
> +	cache_chunks =3D reshape ? max(old_chunks, chunks) : chunks;
> +	ret =3D llbitmap_prepare_resize(llbitmap, old_chunks, chunks, cache_chu=
nks);
> +	if (ret)
> +		goto out;
> +
> +	if (reshape) {
> +		llbitmap->chunks =3D max(old_chunks, chunks);
> +	} else {

[Severity: Critical]
Does the reshape path here fail to update the chunkshift and chunksize?
It expands the page cache based on the new chunks count, but doesn't seem to
update llbitmap->chunksize and llbitmap->chunkshift. When subsequent I/O
operations are processed, could they calculate their chunk index using the =
old,
smaller shift, resulting in chunk indices that exceed the newly allocated
pages? Would this lead to an out-of-bounds access on llbitmap->pctl?

> +		if (blocks < old_blocks && chunks < old_chunks)
> +			llbitmap_mark_range(llbitmap, chunks, old_chunks - 1,
> +					    BitUnwritten);
> +		mddev->bitmap_info.chunksize =3D bitmap_chunksize;
> +		llbitmap->chunks =3D chunks;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D15
