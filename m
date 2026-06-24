Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE4B2F8E9C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284544; cv=none; b=eNTeaXmmk66Xc2VBE4Urh7utqDlxiTND1JLe1fKAByfzxUtBSJI0aQk2yzZhkiW2zI16d1lfTsxVQqnZLPqL6s963mjdu98rNyMbO0WcLKKr9/k3ZTA00eXINw7BA64k6oy5NAn2pMxYe9bfeoTjM8IutZrkTKmRAB5/lfD15Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284544; c=relaxed/simple;
	bh=iYAXSPZNp9r/5DOpFXbrnfihSn/2I8GQ+SiWRm6XeyE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TrajtXe0+7T8YjBWwSubX+Dypk33pzW/1lBlzlHIYVwW3XSntHOsdqD1WbKPCc2GAS2YEnPip/Zf9DvLeHgH4weYC6XGMLjWDTv0V30M1gVjZ66kA7/9E85zDDwDdsCqiS/vpE5OqB8qRc8CjmzJhZIXVGxQtUkZLR8QnG/gz2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdMzpjdS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdMzpjdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E21F000E9;
	Wed, 24 Jun 2026 07:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284543;
	bh=FkV0YS+et39lu71amW02wJ+uwPW9neks0qyzhjppAjo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JdMzpjdSmJziNL60ieKH2tWhDT5+OWP5TkRxzKKJoSbgKzxaYxw6yCRxsqek4WBg0
	 OWwDwYHhJEgcbBHzVLeoOObO6rdU3f1OlCCmXnlXVFmg2msIAzt+LR5gkEaZFMG0+w
	 G1Z6LYjezasv/LW21xLOAWjyHwh+S5s3x5sBrr4qTlMCmGIEM7haDQcNXJsu0TATcx
	 kvpeS80Xm43xs78nhAQW3Gg5zg6R83/sOnyJHxQdpjIx9fBjFp6H1GGNKYLEBVRMqW
	 nM4ri8e45l2kKxBwcdXvyKwJLfB4t1hXUguIsnQzvCrZXaKMmaf9aT5gnusvbLsOWj
	 0cRFEuh4zndZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/20] md/md-llbitmap: track bitmap sync_size
 explicitly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <2fd017b2cb7bbeb49f0a1b8e0d413c0822f80885.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <2fd017b2cb7bbeb49f0a1b8e0d413c0822f80885.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:02:22 +0000
Message-Id: <20260624070223.0C8E21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Data race on `llbitmap->sync_size` between `llbitmap_resize` and `=
llbitmap_update_sb` can result in a corrupted superblock.

Pre-existing issues:
- [Critical] Improper teardown order in `llbitmap_destroy()` allows the asy=
nchronous workqueue to unsafely re-arm the timer, leading to a Use-After-Fr=
ee.
--

commit 4f14b77c13988c93db9a3db0e4720c69a8ac613c
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: track bitmap sync_size explicitly

Track llbitmap's own sync_size instead of always using
mddev->resync_max_sectors directly. This is the minimal bookkeeping
needed before llbitmap can track old and new reshape geometry
independently.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index f0c20afa354eb..e3500a1a52c07 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

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

[ ... ]

> @@ -1526,7 +1535,7 @@ static void llbitmap_update_sb(void *data)
>  	sb->events =3D cpu_to_le64(mddev->events);
>  	sb->state =3D cpu_to_le32(llbitmap->flags);
>  	sb->chunksize =3D cpu_to_le32(llbitmap->chunksize);
> -	sb->sync_size =3D cpu_to_le64(mddev->resync_max_sectors);
> +	sb->sync_size =3D cpu_to_le64(llbitmap->sync_size);

[Severity: High]
Can this read of llbitmap->sync_size cause a torn read on 32-bit systems?

While llbitmap_resize() updates this 64-bit value while holding
mddev->bitmap_info.mutex and reconfig_mutex, md_update_sb() calls
llbitmap_update_sb() without holding bitmap_info.mutex.

If a torn read occurs during concurrent array resize operations, could the
superblock be written with a corrupted sync_size? This might lead to array
assembly failures or out-of-bounds accesses during subsequent operations.

[ ... ]

[Severity: Critical]
This is a pre-existing issue, but does the teardown sequence in
llbitmap_destroy() have a use-after-free risk for the timer?

Looking at the current teardown order in llbitmap_destroy():

llbitmap_destroy() {
        ...
        timer_delete_sync(&llbitmap->pending_timer);
        flush_workqueue(md_llbitmap_io_wq);
        ...
}

If md_llbitmap_daemon_fn() is running during the flush_workqueue() call,
it might attempt to re-arm the timer:

md_llbitmap_daemon_fn() {
        ...
        if (restart)
                mod_timer(&llbitmap->pending_timer, jiffies + ...);
}

Could the asynchronous workqueue unsafely re-arm the timer here, allowing
it to resurrect after timer_delete_sync() and execute after the llbitmap
structure has been freed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D4
