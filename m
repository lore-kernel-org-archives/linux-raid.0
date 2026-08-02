Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED17225403
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702455; cv=none; b=rN1V0k/7GZKqahh3p9+fBxo/lcQk2m1UBr3UMyqb9shMMEbxI35hQxUMI/LgirEvQPneEIdFGE4avl8BnqnYyjKDH4T8jk1m0/maTnAmBwiuebXnTvG8rb/W67Molwe5hrJ1H/1oPVnOXDFszqg94GsJ0Voi57zm8zRHZlKTbuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702455; c=relaxed/simple;
	bh=fNFd+Gj9DfecNAT0JUDM/V4XT2wxHSY4zxcci9Rf2AA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qxUEC0RAHQS9Riiqd/6nP6JMZSPO5UsK0NJgduipbTOK0l/TsCxf8ccED7MY/NjK/8uNoKa45pEGosCUHF6BkXKN8vZe+AkVlUO/EMYQHrB8Um4oteDsia8U4SoMck2jeQTNR9mLF3MYztHD5ba8OQ13pYPY8OF/j7C7w9yrY7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PYFPwYJe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PYFPwYJe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298541F000E9;
	Sun,  2 Aug 2026 20:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702453;
	bh=i6wzIWgyaE81AXlT0nymOtnCsWJXbqtOv9F7JoZzyQc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PYFPwYJe0YKERKP+3Fsf+aYjqlLr1ODenrLjtrbAcSQ7SY2158ZXcsPq+YFXeXQ8H
	 SOI6MZIc+ip2hNzj8NEQVEdLfP8B70w2qdC93D5tnFvyzyJn09iA4M32iizjUztiZy
	 SGbKIjcJ4AsfWzQo455jDYVVcCzsxYcx4Z5+WmR6EwfJXRMsy3jJMjg4462+/FyeN9
	 RX1ZbgottLT/2t+0YqXO+BpLZ8RQv4RPw5EIxbL0vZLd2SOwltp1nQSyyWb4CUPbO6
	 ND0Epd2LuEgESb0PzsPECga0y+h15MQ0H7/QEFdGFAjfxmPFbrKb94hNWJK93GBGoF
	 FHPWhX0SCCWkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/29] md/md-llbitmap: allocate page controls
 independently
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-15-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-15-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:27:32 +0000
Message-Id: <20260802202733.298541F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] Heap buffer overflow in `llbitmap_write()` during array reshap=
e due to missing `BITMAP_DATA_OFFSET` in `reserved_pages` calculation.
- [High] Denial of Service via eager unbounded memory allocation based on u=
ntrusted on-disk `sectors_reserved`.
--

--- Patch [14]: [PATCH v5 14/29] md/md-llbitmap: allocate page controls ind=
ependently ---
commit f1fb318905483b935b4e96f1cbe5fe6c77c4134e
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: allocate page controls independently

This commit allocates llbitmap page-control objects independently rather
than as a single array. It also modifies llbitmap_read_page() to return a
zeroed page when beyond the current size, preparing for in-place growth.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 0813cebfbdeb3..300dd8b93b01e 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> +static unsigned int llbitmap_reserved_pages(struct llbitmap *llbitmap)
> +{
> +	return DIV_ROUND_UP(llbitmap->mddev->bitmap_info.space << SECTOR_SHIFT,
> +			    PAGE_SIZE);
> +}

[Severity: Critical]
Does this reserved pages calculation need to account for BITMAP_DATA_OFFSET?

When the array grows to the max chunks allowed by space during a reshape,
llbitmap_write() will add BITMAP_DATA_OFFSET to the position:

llbitmap_write() {
        pos +=3D BITMAP_DATA_OFFSET;
        idx =3D pos >> PAGE_SHIFT;
        bit =3D offset_in_page(pos);

        llbitmap->pctl[idx]->state[bit] =3D state;
        ...
}

If space happens to align closely to a page boundary, reserved_pages could
evaluate to 1, but the allowed chunks plus BITMAP_DATA_OFFSET could result
in pos crossing into the next page. Will this cause idx to exceed the pctl
array capacity and trigger an out-of-bounds write?

> +static int llbitmap_alloc_pages(struct llbitmap *llbitmap)
> +{
> +	unsigned int used_pages =3D llbitmap_used_pages(llbitmap, llbitmap->chu=
nks);
> +	unsigned int nr_pages =3D max(used_pages, llbitmap_reserved_pages(llbit=
map));
> +	int i;
> +
> +	llbitmap->pctl =3D kcalloc(nr_pages, sizeof(*llbitmap->pctl), GFP_NOIO);
> +	if (!llbitmap->pctl)
> +		return -ENOMEM;
> +
> +	llbitmap->nr_pages =3D nr_pages;
> +
> +	for (i =3D 0; i < nr_pages; i++) {
> +		llbitmap->pctl[i] =3D llbitmap_alloc_page_ctl(llbitmap, i);

[Severity: High]
Is it safe to eagerly allocate all possible page controls based on the
on-disk sectors_reserved value?

If a malicious or corrupted superblock provides a massive sectors_reserved
value, this loop will invoke llbitmap_alloc_page_ctl() hundreds of
thousands of times for unused capacity:

llbitmap_alloc_page_ctl() {
        pctl =3D kzalloc(size, GFP_NOIO);
        ...
        page =3D llbitmap_read_page(llbitmap, idx);
        ...
        if (percpu_ref_init(&pctl->active, active_release,
                            PERCPU_REF_ALLOW_REINIT, GFP_NOIO)) {
        ...
}

Could this lead to severe kernel memory exhaustion and trigger the OOM
killer, since GFP_NOIO aggressively reclaims memory during these
allocations?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D14
