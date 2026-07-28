Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B1541A791
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230167; cv=none; b=AOUEey3E9+CaveHCN24f9A4aYF+dbxBrbH1TEagk3vWJsp5LdGS78UVerwAftgmGurMZz5ArWANp23G10Xf67eh+15WFAZuUwB3qs9+Pl40S3cxEp8yDoFaPT5qh1JaGDD63qyOUfApROl3y53wkaMg7jbkkoxnjnicXznnKyUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230167; c=relaxed/simple;
	bh=K7BpJnAqcHQl3ey11gdu7UJx2dlUV4AiCEs9EGJh+5M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ETIHzQWL2hp+S4qQvWvKaG/tH/UjeJE8lKhSIBE842d+N8Iz5QzYsErXcWaTeCvSQGTtVG9OpWACqB/2SaoCWg2uwMRsSFm9rr+0efmRzTpVW3L0rJiyffL/fWm11l1kIOjiO0KFnp1MZrwIWOK6thcH0K/M9Ya9Ex7TkhJpcY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/lub3S5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/lub3S5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDB51F000E9;
	Tue, 28 Jul 2026 09:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230165;
	bh=mPbC8JE3/xpH/oFsamYrOJHjIJtrOa1XxZQBptMYCE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I/lub3S51QxCilvoIfoR9Aiv+fOC1Av69gce//UtiEBRVE+MaYpvcUjyLIGnxdoIE
	 6IWW8I9Xlgv0H6bxrwH5QHGNiHGpfGu3j/GQVx8Lnvw3I3c1kxbTORGJ1WelmIqDuH
	 L4pYkQ6uXrw8IgFogymBsl+uOiHP2AR6HoZiqiSt6M6UcR2RV0Vt++zyX/7zZDFWcp
	 ldcZqIWkSXNQncsR6YZzIYZPSlLEHVqOL/QlBsgE+TtH2llEY0nrgxyOGcc+tPqjwC
	 AvD8JCHAguPscALeuZbql8YSR+J7duRF+42UckaaWTQa+ynFXVKsdlCxz6Y4sEOb6G
	 dgOrKl6R+8mVA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/21] md/md-llbitmap: track bitmap sync_size
 explicitly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <c7c477a0e0203fd6ce98e49cd0cc1382b1786f4d.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <c7c477a0e0203fd6ce98e49cd0cc1382b1786f4d.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:16:05 +0000
Message-Id: <20260728091605.ABDB51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Missing upper and lower bounds validation on the newly tracked=
 `sync_size` read from the superblock leads to arbitrary out-of-bounds memo=
ry accesses.
- [High] Validation of `chunksize` in `llbitmap_read_sb` incorrectly uses `=
mddev->resync_max_sectors` instead of `sync_size`.
- [High] Torn read of the 64-bit `sync_size` field leading to superblock co=
rruption and memory allocation bugs on reboot, along with unprotected bitma=
p geometry updates.

Pre-existing issues:
- [High] A teardown race condition in `llbitmap_destroy()` fails to prevent=
 a workqueue task from re-arming a timer after it has been deleted, causing=
 a UAF.
--

--- Patch [5]: [PATCH v3 05/21] md/md-llbitmap: track bitmap sync_size expl=
icitly ---
commit e1b87a51dfe616ddb9c0f12bcc69bdac5d5044d5
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track bitmap sync_size explicitly
   =20
Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly.

This is the minimal bookkeeping needed before llbitmap can track old
and new reshape geometry independently.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index f0c20afa354eb..e3500a1a52c07 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -987,6 +991,9 @@ static int llbitmap_read_sb(struct llbitmap *llbitmap)
>  		goto out_put_page;
>  	}
> =20
> +	sync_size =3D le64_to_cpu(sb->sync_size);

[Severity: Critical]
Is it necessary to validate the upper and lower bounds of the sync_size
read from the superblock here?

If sync_size is manipulated to be near U64_MAX, calculating nr_pages
might truncate to a small 32-bit integer, while chunks remains huge.
Could this cause llbitmap_init_state() to perform massive out-of-bounds
writes into the undersized pctl array?

Alternatively, if sync_size is too small, nr_pages is small, but incoming
IO up to mddev->resync_max_sectors calculates a page_start that exceeds
the bounds of pctl:

drivers/md/md-llbitmap.c:llbitmap_start_write() {
    ...
    int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
    ...
    while (page_start <=3D page_end) {
        llbitmap_raise_barrier(llbitmap, page_start);
    ...
}

Could this lead to out-of-bounds memory accesses if a maliciously crafted
bitmap superblock is mounted?


[Severity: High]
Should the chunksize validation further down in llbitmap_read_sb() be
updated to use sync_size as well?

    if (chunksize < DIV_ROUND_UP_SECTOR_T(mddev->resync_max_sectors,
                                          mddev->bitmap_info.space << SECTO=
R_SHIFT)) {

If an array is grown and stopped before the bitmap is resized,
mddev->resync_max_sectors reflects the new larger size, but the bitmap
superblock retains the old sync_size and chunksize.

Will checking if the old chunksize can cover the new resync_max_sectors
cause a false failure and abort bitmap initialization in this scenario?

> +	if (!sync_size)
> +		sync_size =3D mddev->resync_max_sectors;
>  	chunksize =3D le32_to_cpu(sb->chunksize);
>  	if (!is_power_of_2(chunksize)) {

[ ... ]

> @@ -1153,6 +1161,7 @@ static int llbitmap_resize(struct mddev *mddev, sec=
tor_t blocks, int chunksize)
>  	llbitmap->chunkshift =3D ffz(~chunksize);
>  	llbitmap->chunksize =3D chunksize;
>  	llbitmap->chunks =3D chunks;
> +	llbitmap->sync_size =3D blocks;
> =20
>  	return 0;
>  }

[Severity: High]
Are these updates to the 64-bit sync_size and geometry variables
adequately protected from concurrent access?

Unlike the legacy bitmap which uses mddev->pers->quiesce() to pause IO,
llbitmap_resize() does not pause IO. This allows active IO paths to read
a mix of old and new geometry values.

Additionally, llbitmap_update_sb() concurrently reads llbitmap->sync_size
locklessly:

drivers/md/md-llbitmap.c:llbitmap_update_sb() {
    ...
    sb->sync_size =3D cpu_to_le64(llbitmap->sync_size);
    ...
}

On 32-bit platforms, might this race result in a torn read of the 64-bit
value, causing a corrupted value to be written to the disk superblock?

[ ... ]

This is a pre-existing issue, but does the teardown sequence in
llbitmap_destroy() allow the pending_timer to be re-armed after deletion?

In llbitmap_destroy():

    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

If the daemon work is concurrently running in the workqueue,
timer_delete_sync() returns immediately because the timer is no longer
pending.

The workqueue is then flushed, but at the end of the worker function
md_llbitmap_daemon_fn(), it unconditionally re-arms the timer:

    if (restart)
        mod_timer(&llbitmap->pending_timer,
                  jiffies + mddev->bitmap_info.daemon_sleep * HZ);

When llbitmap is subsequently freed, will the re-armed timer dereference
the freed memory when it fires?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D5
