Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169F63B71D1
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606122; cv=none; b=CbwXXr0yM25ktDZllSSpzI2esF0t46dUaCfWAQEmSmW5lgTeJyjSkiRUMhrg/Vn0GA6KJvAQf6QSL/cISA2aCofNXouGz8zZRupZobiLjdKhGnYR3K+cMH3hTXn18d1joAyalNyn7MVpSBOShkdatcGaNhkuf18Xo+bG/COeZB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606122; c=relaxed/simple;
	bh=5dsj8Cxtc5yWJJBQujSo2hdndIqMuV05Hrixa3n+AV8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MHmPR5YH1Nb0w51GVa5Fox5bEYW5aTZQ6dyreSd+wKDpkYcPfbc0kP9r4Sw5aP1qsh2JIIR8dT35frDwuUGI+Vuw8C+4GLm2beUF99amSmk7fRYJ6HarK6rYAVJb5tF4cnzz7mnfHEDS5SLXEz1L1Y6ljVmeAE926eUcwTpnNLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+9mTIMq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+9mTIMq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C781F00AC4;
	Sat,  1 Aug 2026 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606120;
	bh=AMv/1Orinb8AXSR67dtLXSfMBjcR1EscjxwMRca1k2c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G+9mTIMqgsAdTCSiMVUJBVB1Fp1/KKhewvonGU98iB4sbNY6QDMJZs6/tDjKRWGgI
	 mdiiuvdDT3N1KtGeBQDCjcHjKUG9uRQD55ch8jLHdHjemlOb7lMtEvHw4eR1JuVizl
	 gHXDUfB3+eU+yuiFhzAQekuGPeRYL97cE4C09RgtzNLTAF0np7qgqxkxBINNEWzaLe
	 16eV+xaikOWJzd1T6L4fLo9BenVAYXzc/luTmuNmusArmloCYOgyQLno2dxuME1beh
	 72e7pRYDNQvECm1QsDvs2GY6Mfqgp0ld0anLJTC/FPtiEmQWVE0GaSJlwzYw2ywcD2
	 JwJOtfMYHyfwA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/25] md/md-llbitmap: use GFP_NOIO for cache
 allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-3-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-3-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:41:59 +0000
Message-Id: <20260801174200.68C781F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Large contiguous memory allocation failure using `kmalloc_array` a=
nd `GFP_NOIO`.

Pre-existing issues:
- [Critical] Unprotected read-modify-write race condition corrupts lockless=
 bitmap state.
- [High] Out-of-bounds array access due to missing page cache reallocation =
during array resize.
- [High] Use-After-Free of `llbitmap` in the `llbitmap_create` error path.
--

--- Patch [2]: [PATCH v4 02/25] md/md-llbitmap: use GFP_NOIO for cache allo=
cations ---
commit e93c6e98fd387cb6b6c743dfb60b192e52bca4d1
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: use GFP_NOIO for cache allocations

This commit changes the allocation context from GFP_KERNEL to GFP_NOIO
for several llbitmap cache and object structures. This is done to prevent
direct reclaim from entering filesystem or block I/O while MD resize state
is locked, avoiding recursive deadlocks.

> update_size() calls the personality resize method, and llbitmap_resize()
> can grow the page cache through llbitmap_prepare_resize().

[Severity: High]
This isn't a bug introduced by this patch, but the commit message mentions
llbitmap_prepare_resize(), which appears to be entirely missing from the
code.

In llbitmap_resize(), llbitmap->chunks is increased, but the underlying
page cache arrays (pctl) are never actually reallocated to match the new
capacity:

drivers/md/md-llbitmap.c:llbitmap_resize() {
    ...
	llbitmap->chunkshift =3D ffz(~chunksize);
	llbitmap->chunksize =3D chunksize;
	llbitmap->chunks =3D chunks;
    ...
}

Will subsequent I/O to the newly resized space calculate a page_start
index exceeding nr_pages and cause an out-of-bounds access?

drivers/md/md-llbitmap.c:llbitmap_start_write() {
    ...
	int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
    ...
	while (page_start <=3D page_end) {
		llbitmap_raise_barrier(llbitmap, page_start);
    ...
}


diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
index 131582724e7e9..6ab2188bba279 100644
--- a/drivers/md/md-llbitmap.c
+++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -616,12 +616,12 @@ static int llbitmap_cache_pages(struct llbitmap *ll=
bitmap)
>  	int i;
> =20
>  	llbitmap->pctl =3D kmalloc_array(nr_pages, sizeof(void *),
> -				       GFP_KERNEL | __GFP_ZERO);
> +				       GFP_NOIO | __GFP_ZERO);
>  	if (!llbitmap->pctl)
>  		return -ENOMEM;
> =20
>  	size =3D round_up(size, cache_line_size());
> -	pctl =3D kmalloc_array(nr_pages, size, GFP_KERNEL | __GFP_ZERO);
> +	pctl =3D kmalloc_array(nr_pages, size, GFP_NOIO | __GFP_ZERO);

[Severity: High]
Will this strict GFP_NOIO constraint cause large contiguous memory
allocations to deterministically fail due to physical memory fragmentation?

For large MD arrays, allocating the pctl array scales linearly with disk
size. This allocation can reach several megabytes, which will exceed
KMALLOC_MAX_SIZE or frequently fail because GFP_NOIO prevents direct
filesystem and I/O reclaim.

Should this allocation be migrated to kvmalloc_array() to handle larger
sizes gracefully?

>  	if (!pctl) {
>  		kfree(llbitmap->pctl);
>  		return -ENOMEM;

[ ... ]

> @@ -1110,7 +1110,7 @@ static int llbitmap_create(struct mddev *mddev)
>  	if (ret)
>  		return ret;
> =20
> -	llbitmap =3D kzalloc_obj(*llbitmap);
> +	llbitmap =3D kzalloc_obj(*llbitmap, GFP_NOIO);
>  	if (!llbitmap)
>  		return -ENOMEM;

[ ... ]

>  	mutex_unlock(&mddev->bitmap_info.mutex);
>  	if (ret) {
>  		kfree(llbitmap);
>  		mddev->bitmap =3D NULL;
>  	}

[Severity: High]
This is a pre-existing issue, but does dropping the mutex before clearing
mddev->bitmap open a race window for concurrent sysfs readers?

If llbitmap_read_sb() fails during llbitmap_create(), the code drops
mddev->bitmap_info.mutex, calls kfree(llbitmap), and only then sets
mddev->bitmap to NULL.

Could a concurrent sysfs read (such as metadata_show()) acquire the lock
while mddev->bitmap is still non-NULL and read from the freed memory?

[Severity: Critical]
This is a pre-existing issue, but can the lockless bitmap state be
corrupted by a read-modify-write race condition here?

When multiple threads write to the same sector concurrently,
llbitmap_infect_dirty_bits() iterates over the chunks and performs an
unlocked read-modify-write on the byte array:

drivers/md/md-llbitmap.c:llbitmap_infect_dirty_bits() {
    ...
		switch (pctl->state[pos]) {
		case BitUnwritten:
			pctl->state[pos] =3D level_456 ? BitNeedSync : BitDirty;
    ...
}

Simultaneously, another thread may execute llbitmap_write() and assign a
new state directly:

drivers/md/md-llbitmap.c:llbitmap_write() {
    ...
	llbitmap->pctl[idx]->state[bit] =3D state;
    ...
}

Could the modifying thread in llbitmap_infect_dirty_bits() overwrite the
direct assignment in llbitmap_write() with a stale value, permanently
losing state updates and leading to silent data corruption (e.g., dirty
regions failing to resync after a crash)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D2
