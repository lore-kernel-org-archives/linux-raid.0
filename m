Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29C3ABD98
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785607198; cv=none; b=Ke2poHs3GsUDrWeH0ks1ijJWJE3mniCgns+Syl3teKrlmyvsJMH3OttjiR7xK/BxrZcBIZ6VjPGdwE29b/Oob/4DafFlyARJmkZ7wyBE+Hgj9/FgoUkpui+W0yv0t8MJsdx6Oz0WaRdNw8ZgNt5QhuM9a0WRYHzToimtAeYF9yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785607198; c=relaxed/simple;
	bh=O36a43gQXjm51t53qWjy5V2muu7DLBnc0l9OsFsGhKQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ikyuxphVoEOlelKO4H+h7VgtE3RNC+ppFNd5eQ8NwRx1ivkuikrrRvQEuZqoV3Jhj9O++p3Tx+ybE76QYSZ+QweT1EgpycHJ2Sd3iwQg2Kq00gCJM39by+/uG59nDID3ThGJbqHKyCbiiNIAq4IJi6sKTRipzMUzB1D/gEE3ua8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6UHP1DI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6UHP1DI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCED1F00AC4;
	Sat,  1 Aug 2026 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785607196;
	bh=8htm6k2LSBsjWcsV/4XG/9QpSUhZ/ogM03aF33++VGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O6UHP1DIprWnfZFsBWDVtzvhNZmaNg0ylsYFypO7KcYSETGv3LMDkE8guK17L/zVD
	 zfdSxj/St0IJIHVeLDJiRI5n0UceWYQTlXVz6dk5fLjrJyXjak3oGFTQNMZU3Bp1HM
	 muwxyyEoBdvQGQ6xLnZDeVSOamB5mgmPRElF9Z+UanVApfc+gXJLSZ8XzgS4vQxBTp
	 otcIzHMjJvLqZfcZczVQLo5HxbSb4iORqy7rUKerllpig0vDkoSnEKMFffdEohigQz
	 YSllUSFNQNbZzTrXDylGjj6Pz5UottyAChr57PBWhqyybRIyuwBKnlp/lAvCsWOXRR
	 qGJVvcrD0LB2A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 13/25] md/md-llbitmap: finish reshape geometry
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-14-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-14-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:59:56 +0000
Message-Id: <20260801175956.7CCED1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The `llbitmap_reshape_finish` callback is dead code and misses API=
 integration, which would cause a sleep-in-atomic panic if properly integra=
ted.

Pre-existing issues:
- [Critical] The pending timer can be re-armed during array teardown after =
`timer_delete_sync()`, leading to a Use-After-Free when the timer fires on =
the freed `llbitmap`.
--

--- Patch [13]: [PATCH v4 13/25] md/md-llbitmap: finish reshape geometry ---
commit 726da375aa50cd87c4a667a63fcb2d5924d50556
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: finish reshape geometry

Commit the staged llbitmap geometry when reshape finishes. When assembling a
stopped reshape, md_run() creates the bitmap before publishing mddev->pers.
Refresh the staged reshape geometry again from llbitmap_load().

Link: https://lore.kernel.org/all/20260726185916.2223460-1-mykola@meshstor.=
io/

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 37d1312e3eab9..f41f9ba2063b5 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c

[ ... ]

> @@ -1694,6 +1703,30 @@ static void llbitmap_dirty_bits(struct mddev *mdde=
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

[Severity: High]
Is this callback actually invoked anywhere by the MD core?

Looking at the MD core code, it seems md_finish_reshape() doesn't call
bitmap_ops->reshape_finish(). This means the staged geometry remains
uncommitted.

Additionally, if it were to be called from md_finish_reshape(), wouldn't
this cause a sleep-in-atomic panic? The callers of md_finish_reshape() hold
a spinlock, but this function acquires a mutex and performs a sleeping wait
via mddev->pers->quiesce().

> +	llbitmap_flush(mddev);
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

> @@ -1991,6 +2024,7 @@ static struct bitmap_operations llbitmap_ops =3D {
>  	.get_stats		=3D llbitmap_get_stats,
>  	.dirty_bits		=3D llbitmap_dirty_bits,
>  	.prepare_range		=3D llbitmap_prepare_range,
> +	.reshape_finish		=3D llbitmap_reshape_finish,
>  	.write_all		=3D llbitmap_write_all,
> =20
>  	.groups			=3D md_llbitmap_groups,

[Severity: Critical]
This is a pre-existing issue, but is there a use-after-free risk during
array teardown in llbitmap_destroy()?

Looking at llbitmap_destroy(), the pending timer is deleted before flushing
the workqueue:

    timer_delete_sync(&llbitmap->pending_timer);
    flush_workqueue(md_llbitmap_io_wq);

If the array is being destroyed on an error path where BITMAP_WRITE_ERROR is
set, __md_stop_writes() skips calling mddev->bitmap_ops->flush(mddev), so
the LLPageFlush bit is never set.

When the workqueue executes md_llbitmap_daemon_fn(), it can encounter
unexpired dirty pages without the flush bit, set restart =3D true, and call
mod_timer().

Could this re-arm the timer right before the llbitmap is freed, allowing
the timer to fire on the freed object?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D13
