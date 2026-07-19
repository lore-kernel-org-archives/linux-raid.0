Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797AB25B086
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784473068; cv=none; b=qvCkLr/h14vHasBpelNEwNq4pMLOqHOlaLfLbeSd54rCf/dYldJaWeBTvYPVSBqHkmysCL51s6VPMElz7o3bN3JnI+NVQS/N3L5rF369USiP4/cAyEAcldz7nQXC8QrRCWKksWm4/uHBJC5VXxDYQjcLrEizgqAFtk5WzeCkWZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784473068; c=relaxed/simple;
	bh=nXAjFajh1VgcBn0A50LZwv4a5PLiGiOnWZVzfbmn9Fw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QjxzW8I6pCaLPyO5C+e6u25S9UIha2g4raxjFgZbkNuietNlyy/j4Haxc2+l+YS5gfQc9zVctWRYb62+JxePrh4gPvlMtZZSbfKMvk2sWIrH6smsJCvfbae6QtIG2HUfFtwElSCdQbyspjcd7mIZSLRdGMPmWXcBuFBiHic+kTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsvNZS7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsvNZS7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936DA1F00A3A;
	Sun, 19 Jul 2026 14:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784473066;
	bh=Ph1met4GxWVxk4LfFfqFgQierAMnyJnuOKK0svR9iDk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XsvNZS7DfOnSw4vkq0mFVBNcqUbWtP4QfP/bXMAy1E+LNvnySQLeVBJayhfZuLGch
	 TL/8Q+r2ZUvtqEfwBrufQsW95u9mtZDXIRbcAp2LWb4cw16EIYFQmnT7/fFAqmTbkg
	 B5LGur1J5JDR0bR/R49pS54LwFbANXeDP+A+WvD/nVj28yfI8R47fhEVpl3QrUFFVf
	 HuvXSWMz+xWwQb44yfxRwYJVlP3ljh6fInwm57/Oz/EvTZgJpCY1OeVLoGsf4JrThD
	 74Ury5ATI+80Fzuf+EP6hyFDo7pps+OzLTOuaOF7ocITwm+QuN2o5mqbMWVwGp5YlW
	 TT4KrSpjiZ0Ug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] md/md-llbitmap: unmap sb page before freeing it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260719144409.940492-4-mykola@meshstor.io>
References: <20260719144409.940492-1-mykola@meshstor.io>
 <20260719144409.940492-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 14:57:46 +0000
Message-Id: <20260719145746.936DA1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer Truncation of 64-bit event counter causes spurious array r=
ecoveries on 32-bit architectures
- [High] Use-After-Free in teardown sequence due to re-arming timer
- [High] Lost Write to `sb->sync_size` during superblock load
- [High] Integer overflow causing division by zero when calculating minimum=
 chunksize
- [High] Integer overflow in page count calculation leading to out-of-bound=
s heap access
--

--- Patch [3]: [PATCH 3/4] md/md-llbitmap: unmap sb page before freeing it =
---
commit 6be442dfef7ad93b44cadb093b6d078f152b2522
Author: Mykola Marzhan <mykola@meshstor.io>

md/md-llbitmap: unmap sb page before freeing it

The patch swaps __free_page(sb_page) and kunmap_local(sb) in
llbitmap_read_sb() to avoid unmapping a page after it has been freed.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 2d3de38f9b784..2d6c7ad0923a1 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1035,8 +1035,8 @@ static int llbitmap_read_sb(struct llbitmap *llbitm=
ap)
>  	ret =3D llbitmap_cache_pages(llbitmap);

[Severity: High]
This is a pre-existing issue, but is there an integer overflow when
calculating nr_pages on 32-bit architectures inside llbitmap_cache_pages()?

drivers/md/md-llbitmap.c:llbitmap_cache_pages() {
    ...
    unsigned int nr_pages =3D DIV_ROUND_UP(llbitmap->chunks +
                                         BITMAP_DATA_OFFSET, PAGE_SIZE);
    ...
    llbitmap->pctl =3D kmalloc_array(nr_pages, sizeof(void *),
                                   GFP_KERNEL | __GFP_ZERO);
    ...
}

If a malicious superblock sets a high resync_max_sectors and chunksize of 2,
could llbitmap->chunks + BITMAP_DATA_OFFSET overflow to 0? Would this result
in a zero-sized array allocation and subsequent out-of-bounds access?

> =20
>  out_put_page:
> -	__free_page(sb_page);
>  	kunmap_local(sb);
> +	__free_page(sb_page);

[Severity: High]
This is a pre-existing issue, but is the update to sb->sync_size lost here?

Earlier in llbitmap_read_sb(), sb->sync_size is updated:

    sb->sync_size =3D cpu_to_le64(mddev->resync_max_sectors);

Since sb_page is unmapped and unconditionally freed here without being
written back to disk or retained in memory, does the runtime state lose
this update?

>  	return ret;
>  }

There are a few other pre-existing issues in this file that might need
attention.

[Severity: High]
This is a pre-existing issue, but does assigning the 64-bit sb->events to t=
he
unsigned long events variable truncate it on 32-bit architectures?

drivers/md/md-llbitmap.c:llbitmap_read_sb() {
    unsigned long events;
    ...
    events =3D le64_to_cpu(sb->events);
    if (events < mddev->events) {
        ...
    }
}

When the 64-bit counter exceeds 4 billion, would this truncation cause a
spurious full array resync by incorrectly making the bitmap appear stale?


[Severity: High]
This is a pre-existing issue, but can the timer fire on freed memory during
teardown?

drivers/md/md-llbitmap.c:llbitmap_destroy() {
    ...
    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);
    ...
}

drivers/md/md-llbitmap.c:md_llbitmap_daemon_fn() {
    ...
    if (restart)
        mod_timer(&llbitmap->pending_timer, ...);
}

If llbitmap_destroy() deletes the timer and flushes the workqueue, could
md_llbitmap_daemon_fn() unconditionally re-arm the timer at the end of its
execution, leading to a use-after-free when llbitmap is subsequently freed?


[Severity: High]
This is a pre-existing issue, but can this overflow and cause a division by
zero panic?

drivers/md/md-llbitmap.c:llbitmap_read_sb() {
    ...
    if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
                                          mddev->bitmap_info.space << SECTO=
R_SHIFT)) {
    ...
}

On 32-bit systems, mddev->bitmap_info.space is a 32-bit unsigned long. If an
attacker-controlled superblock sets a value where space << 9 overflows to 0,
would DIV_ROUND_UP_SECTOR_T divide by zero?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719144409.9404=
92-1-mykola@meshstor.io?part=3D3
